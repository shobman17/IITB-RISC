library ieee;
use ieee.std_logic_1164.all;

library work;
use work.Components.all;

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
		
	for all: ALU
		use entity work.ALU(addnand);
		
	for all: IF2IDreg
		use entity work.IF2IDreg(bhv1);
	
	for all: reverse_decoder_3to8
		use entity work.reverse_decoder_3to8(dec);
	
	signal IF_IM_in, update_PC, IF_IM_out, ID_IM_in, EX_D1_MUX_out, EX_adder2_out, IF_adder1_out, ID_adder1_out, OR_adder1_out, MA_adder1_out, WB_adder1_out, : std_logic_vector(15 downto 0):=(others=>'0');
	signal clk, PC_WR: std_logic;
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
			
		PC_MUX: component mux_4_1
			port map(IF_adder1_out, EX_adder2_out, EX_D1_MUX_out, Prediction, update_PC);
			
		BranchPredictor: component 
		
		
			
		--Now we will try and connect the shift register to everything
		
		reg_file: component prog_reg
			port map(a1, a2, a3, d1, d2, d3, clk, r_wr);
			
		-- viola we are now done with all of the storage units except memory
		priori_enc: component Priority
			port map(s1_3, enc_out);
			
		decoder: component decoder_3to8
			port map(enc_out, dec_out);
			
		e8: component extender8
			port map(dec_out, e8_out);
		
		lshift7: component Lshifter7
			port map(s1_1, L7_out);
			
		se6: component signed_extender
			port map(s1_2, se6_out);
			
		mem: component memory
			port map(m_a, m_in, m_wr, m_rd, m_out);
			
		alu_comp: component alu
			port map(alu_a, alu_b, alu_ctrl, alu_out, z_in, c_in);
			
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