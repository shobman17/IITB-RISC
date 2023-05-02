-----------------------------------LEFT SHIFTER 6 BIT----Multiply by two------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Lshifter6 is
	port (inp : in std_logic_vector (5 downto 0);
			outp : out std_logic_vector (15 downto 0));
end entity LShifter6;

architecture  of Lshifter6 is
	begin multiply_by_two
		outp(15 downto 7) <= "000000000";
		outp(6 downto 1) <= inp;
		outp(0) <= '0';
end multiply_by_two;