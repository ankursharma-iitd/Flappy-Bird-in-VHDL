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


-- *******************************************************************************
--  								Define block inputs and outputs
-- *******************************************************************************
entity DFF is
    Port ( D : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
			  RST : in STD_LOGIC;
           Q : inout  STD_LOGIC);
end DFF;

architecture Behavioral of DFF is

-- *******************************************************************************
--  										 Implementation
-- *******************************************************************************
begin

	--  On CLK read incoming data and store it
	STOREDATA : process(CLK, RST, Q)
	begin
		
		if (RST = '1') then
			Q <= '0';
		elsif (CLK'event and CLK='1') then
			Q <= D;
		else
			Q <= Q;
		end if;
		
	end process;

end Behavioral;
