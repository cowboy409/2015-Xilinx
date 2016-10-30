library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.std_logic_unsigned.all; -- unsigned와 + operator를 사용하기 위한 library.


entity ram3_address_cnt is
    Port ( ram3_address_cnt_clk : in  STD_LOGIC;
           ram3_address_cnt_reset : in  STD_LOGIC;
           ram3_address_cnt_en : in  STD_LOGIC;
			  ram3_count_num : in std_logic_vector(10 downto 0);
           ram3_address_cnt_addr : out  STD_LOGIC_vector(10 downto 0));
end ram3_address_cnt;

architecture Behavioral of ram3_address_cnt is
    signal s_addr : std_logic_vector(10 downto 0) := (others => '0');
	 signal s_num : std_logic_vector(10 downto 0) := (others => '0');
    
begin
     
	  
	  s_num <= ram3_count_num+'1';
	  
    s_addr <= (others=>'0') when (ram3_address_cnt_reset = '0' or s_addr=s_num ) else
			 s_addr+'1' when (rising_edge(ram3_address_cnt_clk) and ram3_address_cnt_en='1');
				
			 
	 ram3_address_cnt_addr <= s_addr;



end Behavioral;
