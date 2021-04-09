----------------------------------------------------------------------------------
-- 04_OneDigitBCDCounter.vhd // Contador BCD de 1 digito.
-- Alumno: Ignacio Piñeyro
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity BCD_Count is	
	port(		
		clk : in std_logic;
		rst : in std_logic;
		ena : in std_logic;
		out_9 : out std_logic;
		out_BCD : out std_logic_vector (3 downto 0));
end ;

architecture BCD_Count_arq of BCD_Count is
	signal or_rst: std_logic;
	signal q_out_bcd: std_logic_vector (3 downto 0);
	signal out_9_aux: std_logic;
	
	begin	
		BCD_Count: entity work.nbit_counter
		generic map(
			N => 4)
		port map(	
			clk => clk,
			ena => ena,
			rst => or_rst,
			Q => q_out_bcd);
		
		out_9_aux <= q_out_bcd(3) and (not q_out_bcd(2)) and (not q_out_bcd(1)) and q_out_bcd(0);
		out_9 <= out_9_aux;
		or_rst <= rst or (out_9_aux and ena);
		out_BCD <= q_out_bcd;
		
end ;