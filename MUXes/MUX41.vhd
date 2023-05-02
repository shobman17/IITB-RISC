library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

entity mux_4_1  is
  port (I0 ,I1, I2,I3: in std_logic_vector(15 downto 0);
        S0,S1 : in std_logic;
		  mux_out: out std_logic_vector(15 downto 0));
end entity mux_4_1;

architecture Structer4 of mux_4_1 is
begin
   selectproc4: process(S0,S1) is 
	begin 
	if (S0 = '0' and S1 = '0') then 
		mux_out <= I0;
	elsif (S0 = '1' and S1 = '0') then 
		mux_out <= I1;
	elsif (S0 = '0' and S1 = '1') then 
		mux_out <= I2;
	elsif (S0 = '1' and S1 = '1') then 
		mux_out <= I3;

   end if;
	end process selectproc4;
end Structer4;