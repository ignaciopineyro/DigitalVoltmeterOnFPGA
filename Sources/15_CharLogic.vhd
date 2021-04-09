----------------------------------------------------------------------------------
-- 15_CharLogic.vhd // Logica de seleccion de caracteres. 
-- Alumno: Ignacio Piñeyro
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity char_logic is
	port(
		pixel_x: in std_logic_vector(9 downto 0);
		pixel_y: in std_logic_vector(9 downto 0);
		rom_col: out std_logic_vector(2 downto 0);
		rom_row: out std_logic_vector(2 downto 0);
		mux_sel: out std_logic_vector(2 downto 0));
end;

architecture char_logic_arq of char_logic is

    begin
	   mux_sel <= pixel_x(9) & pixel_x(8) & pixel_x(7);
	   rom_col <= pixel_x(6) & pixel_x(5) & pixel_x(4);
	   rom_row <= pixel_y(6) & pixel_y(5) & pixel_y(4);
end;