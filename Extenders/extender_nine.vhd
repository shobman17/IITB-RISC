library ieee;
use ieee.std_logic_1164.all;

entity extender_nine is
	port (input: in std_logic_vector(8 downto 0);
			output: out std_logic_vector(15 downto 0));
end entity extender_nine;

architecture major_extending of extender_nine is
begin
	--new_process: process(input)
	--begin
	output <= "0000000" & input;
	--end process;
end major_extending;