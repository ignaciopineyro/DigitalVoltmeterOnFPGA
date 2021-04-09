----------------------------------------------------------------------------------
-- 10_PulseCounter.vhd // Contador de pulsos.
-- Alumno: Ignacio Piñeyro
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity pulse_count is

	port (	
		clk: in std_logic;
		rst: in std_logic;
		ADC_out: in std_logic;
		ena: in std_logic;
		pulse_count_out: out std_logic_vector(11 downto 0));
end;

architecture pulse_count_arq of pulse_count is
	signal comp_out2ena: std_logic;
	signal BCD_out2reg: std_logic_vector (19 downto 0);
	signal cont_Q2comp: std_logic_vector (15 downto 0); 
	signal cont_rst2comp_out: std_logic;
	
	begin	
	   nbit_counter: entity work.nbit_counter
	    generic map(N => 16)
	
	port map(
		clk => clk,
		rst => cont_rst2comp_out,
		ena => ena,
		Q => cont_Q2comp);
	
	cont_rst2comp_out <= comp_out2ena or rst;
	
	nbits_comp: entity work.nbits_comp
	    generic map(N => 16)

	port map(	
		ena => ena,
		a => cont_Q2comp,
		b => "1000000011101000",
		high => open,
		equal => comp_out2ena,
		minor => open);
	
	Nd_BCD_Count: entity work.Nd_BCD_Count
	    generic map(N => 5)
	
	port map(
		clk => clk,
		rst => cont_rst2comp_out,
		ena => ADC_out,
		out_BCD => BCD_out2reg);
	
	NBit_Register_1: entity work.nbit_reg
	    generic map(N => 4)
	
	port map(	
		clk => clk,
		rst => rst,
		ena => comp_out2ena,
		reg_in => BCD_out2reg(19 downto 16),
		reg_out => pulse_count_out(11 downto 8));
	
	NBit_Register_2: entity work.nbit_reg
	    generic map(N => 4)
	
	port map(	
		clk => clk,
		rst => rst,
		ena => comp_out2ena,
		reg_in => BCD_out2reg(15 downto 12),
		reg_out => pulse_count_out (7 downto 4));
	
	NBit_Register_3: entity work.nbit_reg
	    generic map(N => 4)
	
	port map( 
		clk => clk,
		rst => rst,
		ena => comp_out2ena,
		reg_in => BCD_out2reg(11 downto 8),
		reg_out => pulse_count_out (3 downto 0));
	
end;		
		