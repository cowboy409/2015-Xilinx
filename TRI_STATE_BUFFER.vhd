
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TRI_STATE_BUFFER is
    PORT(
        bidir   : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        oe		 : IN STD_LOGIC;
		  ie		 : IN STD_LOGIC;
        inp     : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        outp    : OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
end TRI_STATE_BUFFER;

architecture Behavioral of TRI_STATE_BUFFER is 
begin
	process(oe, ie,inp,bidir )
	begin
		if(oe='1') then
			bidir <= inp;
		elsif(ie='1') then
			outp <= bidir;
		else
			bidir <= "ZZZZZZZZ";
			outp <= "ZZZZZZZZ";
		end if;
	end process;
	
end Behavioral;

