----------------------------------------------------------------------------------
-- Company: Digilent Inc.
-- Engineer: Josh Sackos
-- 
-- Create Date:    15:20:31 06/15/2012 
-- Module Name:    Debounce_Clk_Div
-- Project Name: 	 PmodCLS_Demo
-- Target Devices: Nexys3
-- Tool versions:  ISE 14.1
-- Description: Produces a slower clock signal used for sampling the logic
--					 levels of the inputs.
--
-- Revision:
-- Revision: 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- *******************************************************************************
--  								Define block inputs and outputs
-- *******************************************************************************
entity Debounce_Clk_Div is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           CLKOUT : out  STD_LOGIC);
end Debounce_Clk_Div;

architecture Behavioral of Debounce_Clk_Div is

-- *******************************************************************************
--  									Signals and Constants
-- *******************************************************************************

	--  Maximum counting value
	constant cntendval : STD_LOGIC_VECTOR(15 downto 0) := X"C350";

	--  Keeps track of the current amount counted to
	signal cntval : STD_LOGIC_VECTOR (15 downto 0) := X"0000";

-- *******************************************************************************
--  										 Implementation
-- *******************************************************************************
begin

	COUNT : process (CLK, RST) begin

		--  If the reset button is pressed then start counting from zero again
		if RST = '1' then
			cntval <= X"0000";

		--  Otherwise proceed with count
		elsif (CLK'event and CLK='1') then

			--  If cntval has reached the max value output signal and reset to zeros
			if (cntval = cntendval) then
				cntval <= X"0000";
				CLKOUT <= '1';

			--  Increment cntval
			else
				cntval <= cntval + X"0001";
				CLKOUT <= '0';
			end if;
		end if;
	end process;

end Behavioral;