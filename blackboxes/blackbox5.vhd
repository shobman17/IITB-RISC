library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library Work;

entity pc_mux is
	port (
		PC2, D1_out, Adder_out, out_IF, out_EXE: in std_logic_vector(15 downto 0);
		opcode_EXE: in std_logic_vector(5 downto 0);
		branch, reset_wr: in std_logic;
		PC_out: out std_logic_vector(15 downto 0)
	);
end entity pc_mux;

architecture blackboxed5 of pc_mux is
	begin
		edit_process: process(opcode_EXE, branch, reset_wr, PC2, D1_out, Adder_out, out_IF, out_EXE)
		begin
			if (opcode_EXE(5 downto 2) = "1111") then -- JRI
				PC_out <= Adder_out;
			elsif (opcode_EXE(5 downto 2) = "1101") then -- JLR
				PC_out <= D1_out;
			elsif (branch = '1') then -- conditional branch + JAL
				PC_out <= out_IF;
			elsif (reset_wr = '1') then -- conditional branch + JAL 
				PC_out <= out_EXE;
			else
				PC_out <= PC2;
			end if;
		end process edit_process;
end architecture blackboxed5;