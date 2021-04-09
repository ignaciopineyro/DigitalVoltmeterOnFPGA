----------------------------------------------------------------------------------
-- 05_NDigitsBCDCounter.vhd // Contador BCD de N digitos.
-- Alumno: Ignacio Piñeyro
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Nd_BCD_Count is

	generic (N : integer);
	--generic (N: integer :=4); --Esta línea es para simular este bloque individualmente.
	port(
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		out_BCD: out std_logic_vector ((4*N)-1 downto 0));
end;

architecture Nd_BCD_Count_arq of Nd_BCD_Count is

    signal and2ena : std_logic_vector ( N downto 0 );
    signal out_nine2and : std_logic_vector ( N  downto 0 );

    begin
        out_nine2and(0) <= '1';
        and2ena(0) <= out_nine2and(0) and ena;

        cont_BCD_Nd: for i in 0 to N-1 generate

        OneD_BCD_Count: entity work.BCD_Count

        port map(
            clk => clk,
            rst => rst ,
            ena => and2ena(i),
            out_9 => out_nine2and(i+1),
            out_BCD => out_BCD(4*i+3 downto 4*i));

        and2ena(i+1) <= and2ena(i) and out_nine2and(i+1);

        end generate ;
end;