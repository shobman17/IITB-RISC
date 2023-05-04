library ieee;
use ieee.std_logic_1164.all;

library work;
use work.Components.all;
use work.Gates.all;


entity DataPath is
	port(clk, reset: in std_logic);
end entity Datapath;

architecture trivial of DataPath is
	
	for all: mux_2_1
		use entity work.mux_2_1(bbD1);
	
	for all: CZreg
		use entity work.CZreg(bhv);
	
	for all: PC
		use entity work.PC(update);
	
	for all: alpha
		use entity work.alpha(update);
		
	for all: mux51
		use entity work.mux51(Structer5);
		
	for all: mux_4_1
		use entity work.mux_4_1(Structer4);
		
	for all: Memory_Data
		use entity work.Memory_Data(memorykakaam);
		
	for all: Memory_Code
		use entity work.Memory_Code(memorykakaam);
	
	for all: bbD1
		use entity work.bbD1(blackboxed);
		
	for all: bbD2
		use entity work.bbD2(blackboxed2);
		
	for all: bb_cwr_zwr
		use entity work.bb_cwr_zwr(blackboxed3);
		
	for all: bb_branching
		use entity work.bb_branching(blackboxed4);
		
	for all: pc_mux
		use entity work.pc_mux(blackboxed5);
		
	for all: Lshifter6
		use entity work.Leftshifter(yes);
	
	for all: Leftshifter9
		use entity work.Leftshifter9(yes);
		
	for all: extender_nine
		use entity work.extender_nine(major_extending);
		
	for all: subtractor
		use entity work.subtractor(sub);
		
	for all: custom_encoder
		use entity work.custom_encoder(enc);
		
	for all: ADDER
		use entity work.ADDER(add);
		
	for all: LShifter9
		use entity work.LShifter9(multiply_by_two);
		
	for all: LShifter6
		use entity work.LShifter6(multiply_by_two);
		
	for all: ALU
		use entity work.ALU(addnand);
		
	for all: IF2IDreg
		use entity work.IF2IDreg(bhv1);
		
	for all: controller
		use entity work.controller(dictator);
	
	for all: reverse_decoder_3to8
		use entity work.reverse_decoder_3to8(dec);
	
	for all: signed_extender
		use entity work.signed_extender(ext);
	
	for all: prog_reg
		use entity work.prog_reg(pr);
		
	for all: EX2MAreg
		use entity work.EX2MAreg(bhv4);
	
	for all: ID2ORreg
		use entity work.ID2ORreg(bhv2);
	
	for all: MA2WBreg
		use entity work.MA2WBreg(bhv5);
	
	for all: OR2EXreg
		use entity work.OR2EXreg(bhv3);
	
	signal IF_IM_in, EX_IM_in, update_PC, IF_IM_out, EX_D1_MUX_out, EX_adder2_out, IF_BP_pred, IF_adder1_out, OR_adder1_out, EX_adder1_out,  MA_adder1_out, WB_adder1_out : std_logic_vector(15 downto 0):=(others=>'0');
	signal clk, PC_WR, BP_control, PC_MUX_branch, hb_in, BR_WR: std_logic;
	signal Mem_D1, OR_E9out, EX_E9out, MA_E9out, WB_E9out, WB_default, MA_out, Mem_D1, OR_SE6out, MA_SE6out, EX_D2_MUX_out : std_logic_vector(15 downto 0);
	signal ID_8_0, ID_LS9out, OR_LS9out, EX_LS9out : std_logic_vector(8 downto 0);
	signal ID_5_0, ID_LS6out, OR_LS6out, EX_LS6out : std_logic_vector(5 downto 0);
	signal ID_11_9, OR_11_9, ID_encoded, OR_encoded, A1_in, A2_in: std_logic_vector(2 downto 0);
	signal ID_8_6, OR_8_6 : std_logic_vector(2 downto 0);
	signal ID_5_3, OR_5_3 : std_logic_vector(2 downto 0);
	signal ID_2_0, OR_2_0, ID_encoded, OR_encoded: std_logic(2 downto 0);
	signal updated_imm, subtractor_out, subtractor_in: std_logic_vector(7 downto 0);
	signal alu_ain, alu_bin, adder2_ain, adder2_bin : std_logic_vector(15 downto 0);
	signal RF_writeback, EX_ALU_out, MA_ALU_out : std_logic_vector(15 downto 0);
	signal c_o, z_o, alu_carry, EX_c : std_logic;
	signal D1, D2, OR_D1_MUX_OUT, OR_D2_MUX_OUT : std_logic_vector(15 downto 0);
	signal out_IF, out_EXE: std_logic_vector(15 downto 0);
	signal branch: std_logic;

	signal IF2ID_WR: std_logic;

	signal ID_IM_out, ID_IM_in, OR_IM_in, EX_IM_in, IF_IM_in, ID_adder1_out: std_logic_vector(15 downto 0):=(others=>'0');	
	signal if2id_wr_and_a, singular_one, alpha_update, n_alpha_update, ID_alpha, OR_alpha, if_LMSM: std_logic;
    
	--signal alu_a, alu_b, alu_out, s1_0, s1_10, s2_0, s2_1, s3_0, s3_1, s4_0, s4_1, s5_0, s5_1, d1, d2, d3, e8_out, se6_out, L7_out, m_a, m_in, m_out: std_logic_vector(15 downto 0):=(others=>'0');
--	signal a1, a2, a3, s6_0, s6_1, s1_7, s1_6, s1_5, enc_out: std_logic_vector(2 downto 0):=(others=>'0');
--	signal alu_ctrl: std_logic_vector(1 downto 0);
--	signal s1_1: std_logic_vector(8 downto 0);
--	signal s1_2: std_logic_vector(5 downto 0);
--	signal s1_3, dec_out: std_logic_vector(7 downto 0);
--	signal s1_4:std_logic_vector(3 downto 0):=(others=>'0');
--	signal t1_wr, t2_wr, t3_wr, t4_wr, t5_wr, t6_wr, m_rd, m_wr, r_wr, c_en, z_en, c_in, c_out, z_in, z_out, s1_8, s1_9: std_logic;
	signal EX_opcode: std_logic_vector(5 downto 0):=(others=>'0');
	signal A3_mux_select, bb_reset_all_zero: std_logic_vector;

	begin

		PC_WR_AND: component AND_2
			port map(bb_PC_wr_suggestion, singular_one, PC_WR);
		
		InstructionMemory: component Memory_Code
			port map(clk, IF_IM_in, IF_IM_out);
			
		PC_MUX: component pc_mux
			port map(IF_adder1_out, EX_D1_MUX_out, EX_adder2_out, out_IF, out_EXE, EX_opcode, branch, bb_reset_wr, update_PC);
		
		BranchPredictor: component branch_predictor
			port map(IF_IM_in, EX_IM_in, EX_adder2_out, EX_adder1_out, EX_opcode, hb_in, out_IF, out_EXE, branch, bb_reset_wr);
		--Fuck bhai ye kya banaya hai
		-- in_IF, in_EXE, in_pred, in_EXE2: in std_logic_vector(15 downto 0); --in_IF is for reading prediction. in_EXE and in_pred are for writing a prediction
		-- opcode_IF, opcode_EXE: in std_logic_vector(5 downto 0);
		-- hb_in: in std_logic; -- input for history bit to write to this table
		-- out_IF, out_EXE: out std_logic_vector(15 downto 0); -- prediction output or correction to branch
		-- branch: out std_logic; -- whether to branch or not
		-- reset_wr: out std_logic); -- whether prediction was wrong or not

		adder1: component ADDER
			port map(IF_IM_in, "0000000000000010", IF_adder1_out);
		
		n_alpha_update <= not(alpha_update);
		IF2ID: component IF2IDreg
			port map(clk, n_alpha_update, IF_IM_out, IF_IM_in, IF_adder1_out, ID_IM_out, ID_IM_in, ID_adder1_out);
			
		alpha_0: component alpha
			port map(alpha_update, clk, ID_alpha);
			
		alpha_XOR: component XOR_2
			port map(singular_one, if_LMSM, alpha_update);
		
		Decoded_MUX: component  mux_2_1
			port map(ID_7_0, subtractor_out, ID_alpha, updated_imm);
			
		customencoder: component custom_encoder
			port map(updated_imm, ID_encoded, singular_one, all_zeros);
			
		decoder: component controller
			port map(ID_IM_out, ID_alpha, ID_opcode, ID_11_9, ID_8_6, ID_5_3, ID_2_0, ID_7_0, ID_8_0, ID_5_0, if_LMSM, lol_ignore_this_signal, ID_control_signals_OR, ID_control_signals_EX, ID_control_signals_MA, ID_control_signals_WB);
		
		lshift6: component LShifter6
			port map(ID_5_0, ID_LS6out);
			
		lshift9: component LShifter9
			port map(ID_8_0, ID_LS9out);
		
		mux_rf_a1: component mux_2_1
			port map(OR_8_6, OR_encoded, OR_controls(1), A1_in);
			
		mux_rf_a2: component mux_2_1
			port map(OR_5_3, OR_11_9, OR_controls(2), A2_in);
		
		reg_file: component prog_reg
			port map(A1_in, A2_in, A3, D1, D2, RF_writeback, update_PC, IF_IM_in, PC_WR, clk, WB_RF_WR, reset);
			
		subtractor0: component subtractor
			port map(subtractor_in, subtractor_out);
		
		D1BlackBox: component bbD1
			port map(A1_in, EX_11_9, MA_11_9, A3, EX_RF_WR, MA_RF_WR, RF_writeback, OR_controls(1), mux_rf_d1_1, mux_rf_d1_0);
			
		D2BlackBox: component bbD2
			port map(A2_in, EX_11_9, MA_11_9, A3, EX_RF_WR, MA_RF_WR, RF_writeback, OR_alpha, OR_controls(2), mux_rf_d2_1, mux_rf_d2_0);
		
		RF_D1_Mux: component mux_4_1
			port map(D1, EX_ALU_out, MA_out, RF_writeback, mux_rf_d1_1, mux_rf_d1_0, OR_D1_MUX_OUT);
		
		RF_D2_Mux: component mux_4_1
			port map(D2,EX_ALU_out, MA_out, RF_writeback, mux_rf_d2_1, mux_rf_d2_0, OR_D2_MUX_OUT);
		
		extender9: component extender_nine
			port map(OR_8_0, OR_E9out);
			
		sextender6: component signed_extender
			port map(OR_5_0, OR_SE6out);
			
		DataMemory: component Memory_Data	
			port map(clk, MA_controls(1), MA_controls(2), MA_ALU_out, Mem_D3_in, Mem_D1);
		
		mux_alu_a: component mux_4_1
			port map(EX_D1_MUX_out, "0000000000000000", "0000000000000010", "0000000000000010", EX_controls(2), EX_controls(1), alu_ain);
		
		mux_alu_b: component mux_2_1
			port map(EX_D2_MUX_out, EX_SE6out, EX_controls(3), alu_bin);
			
		mux_alu_carry: component mux_4_1
			port map('0', EX_c, EX_c, '1', EX_controls(4), EX_controls(5), alu_carry);
		
		alu_comp: component alu
			port map(alu_ain, alu_bin, EX_controls(6), EX_controls(7), alu_carry, alu_out, z_o, c_o);
			
		CZFlags: component CZreg
			port map(c_o, z_o, clk, c_wr, z_wr, EX_c, EX_z);
			
		mux_adder_A: component mux_2_1
			port map(EX_D2_MUX_out, EX_IM_in, EX_controls(8), adder2_ain);
			
		mux_adder_B: component mux_4_1
			port map("0000000000000000", EX_LS9out, EX_LS9out, EX_LS6out, EX_controls(10), EX_controls(9), adder2_bin);
			
		adder2: component ADDER
			port map(adder2_ain, adder2_bin, EX_adder2_out);
			
		CZBlackBox: component bb_cwr_zwr
			port map(EX_RF_WR, MA_c, MA_z, EX_opcode, c_wr, z_wr, ex_rf_wr_and_a);
			
		BranchingBlackBox: component bb_branching
			port map(c_o, z_o, EX_opcode, hb_in);

		A3_mux_select <= (not WB_opcode(5)) and WB_opcode(4) and WB_opcode(3) and (not WB_opcode(2));
			
		A3_MUX: component mux_2_1
			port map(WB_11_9, WB_encoded, A3_mux_select, A3);

		bb_reset_all_zero <= bb_reset_wr or all_zeros;

		ID2OR_reset_WR_OR: component OR_2
			port map(reset, bb_reset_all_zero, ID2OR_reset_WR);

		OR2EX_reset_WR_OR: component OR_2
			port map(reset, bb_reset_wr, OR2EX_reset_WR);
		
		Mem_out_MUX: component mux_2_1
			port map(MA_ALU_out, Mem_D1, MA_controls(3), MA_out);
			
		WB_MUX: component mux_4_1
			port map(WB_default, WB_default, WB_adder1_out, WB_E9out, WB_MUX(1), WB_MUX(0), RF_writeback);
			
		ID2OR: component ID2ORreg
			port map(clk, '1', ID2OR_reset_WR, ID_opcode, ID_11_9, ID_8_6, ID_5_3, ID_2_0, ID_5_0, ID_8_0, ID_encoded, updated_imm, ID_LS6out, ID_LS9out, ID_IM_in, ID_adder1_out, ID_control_signals_OR, ID_control_signals_EX, ID_control_signals_MA, ID_control_signals_WB, ID_alpha, ID_RF_WR, 
			 OR_opcode, OR_11_9, OR_8_6, OR_5_3, OR_5_0, OR_8_0, OR_encoded, subtractor_in, OR_LS6out, OR_LS9out, OR_IM_in, OR_adder1_out, OR_controls, OR_control_signals_EX, OR_control_signals_MA, OR_control_signals_WB, OR_alpha, OR_RF_WR);
			 
		OR2EX: component OR2EXreg
			port map(clk, '1', OR2EX_reset_WR, OR_opcode, OR_11_9, OR_E9out, OR_SE6out, OR_D1_MUX_OUT, OR_D2_MUX_OUT, OR_encoded, OR_LS6out, OR_LS9out, OR_IM_in, OR_adder1_out, OR_control_signals_EX, OR_control_signals_MA, OR_control_signals_WB, OR_RF_WR, 
			EX_opcode, EX_E9out, EX_11_9, EX_SE6out, EX_D1_MUX_out, EX_D2_MUX_out, EX_encoded, EX_LS6out, EX_LS9out, EX_IM_in, EX_adder1_out, EX_controls, EX_control_signals_MA, EX_control_signals_WB, EX_RF_WR);
			
		EX2MA: component EX2MAreg
			port map(clk, '1', reset, EX_opcode, EX_11_9, EX_E9out, EX_ALU_out, EX_D2_MUX_out, EX_encoded, EX_adder1_out, EX_control_signals_MA, EX_control_signals_WB, EX_c, EX_z, ex_rf_wr_and_a,
				MA_opcode, MA_11_9, MA_E9out, MA_ALU_out, Mem_D3_in, MA_encoded, MA_adder1_out, MA_controls, MA_control_signals_WB, MA_c, MA_z, MA_RF_WR);

		MA2WB: component MA2WBreg
			port map(clk, '1', reset, MA_opcode, MA_11_9, MA_out, MA_E9out, MA_encoded, MA_adder1_out, MA_control_signals_WB, MA_RF_WR,
			 WB_opcode, WB_11_9, WB_default, WB_E9out, WB_encoded, WB_adder1_out, WB_MUX, WB_RF_WR);

end architecture trivial;