library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;

entity filter is
    Port ( 
			  filter_in : in std_logic_vector(7 downto 0);
           m_clk : in  STD_LOGIC;
			  m_reset : in  STD_LOGIC;   -- active low  
			  filter_en : in  STD_LOGIC;
			  filter_sel : in  STD_LOGIC;
           filter_out : out STD_LOGIC_vector(7 downto 0);
			  );	
end filter;

signal delay01 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal delay02 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal delay03 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal delay04 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal delay05 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal delay06 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal delay07 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal delay08 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal delay09 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal delay10 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal delay11 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal delay12 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal delay13 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal delay14 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal delay15 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal delay16 : in STD_LOGIC_vector(7 downto 0):= (others => '0');


signal out01 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal out02 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal out03 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal out04 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal out05 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal out06 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal out07 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal out08 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal out09 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal out10 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal out11 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal out12 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal out13 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal out14 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal out15 : in STD_LOGIC_vector(7 downto 0):= (others => '0');
signal out16 : in STD_LOGIC_vector(7 downto 0):= (others => '0');



architecture Behavioral of filter is
BEGIN   
    process (m_clk)
		begin
	 process(m_clk, m_reset)
	 begin
		if m_reset='0' then
			delay16 <= "00000000";
			delay15 <= "00000000";
			delay14 <= "00000000";
			delay13 <= "00000000";
			delay12 <= "00000000";
			delay11 <= "00000000";
			delay10 <= "00000000";
			delay09 <= "00000000";
			delay08 <= "00000000";
			delay07 <= "00000000";
			delay06 <= "00000000";
			delay05 <= "00000000";
			delay04 <= "00000000";
			delay03 <= "00000000";
			delay02 <= "00000000";
			delay01 <= "00000000";
			
		elsif (rising_edge(m_clk) and filter_en='1') then	
			delay16 <= delay15;
			delay15 <= delay14;
			delay14 <= delay13;
			delay13 <= delay12;
			delay12 <= delay11;
			delay11 <= delay10;
			delay10 <= delay09;
			delay09 <= delay08;
			delay08 <= delay07;
			delay07 <= delay06;
			delay06 <= delay05;
			delay05 <= delay04;
			delay04 <= delay03;
			delay03 <= delay02;
			delay02 <= delay01;
			delay01 <= filter_in;
			
			out01 <= delay01 * 0.00000100011;
			out02 <= delay02 * 0.00000110010;
			out03 <= delay03 * 0.00001010000;
			out04 <= delay04 * 0.00001110000;
			out05 <= delay05 * 0.00010010010;
			out06 <= delay06 * 0.00010101111;
			out07 <= delay07 * 0.00011000101;
			out08 <= delay08 * 0.00011010001;
			out09 <= delay09 * 0.00011010001;
			out10 <= delay10 * 0.00011000101;
			out11 <= delay11 * 0.00010101111;
			out12 <= delay12 * 0.00010010010;
			out13 <= delay13 * 0.00001110000;
			out14 <= delay14 * 0.00001010000;
			out15 <= delay15 * 0.00000110010;
			out16 <= delay16 * 0.00000100011;
			
			if filter_sel ='1' then
			filter_out = out01+out02+out03+out04+out05+out06+out07+out08+out09+out10+out11+out12+out13+out14+out15+out16;	
			else 
		end if;
    end process;
end Behavioral;