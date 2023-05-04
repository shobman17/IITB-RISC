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