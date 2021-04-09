----------------------------------------------------------------------------------
-- 09_Mux_Nbits.vhd // Multiplexor de N bits.
-- Alumno: Ignacio Piñeyro
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux_Nbits is 
	generic(N:natural); 	 
    port(    			 
        a: in  std_logic_vector (N-1 downto 0);
        b: in  std_logic_vector (N-1 downto 0);   
        s : in  std_logic; 
        mux_out: out std_logic_vector (N-1 downto 0));  
end mux_Nbits;
   
architecture mux_Nbits_arq of mux_Nbits is
    begin
	   mux_Nbits: for i in 0 to N-1 generate
		  mux_out(i) <= ((not s) and a(i)) or (s and b(i));
	   end generate;
	   
end;