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
		
	for all: bb_pc_mux
		use entity work.bb_pc_mux(blackboxed5);
		
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
	
	signal IF_IM_in, update_PC, IF_IM_out, ID_IM_in, EX_D1_MUX_out, EX_adder2_out, Prediction, IF_adder1_out, ID_adder1_out, OR_adder1_out, MA_adder1_out, WB_adder1_out, : std_logic_vector(15 downto 0):=(others=>'0');
	signal clk, PC_WR, BP_control: std_logic;
--	signal alu_a, alu_b, alu_out, s1_0, s1_10, s2_0, s2_1, s3_0, s3_1, s4_0, s4_1, s5_0, s5_1, d1, d2, d3, e8_out, se6_out, L7_out, m_a, m_in, m_out: std_logic_vector(15 downto 0):=(others=>'0');
--	signal a1, a2, a3, s6_0, s6_1, s1_7, s1_6, s1_5, enc_out: std_logic_vector(2 downto 0):=(others=>'0');
--	signal alu_ctrl: std_logic_vector(1 downto 0);
--	signal s1_1: std_logic_vector(8 downto 0);
--	signal s1_2: std_logic_vector(5 downto 0);
--	signal s1_3, dec_out: std_logic_vector(7 downto 0);
--	signal s1_4:std_logic_vector(3 downto 0):=(others=>'0');
--	signal t1_wr, t2_wr, t3_wr, t4_wr, t5_wr, t6_wr, m_rd, m_wr, r_wr, c_en, z_en, c_in, c_out, z_in, z_out, s1_8, s1_9: std_logic;
	
	begin
		--How many t_regs do we need? 5. The first one is a bit special though
		PCyes: component PC
			port map(update_PC, clk, PC_WR, IM_in_s);
		
		InstructionMemory: component Memory_Code
			port map(clk, IF_IM_in, IF_IM_out);
			
		PC_MUX_Blackbox: component bb_pu_mux
			port map(pc_mux_branch, BP_control, EX_opcode, PC_mux_ctrl);
			
		PC_MUX: component mux_4_1
			port map(IF_adder1_out, EX_adder2_out, EX_D1_MUX_out, Prediction, PC_mux_ctrl(1), PC_mux_ctrl(0), update_PC);
			
		BranchPredictor: component branch_predictor
			port map(IF_IM_in, EX_IM_in, update_PC, BR_WR, hb_in, Prediction, BP_control);

		adder1: component ADDER
			port map(IF_IM_in, "0000000000000010", IF_adder1_out);
		
		IF2ID: component IF2IDreg
			port map(clk, IF2ID_WR, IF_IM_out, IF_IM_in, IF_adder1_out, ID_IM_out, ID_IM_in, ID_adder1_out);
			
		IF2ID_AND: component AND_2
			port map(if2id_wr_and_a, not singular_one, IF2ID_WR);
			
		alpha_0: component alpha
			port map(alpha_update, clk, ID_alpha);
			
		alpha_XOR: component XOR_2
			port map(singular_one, if_LMSM, alpha_update);
		
		Decoded_MUX: component mux_2_1
			port map(ID_7_0, subtractor_out, ID_alpha, updated_imm);
			
		customencoder: component custom_encoder
			port map(updated_imm, ID_encoded, singular_one, all_zeros);
			
		decoder: component controller
			port map(ID_IM_out, ID_alpha, ID_opcode, ID_11_9, ID_8_6, ID_5_3, ID_2_0, ID_7_0, ID_8_0, ID_5_0, if_LMSM, ID_st, OR_st, EX_st, MA_st, WB_st);
		
		lshift6: component LShifter6
			port map(ID_5_0, ID_LS6out);
			
		lshift9: component LShifter9
			port map(ID_8_0, ID_LS9out);
		
		mux_rf_a1: component mux_2_1
			port map(OR_8_6, OR_encoded, MUX_RF_A1, A1_in);
			
		mux_rf_a2: component mux_2_1
			port map(OR_5_3, OR_11_9, MUX_RF_A2, A2_in);
		
		reg_file: component prog_reg
			port map(A1_in, A2_in, A3, D1, D2, RF_writeback, clk, RF_WR);
			
		subtractor0: component subtractor
			port map(subtractor_in, subtractor_out);
		
		D1BlackBox: component bbD1
			port map(A1_in, or2ex_a3, ex2ma_a3, ma2wb_a3, or2ex_rf_wr, ex2ma_rf_wr, ma2wb_rf_wr, id2or_mux_alu_a, mux_rf_d1_1, mux_rf_d1_0);
			
		D2BlackBox: component bbD2
			port map(A2_in, or2ex_a3, ex2ma_a3, ma2wb_a3, or2ex_rf_wr, ex2ma_rf_wr, ma2wb_rf_wr, OR_alpha, id2or_mux_alu_b,	mux_rf_d2_1, mux_rf_d2_0);
		
		RF_D1_Mux: component mux_4_1
			port map(D1, EX_ALU_out, MA_out, RF_writeback, mux_rf_d1_1, mux_rf_d1_0);
		
		RF_D2_Mux: component mux_4_1
			port map(D2,EX_ALU_out, MA_out, RF_writeback, mux_rf_d2_1, mux_rf_d2_0);
		
		extender9: component extender_nine
			port map(OR_8_6, OR_5_3, OR_2_0, OR_E9out);
			
		sextender6: component signed_extender
			port map(OR_5_3, OR_2_0, OR_SE6out);
			
		DataMemory: component Memory_Data	
			port map(clk, m_wr, m_rd, MA_ALU_out, Mem_D3_in, Mem_D1);
		
		mux_alu_a: component mux_4_1
			port map(EX_D1_MUX_out, "0000000000000000", "0000000000000010", "0000000000000010", mux_alu_a_1, mux_alu_a_0, alu_ain);
		
		mux_alu_b: component mux_2_1
			port map(EX_D2_MUX_out, MA_SE6out, mux_alu_b, alu_bin);
			
		mux_alu_carry: component mux_4_1
			port map('0', EX_c, EX_c, '1', alu_carry_1, alu_carry_0, alu_carry);
		
		alu_comp: component alu
			port map(alu_ain, alu_bin, alu_op, alu_comp, alu_carry, alu_out, z_o, c_o);
			
		CZFlags: component CZreg
			port map(c_o, z_o, clk, c_wr, z_wr, EX_c, EX_z);
			
		mux_adder_A: component mux_2_1
			port map(EX_D2_MUX_out, EX_IM_in, MUX_ADDER_A, adder2_ain);
			
		mux_adder_B: component mux_4_1
			port map("0000000000000000", EX_LS9out, EX_LS9out, EX_LS6out,MUX_ADDER_B_1, MUX_ADDER_B_0, adder2_bin);
			
		adder2: component ADDER
			port map(adder2_ain, adder2_bin, EX_adder2_out);
			
		CZBlackBox: component bb_cwr_zwr
			port map(EX_RF_WR, ,ex2ma_c, ex2ma_z, EX_opcode, c_wr, z_wr, ex_rf_wr_and_a);
			
		BranchingBlackBox: component bb_branching
			port map(c_o, z_o, EX_opcode, pc_mux_branch, if2id_wr_and_a, id2or_reset_all_wr, or2ex_reset_all_wr);
		
		Mem_out_MUX: component mux_2_1
			port map(MA_ALU_out, Mem_D1, MUX_MEM_OUT, MA_out);
			
		WB_MUX: component mux_4_1
			port map(WB_default, WB_default, WB_adder1_out, WB_E9out, WB_MUX_1, WB_MUX_1, RF_writeback);
			
		ID2OR: component ID2ORreg
			port map(clk, '1', reset, ID_opcode, ID_11_9, ID_8_6, ID_5_3, ID_2_0, ID_5_0, ID_8_0, ID_encoded, updated_imm, ID_LS6out, ID_LS9out, ID_IM_in, ID_adder1_out, OR_st, EX_st, MA_st, WB_st, ID_RF_veto, );
			
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
			
		OR2EX: component OR2EXreg
			port map();
		
		EX2MA: component EX2MAreg
			port map();
		
		MA2WB: component MA2WBreg
			port map();
			
		
end entity CZreg;
			
		only_process: process(state)-- don't know for sure what exactly should be in the static sensitivity list
		begin
			alu_a<=(others=>'0');
			alu_b<=(others=>'0');
			s1_0<=(others=>'0');
			s2_0<=(others=>'0');
			s3_0<=(others=>'0');
			s4_0<=(others=>'0');
			s5_0<=(others=>'0');
			d3<=(others=>'0');
			m_a<=(others=>'0');
			m_in<=(others=>'0');
			a1<=(others=>'0');
			a2<=(others=>'0');
			a3<=(others=>'0');
			s6_0<=(others=>'0');
			alu_ctrl<=(others=>'0');
			
			case state is
				when state1 =>
					--Data Flow
					a1<="111";
					m_a<=d1;
					alu_a<=d1;
					s5_0<= d1;
					s1_0<=m_out;
					alu_b<="0000000000000001";
					d3<=alu_out;
					a3<="111";
					
					--Control Signals
					r_wr<='1';
					m_wr<='0';
					m_rd<='1';
					t1_wr<='1';
					t2_wr<='0';
					t3_wr<='0';
					t4_wr<='0';
					t5_wr<='1';
					t6_wr<='0';
					z_en<='0';
					c_en<='0';
					alu_ctrl<="00";

				when state2 =>
					--Data Flow
					a1<=s1_5;
					a2<=s1_6;
					s2_0<=d1;
					s3_0<=d2;
					s6_0<=s1_7;
					
					--Control Signals
					r_wr<='0';
					m_wr<='0';
					m_rd<='0';
					t1_wr<='0';
					t2_wr<='1';
					t3_wr<='1';
					t4_wr<='0';
					t5_wr<='0';
					t6_wr<='1';
					z_en<='0';
					c_en<='0';
					alu_ctrl<="00";
					
				when state3 =>
					--Data Flow
					alu_a<=s2_1;
					alu_b<=s3_1;
					s4_0<=alu_out;
					--aluz, aluc are implicit
					
					--Control Signal
					r_wr<='0';
					m_wr<='0';
					m_rd<='0';
					t1_wr<='0';
					t2_wr<='0';
					t3_wr<='0';
					t4_wr<='1';
					t5_wr<='0';
					t6_wr<='0';
					z_en<=(not s1_4(3)) and (not s1_4(2)) and (not(s1_4(1) and s1_4(0)));
					c_en<=(not s1_4(3)) and (not s1_4(2)) and (not s1_4(1));
					alu_ctrl<=(1=>s1_4(3) and s1_4(2), 0=>((not s1_4(3)) and (not s1_4(2)) and s1_4(1) and (not s1_4(0))) or (s1_4(3) and s1_4(2)));
					
				when state4 =>
					--Data Flow
					d3<=s4_1;
					a3<=s6_1;
					
					--Control Signals
					r_wr<='1';
					m_wr<='0';
					m_rd<='0';
					t1_wr<='0';
					t2_wr<='0';
					t3_wr<='0';
					t4_wr<='0';
					t5_wr<='0';
					t6_wr<='0';
					z_en<='0';
					c_en<='0';
					alu_ctrl<="00";
					
				when state5 =>
					--Data Flow
					a1<=s1_5;
					s2_0<=d1;
					--se6_in is implicit
					s3_0<=se6_out;
					s6_0<=s1_6;
					
					--Control Signals
					r_wr<='0';
					m_wr<='0';
					m_rd<='1';
					t1_wr<='0';
					t2_wr<='1';
					t3_wr<='1';
					t4_wr<='0';
					t5_wr<='0';
					t6_wr<='1';
					z_en<='0';
					c_en<='0';
					alu_ctrl<="00";
					
				when state6 =>
					--Data Flow
					s6_0<=s1_5;
					--se6_in is implicit
					alu_a<=se6_out;
					a2<=s1_6;
					alu_b<=d2;
					s4_0<=alu_out;
					a1<=s1_5;
					s2_0<=d1;
					
					--Control Signals
					r_wr<='0';
					m_wr<='0';
					m_rd<='0';
					t1_wr<='0';
					t2_wr<='1';
					t3_wr<='0';
					t4_wr<='1';
					t5_wr<='0';
					t6_wr<='1';
					z_en<=(not s1_4(3)) and s1_4(2) and (not s1_4(1)) and (not s1_4(0));
					c_en<='0';
					alu_ctrl<="00";
					
				when state7 =>
					--Data Flow
					m_a<=s4_1;
					s4_0<=m_out;
					
					--Control Signals
					r_wr<='0';
					m_wr<='0';
					m_rd<='1';
					t1_wr<='0';
					t2_wr<='0';
					t3_wr<='0';
					t4_wr<='1';
					t5_wr<='0';
					t6_wr<='0';
					z_en<='0';
					c_en<='0';
					alu_ctrl<="00";
					
				when state8 =>
					--Data Flow
					m_in<=s2_1;
					m_a<=s4_1;
					
					--Control Signals
					r_wr<='0';
					m_wr<='1';
					m_rd<='0';
					t1_wr<='0';
					t2_wr<='0';
					t3_wr<='0';
					t4_wr<='0';
					t5_wr<='0';
					t6_wr<='0';
					z_en<='0';
					c_en<='0';
					alu_ctrl<="00";
					
				when state9 =>
					--Data Flow
					--lshift_in is implicit
					s4_0<=L7_out;
					s6_0<=s1_5;
					
					--Control Signals
					r_wr<='0';
					m_wr<='0';
					m_rd<='0';
					t1_wr<='0';
					t2_wr<='0';
					t3_wr<='0';
					t4_wr<='1';
					t5_wr<='0';
					t6_wr<='1';
					z_en<='0';
					c_en<='0';
					alu_ctrl<="00";
					
				when state10 =>
					--Data Flow
					alu_b<=s5_1;
					--se6_in is implicit
					alu_a<=se6_out;
					d3<=alu_out;
					a3<="111";
					
					--Control Signals
					r_wr<='1';
					m_wr<='0';
					m_rd<='0';
					t1_wr<='0';
					t2_wr<='0';
					t3_wr<='0';
					t4_wr<='0';
					t5_wr<='0';
					t6_wr<='0';
					z_en<='0';
					c_en<='0';
					alu_ctrl<="00";
					
				when state11 =>
					--Data Flow
					a3<=s1_5;
					d3<=s5_1;
					
					--Control Signals
					r_wr<='1';
					m_wr<='0';
					m_rd<='0';
					t1_wr<='0';
					t2_wr<='0';
					t3_wr<='0';
					t4_wr<='0';
					t5_wr<='0';
					t6_wr<='0';
					z_en<='0';
					c_en<='0';
					alu_ctrl<="00";
					
				when state12 =>
					--Data Flow
					a2<=s1_6;
					d3<=d2;
					a3<="111";
					
					--Control Signals
					r_wr<='1';
					m_wr<='0';
					m_rd<='0';
					t1_wr<='0';
					t2_wr<='0';
					t3_wr<='0';
					t4_wr<='0';
					t5_wr<='0';
					t6_wr<='0';
					z_en<='0';
					c_en<='0';
					alu_ctrl<="00";
					
				when state13 =>
					--Data Flow
					m_a<=s2_1;
					d3<=m_out;
					--priori_in is implicit
					a3<=enc_out;
					--enc_out to dec_in is implicit
					--dec_out to e8_in is implicit
					s3_0<=e8_out;
					alu_a<=s2_1;
					alu_b<="0000000000000001";
					s2_0<=alu_out;
					
					--Control Signals
					r_wr<='1';
					m_wr<='0';
					m_rd<='1';
					t1_wr<='0';
					t2_wr<='1';
					t3_wr<='1';
					t4_wr<='0';
					t5_wr<='0';
					t6_wr<='0';
					z_en<='0';
					c_en<='0';
					alu_ctrl<="00";
					
				when state14 =>
					--Data Flow
					alu_a<=s1_10;
					alu_b<=s3_1;
					s1_0<=alu_out;
					
					--Control Signals
					r_wr<='0';
					m_wr<='0';
					m_rd<='0';
					t1_wr<='1';
					t2_wr<='0';
					t3_wr<='0';
					t4_wr<='0';
					t5_wr<='0';
					t6_wr<='0';
					z_en<='0';
					c_en<='0';
					alu_ctrl<="11";
					
				when state15 =>
					--Data Flow
					m_a<=s2_1;
					--priori_in is implicit
					a2<=enc_out;
					m_in<=d2;
					--enc_out to dec_in is implicit
					--dec_out to e8_in is implicit
					s3_0<=e8_out;
					alu_a<=s2_1;
					alu_b<="0000000000000001";
					s2_0<=alu_out;
					
					--Control Signals
					r_wr<='0';
					m_wr<='1';
					m_rd<='0';
					t1_wr<='0';
					t2_wr<='1';
					t3_wr<='1';
					t4_wr<='0';
					t5_wr<='0';
					t6_wr<='0';
					z_en<='0';
					c_en<='0';
					alu_ctrl<="00";
					
				when state_reset =>
					--Control Signals
					r_wr<='0';
					m_wr<='0';
					m_rd<='0';
					t1_wr<='0';
					t2_wr<='0';
					t3_wr<='0';
					t4_wr<='0';
					t5_wr<='0';
					t6_wr<='0';
					z_en<='0';
					c_en<='0';
					alu_ctrl<="00";
			end case;
		end process;
		
		out_c_in<=c_in;
		out_c_out<=c_out;
		out_z_in<=z_in;
		out_z_out<=z_out;
		out_c_i<=s1_8;
		out_z_i<=s1_9;
	
end architecture trivial;