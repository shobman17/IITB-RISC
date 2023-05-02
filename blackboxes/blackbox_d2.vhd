library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity bbD2 is
	port (
			mux_rf_a1_output, or2ex_a3, ex2ma_a3, ma2wb_a3, or2ex_rf_wr, ex2ma_rf_wr, ma2wb_rf_wr, alpha:in std_logic;
		   id2or_mux_alu_b : in std_logic_vector(1 downto 0);
			mux_rf_d2_1, mux_rf_d2_0 : out std_logic);
end entity bbD2;

architecture blackboxed2 of bbD2 is
	--signal c, z: std_logic := '0';
	--signal storage: std_logic_vector(1 downto 0):="00";
	begin
		edit_process: process(mux_rf_a1_output, or2ex_a3, ex2ma_a3, ma2wb_a3, or2ex_rf_wr, ex2ma_rf_wr, ma2wb_rf_wr,id2or_mux_alu_b)
		begin
			if ((mux_rf_a1_output = or2ex_a3 and or2ex_rf_wr = '1' and alpha ='1') or (alpha = '0'and id2or_mux_alu_b = "00")) then
			   mux_rf_d2_1<='0';
				mux_rf_d2_0<='1';
			elsif (mux_rf_a1_output = ex2ma_a3 and ex2ma_rf_wr ='1'and alpha = '1' and id2or_mux_alu_b = "00") then
			   mux_rf_d2_1<='1';
				mux_rf_d2_0<='0';
			elsif (mux_rf_a1_output = ma2wb_a3 and ma2wb_rf_wr = '1'and alpha = '1' and id2or_mux_alu_b = "00") then
			   mux_rf_d2_1<='1';
				mux_rf_d2_0<='1';
			else 
				mux_rf_d2_1<='0';
				mux_rf_d2_0<='0';
			end if;
			
		end process;
end architecture blackboxed2;