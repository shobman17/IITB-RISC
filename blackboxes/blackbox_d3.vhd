library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity bb_cwr_zwr is
	port (
			ex2ma_c, ex2ma_z:in std_logic;
		   opcode : in std_logic_vector(5 downto 0);
			c_wr, z_wr : out std_logic);
end entity bb_cwr_zwr;

architecture blackboxed3 of bb_cwr_zwr is
	begin
		edit_process: process(ex2ma_c, ex2ma_z, opcode)
		begin
			if (opcode = "000100" or opcode = "000111" or opcode = "000000" or opcode = "000001" or opcode = "000010" or opcode = "000011") then
			   c_wr<= '1';
				z_wr<= '1';
			elsif (opcode = "000110" and ex2ma_c ='1') then 
				c_wr<= '1';
				z_wr<= '1';
			elsif (opcode = "000101" and ex2ma_z ='1') then 
				c_wr<= '1';
				z_wr<= '1';
			elsif (opcode = "001000" or opcode = "001011" ) then 
				c_wr<= '0';
				z_wr<= '1';
			elsif (opcode = "001010" and ex2ma_c ='1') then 
				c_wr<= '0';
				z_wr<= '1';
			elsif (opcode = "001001" and ex2ma_z ='1') then 
				c_wr<= '0';
				z_wr<= '1';
			else 
			   c_wr<= '0';
				z_wr<= '0';
			end if;
			
		end process;
end architecture blackboxed3;