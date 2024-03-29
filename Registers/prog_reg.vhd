library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.all;

entity prog_reg is
	port (A1, A2, A3: in std_logic_vector(2 downto 0);
			D1, D2: out std_logic_vector(15 downto 0);
			D3: in std_logic_vector(15 downto 0);
			PC_in: in std_logic_vector(15 downto 0);
			PC_out: out std_logic_vector(15 downto 0);
			PC_enable: in std_logic;
			clk: in std_logic;
			w_enable: in std_logic);
end entity prog_reg;

architecture pr of prog_reg is
	-- These signals dictate which registers are allowed to be written
	signal e0, e1, e2, e3, e4, e5, e6,  e7: std_logic;
	-- These signals carry the output from each register
	signal r0, r1, r2, r3, r4, r5, r6, r7: std_logic_vector(15 downto 0);
begin

	-- Assign signals to control write enable for individual registers
	e0 <= w_enable and not(A3(2)) and not(A3(1)) and not(A3(0));
	e1 <= w_enable and not(A3(2)) and not(A3(1)) and (A3(0));
	e2 <= w_enable and not(A3(2)) and (A3(1)) and not(A3(0));
	e3 <= w_enable and not(A3(2)) and (A3(1)) and (A3(0));
	e4 <= w_enable and (A3(2)) and not(A3(1)) and not(A3(0));
	e5 <= w_enable and (A3(2)) and not(A3(1)) and (A3(0));
	e6 <= w_enable and (A3(2)) and (A3(1)) and not(A3(0));
	e7 <= w_enable and (A3(2)) and (A3(1)) and (A3(0));
	
	-- Initialise the registers
	reg0: T_reg port map (input => D3, w_enable => e0, clk => clk, output => r0);
	reg1: T_reg port map (input => D3, w_enable => e1, clk => clk, output => r1);
	reg2: T_reg port map (input => D3, w_enable => e2, clk => clk, output => r2);
	reg3: T_reg port map (input => D3, w_enable => e3, clk => clk, output => r3);
	reg4: T_reg port map (input => D3, w_enable => e4, clk => clk, output => r4);
	reg5: T_reg port map (input => D3, w_enable => e5, clk => clk, output => r5);
	reg6: T_reg port map (input => D3, w_enable => e6, clk => clk, output => r6);
	reg7: T_reg port map (input => D3, w_enable => e7, clk => clk, output => r7);
	
	with A1 select
		D1 <= r0 when "000",
				r1 when "001",
				r2 when "010",
				r3 when "011",
				r4 when "100",
				r5 when "101",
				r6 when "110",
				r7 when "111";
	
	with A2 select
		D2 <= r0 when "000",
				r1 when "001",
				r2 when "010",
				r3 when "011",
				r4 when "100",
				r5 when "101",
				r6 when "110",
				r7 when "111";
				
	PC_out <= r0;
	writePC: process(clk) is
	begin
		if(falling_edge(clk)) then
			if(PC_enable = '1') then 
				r0 <= PC_in;
			end if;
		end if;
	end process writePC;
end pr;