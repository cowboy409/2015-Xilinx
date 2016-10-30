library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.std_logic_unsigned.all; -- unsigned와 + operator를 사용하기 위한 library.


entity ram2_address_cnt is
    Port ( ram2_address_cnt_clk : in  STD_LOGIC;
           ram2_address_cnt_reset : in  STD_LOGIC;
           ram2_address_cnt_en : in  STD_LOGIC;
           ram2_address_cnt_addr : out  STD_LOGIC_vector(10 downto 0));
end ram2_address_cnt;

architecture Behavioral of ram2_address_cnt is
    signal s_addr : std_logic_vector(10 downto 0) := (others => '0');
 
    
begin
     
    s_addr <= (others=>'0') when ram2_address_cnt_reset = '0' else
			 s_addr+'1' when (rising_edge(ram2_address_cnt_clk) and ram2_address_cnt_en='1') ;
			 
	 ram2_address_cnt_addr <= s_addr;



end Behavioral;
