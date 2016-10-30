
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux is
    Port ( din0 : in STD_LOGIC_vector(7 downto 0);
           din1 : in STD_LOGIC_vector(7 downto 0);
			  din2 : in STD_LOGIC_vector(7 downto 0);
           sel : in  STD_LOGIC_vector(1 downto 0);
			  reset : in STD_LOGIC;	
           dout : out STD_LOGIC_vector(7 downto 0));
			  
end mux;

architecture Behavioral of mux is

begin
	process(reset,sel,din0,din1,din2)
		begin
			if reset = '0' then -- active low
			dout <= "00000000";
			else
				if sel="01" then
				dout <= din1; -- sel 이 low일 때는 din0를 출력한다.
				elsif sel="00" then
				dout <= din0; -- sel 이 high 일 떄는 din1을 출력한다.
				elsif sel="10" then
				dout <= din2;
				end if;
			end if;
	end process;
end Behavioral;

