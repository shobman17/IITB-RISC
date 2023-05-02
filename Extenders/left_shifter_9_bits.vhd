-----------------------------------LEFT SHIFTER 9 BIT----Multiply by two------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Lshifter9 is
	port (inp : in std_logic_vector (8 downto 0);
			outp : out std_logic_vector (15 downto 0));
end entity LShifter9;

architecture  of Lshifter9 is
	begin multiply_by_two
		outp(15 downto 10) <= "000000";
		outp(9 downto 1) <= inp;
		outp(0) <= '0';
end multiply_by_two;