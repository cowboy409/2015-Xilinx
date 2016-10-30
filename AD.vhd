
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.std_logic_arith.ALL;

entity AD is
    Port ( AD_in : in  STD_LOGIC_VECTOR (8 downto 0);
           pcs_addr : out  STD_LOGIC;
           MC_addr : out  STD_LOGIC_VECTOR (3 downto 0));
end AD;

architecture Behavioral of AD is


	signal temp : std_logic_vector(11 downto 0);
	signal MC_a_t : std_logic_vector(3 downto 0);
	


begin

temp(8 downto 0 )<=AD_in;
temp(11 downto 9) <="000";



process(temp)

begin

	
	case temp is
		
		when x"140" =>
			pcs_addr <= '1';
			MC_addr<= "1111";
		when x"141" =>
			pcs_addr <= '1';
			MC_addr<= "1111";
		when x"142" =>
			pcs_addr <= '1';
			MC_addr<= "1111";
		when x"143" =>
			pcs_addr <= '1';
			MC_addr<= "1111";
	
		when x"160" =>
			MC_addr<= x"1";
			pcs_addr <='0';
		when x"162" =>
			MC_addr<= x"2";
			pcs_addr <='0';
		when x"164" =>
			MC_addr<= x"3";
			pcs_addr <='0';
		when x"166" =>
			MC_addr<= x"4";
			pcs_addr <='0';
		when x"168" =>
			MC_addr<= x"5";
			pcs_addr <='0';
		when x"16A" =>
			MC_addr<= x"6";
			pcs_addr <='0';
		when x"170" =>
			MC_addr<= x"7";
			pcs_addr <='0';
			
		when x"180" => 
			MC_addr<= x"8";
			pcs_addr <='0';
			
		when x"000" =>
			MC_addr <= x"0";
			pcs_addr <='0';
			
					
		when others =>
			MC_addr <= x"0";
			pcs_addr <='0';
		
	end case;
	
	
end process;
	

end Behavioral;

