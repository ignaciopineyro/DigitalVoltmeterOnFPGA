----------------------------------------------------------------------------------
-- 06_NBit_Register.vhd // Registro de N Bits.
-- Alumno: Ignacio Piñeyro
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all ;

entity nbit_reg is
    generic ( N : integer);
	port(		
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		reg_in: in std_logic_vector (N-1 downto 0);
		reg_out: out std_logic_vector (N-1 downto 0));
end;

architecture nbit_reg_arq of nbit_reg is
	begin
		nbit_reg: for i in 0 to N-1 generate
		FFD: entity work.FFD
		port map(		
			clk => clk,
			rst => rst,
			ena => ena,
			D => reg_in(i),
			Q => reg_out(i));
	end generate;
end;