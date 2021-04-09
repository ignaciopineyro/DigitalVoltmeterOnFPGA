----------------------------------------------------------------------------------
-- 11_Nbit_HVCounter.vhd // Contador y comparador de 10 bits para los contadores horizontal (800px) y vertical(522). 
-- Alumno: Ignacio Piñeyro
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity nbit_hvcounter is
	port(	
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		FFD_H_out: out std_logic_vector (9 downto 0);
		FFD_V_out: out std_logic_vector (9 downto 0);
		flag_h: out std_logic;
		flag_v: out std_logic);		
end;

architecture nbit_hvcounter_arq of nbit_hvcounter is
    signal contH_Q2comp: std_logic_vector (9 downto 0);
    signal contV_Q2comp: std_logic_vector (9 downto 0);
    signal comp_out2cont_rst: std_logic;
    signal flag_h_aux: std_logic;
    signal flag_v_aux: std_logic;
    signal contH_rst: std_logic;
	signal contV_rst: std_logic;
	signal ena_V: std_logic;
	
	begin
	   nbit_counter_H: entity work.nbit_counter
	   generic map(N => 10)
	   port map(	
			clk => clk,
			ena => ena,
			rst => contH_rst,
			Q => contH_Q2comp );
			
	   contH_rst <= flag_h_aux or rst;
	   FFD_H_out <= contH_Q2comp;
	   
	   nbit_counter_V: entity work.nbit_counter
	   generic map(N => 10)
	   port map(	
			clk => clk,
			ena => ena_V,
			rst => contV_rst,
			Q => contV_Q2comp);
			
	   contV_rst <= (flag_v_aux and flag_h_aux) or rst;
	   FFD_V_out <= contV_Q2comp;	   
	   
	nbits_comp_800: entity work.nbits_comp
	generic map(N => 10)
	port map(	
		ena => ena,
		a => contH_Q2comp,
		b => "1100011111",
		high => open,
		equal => flag_h_aux,
		minor => open);

    flag_h <= flag_h_aux;
	ena_V <= ena and flag_h_aux;
	
	nbits_comp_522: entity work.nbits_comp
	generic map(N => 10)
	port map(	
		ena => ena,
		a => contV_Q2comp,
		b => "1000001001",
		high => open,
		equal => flag_v_aux,
		minor => open);
		
	flag_v <= flag_v_aux;
end;	