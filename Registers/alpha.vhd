library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity alpha is
	port (
			input,clk: in std_logic;
			output: out std_logic);
end entity alpha;

architecture update of alpha is 
	signal alpha_content: std_logic := '0';
begin
	write_alpha: process(clk) is
	begin
		if(falling_edge(clk)) then
			alpha_content <= input;
		end if;
	end process write_alpha;
	
	output <= alpha_content;
end update;
			