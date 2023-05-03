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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity bbD1 is
	port (
			mux_rf_a1_output, or2ex_a3, ex2ma_a3, ma2wb_a3, or2ex_rf_wr, ex2ma_rf_wr, ma2wb_rf_wr:in std_logic;
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

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------NEW COMPONENT-----------------------------------------
--------------------------------------------------------------DON'T BLINK-------------------------------------------
--------------------------------------------------------------LEST YOU MISS-----------------------------------------
--------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity bbD3 is
	port (
			ex2ma_c, ex2ma_z:in std_logic;
		   opcode : in std_logic_vector(5 downto 0);
			c_wr, z_wr : out std_logic);
end entity bbD3;

architecture blackboxed3 of bbD3 is
	begin
		edit_process: process(ex2ma_c, ex2ma_z, opcode)
		begin
			if (opcode = "000100" or opcode = "000111" or opcode = "000000" or opcode = "000001" or opcode = "000010" or opcode = "000011") then
			   c_wr<= '1';
				z_wr<= '1';
			elsif (opcode = "000110" and ex2ma_c ='1') then 
				c_wr<= '1';
				z_wr<= '1';
			elsif (opcode = "000101" and ex2ma_z ='1') then 
				c_wr<= '1';
				z_wr<= '1';
			elsif (opcode = "001000" or opcode = "001011" ) then 
				c_wr<= '0';
				z_wr<= '1';
			elsif (opcode = "001010" and ex2ma_c ='1') then 
				c_wr<= '0';
				z_wr<= '1';
			elsif (opcode = "001001" and ex2ma_z ='1') then 
				c_wr<= '0';
				z_wr<= '1';
			else 
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

architecture Structer of mux_4_1 is
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
				clk, m_wr: in std_logic; 
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
