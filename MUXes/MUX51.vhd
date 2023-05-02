library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

entity mux51  is
  port (I0 ,I1, I2,I3,I4: in std_logic_vector(15 downto 0);
        S0,S1,S2 : in std_logic;
		  mux_out: out std_logic_vector(15 downto 0));
end entity mux51;

architecture Structer5 of mux51 is
begin
   selectproc5: process(S0,S1,S2) is 
	begin 
	if (S0 = '0' and S1 = '0' and S2 = '0') then 
		mux_out <= I0;
	elsif (S0 = '1' and S1 = '0' and S2 = '0') then 
		mux_out <= I1;
	elsif (S0 = '0' and S1 = '1' and S2 = '0') then 
		mux_out <= I2;
	elsif (S0 = '1' and S1 = '1' and S2 = '0') then 
		mux_out <= I3;
	elsif (S0 = '0' and S1 = '0' and S2 = '1') then 
		mux_out <= I4;
   end if;
	end process selectproc5;
end Structer5;