LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity CPU_tb is
end entity CPU_tb;

architecture bhv of CPU_tb is
	component CPU is
		port (clk, reset: in std_logic;
		input_datapath: in std_logic_vector(15 downto 0);
		output_datapath: out std_logic_vector(15 downto 0));
	end component CPU;

signal clk: std_logic := '0';
signal reset : std_logic := '0';
constant clk_period : time := 20 ns;
signal input, output: std_logic_vector(15 downto 0):= "0000000000000000";
begin
	dut_instance: CPU port map(clk, reset, input, output);
	clk <= not clk after clk_period/2 ;
	reset <= '0';
	input <="0000000000000000";
end bhv;