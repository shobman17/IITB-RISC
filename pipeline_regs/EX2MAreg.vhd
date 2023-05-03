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