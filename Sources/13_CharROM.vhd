----------------------------------------------------------------------------------
-- 13_CharROM.vhd // ROM de caracteres. 
-- Alumno: Ignacio Piñeyro
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity char_ROM is
	port(
		char: in std_logic_vector (3 downto 0);
		row, col: in std_logic_vector (2 downto 0);
		rom_out: out std_logic);
end;

architecture char_ROM_arq of char_ROM is

	type caracter is array (0 to 7) of std_logic_vector (0 to 7);
	type dir is array (0 to 255) of std_logic_vector (0 to 7);
		
	constant cero: caracter :=(
			"00000000",
			"01111110",
			"01000010",
			"01000010",
			"01000010",
			"01000010",
			"01111110",
			"00000000");
			
	constant uno: caracter :=(
			"00000000",
			"00111000",
			"00001000",
			"00001000",
			"00001000",
			"00001000",
			"00111110",
			"00000000");
				
	constant dos: caracter :=(
			"00000000",
			"01111110",
			"00000010",
			"01111110",
			"01000000",
			"01000000",
			"01111110",
			"00000000");
	
	constant tres: caracter :=(
			"00000000",
			"01111110",
			"00000010",
			"00011110",
			"00000010",
			"00000010",
			"01111110",
			"00000000");
	
	constant cuatro: caracter :=(
			"00000000",
			"01000010",
			"01000010",
			"01000010",
			"01111110",
			"00000010",
			"00000010",
			"00000000");
	
	constant cinco: caracter :=(
			"00000000",
			"01111110",
			"01000000",
			"01111110",
			"00000010",
			"00000010",
			"01111110",
			"00000000");
	
	constant seis: caracter :=(
			"00000000",
			"01111110",
			"01000000",
			"01111110",
			"01000010",
			"01000010",
			"01111110",
			"00000000");
	
	constant siete: caracter :=(
			"00000000",
			"01111110",
			"00000010",
			"00000010",
			"00000010",
			"00000010",
			"00000010",
			"00000000");
	
	constant ocho: caracter :=(
			"00000000",
			"01111110",
			"01000010",
			"01111110",
			"01000010",
			"01000010",
			"01111110",
			"00000000");
	
	constant nueve: caracter :=(
			"00000000",
			"01111110",
			"01000010",
			"01000010",
			"01111110",
			"00000010",
			"00000010",
			"00000000");
	
	constant punto: caracter :=(
			"00000000",
			"00000000",
			"00000000",
			"00000000",
			"00000000",
			"00011000",
			"00011000",
			"00000000");
	
	constant V: caracter :=(
			"00000000",
			"01000010",
			"01000010",
			"00100100",
			"00100100",
			"00011000",
			"00011000",
			"00000000");
	
	constant blank: caracter :=(
			"00000000",
			"00000000",
			"00000000",
			"00000000",
			"00000000",
			"00000000",
			"00000000",
			"00000000");
	
	signal char_dir: dir:=(
		0 => cero(0), 1 => cero(1), 2 => cero(2), 3 => cero(3), 4 => cero(4), 5 => cero(5), 6 => cero(6), 7 => cero(7),
		8 => uno(0), 9 => uno(1), 10 => uno(2), 11 => uno(3), 12 => uno(4), 13 => uno(5), 14 => uno(6), 15 => uno(7),
		16 => dos(0), 17 => dos(1), 18 => dos(2), 19 => dos(3), 20 => dos(4), 21 => dos(5), 22 => dos(6), 23 => dos(7),
		24 => tres(0), 25 => tres(1), 26 => tres(2), 27 => tres(3), 28 => tres(4), 29 => tres(5), 30 => tres(6), 31 => tres(7),
		32 => cuatro(0), 33 => cuatro(1), 34 => cuatro(2), 35 => cuatro(3), 36 => cuatro(4), 37 => cuatro(5), 38 => cuatro(6), 39 => cuatro(7),
		40 => cinco(0), 41 => cinco(1), 42 => cinco(2), 43 => cinco(3), 44 => cinco(4), 45 => cinco(5), 46 => cinco(6), 47 => cinco(7),
		48 => seis(0), 49 => seis(1), 50 => seis(2), 51 => seis(3), 52 => seis(4), 53 => seis(5), 54 => seis(6), 55 => seis(7),
		56 => siete(0), 57 => siete(1), 58 => siete(2), 59 => siete(3), 60 => siete(4), 61 => siete(5), 62 => siete(6), 63 => siete(7),
		64 => ocho(0), 65 => ocho(1), 66 => ocho(2), 67 => ocho(3), 68 => ocho(4), 69 => ocho(5), 70 => ocho(6), 71 => ocho(7),
		72 => nueve(0), 73 => nueve(1), 74 => nueve(2), 75 => nueve(3), 76 => nueve(4), 77 => nueve(5), 78 => nueve(6), 79 => nueve(7),
		80 => V(0), 81 => V(1), 82 => V(2), 83 => V(3), 84 => V(4), 85 => V(5), 86 => V(6), 87 => V(7),
		88 => punto(0), 89 => punto(1), 90 => punto(2), 91 => punto(3), 92 => punto(4), 93 => punto(5), 94 => punto(6), 95 => punto(7),
		96 => blank(0), 97 => blank(1), 98 => blank(2), 99 => blank(3), 100 => blank(4), 101 => blank(5), 102 => blank(6), 103 => blank(7),
		104 to 255 => "00000000");
	
begin

    rom_out <= char_dir(to_integer(unsigned(char) & unsigned(row)))(to_integer(unsigned(col)));
	
end;
	
	