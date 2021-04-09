----------------------------------------------------------------------------------
-- 01_NBitCounter.vhd // Contador binario de N bits
-- Alumno: Ignacio Piñeyro
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity nbit_counter is
	generic (N: integer);
	port(
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		Q: out std_logic_vector (N-1 downto 0));
end;

architecture nbit_counter_arq of nbit_counter is
	signal out_and: std_logic_vector (N downto 0);
	signal out_xor: std_logic_vector (N-1 downto 0);
	signal out_ffd: std_logic_vector (N-1 downto 0);
	
	begin
		out_and(0) <= '1';
		nbit_counter: for i in 0 to N-1 generate
			out_xor(i) <= out_and(i) xor out_ffd(i);
			out_and(i+1) <= out_and(i) and out_ffd(i);
			
			FFD_i: entity work.FFD 
			port map(
				clk => clk,
				rst => rst,
				ena => ena,
				D => out_xor(i),
				Q => out_ffd(i));
		Q(i) <= out_ffd(i);	
	end generate;
end;
