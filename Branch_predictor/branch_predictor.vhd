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
	variable head    : integer := 0; -- where to write a new entry	
	
begin

	readTable: process(in_IF) is
		variable found: std_logic := '0';
	begin
		if(in_IF(15) and ((not in_IF(13) and not in_IF(12)) or (not in_IF(14) and in_IF(12)))) then -- check if opcode is of branching instruction
			searchTable: for IR in 0 to tableSize - 1 loop
				if(inputTable(addrSize*IR to addrSize*(IR+1) - 1) = in_IF and historyBit(IR)) then
					out_pred <= predTable(addrSize*IR to addrSize*(IR+1) - 1);
					branch <= '1';
					found := '1'; --match is found
					EXIT searchTable;
				end if; 
			end loop searchTable
			
			if(not found) then -- return dummy prediciton
				branch <= '0';
				out_pred <= "0000000000000000";
			end if;
		else 
			branch <= '0';
			out_pred <= "0000000000000000";
		end if;
	end process readTable;
	
	writeTable: process(in_EXE, in_pred, BR_WR, hb_in) is --write to the LUT by changing the hb or adding a new entry
		variable found: std_logic := '0';
	begin
		if(in_EXE(15) and ((not in_EXE(13) and not in_EXE(12)) or (not in_EXE(14) and in_EXE(12))) and BR_WR) then
			searchTable2: for IR in 0 to tableSize - 1 loop
				if(inputTable(addrSize*IR to addrSize*(IR+1) - 1) = in_EXE) then
					found := '1'; --match is found
					historyBit(IR) <= hb_in;
					EXIT searchTable2;
				end if; 
			end loop searchTable2
			if(not found) then
				inputTable(addrSize*head to addrSize*(head + 1)-1) <= in_EXE;
				historyBit(head) <= hb_in;
				predTable(addrSize*head to addrSize*(head + 1)-1) <= in_pred;
				
				