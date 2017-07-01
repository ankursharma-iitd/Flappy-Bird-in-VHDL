----------------------------------------------------------------------------------
-- Company: Digilent Inc.
-- Engineer: Andrew Skreen
-- 
-- Create Date:    17:25:25 03/01/2012 
-- Module Name:    command_lookup
-- Project Name: 	 PmodCLS_Demo
-- Target Devices: Nexys3
-- Tool versions:  ISE 14.1
-- Description: Outputs a byte of data to be sent to the PmodCLS.
--
-- Revision: 1.00 - Added debouncing, comments, fixed reset issue.
-- Revision: 0.01 - File Created
----------------------------------------------------------------------------------
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--
--package instruction_buffer_type is
--    type instructionBuffer is array(0 to 33) of std_logic_vector (7 downto 0);
--end package instruction_buffer_type;
--
--use work.instruction_buffer_type.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- *******************************************************************************
--  								Define block inputs and outputs
-- *******************************************************************************
entity command_lookup is
    Port ( sel : in integer range 0 to 47;
--			  input: in instructionBuffer;
				row : in std_logic;
				t: in integer;
--				done: in std_logic;
--				done2: in std_logic;
           data_out : out  STD_LOGIC_VECTOR (7 downto 0));
end command_lookup;

architecture Behavioral of command_lookup is

-- *******************************************************************************
--  								Signals, Constants, and Types
-- *******************************************************************************

	-- Define data type to hold bytes of data to be written to PmodCLS
	type LOOKUP is array ( 0 to 47 ) of std_logic_vector (7 downto 0);
												
	-- Hexadecimal values below represent ASCII characters
	signal command1 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												"00111110",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
												
		signal command2 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												"00111110",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
												
			signal command3 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												"00111110",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
												
				signal command4: LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												"00111110",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
	signal command5 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												"00111110",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
												
		signal command6 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												"00111110",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
												
			signal command7 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												X"47",
												X"41",
												X"4D",
												X"45",
												X"20",
												X"4F",
												X"56",
												X"45",
												X"52",
												X"21",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--null
												X"00");
												
				signal command8 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												"00111110",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
	signal command9 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												"00111110",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
												
		signal command10 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												"00111110",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
												
			signal command11 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												"00111110",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
												
				signal command12 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"00111110",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
	signal command13 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												"00111110",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
												
		signal command14 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												X"47",
												X"41",
												X"4D",
												X"45",
												X"20",
												X"4F",
												X"56",
												X"45",
												X"52",
												X"21",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--null
												X"00");
												
			signal command15 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												"00111110",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
												
				signal command16 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												"00111110",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
	signal command17 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												"00111110",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
												
		signal command18 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												"00111110",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
												
			signal command19 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"00111110",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
												
				signal command20 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												"00111110",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
	signal command21 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												X"47",
												X"41",
												X"4D",
												X"45",
												X"20",
												X"4F",
												X"56",
												X"45",
												X"52",
												X"21",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--null
												X"00");
												
		signal command22 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												"00111110",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
												
			signal command23 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												"00111110",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
												
				signal command24 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												"00111110",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
	signal command25 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												"00111110",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
												
		signal command26 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"00111110",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
												
			signal command27 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												"00111110",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
												
				signal command28 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												X"47",
												X"41",
												X"4D",
												X"45",
												X"20",
												X"4F",
												X"56",
												X"45",
												X"52",
												X"21",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--null
												X"00");
	signal command29 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												"00111110",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
												
		signal command30 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												"00111110",
												X"20",
												--null
												X"00");
												
			signal command31 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												"00111110",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												--null
												X"00");
												
				signal command32 : LOOKUP  := (  X"1B",
												X"5B",
												X"6A",
												--Cursor to 0,0
												X"1B",
												X"5B",
												X"30",
												X"3B",
												X"30",
												X"48",
												--Top row
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												--Cursor to 1,0
												X"1B",
												X"5B",
												X"31",
												X"3B",
												X"30",
												X"48",
												--Bottom Row
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												X"20",
												"11111111",
												X"20",
												"00111110",
												--null
												X"00");
												
signal done: std_logic := '0';
signal score: integer range 0 to 9:=0;
-- *******************************************************************************
--  										Implementation
-- *******************************************************************************
begin
--	process(score)
--	begin
--		case score is
--		when 0 => command7(41) <= X"30";
--		when 1 => command7(41) <= X"31";
--		when 2 => command7(41) <= X"32";
--		when 3 => command7(41) <= X"33";
--		when 4 => command7(41) <= X"34";
--		when 5 => command7(41) <= X"35";
--		when 6 => command7(41) <= X"36";
--		when 7 => command7(41) <= X"37";
--		when 8 => command7(41) <= X"38";
--		when 9 => command7(41) <= X"39";
--		end case;
--	end process;
--	 Assign byte to output
	process(row)
	begin
		if done = '1' then
--		case score is
--		when 0 => command7(41) <= X"30";
--		when 1 => command7(41) <= X"31";
--		when 2 => command7(41) <= X"32";
--		when 3 => command7(41) <= X"33";
--		when 4 => command7(41) <= X"34";
--		when 5 => command7(41) <= X"35";
--		when 6 => command7(41) <= X"36";
--		when 7 => command7(41) <= X"37";
--		when 8 => command7(41) <= X"38";
--		when 9 => command7(41) <= X"39";
--		end case;
		data_out<=command7(sel);
		elsif row='0' then
		case t is
		when 1 => data_out <= command1( sel );
		when 2 => data_out <= command3( sel );
		when 3 => data_out <= command5( sel );
		when 4 => data_out <= command7( sel ); done<='1';		
		when 5 => data_out <= command9( sel );
		when 6 => data_out <= command11( sel );
		when 7 => data_out <= command13( sel );--score<=score+1;
		when 8 => data_out <= command15( sel );
		when 9 => data_out <= command17( sel );
		when 10 => data_out <= command19( sel );
		when 11 => data_out <= command21( sel ); done<='1';
		when 12 => data_out <= command23( sel );
		when 13 => data_out <= command25( sel );
		when 14 => data_out <= command27( sel );--score<=score+1;
		when 15 => data_out <= command29( sel );
		when 16 => data_out <= command31( sel );
		when others => data_out <= command7( sel );
		end case;
		else
		case t is
		when 1 => data_out <= command2( sel );
		when 2 => data_out <= command4( sel );
		when 3 => data_out <= command6( sel );
		when 4 => data_out <= command8( sel );	--score<=score+1;	
		when 5 => data_out <= command10( sel );
		when 6 => data_out <= command12( sel );
		when 7 => data_out <= command14( sel ); done<='1';
		when 8 => data_out <= command16( sel );
		when 9 => data_out <= command18( sel );
		when 10 => data_out <= command20( sel );
		when 11 => data_out <= command22( sel ); --score<=score+1;
		when 12 => data_out <= command24( sel );
		when 13 => data_out <= command26( sel );
		when 14 => data_out <= command28( sel ); done<='1';
		when 15 => data_out <= command30( sel );
		when 16 => data_out <= command32( sel );
		when others => data_out <= command7( sel );
		end case;
		end if;
	end process;
end Behavioral;

