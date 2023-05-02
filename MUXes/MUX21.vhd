 library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

entity mux_2_1  is
  port (I0 ,I1: in std_logic_vector(15 downto 0);
        S0: in std_logic;
		  mux_out: out std_logic_vector(15 downto 0));
end entity mux_2_1;

architecture Structer of mux_4_1 is
begin
   selectproc: process(S0,S1) is 
	begin 
	if (S0 = '0' ) then 
		mux_out <= I0;
	elsif (S0 = '1') then 
		mux_out <= I1;


   end if;
	end process selectproc;
end Structer;