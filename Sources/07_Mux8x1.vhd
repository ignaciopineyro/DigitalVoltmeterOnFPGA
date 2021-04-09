----------------------------------------------------------------------------------
-- 07_Mux8x1.vhd // Multiplexor de 8 entradas, 1 salida y 3 entradas de selección.
-- Alumno: Ignacio Piñeyro
----------------------------------------------------------------------------------

library IEEE ;
use IEEE.std_logic_1164.all ;

entity mux_8x1 is
	port(	
		input: in std_logic_vector(7 downto 0);
		a, b, c: in std_logic;
		mux_8x1_out: out std_logic);
end;

architecture mux_8x1_arq of mux_8x1 is 
	signal and_out: std_logic_vector(7 downto 0);

begin
	and_out(0) <= input(0) and not (a) and not (b) and not (c);
	and_out(1) <= input(1) and not (a) and not (b) and c;
	and_out(2) <= input(2) and not (a) and b  and not (c);
	and_out(3) <= input(3) and not (a) and b  and c;
	and_out(4) <= input(4) and a and not (b) and not (c);
	and_out(5) <= input(5) and a and not (b) and c;
	and_out(6) <= input(6) and a and b and not (c);
	and_out(7) <= input(7) and a and b and c;

	mux_8x1_out <= and_out(0) or and_out(1) or and_out(2) or and_out(3) or and_out(4) or and_out(5) or and_out(6) or and_out(7);
	
end;