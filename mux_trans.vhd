
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux_trans is
    Port ( din0 : in STD_LOGIC_vector(7 downto 0);
           din1 : in STD_LOGIC_vector(7 downto 0);
			  din2 : in STD_LOGIC_vector(7 downto 0);
           sel : in  STD_LOGIC_vector(1 downto 0);
			  reset : in STD_LOGIC;	
           dout : out STD_LOGIC_vector(7 downto 0));
			  
end mux_trans;

architecture Behavioral of mux_trans is

begin
	process(reset,sel,din0,din1,din2)
		begin
			if reset = '0' then -- active low
			dout <= "00000000";
			else
				if sel="00" then
				dout <= din0;
				elsif sel="01" then
				dout <= din1;
				elsif sel="10" then
				dout <= din2;
				elsif sel="11" then
				dout <= "00000000";
				end if;
			end if;
	end process;
end Behavioral;

