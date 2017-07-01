--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:19:48 03/20/2012
-- Design Name:   
-- Module Name:   Z:/Ref Mat/Demo Projects/Digilent/PmodCLS/HDL/PmodCLS_Demo/PmodCLS_Demo_Test.vhd
-- Project Name:  PmodCLS_Demo
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PmodCLS_Demo
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY PmodCLS_Demo_Test IS
END PmodCLS_Demo_Test;
 
ARCHITECTURE behavior OF PmodCLS_Demo_Test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PmodCLS_Demo
    PORT(
         sw : IN  std_logic_vector(2 downto 0);
         JA : INOUT  std_logic_vector(3 downto 0);
         Led : OUT  std_logic_vector(2 downto 0);
         clk : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal sw : std_logic_vector(2 downto 0) := (others => '0');
   signal clk : std_logic := '0';

	--BiDirs
   signal JA : std_logic_vector(3 downto 0);

 	--Outputs
   signal Led : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PmodCLS_Demo PORT MAP (
          sw => sw,
          JA => JA,
          Led => Led,
          clk => clk
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 


   -- Stimulus process
   stim_proc: process
   begin		
	
	sw(0) <= '1';
	wait for 1ms;
	
	sw(0) <= '0';
	sw(1) <= '1';
	

      wait;
   end process;

END;
