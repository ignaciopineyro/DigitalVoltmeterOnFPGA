----------------------------------------------------------------------------------
-- 16_VGA.vhd // Control para la VGA. 
-- Alumno: Ignacio Piñeyro
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity VGA is
    port(
	   ena: in std_logic;
	   rst: in std_logic;
	   clk: in std_logic;	
	   cont2reg: in std_logic_vector (11 downto 0);	
	   H_sync: out std_logic;
	   V_sync: out std_logic;
	   R_out: out std_logic;
	   G_out: out std_logic;
	   B_out: out std_logic;
	   flag_H: out std_logic;
	   flag_V: out std_logic);
end;

architecture VGA_arq of VGA is

	--CONTADOR HV
	signal comp2mux_x: std_logic;
	signal H_count_out: std_logic_vector (9 downto 0); 
	signal Hsync2reg: std_logic;
	
	signal comp2mux_y: std_logic;
	signal V_count_out: std_logic_vector (9 downto 0);
	signal contV2reg: std_logic;
	
	--LOGICA
	signal pixel_x: std_logic_vector (9 downto 0);
	signal pixel_y: std_logic_vector (9 downto 0);
	signal mux2logica: std_logic_vector (2 downto 0); 
	
	--ROM
	signal rom2and: std_logic;
	signal logica2rom_col: std_logic_vector (2 downto 0);
	signal logica2rom_row: std_logic_vector (2 downto 0);
	signal mux2rom: std_logic_vector (3 downto 0);
	
	--RESTADORES
	--signal H_bp: std_logic_vector(9 downto 0) := "0010010000"; 	-- Hpw + H_bp (144, "00 1001 0000")
	signal resta_h: std_logic_vector (9 downto 0);
	signal flagH2count: std_logic;

	signal V_bp: std_logic_vector(9 downto 0) := "0000100001"; 	-- Vpw + V_bp (33, "00 0001 1111")
	signal resta_v: std_logic_vector (9 downto 0);
	signal flagV2count: std_logic;
	signal restaVena: std_logic;
	
	signal vidon_aux: std_logic;
	signal printline: std_logic;
	signal and_rom: std_logic;
	signal and_rgb: std_logic;
	signal reg2mux: std_logic_vector(11 downto 0);
	signal reg2rgb: std_logic;
	
	begin
			
		HV_count: entity work.HV_count
		port map(
			ena => ena,
			rst => rst,
			clk => clk,
			mux_x => comp2mux_x,
			mux_y => comp2mux_y,
			H_count_out => H_count_out,
			V_count_out => V_count_out,
			H_sync => Hsync2reg,
			V_sync => contV2reg,
			flag_800px => flagH2count,
			flag_522px => flagV2count);
		
		flag_V <= flagV2count;
				
		FFD_1: entity work.FFD
		port map(
			clk => clk,
			rst => rst,
			ena => ena,
			D => Hsync2reg,
			Q => H_sync);
			
--		restador_H: entity work.restador -- Necesita el uso de numeric_std
--		port map(
--			A => H_count_out,
--			B => H_bp,
--			rest_out => resta_h);

        NBitCounter_restaH: entity work.nbit_counter
        generic map(N => 10)
        port map(
            clk => clk,
            rst => flagH2count,
            ena => comp2mux_x,
            Q => resta_h);
            
        NBitCounter_restaV: entity work.nbit_counter
        generic map(N => 10)
        port map(
            clk => clk,
            rst => flagV2count,
            ena => restaVena,
            Q => resta_v);
            
        restaVena <= flagH2count and comp2mux_y;
			
		FFD_2: entity work.FFD
		port map(
			clk => clk,
			rst => rst,
			ena => ena,
			D => contV2reg,
			Q => V_sync);
		
	   
	    printline <= pixel_y(7) and (not pixel_y(8)) and (not pixel_y(9));
		vidon_aux <= comp2mux_x and comp2mux_y;

--		restador_V: entity work.restador -- Necesito el uso de numeric_std
--		port map(		
--			A => V_count_out,
--			B => V_bp,
--			rest_out => resta_v);
			
		mux_Nbits_H: entity work.mux_Nbits
		generic map (N => 10)
		port map(
			A => "0000000000",
			B => resta_h,
			S => comp2mux_x,
			mux_out => pixel_x);	
		
		mux_Nbits_V: entity work.mux_Nbits
		generic map(N => 10)
		port map(
			A => "0000000000",
			B => resta_v,
			S => comp2mux_y,
			mux_out => pixel_y);		

		char_logic: entity work.char_logic
		port map(	
			pixel_x => pixel_x,
			pixel_y => pixel_y,
			rom_col => logica2rom_col,
			rom_row => logica2rom_row,
			mux_sel => mux2logica);
		 
		char_ROM: entity work.char_ROM
		port map(
			char => mux2rom,
			row => logica2rom_row,
			col => logica2rom_col,
			rom_out => rom2and);
		
		and_rom <= rom2and and printline;
		and_rgb <= and_rom and vidon_aux;
		
		FFD_3: entity work.FFD
		port map(		
			clk => clk,
			rst => rst,
			ena => ena,
			D => and_rgb,
			Q => reg2rgb);
		
		nbit_reg_4: entity work.nbit_reg
		generic map (N => 12)
		port map(
			clk => clk,
			rst => rst,
			ena => ena,
			reg_in => cont2reg,
			reg_out => reg2mux);
		
		mux_8x4: entity work.mux_8x4
		port map(
			D1 => reg2mux (11 downto 8),
			P => "1011",
			D2 => reg2mux (7 downto 4),
			D3 => reg2mux (3 downto 0),
			V => "1010",
			S => mux2logica,
			out_mux_8x4 => mux2rom);
		 
		R_out <= reg2rgb;
		G_out <= reg2rgb;
		B_out <= reg2rgb;
	
end;