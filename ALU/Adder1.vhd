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
