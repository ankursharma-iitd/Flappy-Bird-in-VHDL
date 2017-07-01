----------------------------------------------------------------------------------
-- Company: Digilent Inc.
-- Engineer: Andrew Skreen
-- 
-- Create Date:    17:25:25 03/01/2012 
-- Module Name:    PmodCLS_Demo
-- Project Name: 	 PmodCLS_Demo
-- Target Devices: Nexys3
-- Tool versions:  ISE 14.1
-- Description: Prints "Hello From Digilent" on PmodCLS connected to Nexys3
--					 on pins JA1-JA4. SPI protocol is utilized for communications
--					 between the PmodCLS and the Nexys3, hence the appropriate
--					 jumpers should be set on the PmodCLS, for details see
--					 PmodCLS reference manual.
--
-- Revision: 1.00 - Added debouncing, comments, fixed reset issue.
-- Revision: 0.01 - File Created
----------------------------------------------------------------------------------
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--
--package instruction_buffer_type is
--    type instructionBuffer is array(0 to 47) of std_logic_vector (7 downto 0);
--end package instruction_buffer_type;
--
--use work.instruction_buffer_type.all;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all; 


-- *******************************************************************************
--  								Define block inputs and outputs
-- *******************************************************************************
entity PmodCLS_Demo is
    Port ( sw : in  STD_LOGIC_VECTOR (2 downto 0);		-- sw[0] is reset
																		-- sw[1] is clear
																		-- sw[2] is start
			  level : in std_logic_vector (3 downto 0);  
           JA : inout  STD_LOGIC_VECTOR (3 downto 0); -- Port JA[4:1]
           Led : inout  STD_LOGIC_VECTOR (0 downto 0); -- Led<0>
           clk : in  STD_LOGIC;
			  l: out std_logic_vector(3 downto 0);
			  tel: in std_logic);								-- Onboard 100 Mhz clock
end PmodCLS_Demo;

architecture Behavioral of PmodCLS_Demo is

-- *******************************************************************************
--  									Component Declarations
-- *******************************************************************************


		-- ++++++++++++++++++++++++++++++++++++++++++++++
		-- 					Master Interface
		-- ++++++++++++++++++++++++++++++++++++++++++++++
		component master_interface
			port ( begin_transmission : out std_logic;
					 end_transmission : in std_logic;
					 clk : in std_logic;
					 rst : in std_logic;
					 start : in std_logic;
					 clear : in std_logic;
--					 done : in std_logic;
					 slave_select : out std_logic;
					 sel : out integer range 0 to 47;
					 temp_data : in std_logic_vector(7 downto 0);
					 send_data : out std_logic_vector(7 downto 0));
		end component;

		-- ++++++++++++++++++++++++++++++++++++++++++++++
		-- 				Serial Port Interface
		-- ++++++++++++++++++++++++++++++++++++++++++++++
		component spi_interface
			port ( begin_transmission : in std_logic;
					 slave_select : in std_logic;
					 send_data : in std_logic_vector(7 downto 0);
					 miso : in std_logic;
					 clk : in std_logic;
					 rst : in std_logic;
					 --recieved_data : out std_logic_vector(7 downto 0);
					 end_transmission : out std_logic;
					 mosi : out std_logic;
					 sclk : out std_logic);
		end component;


		-- ++++++++++++++++++++++++++++++++++++++++++++++
		-- 					Command Lookup
		-- ++++++++++++++++++++++++++++++++++++++++++++++
		component command_lookup
			port( sel : in integer range 0 to 47;
--					input: in instructionBuffer;
					row : in std_logic;
					t : in integer;
--					done: in std_logic;
					data_out : out std_logic_vector(7 downto 0));
		end component;
		
		
		-- ++++++++++++++++++++++++++++++++++++++++++++++
		-- 						Debouncer
		-- ++++++++++++++++++++++++++++++++++++++++++++++
		component three_bit_debouncer
			port( 
					CLK : in STD_LOGIC;							
					RST : in STD_LOGIC;							
					DIN : in STD_LOGIC_VECTOR(2 downto 0);
					DOUT : out STD_LOGIC_VECTOR(2 downto 0)
			);
		end component;


-- *******************************************************************************
--  									Signals and Constants
-- *******************************************************************************

	-- Active low signal for writing data to PmodCLS
	signal slave_select : std_logic;
	-- Initializes data transfer with PmodCLS
	signal begin_transmission : std_logic;
	-- Handshake signal to signify data transfer done
	signal end_transmission : std_logic;
	-- Selects which ASCII value to send to PmodCLS
	signal sel : integer range 0 to 47;
	-- Output data from C2 to C0
	signal temp_data : std_logic_vector(7 downto 0);
	-- Output data from C0 to C1
	signal send_data : std_logic_vector(7 downto 0);
	-- Ground, i.e. logic low
	signal GRND : std_logic := '0';
	-- dbSW[0] Debounced SW[0], dbSW[1] Debounced SW[1], dbSW[2] Debounced SW[2]
	signal dbSW : std_logic_vector(2 downto 0) := "000";
	signal tcount,tcount1 : integer := 0;
	signal n: integer := 67108864;
	signal t: integer := 1;
	signal startt,row,donet :std_logic := '0';
--	signal cleartemp,starttemp : std_logic;
	signal SWtemp : std_logic_vector(2 downto 0) :="000";
	
--	signal command : instructionBuffer := (  X"1B",
--												X"5B",
--												X"6A",
--												X"1B",
--												X"5B",
--												X"30",
--												X"3B",
--												X"30",
--												X"48",
--												X"2A",
--												X"20",
--												X"20",
--												X"20",
--												X"20",
--												X"20",
--												X"20",
--												X"20",
--												X"20",
--												X"20",
--												X"1B",
--												X"5B",
--												X"31",
--												X"3B",
--												X"34",
--												X"48",
--												X"20",
--												X"20",
--												X"20",
--												X"20",
--												X"20",
--												X"20",
--												X"20",
--												X"20",
--												X"00");

-- *******************************************************************************
--  										Implementation
-- *******************************************************************************
begin

	-- Debounces the input control signals from switches.
	DebounceInputs : Three_Bit_Debouncer port map(
			CLK=>CLK,
			RST=>GRND,
			DIN=>sw,
			DOUT=>dbSW
	);

	-- Produces signals for controlling SPI interface, and selecting output data.
	C0: master_interface port map( 
			begin_transmission => begin_transmission,
			end_transmission => end_transmission,
			clk => clk,
			rst => dbSW(0),
--			start => dbSW(2),
			start => startt,
			clear => dbSW(1),
--			done => donet,
			slave_select => slave_select,
			temp_data => temp_data,
			send_data => send_data,
			sel => sel
	);

	-- Interface between the PmodCLS and FPGA, proeduces SCLK signal, etc.
	C1 : spi_interface port map(
			begin_transmission => begin_transmission,
			slave_select => slave_select,
			send_data => send_data,
			--recieved_data => recieved_data,
			miso => JA(2),
			clk => clk,
			rst => dbSW(0),
			end_transmission => end_transmission,
			mosi => JA(1),
			sclk => JA(3)
	);

	-- Contains the ASCII characters for commands
	C2 : command_lookup port map (
			sel => sel,
--			input => command,
			row => tel,
			t => t,
--			done => donet,
			data_out => temp_data
	);

	--  Active low slave select signal
	JA(0) <= slave_select;

	--  Assign Led<0> the value of SW(0)
	Led(0) <= '1' when SW(0) = '1' else '0';
	
--	process(sw)
--	begin
--		if sw(2)='1' then
--		donet<='0';
--		end if;
--	end process;
-- 
-- process(level)
-- begin
-- 		case level is
--		when "0000" => n <= 134217728;
--		when "0001" => n <= 123032912;
--		when "0010" => n <= 111848102;
--		when "0011" => n <= 100663292;
--		when "0100" => n <= 89478482;
--		when "0101" => n <= 78293672;
--		when "0110" => n <= 67108862;
--		when "0111" => n <= 55924052;
--		when "1000" => n <= 44739242;
--		when "1001" => n <= 33554432;
--		when others => n <=  67108864;
--		end case;
--		l <= level;
-- end process;
--	
	process(clk)
	begin 
		
--		if sw(0)='1' then
--		donet<='0';
--		end if;
--		if ((row='0' and (t=4 or t = 11)) or (row='1' and (t=7 or t=14))) then
----					startt<='1';
--					donet<='1';
--					end if;
--		case level is
--		when "0000" => n <= 	1073741824;
--		when "0001" => n <= 536870912;
--		when "0010" => n <= 268435456;
--		when "0011" => n <= 	134217728;
--		when "0100" => n <= 	67108864;
--		when "0101" => n <= 33554432;
--		when "0110" => n <= 16777216;
--		when "0111" => n <= 8388608;
--		when "1000" => n <= 4194304;
--		when "1001" => n <= 2097152;
--		when others => n <=  67108864;
--		end case;
		
		if (rising_edge(clk)) then
		tcount <= tcount + 1;
		tcount1 <= tcount1 + 1;
		case level is
		when "0000" => n <= 134217728;
		when "0001" => n <= 123032912;
		when "0010" => n <= 111848102;
		when "0011" => n <= 100663292;
		when "0100" => n <= 89478482;
		when "0101" => n <= 78293672;
		when "0110" => n <= 67108862;
		when "0111" => n <= 55924052;
		when "1000" => n <= 44739242;
		when "1001" => n <= 33554432;
		when others => n <=  67108864;
		end case;
		l <= level;
--			if(tel = '1') then
--				row <= not row;
--			end if;
			if (tcount mod 4096 = 0) then			   
				startt <= not startt;
			end if;
--			if(tcount mod n = 0) then
--				t<= t+1;
--			end if;	
			if(tcount1 = n) then
			   tcount1 <= 0;
				t<=t+1;
			end if;
			if (t=16) then
				t<= 1;
			end if;
			
		end if;
	end process;
	
end Behavioral;

