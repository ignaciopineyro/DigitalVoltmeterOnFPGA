----------------------------------------------------------------------------------
-- FFD.vhd // FlipFlop D 
-- Alumno: Ignacio Piñeyro
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FFD is
    Port ( D : in STD_LOGIC;
           clk : in STD_LOGIC;
           ena : in STD_LOGIC;
           rst : in STD_LOGIC;
           Q : out STD_LOGIC);
end FFD;

architecture FFD_arq of FFD is
begin
	process(clk, rst)
	begin
		if rising_edge(clk) then
			if rst = '1' then
			    Q <= '0';
			elsif ena = '1' then
				Q <= D;
			end if;
		end if;
	end process;
end;