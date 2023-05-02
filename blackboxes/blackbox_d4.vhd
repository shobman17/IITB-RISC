library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity bb_branching is
	port (
			c_o, z_o:in std_logic;
		   opcode : in std_logic_vector(5 downto 0);
			 pc_mux_branch,if2id_wr_and_a, id2or_reset_all_wr, or2ex_reset_all_wr  : out std_logic);
end entity bb_branching;

architecture blackboxed4 of bb_branching is
	begin
		edit_process: process(c_o, z_o, opcode)
		begin
			if ((opcode = ("100000" or "100001" or "100010" or "100011") and c_o ='1' and z_o ='1') or 
			    (opcode = ("100100" or "100101" or "100110" or "100111") and c_o = '0' and z_o ='0') or 
				 (c_o = '1' and z_o ='1') or (opcode =("110000" or "110001" or "110010" or "110011")) or
				 (opcode =("111100" or "111101" or "111110" or "111111"))) then 
				 
			     pc_mux_branch <= '1';
				  if2id_wr_and_a <= '0';
				  id2or_reset_all_wr <= '1';
				  or2ex_reset_all_wr <= '1';
			else 
				  pc_mux_branch <= '0';
				  if2id_wr_and_a <= '1';
				  id2or_reset_all_wr <= '0';
				  or2ex_reset_all_wr <= '0';
			end if;
			
		end process;
end architecture blackboxed4;