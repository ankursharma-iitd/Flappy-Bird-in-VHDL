----------------------------------------------------------------------------------
-- Company: Digilent Inc.
-- Engineer: Josh Sackos
-- 
-- Create Date:    15:20:31 06/15/2012 
-- Module Name:    three_bit_debouncer
-- Project Name: 	 PmodCLS_Demo
-- Target Devices: Nexys3
-- Tool versions:  ISE 14.1
-- Description: Debounces the START, CLEAR, and RESET signals comming from
--					 switches SW[2:0].
--
-- Revision:
-- Revision: 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- *******************************************************************************
--  								Define block inputs and outputs
-- *******************************************************************************
entity three_bit_debouncer is
    Port ( CLK : in  STD_LOGIC;
			  RST : in STD_LOGIC;
			  DIN : in  STD_LOGIC_VECTOR(2 downto 0);
           DOUT : out  STD_LOGIC_VECTOR(2 downto 0));
end three_bit_debouncer;

architecture Behavioral of three_bit_debouncer is

-- *******************************************************************************
--  									Component Declarations
-- *******************************************************************************


		-- ++++++++++++++++++++++++++++++++++++++++++++++
		-- 					 Data Flip Flop
		-- ++++++++++++++++++++++++++++++++++++++++++++++
		component DFF

			 Port ( D : in  STD_LOGIC;
					  CLK : in  STD_LOGIC;
					  RST : in STD_LOGIC;
					  Q : inout  STD_LOGIC);

		end component;
		
		
		
		-- ++++++++++++++++++++++++++++++++++++++++++++++
		-- 				Debounce Clock Divider
		-- ++++++++++++++++++++++++++++++++++++++++++++++
		component Debounce_Clk_Div

			 Port ( CLK : in  STD_LOGIC;
					  RST : in  STD_LOGIC;
					  CLKOUT : out  STD_LOGIC);

		end component;
		
		
		
-- *******************************************************************************
--  									Signals and Constants
-- *******************************************************************************

signal D0_DFF1OUT : STD_LOGIC := '0';		-- DIN(0) input flip flop 1
signal D0_DFF2OUT : STD_LOGIC := '0';		-- DIN(0) input flip flop 2

signal D1_DFF1OUT : STD_LOGIC := '0';		-- DIN(1) input flip flop 1
signal D1_DFF2OUT : STD_LOGIC := '0';		-- DIN(1) input flip flop 2

signal D2_DFF1OUT : STD_LOGIC := '0';		-- DIN(2) input flip flop 1
signal D2_DFF2OUT : STD_LOGIC := '0';		-- DIN(2) input flip flop 2

signal DCKL : STD_LOGIC := '0';				-- Clock signal debounce flip flops use


-- *******************************************************************************
--  										Implementation
-- *******************************************************************************
begin

	--  Debounce clock divider
	DB_CLK_DIV: Debounce_Clk_Div port map(
			CLK=>CLK,
			RST=>RST,
			CLKOUT=>DCKL
	);





   --  DIN(0), data flip flop 1
	D0_DFF1: DFF port map(
			D=>DIN(0),
			CLK=>DCKL,
			RST=>RST,
			Q=>D0_DFF1OUT
	);
	
   --  DIN(0), data flip flop 2
	D0_DFF2: DFF port map(
			D=>D0_DFF1OUT,
			CLK=>DCKL,
			RST=>RST,
			Q=>D0_DFF2OUT
	);




   --  DIN(1), data flip flop 1
	D1_DFF1: DFF port map(
			D=>DIN(1),
			CLK=>DCKL,
			RST=>RST,
			Q=>D1_DFF1OUT
	);
	
   --  DIN(1), data flip flop 2
	D1_DFF2: DFF port map(
			D=>D1_DFF1OUT,
			CLK=>DCKL,
			RST=>RST,
			Q=>D1_DFF2OUT
	);




   --  DIN(2), data flip flop 1
	D2_DFF1: DFF port map(
			D=>DIN(2),
			CLK=>DCKL,
			RST=>RST,
			Q=>D2_DFF1OUT
	);
	
   --  DIN(2), data flip flop 2
	D2_DFF2: DFF port map(
			D=>D2_DFF1OUT,
			CLK=>DCKL,
			RST=>RST,
			Q=>D2_DFF2OUT
	);


   --  Logical "and" both outputs of D0 flip flops to ensure no noise
	DOUT(0) <= D0_DFF1OUT and D0_DFF2OUT;
	
   --  Logical "and" both outputs of D1 flip flops to ensure no noise
	DOUT(1) <= D1_DFF1OUT and D1_DFF2OUT;
	
   --  Logical "and" both outputs of D2 flip flops to ensure no noise
	DOUT(2) <= D2_DFF1OUT and D2_DFF2OUT;

end Behavioral;

