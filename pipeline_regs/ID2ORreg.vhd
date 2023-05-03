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