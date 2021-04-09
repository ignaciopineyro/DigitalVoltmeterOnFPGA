----------------------------------------------------------------------------------
-- 18_TopLevel.vhd // Conexión de nivel superior y mapeo de pines para Arty A7-35. 
-- Alumno: Ignacio Piñeyro
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Voltimetro_toplevel is
	port(
		clk_i			: in std_logic;
		rst_i			: in std_logic;
		data_volt_in_i	: in std_logic;
		data_volt_out_o	: out std_logic;
		hs_o 			: out std_logic;
		vs_o 			: out std_logic;
		red_o 			: out std_logic;
		grn_o 			: out std_logic;
        blu_o 			: out std_logic;
        pwm_out			: out std_logic;
		led				: out std_logic);
	
	-- Mapeo de pines para el kit Arty A7-35
	attribute loc		: string;
	attribute iostandard: string;
	
	attribute loc 			of clk_i    : signal is "E3";					-- reloj del sistema (100 MHz)
	attribute iostandard 	of clk_i    : signal is "LVCMOS33";	
	attribute loc 			of rst_i    : signal is "D9";					-- senal de reset (boton 0)
    attribute iostandard 	of rst_i    : signal is "LVCMOS33";
    	
	-- Entradas simple
	attribute loc 			of data_volt_in_i: signal is "D4";			-- entrada
	attribute iostandard 	of data_volt_in_i: signal is "LVCMOS33";

	-- Salida realimentada
	attribute loc 			of data_volt_out_o: signal is "F3";			-- realimentacion
	attribute iostandard 	of data_volt_out_o: signal is "LVCMOS33";
	
	-- VGA
	attribute loc 			of hs_o     : signal is "D12";					-- sincronismo horizontal
	attribute iostandard 	of hs_o     : signal is "LVCMOS33";
	attribute loc 			of vs_o     : signal is "K16";					-- sincronismo vertical
	attribute iostandard 	of vs_o     : signal is "LVCMOS33";
	attribute loc 			of red_o    : signal is "G13";					-- salida color rojo
	attribute iostandard 	of red_o    : signal is "LVCMOS33";
	attribute loc 			of grn_o    : signal is "B11";					-- salida color verde
	attribute iostandard 	of grn_o    : signal is "LVCMOS33";
	attribute loc 			of blu_o    : signal is "A11";					-- salida color azul
	attribute iostandard 	of blu_o    : signal is "LVCMOS33";
    
    -- Generacion de salida pwm controlada
	attribute loc 			of pwm_out  : signal is "F4";					-- salida de '1's
	attribute iostandard 	of pwm_out  : signal is "LVCMOS33";
	attribute loc 			of led    : signal is "H6";					-- salida color verde (led rgb)
	attribute iostandard 	of led    : signal is "LVCMOS33";

end Voltimetro_toplevel;

architecture Voltimetro_toplevel_arq of Voltimetro_toplevel is
	
	component clk_wiz_0
		port (
			clk_in1: in std_logic;
	  		clk_out1: out std_logic);
    end component;
    
    component dac_pwm is
		generic (
			N: natural := 8);
	    port (
	        clk     : in std_logic;
	        rst     : in std_logic;
	        pwm_in  : in std_logic_vector (N-1 downto 0);
	        pwm_out : out std_logic);
	end component dac_pwm;
    
    constant Nb		: natural := 5;

	signal clk25MHz	: std_logic;
	signal pwm_in	: std_logic_vector(Nb-1 downto 0);
	signal pwm_out_s: std_logic;
	
begin

	-- Generador del reloj lento
	clk25MHz_gen : clk_wiz_0
   		port map ( 
   			clk_in1		=> clk_i,		-- reloj del sistema (125 MHz)
   			clk_out1	=> clk25MHz);		-- reloj generado (25 MHz)

	voltmeter: entity work.voltmeter
		port map(
		    clk			    => clk25MHz,
		    ena			    => '1',
            rst			    => rst_i,
            data_volt_in	=> data_volt_in_i,
            data_volt_out	=> data_volt_out_o,
            H_sync		    => hs_o,
            V_sync		    => vs_o,
            R_out		    => red_o,
            G_out		    => grn_o,
            B_out		    => blu_o);

    ------------------------------------------------------------------------------
    -- Generación de una senal que contiene una cantidad de pulsos equiespaciados
    -- para establecer un voltaje determinado
    ------------------------------------------------------------------------------
    process(clk25MHz)
 		variable cuenta: integer := 0;
 	begin
 		if rising_edge(clk25MHz) then
 			if rst_i = '1' then
 				cuenta := 0;
 				pwm_in <= (Nb-1 downto 0 => '0');
 			else
				if cuenta = 50E6 then
					cuenta := 0;
					pwm_in <= std_logic_vector(unsigned(pwm_in) + 1);
				else
					cuenta := cuenta + 1;
					pwm_in <= pwm_in;
				end if;
			end if;
		end if;	
	end process;
	
 	genUnos: entity work.dac_pwm
 		generic map(N => Nb)
 			
 		port map(
 			clk		=> clk25MHz,
 			rst		=> rst_i,
 			pwm_in	=> pwm_in,
 			pwm_out	=> pwm_out_s);
 	
 	pwm_out	<= pwm_out_s;
 	led		<= pwm_out_s;

end Voltimetro_toplevel_arq;