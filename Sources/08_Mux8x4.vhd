----------------------------------------------------------------------------------
-- 08_Mux8x4.vhd // Multiplexor de 8 entradas, 4 salidas y 3 entradas de selección. 
-- Alumno: Ignacio Piñeyro
----------------------------------------------------------------------------------

library IEEE ;
use IEEE.std_logic_1164.all ;

entity mux_8x4 is
generic( N: integer :=4);
	port(
		D1: in std_logic_vector (N-1 downto 0);
		P: in std_logic_vector (N-1 downto 0);
		D2: in std_logic_vector (N-1 downto 0);
		D3: in std_logic_vector (N-1 downto 0);
		V: in std_logic_vector (N-1 downto 0);
		S: in std_logic_vector (2 downto 0);
		out_mux_8x4: out std_logic_vector (3 downto 0));
end;

architecture mux_8x4_arq of mux_8x4 is

	begin	
		mux_8x4: for i in 0 to N-1 generate
		mux8x1: entity work.mux_8x1
		
		port map(		
			input(0) => D1(i),
			input(1) => P(i),
			input(2) => D2(i),
			input(3) => D3(i),
			input(4) => V(i),
			input(5) => '0',
			input(6) => '0',
			input(7) => '0',
			a => S(2),
			b => S(1),
			c => S(0),
			mux_8x1_out => out_mux_8x4(i));
	end generate;
	
end;	