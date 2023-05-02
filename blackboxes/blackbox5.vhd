library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity bb_pc_mux is
	port (
			pc_mux_branch, bp_control:in std_logic;
		   op2ex_opcode : in std_logic_vector(3 downto 0);
			pc_mux_control_bits : out std_logic_vector(1 downto 0));
end entity bb_pc_mux;

architecture blackboxed5 of bb_pc_mux is
	begin
		edit_process: process(pc_mux_branch, bp_control,op2ex_opcode )
		begin
			if (pc_mux_branch = '1') then 
				  pc_mux_control_bits <= "01";
			elsif (op2ex_opcode = "1101") then 
				  pc_mux_control_bits <= "10";
			elsif (bp_control = '1') then 
				  pc_mux_control_bits <= "11";
			else 
				  pc_mux_control_bits <= "00";
				
			end if;
			
		end process;
end architecture blackboxed5;