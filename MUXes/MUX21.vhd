library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity mux_2_1  is
  port (D0, D1, mux_select: in std_logic; output: out std_logic);
end entity mux_2_1;

architecture Struct of mux_2_1 is
  signal T1,T2,T3 : std_logic;
begin
  -- component instances
  INVERTER1 : INVERTER port map (A => mux_select, Y => T1);
  AND1: AND_2 port map (A => D0, B => T1, Y => T2);
  AND2: AND_2 port map (A => D1, B => mux_select, Y => T3);
  OR1: OR_2 port map (A => T2, B => T3, Y => output);
  
end Struct;