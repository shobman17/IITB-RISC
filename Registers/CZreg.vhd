library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity CZreg is
	port (
			c_in, z_in, clk, c_wr, z_wr:in std_logic;
			c_out, z_out: out std_logic);
end entity CZreg;

architecture bhv of CZreg is
	signal c, z: std_logic := '0';
	--signal storage: std_logic_vector(1 downto 0):="00";
	begin
		c_out <= c;
		z_out <= z;
		--output(1 downto 0)<= storage(1 downto 0);
		edit_process: process(clk)
		begin
			if(falling_edge(clk)) then
				--storage(1 downto 0)<=input(1 downto 0);
				c <= (c_in and c_wr) or ((not(c_wr)) and c);
				z <= (z_in and z_wr) or ((not(z_wr)) and z);
			else 
				c <= c;
				z <= z;
			end if;
			
		end process;
end architecture bhv;