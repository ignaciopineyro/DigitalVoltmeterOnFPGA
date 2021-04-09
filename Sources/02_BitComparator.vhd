----------------------------------------------------------------------------------
-- 02_BitComparator.vhd // Comparador de 1 bit. 
-- Alumno: Ignacio Piñeyro
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity bit_comp is
	port(
		ena: in std_logic;
		a: in std_logic;
		b: in std_logic;
		AhighB: out std_logic;
		AequalB: out std_logic;
		AminorB: out std_logic);
end entity;

architecture bit_comp_arq of bit_comp is
	begin	
		AhighB <= ena and a and not b;
		AequalB <= ena and (a xnor b);
		AminorB <= ena and not a and b;	
end;