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