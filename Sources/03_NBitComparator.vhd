----------------------------------------------------------------------------------
-- 03_NBitComparator.vhd // Comparador de N bits. 
-- Alumno: Ignacio Piñeyro
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity nbits_comp is
    generic (N : integer := 4);
	port(
		ena: in std_logic;
		a: in std_logic_vector (N-1 downto 0);
		b: in std_logic_vector (N-1 downto 0);
		high : out std_logic;
		equal : out std_logic;
		minor : out std_logic);
end;

architecture nbits_comp_arq of nbits_comp is
	signal AhighB_out : std_logic_vector (N-1 downto 0);
	signal AequalB_out : std_logic_vector (N downto 0);
	signal AminorB_out : std_logic_vector (N-1 downto 0);
	signal out_or_1: std_logic_vector (N-1 downto 0);
	signal out_or_2: std_logic_vector (N-1 downto 0);
  
    begin	
	   AequalB_out(N) <= ena;
	   nbits_comp: for i in 0 to N-1 generate
	       nbits_comp: entity work.bit_comp
	       port map(	
		      ena => AequalB_out(i+1),
			  a => a(i),
			  b => b(i),
			  AhighB => AhighB_out(i),
			  AequalB => AequalB_out(i),
			  AminorB => AminorB_out(i));	
       end generate;
             
    
       out_or_2(0) <= AminorB_out(0);
       out_or_1(0) <= AhighB_out(0);
       or_outs: for i in 1 to N-1 generate
           out_or_2(i) <= out_or_2(i-1) or AminorB_out(i);
           out_or_1(i) <= out_or_1(i-1) or AhighB_out(i);
	   end generate;

       high <= out_or_1(N-1) and not (AequalB_out(0)) and not (out_or_2(N-1));
       minor <= not (out_or_1(N-1)) and not (AequalB_out(0)) and out_or_2(N-1);
       equal <= not (out_or_1(N-1)) and AequalB_out(0) and not (out_or_2(N-1));
end;
