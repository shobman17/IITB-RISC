--This contains all the components we might need in a single place to make the initialisation a lot easier.

library ieee;
use ieee.std_logic_1164.all;

--A package declaration is used to store a set of common declarations, such as components.
--These declarations can then be imported into other design units using a use clause.

package Components is

----------------------------------------------------------------------------------------
-----------------------------------ADDERs and family------------------------------------
----------------------------------------------------------------------------------------

	component ALU_unit_cell is
		port (A, B: in std_logic;
				C: in std_logic;
				alu_cmp, alu_oper: in std_logic;
				out_c, out_s: out std_logic);
	end component ALU_unit_cell;

	component ALU is 
	port (ALU_A, ALU_B: in std_logic_vector(15 downto 0);
			ALU_OPER: in std_logic;
			ALU_COMP, ALU_CARRY: in std_logic;
			ALU_OUT: out std_logic_vector(15 downto 0);
			Z_O, C_O: out std_logic);
	end component ALU;

	component ADDER_unit_cell is
		port (A, B: in std_logic;
				C: in std_logic;
				out_c, out_s: out std_logic);
	end component ADDER_unit_cell;

	component ADDER is 
	port (ADDER_A, ADDER_B: in std_logic_vector(15 downto 0);
			--ALU_OPER: in std_logic;
			--ALU_COMP, ALU_CARRY: in std_logic;
			ADDER_OUT: out std_logic_vector(15 downto 0));
			--Z_O, C_O: out std_logic);
	end component ADDER;

---------------------------------------------------------------------------------
-----------------------------------BLACKBOXES------------------------------------
---------------------------------------------------------------------------------

	component bbD1 is
		port (
				mux_rf_a1_output, or2ex_a3, ex2ma_a3, ma2wb_a3: in std_logic_vector(2 downto 0);
				or2ex_rf_wr, ex2ma_rf_wr, ma2wb_rf_wr:in std_logic;
			id2or_mux_alu_a : in std_logic_vector(1 downto 0);
				mux_rf_d1_1, mux_rf_d1_0 : out std_logic
			);
	end component bbD1;

	component bbD2 is
		port (
				mux_rf_a1_output, or2ex_a3, ex2ma_a3, ma2wb_a3: in std_logic_vector(2 downto 0);
				or2ex_rf_wr, ex2ma_rf_wr, ma2wb_rf_wr, alpha:in std_logic;
			id2or_mux_alu_b : in std_logic;
				mux_rf_d2_1, mux_rf_d2_0 : out std_logic
			);
	end component bbD2;

	component bb_cwr_zwr is
		port (
				EX_RF_WR, ex2ma_c, ex2ma_z:in std_logic;
				opcode : in std_logic_vector(5 downto 0);
				c_wr, z_wr, rf_wr_and_a: out std_logic);
	end component bb_cwr_zwr;

	component bb_branching is
		port (c_o, z_o:in std_logic;
				opcode : in std_logic_vector(5 downto 0);
				hb_in : out std_logic);
	end component bb_branching;

	component pc_mux is
		port (
			PC2, D1_out, Adder_out, out_IF, out_EXE: in std_logic_vector(15 downto 0);
			opcode_EXE: in std_logic_vector(5 downto 0);
			branch, reset_wr: in std_logic;
			PC_out: out std_logic_vector(15 downto 0)
			);
	end component pc_mux;

---------------------------------------------------------------------------------------
-----------------------------------BRANCH-PREDICTOR------------------------------------
---------------------------------------------------------------------------------------

	component branch_predictor is 
	generic (
		addrSize    : integer   := 16;
		tableSize   : integer   := 64);
	port(
		in_IF, in_EXE, in_pred, in_EXE2: in std_logic_vector(15 downto 0); --in_IF is for reading prediction. in_EXE and in_pred are for writing a prediction
		opcode_EXE: in std_logic_vector(5 downto 0);
		hb_in: in std_logic; -- input for history bit to write to this table
		out_IF, out_EXE: out std_logic_vector(15 downto 0); -- prediction output or correction to branch
		branch: out std_logic; -- whether to branch or not
		reset_wr: out std_logic); -- whether prediction was wrong or not
	end component branch_predictor;

---------------------------------------------------------------------------------------
-----------------------------------CONTROLLER------------------------------------
---------------------------------------------------------------------------------------

	component controller is
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
	end component controller;


----------------------------------------------------------------------------------------
-----------------------------------CUSTOM-ENCODER---------------------------------------
----------------------------------------------------------------------------------------

	component reverse_decoder_3to8 is
		port (input: in std_logic_vector(2 downto 0);
				output: out std_logic_vector(7 downto 0));
	end component reverse_decoder_3to8;

	component custom_encoder is
		port (input: in std_logic_vector(7 downto 0);
				output: out std_logic_vector(2 downto 0);
				all_zero, single_one: out std_logic); -- nor of all input bits. Useful to know end of LM/SM instruction
	end component custom_encoder;

----------------------------------------------------------------------------------------
----------------------------------------EXTENDERS---------------------------------------
----------------------------------------------------------------------------------------

	component extender_nine is
		port (input: in std_logic_vector(8 downto 0);
				output: out std_logic_vector(15 downto 0));
	end component extender_nine;
	
	component Lshifter6 is
		port (inp : in std_logic_vector (5 downto 0);
				outp : out std_logic_vector (15 downto 0));
	end component LShifter6;
	
	component Lshifter9 is
		port (inp : in std_logic_vector (8 downto 0);
				outp : out std_logic_vector (15 downto 0));
	end component LShifter9;
	
	component signed_extender is
		port (input: in std_logic_vector(5 downto 0);
				output: out std_logic_vector(15 downto 0));
	end component signed_extender;

----------------------------------------------------------------------------------------
----------------------------------------MEMORY------------------------------------------
----------------------------------------------------------------------------------------


	component Memory_Code is 
			port(
					clk: in std_logic; 
					mem_addr: in std_logic_vector(15 downto 0);
					mem_out: out std_logic_vector(15 downto 0)
				); 
	end component; 

	component Memory_Data is 
			port(
					clk, m_wr, m_rd: in std_logic; 
					mem_addr, mem_in: in std_logic_vector(15 downto 0);
					mem_out, output_datapath: out std_logic_vector(15 downto 0)
				); 
	end component; 

----------------------------------------------------------------------------------------
-----------------------------------------MUXES------------------------------------------
----------------------------------------------------------------------------------------

	component mux_2_1  is
		port (I0 ,I1: in std_logic_vector(15 downto 0);
			S0: in std_logic;
				mux_out: out std_logic_vector(15 downto 0));
	end component mux_2_1;

	component mux_2_1_3  is
		port (I0 ,I1: in std_logic_vector(2 downto 0);
			S0: in std_logic;
				mux_out: out std_logic_vector(2 downto 0));
	end component mux_2_1_3;
	
	component mux_4_1  is
		port (I0 ,I1, I2,I3: in std_logic_vector(15 downto 0);
			S0,S1 : in std_logic;
				mux_out: out std_logic_vector(15 downto 0));
	end component mux_4_1;
		
	component mux_4_1_1  is
	  port (I0 ,I1, I2,I3: in std_logic;
			  S0,S1 : in std_logic;
			  mux_out: out std_logic);
	end component mux_4_1_1;

	component mux51  is
		port (I0 ,I1, I2,I3,I4: in std_logic_vector(15 downto 0);
			S0,S1,S2 : in std_logic;
				mux_out: out std_logic_vector(15 downto 0));
	end component mux51;


----------------------------------------------------------------------------------------
-----------------------------------------PIPELINE-REGISTERS------------------------------------------
----------------------------------------------------------------------------------------

	component EX2MAreg is
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
				EX_c, EX_z: in std_logic;
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
				MA_c, MA_z: out std_logic;
            RF_WR_out: out std_logic
		);
	end component EX2MAreg;


	component ID2ORreg is
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
					ID_alpha : in std_logic;
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
					OR_alpha : out std_logic;
					RF_WR_out: out std_logic
		 );
	end component ID2ORreg;

	component IF2IDreg is
		port (
				clk, IF2ID_WR: in std_logic;
				IMdata, pc, pc2: in std_logic_vector(15 downto 0);
				IMdatao, pco, pc2o: out std_logic_vector(15 downto 0));
	end component IF2IDreg;

	component MA2WBreg is
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
	--            EX_c, EX_z: in std_logic;
					RF_WR_in: in std_logic;
					---------------------------------outputs
					opcode_out: out std_logic_vector(5 downto 0);
					correct_rf_addr : out std_logic_vector(2 downto 0);
					MEM_output_out: out std_logic_vector(15 downto 0);
					E9_output_out: out std_logic_vector(15 downto 0);
					enc_addr_out : out std_logic_vector(2 downto 0); -- output from custom encoder
					PC2_out : out std_logic_vector(15 downto 0);
					WB_st_out : out std_logic_vector(1 downto 0); -- WB_MUX_1, WB_MUX_0
	--            MA_c, MA_z: out std_logic;
					RF_WR_out: out std_logic
		 );
	end component MA2WBreg;

	component OR2EXreg is
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
	end component OR2EXreg;


----------------------------------------------------------------------------------------
-----------------------------------------REGISTERS------------------------------------------
----------------------------------------------------------------------------------------

	component alpha is
		port (
				input,clk: in std_logic;
				output: out std_logic);
	end component alpha;

	component CZreg is
		port (
				c_in, z_in, clk, c_wr, z_wr:in std_logic;
				c_out, z_out: out std_logic);
	end component CZreg;

	component prog_reg is
		port (A1, A2, A3: in std_logic_vector(2 downto 0);
				D1, D2: out std_logic_vector(15 downto 0);
				D3: in std_logic_vector(15 downto 0);
				PC_in: in std_logic_vector(15 downto 0);
				PC_out: out std_logic_vector(15 downto 0);
				PC_enable: in std_logic;
				clk: in std_logic;
				w_enable: in std_logic;
				reset: in std_logic);
	end component prog_reg;

	component T_reg is
		port (input:in std_logic_vector(15 downto 0);
				w_enable, clk: in std_logic;
				output: out std_logic_vector(15 downto 0));
	end component T_reg;
	
	component subtractor is 
	port (input_addr: in std_logic_vector(2 downto 0);
			input_immediate: in std_logic_vector(7 downto 0);
			output: out std_logic_vector(7 downto 0));
	end component subtractor;

---------------------------------------------------------------------------------------------------------
-----------------------------------------REST-OF-THE-COMPONENTS------------------------------------------
---------------------------------------------------------------------------------------------------------


end package Components;


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
use ieee.numeric_std.all;

library Work;
entity T_reg is
	port (input:in std_logic_vector(15 downto 0);
			w_enable, clk: in std_logic;
			output: out std_logic_vector(15 downto 0));
end entity T_reg;

architecture bhv of T_reg is
	signal storage, input_storage: std_logic_vector(15 downto 0):="0000000000000000";
	begin
		output(15 downto 0)<= storage(15 downto 0);
		edit_process: process(clk)
		begin
			if(clk='1' and clk'event and w_enable='1') then
				storage(15 downto 0)<=input_storage(15 downto 0);
			end if;
			if(rising_edge(clk)) then
				input_storage(15 downto 0)<=input(15 downto 0);
			end if;
		end process;
end architecture bhv;




library ieee;
use ieee.std_logic_1164.all;

entity extender_nine is
	port (input: in std_logic_vector(8 downto 0);
			output: out std_logic_vector(15 downto 0));
end entity extender_nine;

architecture major_extending of extender_nine is
begin
	--new_process: process(input)
	--begin
	output <= "0000000" & input;
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

architecture multiply_by_two of Lshifter6 is
	begin 
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

architecture multiply_by_two of Lshifter9 is
	begin 
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
			or2ex_rf_wr, ex2ma_rf_wr, ma2wb_rf_wr: in std_logic;
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
		   id2or_mux_alu_b : in std_logic;
			mux_rf_d2_1, mux_rf_d2_0 : out std_logic);
end entity bbD2;

architecture blackboxed2 of bbD2 is
	--signal c, z: std_logic := '0';
	--signal storage: std_logic_vector(1 downto 0):="00";
	begin
		edit_process: process(mux_rf_a1_output, or2ex_a3, ex2ma_a3, ma2wb_a3, or2ex_rf_wr, ex2ma_rf_wr, ma2wb_rf_wr,id2or_mux_alu_b, alpha)
		begin
			if ((mux_rf_a1_output = or2ex_a3 and or2ex_rf_wr = '1' and alpha ='1') or (alpha = '0'and id2or_mux_alu_b = '0')) then
			   mux_rf_d2_1<='0';
				mux_rf_d2_0<='1';
			elsif (mux_rf_a1_output = ex2ma_a3 and ex2ma_rf_wr ='1'and alpha = '1' and id2or_mux_alu_b = '0') then
			   mux_rf_d2_1<='1';
				mux_rf_d2_0<='0';
			elsif (mux_rf_a1_output = ma2wb_a3 and ma2wb_rf_wr = '1'and alpha = '1' and id2or_mux_alu_b = '0') then
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
			c_wr, z_wr, rf_wr_and_a: out std_logic);
end entity bb_cwr_zwr;

architecture blackboxed3 of bb_cwr_zwr is
	begin
		edit_process: process(ex2ma_c, ex2ma_z, opcode, EX_RF_WR)
		begin
			if (EX_RF_WR ='0') then
				c_wr <= '0';
				z_wr <= '0';
				rf_wr_and_a <= '0'; ---- ??????
			elsif (opcode = "000100" or opcode = "000111" or opcode = "000000" or opcode = "000001" or opcode = "000010" or opcode = "000011") then
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
			elsif (opcode = "000110" or opcode = "000101" or opcode = "001010" or opcode = "001001") then
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
entity bb_branching is
	port (c_o, z_o:in std_logic;
		   opcode : in std_logic_vector(5 downto 0);
			hb_in : out std_logic);
end entity bb_branching;

architecture blackboxed4 of bb_branching is
	begin
		edit_process: process(c_o, z_o, opcode)
		begin
			if (((opcode(5 downto 2) = "1000") and c_o ='1' and z_o ='1') or 
			    ((opcode(5 downto 2) = "1001") and (c_o = '1' and z_o ='0')) or 
				(opcode(5 downto 2)="1011" and (c_o = '1')) or
				(opcode(5 downto 2) ="1100") or  (opcode(5 downto 2) ="1111")) then 
				 
			      hb_in<= '1';
			else
				  hb_in<='0';
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

entity pc_mux is
	port (
		PC2, D1_out, Adder_out, out_IF, out_EXE: in std_logic_vector(15 downto 0);
		opcode_EXE: in std_logic_vector(5 downto 0);
		branch, reset_wr: in std_logic;
		PC_out: out std_logic_vector(15 downto 0)
	);
end entity pc_mux;

architecture blackboxed5 of pc_mux is
	begin
		edit_process: process(opcode_EXE, branch, reset_wr, PC2, D1_out, Adder_out, out_IF, out_EXE)
		begin
			if (opcode_EXE(5 downto 2) = "1111") then -- JRI
				PC_out <= Adder_out;
			elsif (opcode_EXE(5 downto 2) = "1101") then -- JLR
				PC_out <= D1_out;
			elsif (branch = '1') then -- conditional branch + JAL
				PC_out <= out_IF;
			elsif (reset_wr = '1') then -- conditional branch + JAL 
				PC_out <= out_EXE;
			else
				PC_out <= PC2;
			end if;
		end process edit_process;
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
--------------------------------------------------------------------------------------------------------

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
			input, clk: in std_logic;
			output: out std_logic);
end entity alpha;

architecture update of alpha is 
	signal alpha_content, alpha_input: std_logic := '0';
begin
	write_alpha: process(clk) is
	begin
		if(falling_edge(clk)) then
			alpha_content <= alpha_input;
		end if;
		if (rising_edge(clk)) then
			alpha_input<= input;
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
--   selectproc: process(S0) is 
--	begin 
--	if (S0 = '0' ) then 
--		mux_out <= I0;
--	elsif (S0 = '1') then 
--		mux_out <= I1;
		
	with S0 select
		mux_out <= I0 when '0',
					  I1 when '1';
	


--   end if;
--	end process selectproc;
end Structer;

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
entity mux_2_1_3  is
  port (I0 ,I1: in std_logic_vector(2 downto 0);
        S0: in std_logic;
		  mux_out: out std_logic_vector(2 downto 0));
end entity mux_2_1_3;

architecture Structer of mux_2_1_3 is
begin
   selectproc: process(S0) is 
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
	signal select_bits: std_logic_vector(1 downto 0);
begin
--   selectproc4: process(S0,S1) is 
--	begin 
--	if (S0 = '0' and S1 = '0') then 
--		mux_out <= I0;
--	elsif (S0 = '1' and S1 = '0') then 
--		mux_out <= I1;
--	elsif (S0 = '0' and S1 = '1') then 
--		mux_out <= I2;
--	elsif (S0 = '1' and S1 = '1') then 
--		mux_out <= I3;
	select_bits <= S1 & S0;
	with select_bits select
		mux_out <= I0 when "00",
					  I1 when "01",
					  I2 when "10",
					  I3 when "11";

--   end if;
--	end process selectproc4;
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

entity mux_4_1_1  is
  port (I0 ,I1, I2,I3: in std_logic;
        S0,S1 : in std_logic;
		  mux_out: out std_logic);
end entity mux_4_1_1;

architecture Structer4 of mux_4_1_1 is
begin
   selectproc4: process(S0,S1, I0, I1, I2, I3) is 
	begin 
	if (S0 = '0' and S1 = '0') then 
		mux_out <= I0;
	elsif (S0 = '1' and S1 = '0') then 
		mux_out <= I1;
	elsif (S0 = '0' and S1 = '1') then 
		mux_out <= I2;
	elsif (S0 = '1' and S1 = '1') then 
		mux_out <= I3;
	else 
		mux_out <= '0';
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
				mem_addr, mem_in: in std_logic_vector(15 downto 0);
				mem_out, output_datapath: out std_logic_vector(15 downto 0)
			 ); 
end entity; 

architecture memorykakaam of Memory_Data is 
		type mem_vec is array(65535 downto 0) of std_logic_vector(15 downto 0);
		signal memorykagyaan : mem_vec := (others => "0000000000000000");  
	
begin
	output_datapath <= memorykagyaan(65281); -- mem(0xFF01) is assigned memory mapped output
  mem_process : process (clk) is
  begin
	
	if m_rd = '1' then
			mem_out <= memorykagyaan(to_integer(unsigned(mem_addr)));
	else 
			mem_out <= "0000000000000000";
	end if;
    if falling_edge(clk) then
      if m_wr = '1' then
        memorykagyaan(to_integer(unsigned(mem_addr))) <= mem_in;  -- Write

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
	signal IMdatap, pcp, pc2p: std_logic_vector(15 downto 0) :="0000000000000000";
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
					IMdatas <= IMdatap;
					pcs <= pcp;
					pc2s <= pc2p; 
--				else 
--					IMdatas <= IMdatas;
--					pcs<=pcs;
--					pc2s<=pc2s;
				end if;
			elsif(rising_edge(clk)) then
					IMdatap <= IMdata;
					pcp <= pc;
					pc2p <= pc2; 
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
use ieee.numeric_std.all;

entity branch_predictor is 
	generic (
		addrSize    : integer   := 16;
		tableSize   : integer   := 64);
	port(
		in_IF, in_EXE, in_pred, in_EXE2: in std_logic_vector(15 downto 0); --in_IF is for reading prediction. in_EXE and in_pred are for writing a prediction
		opcode_EXE: in std_logic_vector(5 downto 0);
		hb_in: in std_logic; -- input for history bit to write to this table
		out_IF, out_EXE: out std_logic_vector(15 downto 0); -- prediction output or correction to branch
		branch: out std_logic; -- whether to branch or not
		reset_wr: out std_logic); -- whether prediction was wrong or not
end branch_predictor;

architecture predict of branch_predictor is
	
	type table is array(tableSize-1 downto 0) of std_logic_vector(addrSize-1 downto 0);
	signal inputTable: table := (others =>"0000000000000000");
	signal historyBit: std_logic_vector(tableSize-1 downto 0) := (others => '0');
	signal predTable : table := (others =>"0000000000000000");
	shared variable head: natural range 63 downto 0 := tableSize-1; -- where to write a new entry	
	 
begin

	IF_proc: process(in_IF, in_EXE, in_EXE2, hb_in, in_pred, opcode_EXE) is
		variable found: std_logic := '0';
		variable index: integer := 0;
	begin

		searchLUTIF: for i in tableSize-1 downto 0 loop
			--check if instruction in LUT
			if(inputTable(i) = in_IF) then
				-- check if HB = 1
				if(historyBit(i) = '1') then
					branch <= '1';
					out_IF <= predTable(i);
				else 
					branch <= '0';
					out_IF <= "0000000000000000";
				end if;
				EXIT searchLUTIF;
			else
				branch <= '0';
				out_IF <= "0000000000000000";
			end if;
		end loop searchLUTIF;
		
		------------------Now we check for EXE stage-------------------------				

		--check for branching opcode first
		if(opcode_EXE(5) = '1' and (((opcode_EXE(3) = '0') and (opcode_EXE(2) = '0')) or ((opcode_EXE(4) = '0') and opcode_EXE(2) = '1'))) then
			searchLUTEXE: for j in tableSize-1 downto 0 loop
				--check if instruction in LUT
				if(inputTable(j) = in_EXE) then
					index := j;
					found := '1';
					EXIT searchLUTEXE;
				else
					found := '0';
				end if;
			end loop searchLUTEXE;
			--if not found in LUT
			if(found = '0') then
				if (hb_in = '1') then
					inputTable(head) <= in_EXE;
					predTable(head) <= in_pred;
					historyBit(head) <= '1';
					out_EXE <= in_pred;
					reset_wr <= '1';
				else
					inputTable(head) <= in_EXE;
					predTable(head) <= in_pred;
					historyBit(head) <= '0';
					out_EXE <= "0000000000000000";
					reset_wr <= '0';
				end if;
				if(head = 0) then
					head := tableSize-1;
				else
					head := head - 1;
				end if;
			else
				-- check if instruction has confirmed branched
				if(hb_in = '1') then 
					reset_wr <= not(historyBit(index));
					out_EXE <= in_pred;
					historyBit(index) <= '1';
				else 
					reset_wr <= historyBit(index);
					out_EXE <= in_EXE2;
					historyBit(index) <='0';
				end if;
			end if;
		else
			reset_wr <= '0';
			out_EXE <= "0000000000000000";
		end if;
	end process IF_proc;
			
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
			w_enable: in std_logic;
			reset: in std_logic);
end entity prog_reg;

architecture pr of prog_reg is

	component T_reg is
		port (input:in std_logic_vector(15 downto 0);
				w_enable, clk: in std_logic;
				output: out std_logic_vector(15 downto 0));
	end component T_reg;

	
	component mux_2_1  is
	  port (I0 ,I1: in std_logic_vector(15 downto 0);
			  S0: in std_logic;
			  mux_out: out std_logic_vector(15 downto 0));
	end component mux_2_1;
		
	-- These signals dictate which registers are allowed to be written
	signal e0, e1, e2, e3, e4, e5, e6,  e7, e_actual_PC, PC_enabler: std_logic;
	-- These signals carry the output from each register
	signal r0, r1, r2, r3, r4, r5, r6, r7, PC_actual_input, PC_real_input, r0_ideal: std_logic_vector(15 downto 0);
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

	PC_input_MUX: component mux_2_1
		port map(D3, PC_in, PC_enable, PC_actual_input);
	
	reset_MUX: component mux_2_1
		port map(PC_actual_input, "0000000000000000", reset, PC_real_input); -- real >> actual

--	e_PC_MUX: component mux_2_1
--		port map(e0, PC_WR, PC_WR, e_actual_PC);
	
	e_actual_PC <= (e0) or (PC_enable);
	PC_enabler <=e_actual_PC or reset;
	
	-- Initialise the registers
	reg0: T_reg port map (input => PC_real_input, w_enable => PC_enabler, clk => clk, output => r0_ideal);
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
			if(PC_enable = '1' and (not A3 = "000")) then 
				r0 <= PC_in;
			else
				r0 <= r0_ideal;
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
	port (input: in std_logic_vector(5 downto 0);
			output: out std_logic_vector(15 downto 0));
end entity signed_extender;

architecture ext of signed_extender is
begin
	conv_process: process(input)
	begin
		if (input(5) = '0') then
			output <= "0000000000" & input;
		else 
			output <= "1111111111" & input;
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
				EX_c, EX_z: in std_logic;
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
				MA_c, MA_z: out std_logic;
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
	signal c_s, z_s: std_logic :='0';
	signal opcode_p: std_logic_vector(5 downto 0) := "000000";
    signal instr_11_9_p, enc_addr_p: std_logic_vector(2 downto 0) := "000";
    signal PC2_p, E9_output_p, D2_output_p, ALU_output_p: std_logic_vector(15 downto 0) := "0000000000000000";
    signal MA_st_p: std_logic_vector(3 downto 0) := "0000";
    signal WB_st_p: std_logic_vector(1 downto 0) := "00";
    signal RF_WR_p: std_logic := '0';
	signal c_p, z_p: std_logic :='0';
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
		MA_z<= z_s;
		MA_c <= c_s;

    edit_process: process(clk, EX2MA_WR, reset_wr) is
    begin
        if(falling_edge(clk) and EX2MA_WR = '1') then
            opcode_s <= opcode_p;
            instr_11_9_s <= instr_11_9_p;
            E9_output_s <= E9_output_p;
            ALU_output_s <= ALU_output_p;
            D2_output_s <= D2_output_p;
            enc_addr_s <= enc_addr_p;
            PC2_s <= PC2_p;
            MA_st_s <= MA_st_p;
            WB_st_s <= WB_st_p;
            RF_WR_s <= RF_WR_p;
			c_s <= c_p;
			z_s <= z_p;
		end if;
		if(rising_edge(clk) and EX2MA_WR='1') then
			opcode_p <= opcode_in;
            instr_11_9_p <= instr_11_9_in;
            E9_output_p <= E9_output_in;
            ALU_output_p <= ALU_output_in;
            D2_output_p <= D2_output_in;
            enc_addr_p <= enc_addr_in;
            PC2_p <= PC2_in;
            MA_st_p<= MA_st_in;
            WB_st_p <= WB_st_in;
            RF_WR_p <= RF_WR_in;
				c_p <= EX_c;
				z_p <= EX_z;
		end if;
		if (reset_wr = '1') then
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
            ID_alpha : in std_logic;
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
            OR_alpha : out std_logic;
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
    signal alpha_s: std_logic := '0';
	signal reset_wr_s: std_logic := '1';
	signal opcode_p, instr_5_0_p: std_logic_vector(5 downto 0) := "000000";
    signal instr_11_9_p, instr_8_6_p, instr_5_3_p, instr_2_0_p, enc_addr_p, OR_st_p: std_logic_vector(2 downto 0) := "000";
    signal instr_8_0_p: std_logic_vector(8 downto 0) := "000000000";
    signal enc_input_p: std_logic_vector(7 downto 0) := "00000000";
    signal LS6_p, LS9_p, PC_p, PC2_p: std_logic_vector(15 downto 0) := "0000000000000000";
    signal EX_st_p: std_logic_vector(10 downto 0) := "00000000000";
    signal MA_st_p: std_logic_vector(3 downto 0) := "0000";
    signal WB_st_p: std_logic_vector(1 downto 0) := "00";
    signal RF_WR_p: std_logic := '0';
    signal alpha_p: std_logic := '0';
	signal reset_wr_p: std_logic := '1';
	
component alpha is
	port (
			input, clk: in std_logic;
			output: out std_logic);
end component alpha;
	
begin
	reset_wr_latch: component alpha
		port map(reset_wr, clk, reset_wr_s);
    opcode_out <= opcode_s;
    instr_11_9_out <= instr_11_9_s;
    instr_8_6_out <= instr_8_6_s;
    instr_5_3_out <= instr_5_3_s;
	 instr_2_0_out <= instr_2_0_s;
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
    OR_alpha <= alpha_s;
    edit_process: process(clk, ID2OR_WR, reset_wr, reset_wr_s) is
    begin
        if(rising_edge(clk) and ID2OR_WR = '1') then
            opcode_p <= opcode_in;
            instr_11_9_p <= instr_11_9_in;
            instr_8_6_p <= instr_8_6_in;
            instr_5_3_p <= instr_5_3_in;
				instr_2_0_p <= instr_2_0_in;
            instr_5_0_p <= instr_5_0_in;
            instr_8_0_p <= instr_8_0_in;
            enc_addr_p <= enc_addr_in;
            enc_input_p <= enc_input_in;
            LS6_p <= LS6_in;
            LS9_p <= LS9_in;
            PC_p <= PC_in;
            PC2_p <= PC2_in;
            OR_st_p <= OR_st_in;
            EX_st_p <= EX_st_in;
            MA_st_p <= MA_st_in;
            WB_st_p <= WB_st_in;
            RF_WR_p <= RF_WR_in;
            alpha_p <= ID_alpha;
		end if;
		if(falling_edge(clk) and ID2OR_WR = '1') then
            opcode_s <= opcode_p;
            instr_11_9_s <= instr_11_9_p;
            instr_8_6_s <= instr_8_6_p;
            instr_5_3_s <= instr_5_3_p;
				instr_2_0_s <= instr_2_0_p;
            instr_5_0_s <= instr_5_0_p;
            instr_8_0_s <= instr_8_0_p;
            enc_addr_s <= enc_addr_p;
            enc_input_s <= enc_input_p;
            LS6_s <= LS6_p;
            LS9_s <= LS9_p;
            PC_s <= PC_p;
            PC2_s <= PC2_p;
            OR_st_s <= OR_st_p;
            EX_st_s <= EX_st_p;
            MA_st_s <= MA_st_p;
            WB_st_s <= WB_st_p;
            RF_WR_s <= RF_WR_p;
            alpha_s <= alpha_p;

		end if;
		if (reset_wr_s = '1') then
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
--            EX_c, EX_z: in std_logic;
            RF_WR_in: in std_logic;
            ---------------------------------outputs
            opcode_out: out std_logic_vector(5 downto 0);
            correct_rf_addr : out std_logic_vector(2 downto 0);
            MEM_output_out: out std_logic_vector(15 downto 0);
            E9_output_out: out std_logic_vector(15 downto 0);
            enc_addr_out : out std_logic_vector(2 downto 0); -- output from custom encoder
            PC2_out : out std_logic_vector(15 downto 0);
            WB_st_out : out std_logic_vector(1 downto 0); -- WB_MUX_1, WB_MUX_0
--            MA_c, MA_z: out std_logic;
            RF_WR_out: out std_logic
    );
end entity MA2WBreg;

architecture bhv5 of MA2WBreg is
	signal opcode_s: std_logic_vector(5 downto 0) := "000000";
    signal instr_11_9_s, enc_addr_s: std_logic_vector(2 downto 0) := "000";
    signal PC2_s, E9_output_s, MEM_output_s: std_logic_vector(15 downto 0) := "0000000000000000";
    signal WB_st_s: std_logic_vector(1 downto 0) := "00";
    signal RF_WR_S: std_logic := '0';
--    signal c_s, z_s: std_logic := '0';
	 signal opcode_p: std_logic_vector(5 downto 0) := "000000";
    signal instr_11_9_p, enc_addr_p: std_logic_vector(2 downto 0) := "000";
    signal PC2_p, E9_output_p, MEM_output_p: std_logic_vector(15 downto 0) := "0000000000000000";
    signal WB_st_p: std_logic_vector(1 downto 0) := "00";
    signal RF_WR_p: std_logic := '0';
--    signal c_p, z_p: std_logic := '0';
begin

    opcode_out <= opcode_s;
    correct_rf_addr <= instr_11_9_s;
    E9_output_out <= E9_output_s;
    MEM_output_out <= MEM_output_s;
    PC2_out <= PC2_s;
    WB_st_out <= WB_st_s;
    RF_WR_out <= RF_WR_s;
	 enc_addr_out <= enc_addr_s;
--    MA_c<= c_s;
--    MA_z <= z_s;
    edit_process: process(clk, MA2WB_WR, reset_wr) is
    begin
		
        if(falling_edge(clk) and MA2WB_WR = '1') then
            opcode_s <= opcode_p;
            instr_11_9_s <= instr_11_9_p;
            E9_output_s <= E9_output_p;
            MEM_output_s <= MEM_output_p;
            enc_addr_s <= enc_addr_p;
            PC2_s <= PC2_p;
            WB_st_s <= WB_st_p;
            RF_WR_s <= RF_WR_p;
--            c_s<=EX_c;
--            z_s<=EX_z;
		end if;
		if(rising_edge(clk) and MA2WB_WR = '1') then
            opcode_p <= opcode_in;
            instr_11_9_p <= instr_11_9_in;
            E9_output_p <= E9_output_in;
            MEM_output_p <= MEM_output_in;
            enc_addr_p <= enc_addr_in;
            PC2_p <= PC2_in;
            WB_st_p <= WB_st_in;
            RF_WR_p <= RF_WR_in;
--            c_s<=EX_c;
--            z_s<=EX_z;
		end if;
		if (falling_edge(clk) and reset_wr = '1') then
            RF_WR_s <= '0';
        end if;
--		if(opcode_s = "011000" or opcode_s = "011001" or opcode_s = "011010" or opcode_s = "011011") then --If it is LM/SM, then we go for the encoder wala A3
--			correct_rf_addr<=enc_addr_s;
--		else
--			correct_rf_addr<=instr_11_9_s;
--		end if;
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
            --c, z: in std_logic;
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
            --EX_c, EX_z : out std_logic;
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
    signal reset_wr_s: std_logic := '1';
	 signal opcode_p: std_logic_vector(5 downto 0) := "000000";
    signal instr_11_9_p, enc_addr_p: std_logic_vector(2 downto 0) := "000";
    signal LS6_p, LS9_p, PC_p, PC2_p, E9_output_p, SE6_output_p, D1_output_p, D2_output_p: std_logic_vector(15 downto 0) := "0000000000000000";
    signal EX_st_p: std_logic_vector(10 downto 0) := "00000000000";
    signal MA_st_p: std_logic_vector(3 downto 0) := "0000";
    signal WB_st_p: std_logic_vector(1 downto 0) := "00";
    signal RF_WR_p: std_logic := '0';
    signal reset_wr_p: std_logic := '1';
component alpha is
	port (
			input, clk: in std_logic;
			output: out std_logic);
end component alpha;
	
	
begin
	reset_wr_latch: component alpha
		port map(reset_wr, clk, reset_wr_s);
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
    --EX_c<= c_s;
    --EX_z <= z_s;
    edit_process: process(clk, OR2EX_WR, reset_wr, reset_wr_s) is
    begin
        if(falling_edge(clk) and OR2EX_WR = '1') then
            opcode_s <= opcode_p;
            instr_11_9_s <= instr_11_9_p;
            E9_output_s <= E9_output_p;
            SE6_output_s <= SE6_output_p;
            D1_output_s <= D1_output_p;
            D2_output_s <= D2_output_p;
            enc_addr_s <= enc_addr_p;
            LS6_s <= LS6_p;
            LS9_s <= LS9_p;
            PC_s <= PC_p;
            PC2_s <= PC2_p;
            EX_st_s <= EX_st_p;
            MA_st_s <= MA_st_p;
            WB_st_s <= WB_st_p;
            RF_WR_s <= RF_WR_p;
            --c_s<=c;
            --z_s<=z;
		end if;
		if(rising_edge(clk) and OR2EX_WR = '1') then
            opcode_p <= opcode_in;
            instr_11_9_p <= instr_11_9_in;
            E9_output_p <= E9_output_in;
            SE6_output_p <= SE6_output_in;
            D1_output_p <= D1_output_in;
            D2_output_p <= D2_output_in;
            enc_addr_p <= enc_addr_in;
            LS6_p <= LS6_in;
            LS9_p <= LS9_in;
            PC_p <= PC_in;
            PC2_p <= PC2_in;
            EX_st_p <= EX_st_in;
            MA_st_p <= MA_st_in;
            WB_st_p <= WB_st_in;
            RF_WR_p <= RF_WR_in;
            --c_s<=c;
            --z_s<=z;
		end if;
		if (reset_wr_s = '1') then
            MA_st_s(2) <= '0'; --DATA_MEM_WR
            RF_WR_s <= '0';
        end if; 
    end process edit_process;
end architecture bhv3;