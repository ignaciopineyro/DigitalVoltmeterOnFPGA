----------------------------------------------------------------------------------
-- 12_HV_Counter.vhd // Generador de señales de VGA (Sync + BackPorch + Visible + Front Porch). 
-- Alumno: Ignacio Piñeyro
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity HV_count is
	port(	
		ena: in std_logic;
		rst: in std_logic;
		clk: in std_logic;
		mux_x: out std_logic;
		mux_y: out std_logic;
		H_count_out: out std_logic_vector (9 downto 0);
		V_count_out: out std_logic_vector (9 downto 0);
		H_sync: out std_logic;
		V_sync: out std_logic;
		flag_800px: out std_logic;
		flag_522px: out std_logic);
end;

architecture HV_count_arq of HV_count is
	signal H_out: std_logic_vector (9 downto 0);
	signal V_out: std_logic_vector (9 downto 0);
	
	signal flag_800px_aux: std_logic;
	signal flag_522px_aux: std_logic;

	signal H_pwb: std_logic_vector(9 downto 0) := "0001011111";	    -- Ancho del pulso de sincronismo horizontal - 1 (comparador >) = (96 - 1,"00 0101 1111")
	signal V_pwb: std_logic_vector(9 downto 0) := "0000000001";	    -- Ancho del pulso de sincronismo vertical - 1 (comparador >) = (2 - 1, "00 0000 0001")
	signal H_bp: std_logic_vector(9 downto 0) := "0010001111"; 	    -- Back porch horizontal (48) + hpw (96) - 1 (comparador >) = (144 - 1, "00 1000 1111")
	signal V_bp: std_logic_vector(9 downto 0) := "0000100000"; 	    -- Back porch vertical (31) + vpw (2) - 1 (comparador >) = (32 - 1, "00 0001 1111")
	signal view_Hfp: std_logic_vector(9 downto 0) := "1100010000"; 	-- Front porch horizontal (16). Visible (640) + HBP (48) + hpw (96) = (784, "11 0001 0000")
	signal view_Vfp: std_logic_vector(9 downto 0) := "0111111111"; 	-- Front porch vertical (11). Visible (480) + VBP (31) + vpw (2) = (511, "01 1111 1111")
	
	signal comp_out_1: std_logic;	
	signal comp_out_2: std_logic;	
	signal comp_out_3: std_logic;
	signal comp_out_4: std_logic;
	signal comp_out_5: std_logic;
	signal comp_out_6: std_logic;

	begin
		nbit_hvcounter: entity work.nbit_hvcounter
		port map(	
		    clk => clk,	
		    rst => rst,
			ena => ena,
            FFD_H_out => H_out,
			FFD_V_out => V_out,
			flag_h => flag_800px_aux,
			flag_v => flag_522px_aux);
			
		nbits_comp_1: entity work.nbits_comp
		generic map (N => 10)
		port map(
		    ena => ena,
			a => H_out,
			b => H_pwb,
			high => comp_out_1,
			equal => open,
			minor => open);

		H_sync <= not comp_out_1;
		
		nbits_comp_2: entity work.nbits_comp
		generic map(N => 10)
		port map(
		    ena => ena,		    
			a => H_out,
			b => H_bp,
			high => comp_out_2,
			equal => open,
			minor => open);
		
		nbits_comp_3: entity work.nbits_comp
		generic map (N => 10)
		port map(
		    ena => ena,
			a => H_out,
			b => view_Hfp,
			high => open,
			equal => open,
			minor => comp_out_3);

		nbits_comp_4: entity work.nbits_comp
		generic map (N => 10)
		port map(
		    ena => ena,
			a => V_out,
			b => V_pwb,
			high => comp_out_4,
			equal => open,
			minor => open);
		
		V_sync <= not comp_out_4;
		
		nbits_comp_5: entity work.nbits_comp
		generic map (N => 10)
		port map(
		    ena => ena,
			a => V_out,
			b => V_bp,
			high => comp_out_5,
			equal => open,
			minor => open);
			
		nbits_comp_6: entity work.nbits_comp
		generic map (N => 10)
		port map(
		    ena => ena,
			a => V_out,
			b => view_Vfp,			
			high => open,
			equal => open,
			minor => comp_out_6);
		
	H_count_out <= H_out;         
	V_count_out <= V_out;
	
	flag_800px <= flag_800px_aux; 
	flag_522px <= flag_522px_aux;       

	mux_x <= comp_out_2 and comp_out_3;
	mux_y <= comp_out_5 and comp_out_6; 
	
end;