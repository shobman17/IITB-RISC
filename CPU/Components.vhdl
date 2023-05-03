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
			output: out std_logic_vector(2 downto 0);
			all_zero, single_one: out std_logic); -- nor of all input bits. Useful to know end of LM/SM instruction
end entity custom_encoder;

architecture enc of custom_encoder is 
begin
	output(2) <= input(0) or input(1) or input(2) or input(3);
	output(1) <= input(0) or input(1) or (not(input(2) or input(3)) and (input(4) or input(5)));
	output(0) <= input(0) or (not(input(1)) and input(2)) or (not(input(1) or input(3)) and input(4)) or (not(input(1) or input(3) or input(5)) and input(6));
	--all_zero <= not(input(0) or input(1) or input(2) or input(3) or input(4) or input(5) or input(6) or input(7));
	with input select
		single_one <= '1' when "00000001",
				 '1' when "00000010",
				 '1' when "00000100",
				 '1' when "00001000",
				 '1' when "00010000",
				 '1' when "00100000",
				 '1' when "01000000",
				 '1' when "10000000",
				 '0' when others;
				 
	with input select
		all_zero <= '1' when "00000000",
						'0' when others;
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

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity extender_nine is
	port (in1, in2, in3: in std_logic_vector(2 downto 0);
			output: out std_logic_vector(15 downto 0));
end entity extender_nine;

architecture major_extending of extender_nine is
begin
	--new_process: process(input)
	--begin
	output <= "0000000" & in1 & in2 & in3;
	--end process;
end major_extending;

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------

-----------------------------------LEFT SHIFTER 6 BIT----Multiply by two------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Lshifter6 is
	port (inp : in std_logic_vector (5 downto 0);
			outp : out std_logic_vector (15 downto 0));
end entity LShifter6;

architecture yes of Lshifter6 is
	begin multiply_by_two
		outp(15 downto 7) <= "000000000";
		outp(6 downto 1) <= inp;
		outp(0) <= '0';
end multiply_by_two;

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------

-----------------------------------LEFT SHIFTER 9 BIT----Multiply by two------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Lshifter9 is
	port (inp : in std_logic_vector (8 downto 0);
			outp : out std_logic_vector (15 downto 0));
end entity LShifter9;

architecture yes of Lshifter9 is
	begin multiply_by_two
		outp(15 downto 10) <= "000000";
		outp(9 downto 1) <= inp;
		outp(0) <= '0';
end multiply_by_two;

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity bbD1 is
	port (
			mux_rf_a1_output, or2ex_a3, ex2ma_a3, ma2wb_a3:in std_logic_vector(2 downto 0);
			or2ex_rf_wr, ex2ma_rf_wr, ma2wb_rf_wr: in std_logic
		   id2or_mux_alu_a : in std_logic_vector(1 downto 0);
			mux_rf_d1_1, mux_rf_d1_0 : out std_logic);
end entity bbD1;

architecture blackboxed of bbD1 is
	--signal c, z: std_logic := '0';
	--signal storage: std_logic_vector(1 downto 0):="00";
	begin
		edit_process: process(mux_rf_a1_output, or2ex_a3, ex2ma_a3, ma2wb_a3, or2ex_rf_wr, ex2ma_rf_wr, ma2wb_rf_wr,id2or_mux_alu_a)
		begin
			if (mux_rf_a1_output = or2ex_a3 and or2ex_rf_wr = '1' and id2or_mux_alu_a = "00") then
			   mux_rf_d1_1<='0';
				mux_rf_d1_0<='1';
			elsif (mux_rf_a1_output = ex2ma_a3 and ex2ma_rf_wr ='1' and id2or_mux_alu_a = "00") then
			   mux_rf_d1_1<='1';
				mux_rf_d1_0<='0';
			elsif (mux_rf_a1_output = ma2wb_a3 and ma2wb_rf_wr = '1'and id2or_mux_alu_a = "00") then
			   mux_rf_d1_1<='1';
				mux_rf_d1_0<='1';
			else 
				mux_rf_d1_1<='0';
				mux_rf_d1_0<='0';
			end if;
			
		end process;
end architecture blackboxed;

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity bbD2 is
	port (
			mux_rf_a1_output, or2ex_a3, ex2ma_a3, ma2wb_a3: in std_logic_vector(2 downto 0);
			or2ex_rf_wr, ex2ma_rf_wr, ma2wb_rf_wr, alpha:in std_logic;
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

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity bb_cwr_zwr is
	port (
			EX_RF_WR, ex2ma_c, ex2ma_z:in std_logic;
		   opcode : in std_logic_vector(5 downto 0);
<<<<<<< HEAD
			c_wr, z_wr : out std_logic);
end entity bb_cwr_zwr;
=======
			c_wr, z_wr, ex_rf_wr_and_a : out std_logic);
end entity bbD3;
>>>>>>> 321aa7e9c243498c59ba5536f63a0783011417b9

architecture blackboxed3 of bb_cwr_zwr is
	begin
		edit_process: process(ex2ma_c, ex2ma_z, opcode)
		begin
			if (opcode = "000100" or opcode = "000111" or opcode = "000000" or opcode = "000001" or opcode = "000010" or opcode = "000011") then
				c_wr<= '1';
				z_wr<= '1';
				rf_wr_and_a<=EX_RF_WR and '1';
			elsif (opcode = "000110" and ex2ma_c ='1') then 
				c_wr<= '1';
				rf_wr_and_a<='1' and EX_RF_WR;
				z_wr<= '1';
			elsif (opcode = "000101" and ex2ma_z ='1') then 
				c_wr<= '1';
				rf_wr_and_a<='1' and EX_RF_WR;
				z_wr<= '1';
			elsif (opcode = "001000" or opcode = "001011" ) then 
				c_wr<= '0';
				rf_wr_and_a<='1' and EX_RF_WR;
				z_wr<= '1';
			elsif (opcode = "001010" and ex2ma_c ='1') then 
				c_wr<= '0';
				rf_wr_and_a<='1' and EX_RF_WR;
				z_wr<= '1';
			elsif (opcode = "001001" and ex2ma_z ='1') then 
				c_wr<= '0';
				rf_wr_and_a<='1' and EX_RF_WR;
				z_wr<= '1';
			elsif (opcode = "000110" or opcode = "000101" or opcode = "001010" or opcode = "001001")
			   c_wr<= '0';
				z_wr<= '0';
				rf_wr_and_a<='0' and EX_RF_WR;
			else
				rf_wr_and_a<='1' and EX_RF_WR;
				c_wr<= '0';
				z_wr<= '0';
			end if;
			
		end process;
end architecture blackboxed3;


--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity bb_pc_mux is
	port (
			pc_mux_branch, bp_control:in std_logic;
		   op2ex_opcode : in std_logic_vector(3 downto 0);
			pc_mux_control_bits : out std_logic_vector(1 downto 0));
end entity bb_pc_mux;

architecture blackboxed5 of bb_pc_mux is
	begin
		edit_process: process(pc_mux_branch, bp_control,op2ex_opcode )
		begin
			if (pc_mux_branch = '1') then 
				  pc_mux_control_bits <= "01";
			elsif (op2ex_opcode = "1101") then 
				  pc_mux_control_bits <= "10";
			elsif (bp_control = '1') then 
				  pc_mux_control_bits <= "11";
			else 
				  pc_mux_control_bits <= "00";
				
			end if;
			
		end process;
end architecture blackboxed5;


--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity bb_branching is
	port (c_o, z_o:in std_logic;
		   opcode : in std_logic_vector(5 downto 0);
			 pc_mux_branch,if2id_wr_and_a, id2or_reset_all_wr, or2ex_reset_all_wr  : out std_logic);
end entity bb_branching;

architecture blackboxed4 of bb_branching is
	begin
		edit_process: process(c_o, z_o, opcode)
		begin
			if (((opcode = "100000" or opcode = "100001" or opcode ="100010" or opcode ="100011") and c_o ='1' and z_o ='1') or 
			    (opcode = "100100" or opcode ="100101" or opcode ="100110" or opcode ="100111" and c_o = '0' and z_o ='0') or 
				 (c_o = '1' and z_o ='1') or (opcode ="110000" or opcode ="110001" or opcode ="110010" or opcode ="110011") or
				 (opcode ="111100" or opcode ="111101" or opcode ="111110" or opcode ="111111")) then 
				 
			     pc_mux_branch <= '1';
				  if2id_wr_and_a <= '0';
				  id2or_reset_all_wr <= '1';
				  or2ex_reset_all_wr <= '1';
			else 
				  pc_mux_branch <= '0';
				  if2id_wr_and_a <= '1';
				  id2or_reset_all_wr <= '0';
				  or2ex_reset_all_wr <= '0';
			end if;
			
		end process;
end architecture blackboxed4;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity bb_branching is
	port (
			c_o, z_o:in std_logic;
		   opcode : in std_logic_vector(5 downto 0);
			 pc_mux_branch,if2id_wr_and_a, id2or_reset_all_wr, or2ex_reset_all_wr  : out std_logic);
end entity bb_branching;

architecture blackboxed4 of bb_branching is
	begin
		edit_process: process(c_o, z_o, opcode)
		begin
			if ((opcode = ("100000" or "100001" or "100010" or "100011") and c_o ='1' and z_o ='1') or 
			    (opcode = ("100100" or "100101" or "100110" or "100111") and c_o = '0' and z_o ='0') or 
				 (c_o = '1' and z_o ='1') or (opcode =("110000" or "110001" or "110010" or "110011")) or
				 (opcode =("111100" or "111101" or "111110" or "111111"))) then 
				 
			     pc_mux_branch <= '1';
				  if2id_wr_and_a <= '0';
				  id2or_reset_all_wr <= '1';
				  or2ex_reset_all_wr <= '1';
			else 
				  pc_mux_branch <= '0';
				  if2id_wr_and_a <= '1';
				  id2or_reset_all_wr <= '0';
				  or2ex_reset_all_wr <= '0';
			end if;
			
		end process;
end architecture blackboxed4;

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity bb_pc_mux is
	port (
			pc_mux_branch, bp_control:in std_logic;
		   op2ex_opcode : in std_logic_vector(3 downto 0);
			pc_mux_control_bits : out std_logic_vector(1 downto 0));
end entity bb_pc_mux;

architecture blackboxed5 of bb_pc_mux is
	begin
		edit_process: process(pc_mux_branch, bp_control,op2ex_opcode )
		begin
			if (pc_mux_branch = '1') then 
				  pc_mux_control_bits <= "01";
			elsif (op2ex_opcode = "1101") then 
				  pc_mux_control_bits <= "10";
			elsif (bp_control = '1') then 
				  pc_mux_control_bits <= "11";
			else 
				  pc_mux_control_bits <= "00";
				
			end if;
			
		end process;
end architecture blackboxed5;

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;

entity ALU_unit_cell is
	port (A, B: in std_logic;
			C: in std_logic;
			alu_cmp, alu_oper: in std_logic;
			out_c, out_s: out std_logic);
end entity ALU_unit_cell;

architecture unit of ALU_unit_cell is
	signal bx, aab, anb, axb, caaxb, s: std_logic;
	--signal out0, out1: std_logic;
begin

	-------------------------------------------------------
	--0: and
	--1: nand
	-------------------------------------------------------
	
	-- intermediate signals
	bx <= B xor alu_cmp;
	aab <= A and bx;
	axb <= A xor bx;
	out_s <= C xor axb;
	caaxb <= axb and C;
	s <= aab or caaxb;
	anb <= not(aab);
	out_c <= (alu_oper and anb) or (not(alu_oper) and s);
	
	
end unit;

library ieee;
use ieee.std_logic_1164.all;

entity ALU is 
	port (ALU_A, ALU_B: in std_logic_vector(15 downto 0);
			ALU_OPER: in std_logic;
			ALU_COMP, ALU_CARRY: in std_logic;
			ALU_OUT: out std_logic_vector(15 downto 0);
			Z_O, C_O: out std_logic);
end entity ALU;


architecture addnand of ALU is

	signal carry: std_logic_vector(16 downto 0);
	signal output: std_logic_vector(15 downto 0);
	
	component ALU_unit_cell is
	port (A, B: in std_logic;
			C: in std_logic;
			alu_cmp, alu_oper: in std_logic;
			out_c, out_s: out std_logic);
	end component ALU_unit_cell;

begin
	carry(0) <= ALU_CARRY;
	unit_cell_generate: for i in 0 to 15 generate -- generate 16 such cells
	begin
		unit: component ALU_unit_cell
			port map (A => ALU_A(i), B => ALU_B(i), C => carry(i), 
						 alu_cmp => ALU_COMP, alu_oper => ALU_OPER,
						 out_c => carry(i+1), out_s => output(i));
	end generate;
	Z_O <= not(output(0) or output(1) or output(2) or output(3) or output(4) or output(5) or output(6) or output(7) or output(8) or output(9) or output(10) or output(11) or output(12) or output(13) or output(14) or output(15));
	C_O <= carry(16);
	ALU_OUT <= output;
end addnand;


library ieee;
use ieee.std_logic_1164.all;

entity ADDER_unit_cell is
	port (A, B: in std_logic;
			C: in std_logic;
			out_c, out_s: out std_logic);
end entity ADDER_unit_cell;

architecture unit of ADDER_unit_cell is
	signal aab, anb, axb, caaxb, s: std_logic;
	--signal out0, out1: std_logic;
begin

	-------------------------------------------------------
	--0: and
	--1: nand
	-------------------------------------------------------
	
	-- intermediate signals
	--bx <= B xor alu_cmp;
	aab <= A and B;
	axb <= A xor B;
	out_s <= C xor axb;
	caaxb <= axb and C;
	out_c <= aab or caaxb;
	--anb <= not(aab);
	--out_c <= (alu_oper and anb) or (not(alu_oper) and s);
	
	
end unit;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity EX2MAreg is
	port (
			---------------------------------inputs
			clk, EX2MA_WR: in std_logic;
            reset_wr: in std_logic;
            opcode_in: in std_logic_vector(5 downto 0);
            instr_11_9_in : in std_logic_vector(2 downto 0);
            E9_output_in: in std_logic_vector(15 downto 0);
            ALU_output_in: in std_logic_vector(15 downto 0);
            D2_output_in: in std_logic_vector(15 downto 0); 
            enc_addr_in : in std_logic_vector(2 downto 0); -- output from custom encoder
            PC2_in : in std_logic_vector(15 downto 0);
            MA_st_in : in std_logic_vector(3 downto 0); -- MA2WB_WR, DATA_MEM_WR, DATA_MEM_RD, MUX_MEM_OUT 
            WB_st_in : in std_logic_vector(1 downto 0); -- WB_MUX_1, WB_MUX_0
            RF_WR_in: in std_logic;
            ---------------------------------outputs
            opcode_out: out std_logic_vector(5 downto 0);
            instr_11_9_out : out std_logic_vector(2 downto 0);
            E9_output_out: out std_logic_vector(15 downto 0);
            ALU_output_out: out std_logic_vector(15 downto 0);
            D2_output_out: out std_logic_vector(15 downto 0); 
            enc_addr_out : out std_logic_vector(2 downto 0); -- output from custom encoder
            PC2_out : out std_logic_vector(15 downto 0);
            MA_st_out : out std_logic_vector(3 downto 0); -- MA2WB_WR, DATA_MEM_WR, DATA_MEM_RD, MUX_MEM_OUT 
            WB_st_out : out std_logic_vector(1 downto 0); -- WB_MUX_1, WB_MUX_0
            RF_WR_out: out std_logic
    );
end entity EX2MAreg;

architecture bhv4 of EX2MAreg is
	signal opcode_s: std_logic_vector(5 downto 0) := "000000";
    signal instr_11_9_s, enc_addr_s: std_logic_vector(2 downto 0) := "000";
    signal PC2_s, E9_output_s, D2_output_s, ALU_output_s: std_logic_vector(15 downto 0) := "0000000000000000";
    signal MA_st_s: std_logic_vector(3 downto 0) := "0000";
    signal WB_st_s: std_logic_vector(1 downto 0) := "00";
    signal RF_WR_S: std_logic := '0';
begin

    opcode_out <= opcode_s;
    instr_11_9_out <= instr_11_9_s;
    E9_output_out <= E9_output_s;
    ALU_output_out <= ALU_output_s;
    D2_output_out <= D2_output_s;
    enc_addr_out <= enc_addr_s;
    PC2_out <= PC2_s;
    MA_st_out <= MA_st_s;
    WB_st_out <= WB_st_s;
    RF_WR_out <= RF_WR_s;

    edit_process: process(clk, EX2MA_WR, reset_wr) is
    begin
        if(falling_edge(clk) and EX2MA_WR = '1') then
            opcode_s <= opcode_in;
            instr_11_9_s <= instr_11_9_in;
            E9_output_s <= E9_output_in;
            ALU_output_s <= ALU_output_in;
            D2_output_s <= D2_output_in;
            enc_addr_s <= enc_addr_in;
            PC2_s <= PC2_in;
            MA_st_s <= MA_st_in;
            WB_st_s <= WB_st_in;
            RF_WR_s <= RF_WR_in;
		end if;
		if (falling_edge(clk) and reset_wr = '1') then
            MA_st_s(2) <= '0'; --DATA_MEM_WR
            RF_WR_s <= '0';
        end if; 
    end process edit_process;
end architecture bhv4;

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ID2ORreg is
	port (
			---------------------------------inputs
			clk, ID2OR_WR: in std_logic;
            reset_wr: in std_logic;
            opcode_in: in std_logic_vector(5 downto 0);
            instr_11_9_in : in std_logic_vector(2 downto 0); 
            instr_8_6_in : in std_logic_vector(2 downto 0); 
            instr_5_3_in : in std_logic_vector(2 downto 0); 
            instr_5_0_in : in std_logic_vector(5 downto 0); 
            instr_8_0_in : in std_logic_vector(8 downto 0); 
            enc_addr_in : in std_logic_vector(2 downto 0); -- output from custom encoder
            enc_input_in : in std_logic_vector(7 downto 0); -- input to custom encoder
            LS6_in : in std_logic_vector(15 downto 0); -- output from leftshifter 6bit
            LS9_in : in std_logic_vector(15 downto 0); -- output from leftshifter 9bit
            PC_in : in std_logic_vector(15 downto 0);
            PC2_in : in std_logic_vector(15 downto 0);
            OR_st_in : in std_logic_vector(2 downto 0); -- OR2EX_WR, MUX_RF_A1, MUX_RF_A2
            EX_st_in : in std_logic_vector(10 downto 0); -- EX2MA_WR, MUX_ALU_A_0, MUX_ALU_A_1, MUX_ALU_B, ALU_CARRY_1, ALU_CARRY_0, ALU_OPER, ALU_COMPLEMENT, MUX_ADDER_A, MUX_ADDER_B_0, MUX_ADDER_B_1
            MA_st_in : in std_logic_vector(3 downto 0); -- MA2WB_WR, DATA_MEM_WR, DATA_MEM_RD, MUX_MEM_OUT 
            WB_st_in : in std_logic_vector(1 downto 0); -- WB_MUX_1, WB_MUX_0
            RF_WR_in: in std_logic;
            ---------------------------------outputs
            opcode_out: out std_logic_vector(5 downto 0);
            instr_11_9_out : out std_logic_vector(2 downto 0); --will go to RF
            instr_8_6_out : out std_logic_vector(2 downto 0); --will go to RF
            instr_5_3_out : out std_logic_vector(2 downto 0); -- will go to RF
            instr_5_0_out : out std_logic_vector(5 downto 0); -- will go to SE6
            instr_8_0_out : out std_logic_vector(8 downto 0); -- will go to E9
            enc_addr_out : out std_logic_vector(2 downto 0); -- output from custom encoder
            enc_input_out : out std_logic_vector(7 downto 0); -- input to custom encoder
            LS6_out : out std_logic_vector(15 downto 0); -- output from leftshifter 6bit
            LS9_out : out std_logic_vector(15 downto 0); -- output from leftshifter 9bit
            PC_out : out std_logic_vector(15 downto 0);
            PC2_out : out std_logic_vector(15 downto 0);
            OR_st_out : out std_logic_vector(2 downto 0); -- OR2EX_WR, MUX_RF_A1, MUX_RF_A2
            EX_st_out : out std_logic_vector(10 downto 0); -- EX2MA_WR, MUX_ALU_A_0, MUX_ALU_A_1, MUX_ALU_B, ALU_CARRY_1, ALU_CARRY_0, ALU_OPER, ALU_COMPLEMENT, MUX_ADDER_A, MUX_ADDER_B_0, MUX_ADDER_B_1
            MA_st_out : out std_logic_vector(3 downto 0); -- MA2WB_WR, DATA_MEM_WR, DATA_MEM_RD, MUX_MEM_OUT 
            WB_st_out : out std_logic_vector(1 downto 0); -- WB_MUX_1, WB_MUX_0
            RF_WR_out: out std_logic
    );
end entity ID2ORreg;

architecture bhv2 of ID2ORreg is
	signal opcode_s, instr_5_0_s: std_logic_vector(5 downto 0) := "000000";
    signal instr_11_9_s, instr_8_6_s, instr_5_3_s, enc_addr_s, OR_st_s: std_logic_vector(2 downto 0) := "000";
    signal instr_8_0_s: std_logic_vector(8 downto 0) := "000000000";
    signal enc_input_s: std_logic_vector(7 downto 0) := "00000000";
    signal LS6_s, LS9_s, PC_s, PC2_s: std_logic_vector(15 downto 0) := "0000000000000000";
    signal EX_st_s: std_logic_vector(10 downto 0) := "00000000000";
    signal MA_st_s: std_logic_vector(3 downto 0) := "0000";
    signal WB_st_s: std_logic_vector(1 downto 0) := "00";
    signal RF_WR_S: std_logic := '0';
begin

    opcode_out <= opcode_s;
    instr_11_9_out <= instr_11_9_s;
    instr_8_6_out <= instr_8_6_s;
    instr_5_3_out <= instr_5_3_s;
    instr_5_0_out <= instr_5_0_s;
    instr_8_0_out <= instr_8_0_s;
    enc_addr_out <= enc_addr_s;
    enc_input_out <= enc_input_s;
    LS6_out <= LS6_s;
    LS9_out <= LS9_s;
    PC_out <= PC_s;
    PC2_out <= PC2_s;
    OR_st_out <= OR_st_s;
    EX_st_out <= EX_st_s;
    MA_st_out <= MA_st_s;
    WB_st_out <= WB_st_s;
    RF_WR_out <= RF_WR_s;

    edit_process: process(clk, ID2OR_WR, reset_wr) is
    begin
        if(falling_edge(clk) and ID2OR_WR = '1') then
            opcode_s <= opcode_in;
            instr_11_9_s <= instr_11_9_in;
            instr_8_6_s <= instr_8_6_in;
            instr_5_3_s <= instr_5_3_in;
            instr_5_0_s <= instr_5_0_in;
            instr_8_0_s <= instr_8_0_in;
            enc_addr_s <= enc_addr_in;
            enc_input_s <= enc_input_in;
            LS6_s <= LS6_in;
            LS9_s <= LS9_in;
            PC_s <= PC_in;
            PC2_s <= PC2_in;
            OR_st_s <= OR_st_in;
            EX_st_s <= EX_st_in;
            MA_st_s <= MA_st_in;
            WB_st_s <= WB_st_in;
            RF_WR_s <= RF_WR_in;
		end if;
		if (falling_edge(clk) and reset_wr = '1') then
            MA_st_s(2) <= '0'; --DATA_MEM_WR
            RF_WR_s <= '0';
        end if; 
    end process edit_process;
end architecture bhv2;

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity MA2WBreg is
	port (
			---------------------------------inputs
			clk, MA2WB_WR: in std_logic;
            reset_wr: in std_logic;
            opcode_in: in std_logic_vector(5 downto 0);
            instr_11_9_in : in std_logic_vector(2 downto 0);
            MEM_output_in: in std_logic_vector(15 downto 0);
            E9_output_in: in std_logic_vector(15 downto 0);
            enc_addr_in : in std_logic_vector(2 downto 0); -- output from custom encoder
            PC2_in : in std_logic_vector(15 downto 0);            
            WB_st_in : in std_logic_vector(1 downto 0); -- WB_MUX_1, WB_MUX_0
            RF_WR_in: in std_logic;
            ---------------------------------outputs
            opcode_out: out std_logic_vector(5 downto 0);
            instr_11_9_out : out std_logic_vector(2 downto 0);
            MEM_output_out: out std_logic_vector(15 downto 0);
            E9_output_out: out std_logic_vector(15 downto 0);
            enc_addr_out : out std_logic_vector(2 downto 0); -- output from custom encoder
            PC2_out : out std_logic_vector(15 downto 0);
            WB_st_out : out std_logic_vector(1 downto 0); -- WB_MUX_1, WB_MUX_0
            RF_WR_out: out std_logic
    );
end entity MA2WBreg;

architecture bhv5 of MA2WBreg is
	signal opcode_s: std_logic_vector(5 downto 0) := "000000";
    signal instr_11_9_s, enc_addr_s: std_logic_vector(2 downto 0) := "000";
    signal PC2_s, E9_output_s, MEM_output_s: std_logic_vector(15 downto 0) := "0000000000000000";
    signal WB_st_s: std_logic_vector(1 downto 0) := "00";
    signal RF_WR_S: std_logic := '0';
begin

    opcode_out <= opcode_s;
    instr_11_9_out <= instr_11_9_s;
    E9_output_out <= E9_output_s;
    MEM_output_out <= MEM_output_s;
    enc_addr_out <= enc_addr_s;
    PC2_out <= PC2_s;
    WB_st_out <= WB_st_s;
    RF_WR_out <= RF_WR_s;

    edit_process: process(clk, MA2WB_WR, reset_wr) is
    begin
        if(falling_edge(clk) and MA2WB_WR = '1') then
            opcode_s <= opcode_in;
            instr_11_9_s <= instr_11_9_in;
            E9_output_s <= E9_output_in;
            MEM_output_s <= MEM_output_in;
            enc_addr_s <= enc_addr_in;
            PC2_s <= PC2_in;
            WB_st_s <= WB_st_in;
            RF_WR_s <= RF_WR_in;
		end if;
		if (falling_edge(clk) and reset_wr = '1') then
            RF_WR_s <= '0';
        end if; 
    end process edit_process;
end architecture bhv5;

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity OR2EXreg is
	port (
			---------------------------------inputs
			   clk, OR2EX_WR: in std_logic;
            reset_wr: in std_logic;
            opcode_in: in std_logic_vector(5 downto 0);
            instr_11_9_in : in std_logic_vector(2 downto 0);
            E9_output_in: in std_logic_vector(15 downto 0);
            SE6_output_in: in std_logic_vector(15 downto 0);
            D1_output_in: in std_logic_vector(15 downto 0);
            D2_output_in: in std_logic_vector(15 downto 0); 
            enc_addr_in : in std_logic_vector(2 downto 0); -- output from custom encoder
            LS6_in : in std_logic_vector(15 downto 0); -- output from leftshifter 6bit
            LS9_in : in std_logic_vector(15 downto 0); -- output from leftshifter 9bit
            PC_in : in std_logic_vector(15 downto 0);
            PC2_in : in std_logic_vector(15 downto 0);
            EX_st_in : in std_logic_vector(10 downto 0); -- EX2MA_WR, MUX_ALU_A_0, MUX_ALU_A_1, MUX_ALU_B, ALU_CARRY_1, ALU_CARRY_0, ALU_OPER, ALU_COMPLEMENT, MUX_ADDER_A, MUX_ADDER_B_0, MUX_ADDER_B_1
            MA_st_in : in std_logic_vector(3 downto 0); -- MA2WB_WR, DATA_MEM_WR, DATA_MEM_RD, MUX_MEM_OUT 
            WB_st_in : in std_logic_vector(1 downto 0); -- WB_MUX_1, WB_MUX_0
            RF_WR_in: in std_logic;
            ---------------------------------outputs
            opcode_out: out std_logic_vector(5 downto 0);
            E9_output_out: out std_logic_vector(15 downto 0);
            instr_11_9_out : out std_logic_vector(2 downto 0);
            SE6_output_out: out std_logic_vector(15 downto 0);
            D1_output_out: out std_logic_vector(15 downto 0);
            D2_output_out: out std_logic_vector(15 downto 0); 
            enc_addr_out : out std_logic_vector(2 downto 0); -- output from custom encoder
            LS6_out : out std_logic_vector(15 downto 0); -- output from leftshifter 6bit
            LS9_out : out std_logic_vector(15 downto 0); -- output from leftshifter 9bit
            PC_out : out std_logic_vector(15 downto 0);
            PC2_out : out std_logic_vector(15 downto 0);
            EX_st_out : out std_logic_vector(10 downto 0); -- EX2MA_WR, MUX_ALU_A_0, MUX_ALU_A_1, MUX_ALU_B, ALU_CARRY_1, ALU_CARRY_0, ALU_OPER, ALU_COMPLEMENT, MUX_ADDER_A, MUX_ADDER_B_0, MUX_ADDER_B_1
            MA_st_out : out std_logic_vector(3 downto 0); -- MA2WB_WR, DATA_MEM_WR, DATA_MEM_RD, MUX_MEM_OUT 
            WB_st_out : out std_logic_vector(1 downto 0); -- WB_MUX_1, WB_MUX_0
            RF_WR_out: out std_logic
    );
end entity OR2EXreg;

architecture bhv3 of OR2EXreg is
	signal opcode_s: std_logic_vector(5 downto 0) := "000000";
    signal instr_11_9_s, enc_addr_s: std_logic_vector(2 downto 0) := "000";
    signal LS6_s, LS9_s, PC_s, PC2_s, E9_output_s, SE6_output_s, D1_output_s, D2_output_s: std_logic_vector(15 downto 0) := "0000000000000000";
    signal EX_st_s: std_logic_vector(10 downto 0) := "00000000000";
    signal MA_st_s: std_logic_vector(3 downto 0) := "0000";
    signal WB_st_s: std_logic_vector(1 downto 0) := "00";
    signal RF_WR_S: std_logic := '0';
begin

    opcode_out <= opcode_s;
    instr_11_9_out <= instr_11_9_s;
    E9_output_out <= E9_output_s;
    SE6_output_out <= SE6_output_s;
    D1_output_out <= D1_output_s;
    D2_output_out <= D2_output_s;
    enc_addr_out <= enc_addr_s;
    LS6_out <= LS6_s;
    LS9_out <= LS9_s;
    PC_out <= PC_s;
    PC2_out <= PC2_s;
    EX_st_out <= EX_st_s;
    MA_st_out <= MA_st_s;
    WB_st_out <= WB_st_s;
    RF_WR_out <= RF_WR_s;

    edit_process: process(clk, OR2EX_WR, reset_wr) is
    begin
        if(falling_edge(clk) and OR2EX_WR = '1') then
            opcode_s <= opcode_in;
            instr_11_9_s <= instr_11_9_in;
            E9_output_s <= E9_output_in;
            SE6_output_s <= SE6_output_in;
            D1_output_s <= D1_output_in;
            D2_output_s <= D2_output_in;
            enc_addr_s <= enc_addr_in;
            LS6_s <= LS6_in;
            LS9_s <= LS9_in;
            PC_s <= PC_in;
            PC2_s <= PC2_in;
            EX_st_s <= EX_st_in;
            MA_st_s <= MA_st_in;
            WB_st_s <= WB_st_in;
            RF_WR_s <= RF_WR_in;
		end if;
		if (falling_edge(clk) and reset_wr = '1') then
            MA_st_s(2) <= '0'; --DATA_MEM_WR
            RF_WR_s <= '0';
        end if; 
    end process edit_process;
end architecture bhv3;


--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
-------------------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity ADDER is 
	port (ADDER_A, ADDER_B: in std_logic_vector(15 downto 0);
			--ALU_OPER: in std_logic;
			--ALU_COMP, ALU_CARRY: in std_logic;
			ADDER_OUT: out std_logic_vector(15 downto 0));
			--Z_O, C_O: out std_logic);
end entity ADDER;


architecture add of ADDER is

	signal carry: std_logic_vector(16 downto 0);
	signal output: std_logic_vector(15 downto 0);
	
	component ADDER_unit_cell is
	port (A, B: in std_logic;
			C: in std_logic;
			--alu_cmp, alu_oper: in std_logic;
			out_c, out_s: out std_logic);
	end component ADDER_unit_cell;

begin
	carry(0) <= '0';--ALU_CARRY;
	unit_cell_generate: for i in 0 to 15 generate -- generate 16 such cells
	begin
		unit: component ADDER_unit_cell
			port map (A => ADDER_A(i), B => ADDER_B(i), C => carry(i), 
						 --alu_cmp => ALU_COMP, alu_oper => ALU_OPER,
						 out_c => carry(i+1), out_s => output(i));
	end generate;
	--Z_O <= not(output(0) or output(1) or output(2) or output(3) or output(4) or output(5) or output(6) or output(7) or output(8) or output(9) or output(10) or output(11) or output(12) or output(13) or output(14) or output(15));
	--C_O <= carry(16);
	ADDER_OUT <= output;
end add;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity alpha is
	port (
			input,clk: in std_logic;
			output: out std_logic);
end entity alpha;

architecture update of alpha is 
	signal alpha_content: std_logic := '0';
begin
	write_alpha: process(clk) is
	begin
		if(falling_edge(clk)) then
			alpha_content <= input;
		end if;
	end process write_alpha;
	
	output <= alpha_content;
end update;

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity PC is
	port (
			input,clk, PC_WR: in std_logic;
			output: out std_logic);
end entity alpha;

architecture update of PC is 
	signal alpha_content: std_logic := '0';
begin
	write_alpha: process(clk) is
	begin
		if(falling_edge(clk) and PC_WR = 1) then
			alpha_content <= input;
		end if;
	end process write_alpha;
	
	output <= alpha_content;
end update;
			
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity CZreg is
	port (
			c_in, z_in, clk, c_wr, z_wr:in std_logic;
			c_out, z_out: out std_logic);
end entity CZreg;

architecture bhv of CZreg is
	signal c, z: std_logic := '0';
	--signal storage: std_logic_vector(1 downto 0):="00";
	begin
		c_out <= c;
		z_out <= z;
		--output(1 downto 0)<= storage(1 downto 0);
		edit_process: process(clk)
		begin
			if(falling_edge(clk)) then
				--storage(1 downto 0)<=input(1 downto 0);
				c <= (c_in and c_wr) or ((not(c_wr)) and c);
				z <= (z_in and z_wr) or ((not(z_wr)) and z);
			else 
				c <= c;
				z <= z;
			end if;
			
		end process;
end architecture bhv;

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

entity mux_2_1  is
  port (I0 ,I1: in std_logic_vector(15 downto 0);
        S0: in std_logic;
		  mux_out: out std_logic_vector(15 downto 0));
end entity mux_2_1;

architecture Structer of mux_2_1 is
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

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;


entity Memory_Code is 
		port(
				clk: in std_logic; 
				mem_addr: in std_logic_vector(15 downto 0);
				mem_out: out std_logic_vector(15 downto 0)
			 ); 
end entity; 

architecture memorykakaam of Memory_Code is 
		type mem_vec is array(65535 downto 0) of std_logic_vector(15 downto 0);
		signal memorykagyaan : mem_vec := (others => "0000000000000000");  
	
begin
	
  mem_process : process (clk) is
  begin
				mem_out <= memorykagyaan(to_integer(unsigned(mem_addr)));
  end  process;
end  architecture;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;


entity Memory_Data is 
		port(
				clk, m_wr, m_rd: in std_logic; 
				mem_addr, mem_addr_edit, mem_in: in std_logic_vector(15 downto 0);
				mem_out: out std_logic_vector(15 downto 0)
			 ); 
end entity; 

architecture memorykakaam of Memory_Data is 
		type mem_vec is array(65535 downto 0) of std_logic_vector(15 downto 0);
		signal memorykagyaan : mem_vec := (others => "0000000000000000");  
	
begin
	
  mem_process : process (clk) is
  begin
		if m_rd = '1' then
				mem_out <= memorykagyaan(to_integer(unsigned(mem_addr)));
		end if;
    if falling_edge(clk) then
      if m_wr = '1' then
        memorykagyaan(to_integer(unsigned(mem_addr_edit))) <= mem_in;  -- Write

      end if;
    end if;
  end  process;
end  architecture;

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------
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


--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity branch_predictor is 
	generic (
		addrSize    : integer   := 16;
		tableSize   : integer   := 64);
	port(
		in_IF, in_EXE, in_pred: in std_logic_vector(15 downto 0); --in_IF is for reading prediction. in_EXE and in_pred are for writing a prediction
		BR_WR: in std_logic; -- if BR_WR is true then we update the LUT else we just read
		hb_in: in std_logic; -- input for history bit to write to this table
		out_pred: out std_logic_vector(15 downto 0);
		branch: out std_logic); -- whether to branch ot not
end branch_predictor;

architecture predict of branch_predictor is
	
	signal inputTable: std_logic_vector(addrSize*tableSize-1 downto 0) := (others =>'0');
	signal historyBit: std_logic_vector(tableSize - 1 downto 0) := (others => '0');
	signal predTable : std_logic_vector(addrSize*tableSize-1 downto 0) := (others =>'0');
	--variable head    : integer := 0; -- where to write a new entry	
	
begin
	out_pred <= "0000000000000000";
	branch <= '0';
--	readTable: process(in_IF) is
--		variable found: std_logic := '0';
--	begin
--		if(in_IF(15) and ((not in_IF(13) and not in_IF(12)) or (not in_IF(14) and in_IF(12)))) then -- check if opcode is of branching instruction
--			searchTable: for IR in 0 to tableSize - 1 loop
--				if(inputTable(addrSize*IR to addrSize*(IR+1) - 1) = in_IF and historyBit(IR)) then
--					out_pred <= predTable(addrSize*IR to addrSize*(IR+1) - 1);
--					branch <= '1';
--					found := '1'; --match is found
--					EXIT searchTable;
--				end if; 
--			end loop searchTable
--			
--			if(not found) then -- return dummy prediciton
--				branch <= '0';
--				out_pred <= "0000000000000000";
--			end if;
--		else 
--			branch <= '0';
--			out_pred <= "0000000000000000";
--		end if;
--	end process readTable;
--	
--	writeTable: process(in_EXE, in_pred, BR_WR, hb_in) is --write to the LUT by changing the hb or adding a new entry
--		variable found: std_logic := '0';
--	begin
--		if(in_EXE(15) and ((not in_EXE(13) and not in_EXE(12)) or (not in_EXE(14) and in_EXE(12))) and BR_WR) then
--			searchTable2: for IR in 0 to tableSize - 1 loop
--				if(inputTable(addrSize*IR to addrSize*(IR+1) - 1) = in_EXE) then
--					found := '1'; --match is found
--					historyBit(IR) <= hb_in;
--					EXIT searchTable2;
--				end if; 
--			end loop searchTable2
--			if(not found) then
--				inputTable(addrSize*head to addrSize*(head + 1)-1) <= in_EXE;
--				historyBit(head) <= hb_in;
--				predTable(addrSize*head to addrSize*(head + 1)-1) <= in_pred;
				
end predict;

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity controller is
	port (instruction: in std_logic_vector(15 downto 0);
            alpha : in std_logic;
		    opcode : out std_logic_vector(5 downto 0);
            instr_11_9 : out std_logic_vector(2 downto 0);
            instr_8_6 : out std_logic_vector(2 downto 0);
            instr_5_3 : out std_logic_vector(2 downto 0);
            instr_2_0 : out std_logic_vector(2 downto 0);
            instr_7_0 : out std_logic_vector(7 downto 0);
            instr_5_0 : out std_logic_vector(5 downto 0);
            instr_8_0 : out std_logic_vector(8 downto 0);
            alpha_decode : out std_logic;
            ID_st : out std_logic; -- ID2OR_WR
            OR_st : out std_logic_vector(2 downto 0); -- OR2EX_WR, MUX_RF_A1, MUX_RF_A2
            EX_st : out std_logic_vector(10 downto 0); -- EX2MA_WR, MUX_ALU_A_0, MUX_ALU_A_1, MUX_ALU_B, ALU_CARRY_1, ALU_CARRY_0, ALU_OPER, ALU_COMPLEMENT, MUX_ADDER_A, MUX_ADDER_B_0, MUX_ADDER_B_1
            MA_st : out std_logic_vector(3 downto 0); -- MA2WB_WR, DATA_MEM_WR, DATA_MEM_RD, MUX_MEM_OUT 
            WB_st : out std_logic_vector(1 downto 0)); -- WB_MUX_1, WB_MUX_0
end entity controller;

architecture dictator of controller is

    signal ID2OR_WR: std_logic;
    signal OR2EX_WR, MUX_RF_A1, MUX_RF_A2: std_logic;
    signal EX2MA_WR, MUX_ALU_A_0, MUX_ALU_A_1, MUX_ALU_B, ALU_CARRY_1, ALU_CARRY_0, ALU_OPER, ALU_COMPLEMENT, MUX_ADDER_A, MUX_ADDER_B_0, MUX_ADDER_B_1: std_logic;
    signal MA2WB_WR, DATA_MEM_WR, DATA_MEM_RD, MUX_MEM_OUT: std_logic;
    signal WB_MUX_1, WB_MUX_0: std_logic;
	 
begin

    opcode <= instruction(15 downto 12) & instruction(1 downto 0);
    instr_11_9 <= instruction(11 downto 9);
    instr_8_6 <= instruction(8 downto 6);
    instr_5_3 <= instruction(5 downto 3);
    instr_2_0 <= instruction(2 downto 0);
    instr_7_0 <= instruction(7 downto 0);
    instr_5_0 <= instruction(5 downto 0);
    instr_8_0 <= instruction(8 downto 0);
    alpha_decode <= not instruction(15) and instruction(14) and instruction(13);
    ID2OR_WR <= '1';
    OR2EX_WR <= '1';
    EX2MA_WR <= '1';
    MA2WB_WR <= '1';
    
    -- All signals with Instruction Decode(ID) Stage 
    ID_st <= ID2OR_WR;

    -- All signals with Operand Read(OR) Stage 
    MUX_RF_A1 <= (not instruction(15)) and instruction(14) and instruction(13) and instruction(12);
    MUX_RF_A2 <= instruction(15) or instruction(14);
    OR_st <= OR2EX_WR & MUX_RF_A1 & MUX_RF_A2;

    -- All signals with Execute(EX) Stage 
    MUX_ALU_A_0 <= (not instruction(15)) and instruction(14) and instruction(13) and alpha;
    MUX_ALU_A_1 <= (not instruction(15)) and instruction(14) and instruction(13);
    MUX_ALU_B <= ((not instruction(15)) and instruction(14) and (not instruction(13))) 
                    or (not (instruction(15) or instruction(14) or instruction(13) or instruction(12)));
    with instruction(15 downto 12) select
        ALU_CARRY_1 <= '1' when "0001",
							  '1' when "1000",
                       '1' when "1001",
                       '1' when "1011",
                       '0' when others;
    with instruction(15 downto 12) select
        ALU_CARRY_0 <= '1' when "1000",
                       '1' when "1001",
                       '1' when "1011",
                       '0' when others;                
    with instruction(15 downto 12) select
        ALU_OPER <= '1' when "0010",
                    '0' when others;
    with instruction(15 downto 12) select
        ALU_COMPLEMENT  <= instruction(2) when "0001",
                           instruction(2) when "0010",
                           '1' when "1000",
                           '1' when "1001",
                           '1' when "1011",
                           '0' when others;
    MUX_ADDER_A <= not(instruction(15) and instruction(14) and instruction(13) and instruction(12));
    MUX_ADDER_B_0 <= '1';
    MUX_ADDER_B_1 <= not(instruction(15) and instruction(14) and instruction(13) and instruction(12));
    EX_st <= EX2MA_WR & MUX_ALU_A_0 & MUX_ALU_A_1 & MUX_ALU_B & ALU_CARRY_1 & ALU_CARRY_0 & ALU_OPER & ALU_COMPLEMENT & MUX_ADDER_A & MUX_ADDER_B_0 & MUX_ADDER_B_1;
    
    -- All signals with Memory Access(MA) Stage 
    DATA_MEM_WR <= (not instruction(15)) and instruction(14) and instruction(12);
    DATA_MEM_RD <= (not instruction(15)) and instruction(14) and (not instruction(12));
    MUX_MEM_OUT <= (not instruction(15)) and instruction(14) and (not instruction(12));
	 MA_st <= MA2WB_WR & DATA_MEM_WR & DATA_MEM_RD & MUX_MEM_OUT; 

    -- All signals with Write Back(WB) Stage 
    WB_MUX_1 <= (instruction(15) and instruction(14)) 
            or ((not instruction(15)) and (not instruction(14)) and instruction(13) and instruction(12));
    WB_MUX_0 <= (not instruction(15)) and (not instruction(14)) and instruction(13) and instruction(12);
	 WB_st <= WB_MUX_1 & WB_MUX_0;

end dictator;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.all;

entity prog_reg is
	port (A1, A2, A3: in std_logic_vector(2 downto 0);
			D1, D2: out std_logic_vector(15 downto 0);
			D3: in std_logic_vector(15 downto 0);
			PC_in: in std_logic_vector(15 downto 0);
			PC_out: out std_logic_vector(15 downto 0);
			PC_enable: in std_logic;
			clk: in std_logic;
			w_enable: in std_logic);
end entity prog_reg;

architecture pr of prog_reg is
	-- These signals dictate which registers are allowed to be written
	signal e0, e1, e2, e3, e4, e5, e6,  e7: std_logic;
	-- These signals carry the output from each register
	signal r0, r1, r2, r3, r4, r5, r6, r7: std_logic_vector(15 downto 0);
begin

	-- Assign signals to control write enable for individual registers
	e0 <= w_enable and not(A3(2)) and not(A3(1)) and not(A3(0));
	e1 <= w_enable and not(A3(2)) and not(A3(1)) and (A3(0));
	e2 <= w_enable and not(A3(2)) and (A3(1)) and not(A3(0));
	e3 <= w_enable and not(A3(2)) and (A3(1)) and (A3(0));
	e4 <= w_enable and (A3(2)) and not(A3(1)) and not(A3(0));
	e5 <= w_enable and (A3(2)) and not(A3(1)) and (A3(0));
	e6 <= w_enable and (A3(2)) and (A3(1)) and not(A3(0));
	e7 <= w_enable and (A3(2)) and (A3(1)) and (A3(0));
	
	-- Initialise the registers
	reg0: T_reg port map (input => D3, w_enable => e0, clk => clk, output => r0);
	reg1: T_reg port map (input => D3, w_enable => e1, clk => clk, output => r1);
	reg2: T_reg port map (input => D3, w_enable => e2, clk => clk, output => r2);
	reg3: T_reg port map (input => D3, w_enable => e3, clk => clk, output => r3);
	reg4: T_reg port map (input => D3, w_enable => e4, clk => clk, output => r4);
	reg5: T_reg port map (input => D3, w_enable => e5, clk => clk, output => r5);
	reg6: T_reg port map (input => D3, w_enable => e6, clk => clk, output => r6);
	reg7: T_reg port map (input => D3, w_enable => e7, clk => clk, output => r7);
	
	with A1 select
		D1 <= r0 when "000",
				r1 when "001",
				r2 when "010",
				r3 when "011",
				r4 when "100",
				r5 when "101",
				r6 when "110",
				r7 when "111";
	
	with A2 select
		D2 <= r0 when "000",
				r1 when "001",
				r2 when "010",
				r3 when "011",
				r4 when "100",
				r5 when "101",
				r6 when "110",
				r7 when "111";
				
	PC_out <= r0;
	writePC: process(clk) is
	begin
		if(falling_edge(clk)) then
			if(PC_enable = '1') then 
				r0 <= PC_in;
			end if;
		end if;
	end process writePC;
end pr;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity signed_extender is
	port (in1, in2: in std_logic_vector(5 downto 0);
			output: out std_logic_vector(15 downto 0));
end entity signed_extender;

architecture ext of signed_extender is
begin
	conv_process: process(input)
	begin
		if (input(5) = '0') then
			output <= "0000000000" & in1 & in2;
		else 
			output <= "1111111111" & in1 & in2;
		end if;
	end process;
end ext;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity EX2MAreg is
	port (
			---------------------------------inputs
			clk, EX2MA_WR: in std_logic;
            reset_wr: in std_logic;
            opcode_in: in std_logic_vector(5 downto 0);
            instr_11_9_in : in std_logic_vector(2 downto 0);
            E9_output_in: in std_logic_vector(15 downto 0);
            ALU_output_in: in std_logic_vector(15 downto 0);
            D2_output_in: in std_logic_vector(15 downto 0); 
            enc_addr_in : in std_logic_vector(2 downto 0); -- output from custom encoder
            PC2_in : in std_logic_vector(15 downto 0);
            MA_st_in : in std_logic_vector(3 downto 0); -- MA2WB_WR, DATA_MEM_WR, DATA_MEM_RD, MUX_MEM_OUT 
            WB_st_in : in std_logic_vector(1 downto 0); -- WB_MUX_1, WB_MUX_0
            RF_WR_in: in std_logic;
            ---------------------------------outputs
            opcode_out: out std_logic_vector(5 downto 0);
            instr_11_9_out : out std_logic_vector(2 downto 0);
            E9_output_out: out std_logic_vector(15 downto 0);
            ALU_output_out: out std_logic_vector(15 downto 0);
            D2_output_out: out std_logic_vector(15 downto 0); 
            enc_addr_out : out std_logic_vector(2 downto 0); -- output from custom encoder
            PC2_out : out std_logic_vector(15 downto 0);
            MA_st_out : out std_logic_vector(3 downto 0); -- MA2WB_WR, DATA_MEM_WR, DATA_MEM_RD, MUX_MEM_OUT 
            WB_st_out : out std_logic_vector(1 downto 0); -- WB_MUX_1, WB_MUX_0
            RF_WR_out: out std_logic
    );
end entity EX2MAreg;

architecture bhv4 of EX2MAreg is
	signal opcode_s: std_logic_vector(5 downto 0) := "000000";
    signal instr_11_9_s, enc_addr_s: std_logic_vector(2 downto 0) := "000";
    signal PC2_s, E9_output_s, D2_output_s, ALU_output_s: std_logic_vector(15 downto 0) := "0000000000000000";
    signal MA_st_s: std_logic_vector(3 downto 0) := "0000";
    signal WB_st_s: std_logic_vector(1 downto 0) := "00";
    signal RF_WR_S: std_logic := '0';
begin

    opcode_out <= opcode_s;
    instr_11_9_out <= instr_11_9_s;
    E9_output_out <= E9_output_s;
    ALU_output_out <= ALU_output_s;
    D2_output_out <= D2_output_s;
    enc_addr_out <= enc_addr_s;
    PC2_out <= PC2_s;
    MA_st_out <= MA_st_s;
    WB_st_out <= WB_st_s;
    RF_WR_out <= RF_WR_s;

    edit_process: process(clk, EX2MA_WR, reset_wr) is
    begin
        if(falling_edge(clk) and EX2MA_WR = '1') then
            opcode_s <= opcode_in;
            instr_11_9_s <= instr_11_9_in;
            E9_output_s <= E9_output_in;
            ALU_output_s <= ALU_output_in;
            D2_output_s <= D2_output_in;
            enc_addr_s <= enc_addr_in;
            PC2_s <= PC2_in;
            MA_st_s <= MA_st_in;
            WB_st_s <= WB_st_in;
            RF_WR_s <= RF_WR_in;
		end if;
		if (falling_edge(clk) and reset_wr = '1') then
            MA_st_s(2) <= '0'; --DATA_MEM_WR
            RF_WR_s <= '0';
        end if; 
    end process edit_process;
end architecture bhv4;

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ID2ORreg is
	port (
			---------------------------------inputs
			clk, ID2OR_WR: in std_logic;
            reset_wr: in std_logic;
            opcode_in: in std_logic_vector(5 downto 0);
            instr_11_9_in : in std_logic_vector(2 downto 0); 
            instr_8_6_in : in std_logic_vector(2 downto 0); 
            instr_5_3_in, instr_2_0_in : in std_logic_vector(2 downto 0); 
            instr_5_0_in : in std_logic_vector(5 downto 0);  
            instr_8_0_in : in std_logic_vector(8 downto 0); 
            enc_addr_in : in std_logic_vector(2 downto 0); -- output from custom encoder
            enc_input_in : in std_logic_vector(7 downto 0); -- input to custom encoder
            LS6_in : in std_logic_vector(15 downto 0); -- output from leftshifter 6bit
            LS9_in : in std_logic_vector(15 downto 0); -- output from leftshifter 9bit
            PC_in : in std_logic_vector(15 downto 0);
            PC2_in : in std_logic_vector(15 downto 0);
            OR_st_in : in std_logic_vector(2 downto 0); -- OR2EX_WR, MUX_RF_A1, MUX_RF_A2
            EX_st_in : in std_logic_vector(10 downto 0); -- EX2MA_WR, MUX_ALU_A_0, MUX_ALU_A_1, MUX_ALU_B, ALU_CARRY_1, ALU_CARRY_0, ALU_OPER, ALU_COMPLEMENT, MUX_ADDER_A, MUX_ADDER_B_0, MUX_ADDER_B_1
            MA_st_in : in std_logic_vector(3 downto 0); -- MA2WB_WR, DATA_MEM_WR, DATA_MEM_RD, MUX_MEM_OUT 
            WB_st_in : in std_logic_vector(1 downto 0); -- WB_MUX_1, WB_MUX_0
            RF_WR_in: in std_logic;
            ---------------------------------outputs
            opcode_out: out std_logic_vector(5 downto 0);
            instr_11_9_out : out std_logic_vector(2 downto 0); --will go to RF
            instr_8_6_out : out std_logic_vector(2 downto 0); --will go to RF
            instr_5_3_out, instr_2_0_out : out std_logic_vector(2 downto 0); -- will go to RF
            instr_5_0_out : out std_logic_vector(5 downto 0); -- will go to SE6
            instr_8_0_out : out std_logic_vector(8 downto 0); -- will go to E9
            enc_addr_out : out std_logic_vector(2 downto 0); -- output from custom encoder
            enc_input_out : out std_logic_vector(7 downto 0); -- input to custom encoder
            LS6_out : out std_logic_vector(15 downto 0); -- output from leftshifter 6bit
            LS9_out : out std_logic_vector(15 downto 0); -- output from leftshifter 9bit
            PC_out : out std_logic_vector(15 downto 0);
            PC2_out : out std_logic_vector(15 downto 0);
            OR_st_out : out std_logic_vector(2 downto 0); -- OR2EX_WR, MUX_RF_A1, MUX_RF_A2
            EX_st_out : out std_logic_vector(10 downto 0); -- EX2MA_WR, MUX_ALU_A_0, MUX_ALU_A_1, MUX_ALU_B, ALU_CARRY_1, ALU_CARRY_0, ALU_OPER, ALU_COMPLEMENT, MUX_ADDER_A, MUX_ADDER_B_0, MUX_ADDER_B_1
            MA_st_out : out std_logic_vector(3 downto 0); -- MA2WB_WR, DATA_MEM_WR, DATA_MEM_RD, MUX_MEM_OUT 
            WB_st_out : out std_logic_vector(1 downto 0); -- WB_MUX_1, WB_MUX_0
            RF_WR_out: out std_logic
    );
end entity ID2ORreg;

architecture bhv2 of ID2ORreg is
	signal opcode_s, instr_5_0_s: std_logic_vector(5 downto 0) := "000000";
    signal instr_11_9_s, instr_8_6_s, instr_5_3_s, instr_2_0_s, enc_addr_s, OR_st_s: std_logic_vector(2 downto 0) := "000";
    signal instr_8_0_s: std_logic_vector(8 downto 0) := "000000000";
    signal enc_input_s: std_logic_vector(7 downto 0) := "00000000";
    signal LS6_s, LS9_s, PC_s, PC2_s: std_logic_vector(15 downto 0) := "0000000000000000";
    signal EX_st_s: std_logic_vector(10 downto 0) := "00000000000";
    signal MA_st_s: std_logic_vector(3 downto 0) := "0000";
    signal WB_st_s: std_logic_vector(1 downto 0) := "00";
    signal RF_WR_S: std_logic := '0';
begin

    opcode_out <= opcode_s;
    instr_11_9_out <= instr_11_9_s;
    instr_8_6_out <= instr_8_6_s;
    instr_5_3_out <= instr_5_3_s;
	instr_2_0_out <= instr_2_0_s
    instr_5_0_out <= instr_5_0_s;
    instr_8_0_out <= instr_8_0_s;
    enc_addr_out <= enc_addr_s;
    enc_input_out <= enc_input_s;
    LS6_out <= LS6_s;
    LS9_out <= LS9_s;
    PC_out <= PC_s;
    PC2_out <= PC2_s;
    OR_st_out <= OR_st_s;
    EX_st_out <= EX_st_s;
    MA_st_out <= MA_st_s;
    WB_st_out <= WB_st_s;
    RF_WR_out <= RF_WR_s;

    edit_process: process(clk, ID2OR_WR, reset_wr) is
    begin
        if(falling_edge(clk) and ID2OR_WR = '1') then
            opcode_s <= opcode_in;
            instr_11_9_s <= instr_11_9_in;
            instr_8_6_s <= instr_8_6_in;
            instr_5_3_s <= instr_5_3_in;
			instr_2_0_s <= instr_2_0_in;
            instr_5_0_s <= instr_5_0_in;
            instr_8_0_s <= instr_8_0_in;
            enc_addr_s <= enc_addr_in;
            enc_input_s <= enc_input_in;
            LS6_s <= LS6_in;
            LS9_s <= LS9_in;
            PC_s <= PC_in;
            PC2_s <= PC2_in;
            OR_st_s <= OR_st_in;
            EX_st_s <= EX_st_in;
            MA_st_s <= MA_st_in;
            WB_st_s <= WB_st_in;
            RF_WR_s <= RF_WR_in;
		end if;
		if (falling_edge(clk) and reset_wr = '1') then
            MA_st_s(2) <= '0'; --DATA_MEM_WR
            RF_WR_s <= '0';
        end if; 
    end process edit_process;
end architecture bhv2;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity MA2WBreg is
	port (
			---------------------------------inputs
			clk, MA2WB_WR: in std_logic;
            reset_wr: in std_logic;
            opcode_in: in std_logic_vector(5 downto 0);
            instr_11_9_in : in std_logic_vector(2 downto 0);
            MEM_output_in: in std_logic_vector(15 downto 0);
            E9_output_in: in std_logic_vector(15 downto 0);
            enc_addr_in : in std_logic_vector(2 downto 0); -- output from custom encoder
            PC2_in : in std_logic_vector(15 downto 0);            
            WB_st_in : in std_logic_vector(1 downto 0); -- WB_MUX_1, WB_MUX_0
            RF_WR_in: in std_logic;
            ---------------------------------outputs
            opcode_out: out std_logic_vector(5 downto 0);
            instr_11_9_out : out std_logic_vector(2 downto 0);
            MEM_output_out: out std_logic_vector(15 downto 0);
            E9_output_out: out std_logic_vector(15 downto 0);
            enc_addr_out : out std_logic_vector(2 downto 0); -- output from custom encoder
            PC2_out : out std_logic_vector(15 downto 0);
            WB_st_out : out std_logic_vector(1 downto 0); -- WB_MUX_1, WB_MUX_0
            RF_WR_out: out std_logic
    );
end entity MA2WBreg;

architecture bhv5 of MA2WBreg is
	signal opcode_s: std_logic_vector(5 downto 0) := "000000";
    signal instr_11_9_s, enc_addr_s: std_logic_vector(2 downto 0) := "000";
    signal PC2_s, E9_output_s, MEM_output_s: std_logic_vector(15 downto 0) := "0000000000000000";
    signal WB_st_s: std_logic_vector(1 downto 0) := "00";
    signal RF_WR_S: std_logic := '0';
begin

    opcode_out <= opcode_s;
    instr_11_9_out <= instr_11_9_s;
    E9_output_out <= E9_output_s;
    MEM_output_out <= MEM_output_s;
    enc_addr_out <= enc_addr_s;
    PC2_out <= PC2_s;
    WB_st_out <= WB_st_s;
    RF_WR_out <= RF_WR_s;

    edit_process: process(clk, MA2WB_WR, reset_wr) is
    begin
        if(falling_edge(clk) and MA2WB_WR = '1') then
            opcode_s <= opcode_in;
            instr_11_9_s <= instr_11_9_in;
            E9_output_s <= E9_output_in;
            MEM_output_s <= MEM_output_in;
            enc_addr_s <= enc_addr_in;
            PC2_s <= PC2_in;
            WB_st_s <= WB_st_in;
            RF_WR_s <= RF_WR_in;
		end if;
		if (falling_edge(clk) and reset_wr = '1') then
            RF_WR_s <= '0';
        end if; 
    end process edit_process;
end architecture bhv5;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity OR2EXreg is
	port (
			---------------------------------inputs
			   clk, OR2EX_WR: in std_logic;
            reset_wr: in std_logic;
            opcode_in: in std_logic_vector(5 downto 0);
            instr_11_9_in : in std_logic_vector(2 downto 0);
            E9_output_in: in std_logic_vector(15 downto 0);
            SE6_output_in: in std_logic_vector(15 downto 0);
            D1_output_in: in std_logic_vector(15 downto 0);
            D2_output_in: in std_logic_vector(15 downto 0); 
            enc_addr_in : in std_logic_vector(2 downto 0); -- output from custom encoder
            LS6_in : in std_logic_vector(15 downto 0); -- output from leftshifter 6bit
            LS9_in : in std_logic_vector(15 downto 0); -- output from leftshifter 9bit
            PC_in : in std_logic_vector(15 downto 0);
            PC2_in : in std_logic_vector(15 downto 0);
            EX_st_in : in std_logic_vector(10 downto 0); -- EX2MA_WR, MUX_ALU_A_0, MUX_ALU_A_1, MUX_ALU_B, ALU_CARRY_1, ALU_CARRY_0, ALU_OPER, ALU_COMPLEMENT, MUX_ADDER_A, MUX_ADDER_B_0, MUX_ADDER_B_1
            MA_st_in : in std_logic_vector(3 downto 0); -- MA2WB_WR, DATA_MEM_WR, DATA_MEM_RD, MUX_MEM_OUT 
            WB_st_in : in std_logic_vector(1 downto 0); -- WB_MUX_1, WB_MUX_0
            RF_WR_in: in std_logic;
            ---------------------------------outputs
            opcode_out: out std_logic_vector(5 downto 0);
            E9_output_out: out std_logic_vector(15 downto 0);
            instr_11_9_out : out std_logic_vector(2 downto 0);
            SE6_output_out: out std_logic_vector(15 downto 0);
            D1_output_out: out std_logic_vector(15 downto 0);
            D2_output_out: out std_logic_vector(15 downto 0); 
            enc_addr_out : out std_logic_vector(2 downto 0); -- output from custom encoder
            LS6_out : out std_logic_vector(15 downto 0); -- output from leftshifter 6bit
            LS9_out : out std_logic_vector(15 downto 0); -- output from leftshifter 9bit
            PC_out : out std_logic_vector(15 downto 0);
            PC2_out : out std_logic_vector(15 downto 0);
            EX_st_out : out std_logic_vector(10 downto 0); -- EX2MA_WR, MUX_ALU_A_0, MUX_ALU_A_1, MUX_ALU_B, ALU_CARRY_1, ALU_CARRY_0, ALU_OPER, ALU_COMPLEMENT, MUX_ADDER_A, MUX_ADDER_B_0, MUX_ADDER_B_1
            MA_st_out : out std_logic_vector(3 downto 0); -- MA2WB_WR, DATA_MEM_WR, DATA_MEM_RD, MUX_MEM_OUT 
            WB_st_out : out std_logic_vector(1 downto 0); -- WB_MUX_1, WB_MUX_0
            RF_WR_out: out std_logic
    );
end entity OR2EXreg;

architecture bhv3 of OR2EXreg is
	signal opcode_s: std_logic_vector(5 downto 0) := "000000";
    signal instr_11_9_s, enc_addr_s: std_logic_vector(2 downto 0) := "000";
    signal LS6_s, LS9_s, PC_s, PC2_s, E9_output_s, SE6_output_s, D1_output_s, D2_output_s: std_logic_vector(15 downto 0) := "0000000000000000";
    signal EX_st_s: std_logic_vector(10 downto 0) := "00000000000";
    signal MA_st_s: std_logic_vector(3 downto 0) := "0000";
    signal WB_st_s: std_logic_vector(1 downto 0) := "00";
    signal RF_WR_S: std_logic := '0';
begin

    opcode_out <= opcode_s;
    instr_11_9_out <= instr_11_9_s;
    E9_output_out <= E9_output_s;
    SE6_output_out <= SE6_output_s;
    D1_output_out <= D1_output_s;
    D2_output_out <= D2_output_s;
    enc_addr_out <= enc_addr_s;
    LS6_out <= LS6_s;
    LS9_out <= LS9_s;
    PC_out <= PC_s;
    PC2_out <= PC2_s;
    EX_st_out <= EX_st_s;
    MA_st_out <= MA_st_s;
    WB_st_out <= WB_st_s;
    RF_WR_out <= RF_WR_s;

    edit_process: process(clk, OR2EX_WR, reset_wr) is
    begin
        if(falling_edge(clk) and OR2EX_WR = '1') then
            opcode_s <= opcode_in;
            instr_11_9_s <= instr_11_9_in;
            E9_output_s <= E9_output_in;
            SE6_output_s <= SE6_output_in;
            D1_output_s <= D1_output_in;
            D2_output_s <= D2_output_in;
            enc_addr_s <= enc_addr_in;
            LS6_s <= LS6_in;
            LS9_s <= LS9_in;
            PC_s <= PC_in;
            PC2_s <= PC2_in;
            EX_st_s <= EX_st_in;
            MA_st_s <= MA_st_in;
            WB_st_s <= WB_st_in;
            RF_WR_s <= RF_WR_in;
		end if;
		if (falling_edge(clk) and reset_wr = '1') then
            MA_st_s(2) <= '0'; --DATA_MEM_WR
            RF_WR_s <= '0';
        end if; 
    end process edit_process;
end architecture bhv3;