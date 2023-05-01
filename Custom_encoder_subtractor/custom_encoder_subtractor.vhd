library ieee;
use ieee.std_logic_1164.all;

entity reverse_decoder_3to8 is
	port (input: in std_logic_vector(2 downto 0);
			output: out std_logic_vector(7 downto 0));
end entity reverse_decoder_3to8;

architecture dec of reverse_decoder_3to8 is
begin
	output(7) <= not(input(0)) and not(input(1)) and not(input(2));
	output(6) <= (input(0)) and not(input(1)) and not(input(2));
	output(5) <= not(input(0)) and (input(1)) and not(input(2));
	output(4) <= (input(0)) and (input(1)) and not(input(2));
	output(3) <= not(input(0)) and not(input(1)) and (input(2));
	output(2) <= (input(0)) and not(input(1)) and (input(2));
	output(1) <= not(input(0)) and (input(1)) and (input(2));
	output(0) <= (input(0)) and (input(1)) and (input(2));
end dec;

library ieee;
use ieee.std_logic_1164.all;

entity custom_encoder is
	port (input: in std_logic_vector(7 downto 0);
			output: out std_logic_vector(2 downto 0));
end entity custom_encoder;

architecture enc of custom_encoder is 
begin
	output(2) <= input(0) or input(1) or input(2) or input(3);
	output(1) <= input(0) or input(1) or (not(input(2) or input(3)) and (input(4) or input(5)));
	output(0) <= input(0) or (not(input(1)) and input(2)) or (not(input(1) or input(3)) and input(4)) or (not(input(1) or input(3) or input(5)) and input(6));
end enc;

library ieee;
use ieee.std_logic_1164.all;

entity subtractor is 
	port (input_addr: in std_logic_vector(2 downto 0);
			input_immediate: in std_logic_vector(7 downto 0);
			output: out std_logic_vector(7 downto 0));
end entity subtractor;

architecture sub of subtractor is

	component reverse_decoder_3to8 is 
		port (input: in std_logic_vector(2 downto 0);
			output: out std_logic_vector(7 downto 0));
	end component reverse_decoder_3to8;
	
	signal decoded_addr: std_logic_vector(7 downto 0); -- for output from decoder
	
begin

	dec: reverse_decoder_3to8 port map(input_addr, decoded_addr);
	
	-- bitwise XOR
	output <= input_immediate xor decoded_addr;
	
end sub;
	
		