library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;
--use work;

-------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

entity mux_4_1  is
  port (I0 ,I1, I2,I3, S0, S1: in std_logic; mux_out: out std_logic);
end entity mux_4_1;

architecture Structer of mux_4_1 is
  signal Ti1,Ti2,Ti3 : std_logic;

component mux_2_1 is
	port (D0, D1, mux_select: in std_logic; output: out std_logic);
end component mux_2_1;
  
begin
  -- component instances
  mu1: mux_2_1 port map (D0 => I0, D1 => I1, mux_select => S0, output => Ti1);
  mu2: mux_2_1 port map (D0 => I2, D1 => I3, mux_select => S0, output => Ti2);
  mu3: mux_2_1 port map (D0 => Ti1, D1 => Ti2, mux_select => S1, output => mux_out);
  
  
end Structer;