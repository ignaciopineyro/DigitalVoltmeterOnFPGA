----------------------------------------------------------------------------------
-- 17_Voltmeter.vhd // Control del voltimetro. 
-- Alumno: Ignacio Piñeyro
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity voltmeter is
	port(
		clk: in std_logic;
		ena: in std_logic;
		rst: in std_logic;

		data_volt_in: in std_logic;
		data_volt_out: out std_logic;		
		
		H_sync: out std_logic;
		V_sync: out std_logic;
		
		R_out: out std_logic;
		G_out: out std_logic;
		B_out: out std_logic);
end;

architecture voltmeter_arq of voltmeter is	
   signal sigmadelta: std_logic;
   signal flagV2reg: std_logic;
   signal pulse2reg: std_logic_vector(11 downto 0);
   signal reg2VGA: std_logic_vector(11 downto 0);
   

begin	
   data_volt_out <= not sigmadelta;
	
   FFD: entity work.ffd
   port map(
        clk => clk,
        rst => rst,
        ena => ena,
        D => data_volt_in,
        Q => sigmadelta);

    pulse_count: entity work.pulse_count
    port map(
	    ena => ena,
	    rst => rst,
		clk => clk,
		ADC_out => sigmadelta,
		pulse_count_out => pulse2reg);
	

    VGA: entity work.VGA
    port map(
        ena => ena,
        clk => clk,
        rst => rst,
        cont2reg => reg2VGA,
        H_sync => h_sync,
        V_sync => v_sync,
        R_out => R_out,
        G_out => G_out,
        B_out => B_out,
        flag_H => open,
        flag_V => flagV2reg);
        
    nbit_reg:entity work.nbit_reg
	generic map (N => 12)
	
	port map(
		clk => clk,
		rst => rst,
		ena => flagV2reg,
		reg_in => pulse2reg,
		reg_out => reg2VGA);

end ;