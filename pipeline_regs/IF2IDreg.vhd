library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library Work;
entity IF2IDreg is
	port (
			clk, IF2ID_WR: in std_logic;
			IMdata, pc, pc2: in std_logic_vector(15 downto 0);
			IMdatao, pco, pc2o: out std_logic_vector(15 downto 0));
end entity IF2IDreg;

architecture bhv1 of IF2IDreg is
	signal IMdatas, pcs,pc2s: std_logic_vector(15 downto 0) := "0000000000000000";
	--signal storage: std_logic_vector(1 downto 0):="00";
	begin
		IMdatao <= IMdatas;
		pco <= pcs;
		pc2o <= pc2s;
		
		--output(1 downto 0)<= storage(1 downto 0);
		edit_process: process(clk)
		begin
			if(falling_edge(clk)) then
				if (IF2ID_WR = '1')then
				IMdatas <= IMdata;
				pcs <= pc;
				pc2s <= pc2; 
				
				else 
				IMdatas <= IMdatas;
				pcs<=pcs;
				pc2s<=pc2s;
				end if;
				
				else 
				IMdatas <= IMdatas;
				pcs<=pcs;
				pc2s<=pc2s;
			end if;
			
		end process;
end architecture bhv1;