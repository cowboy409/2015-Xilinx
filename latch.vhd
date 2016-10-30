
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity latch is
    Port ( latchin : in  STD_LOGIC_VECTOR (7 downto 0);
           latchout : out  STD_LOGIC_VECTOR (7 downto 0);
           latchclk : in  STD_LOGIC;
           latchrst : in  STD_LOGIC;
           latchen : in  STD_LOGIC);
end latch;

architecture Behavioral of latch is

	signal temp : std_logic_vector(7 downto 0);
	signal en : STD_LOGIC:='0';
	

begin



	process (latchclk,latchrst,latchen)
	begin
		
			
		if (rising_edge(latchclk)) then
		
			 if (latchrst='0' and latchen='1') then
						
				latchout<=latchin;
				
			elsif (latchrst='1' or latchen='0') then
				latchout<= (others=>'Z');
			end if;
		
		else
		end if;
			
		
	end process;
	
end Behavioral;

