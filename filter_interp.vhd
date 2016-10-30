library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; -- integer과 + operator를 사용하기 위한 library.
use ieee.std_logic_arith.all; -- integer과 + operator를 사용하기 위한 library.
use IEEE.std_logic_unsigned.all; -- unsigned와 + operator를 사용하기 위한 library.

entity filter_interp is
    Port ( m_filter_in : in  STD_LOGIC_VECTOR (7 downto 0);
           m_filter_out : out  STD_LOGIC_VECTOR (7 downto 0);
			  m_filter_en : in  STD_LOGIC;
			  m_filter_sel : in  STD_LOGIC;
           m_reset : in  STD_LOGIC;
           m_clk : in  STD_LOGIC
			  );
end filter_interp;

architecture Behavioral of filter_interp is

component mul is 
port( A : in std_logic_vector ( 7 downto 0);
		B : in std_logic_vector (10 downto 0);
		clk : in std_logic;
		P : out std_logic_vector (18 downto 0)
		);
end component;

type type_18downto0 is array (15 downto 0) of std_logic_vector(18 downto 0);
signal s_out : type_18downto0;
type type_7downto0 is array (15 downto 0) of std_logic_vector(7 downto 0);
signal s_in : type_7downto0;
signal s_sum : std_logic_vector(22 downto 0);


begin
mul1 : mul
port map( A => s_in(0),
		B =>"00000100011",
		clk => m_clk,
		P =>s_out(0));
mul2 : mul
port map( A => s_in(1),
		B =>"00000110010",
		clk => m_clk,
		P =>s_out(1));		
mul3 : mul
port map( A => s_in(2),
		B =>"00001010000",
		clk => m_clk,
		P =>s_out(2));
mul4 : mul
port map( A => s_in(3),
		B =>"00001110000",
		clk => m_clk,
		P =>s_out(3));
mul5 : mul
port map( A => s_in(4),
		B =>"00010010010",
		clk => m_clk,
		P =>s_out(4));		
mul6 : mul
port map( A => s_in(5),
		B =>"00010101111",
		clk => m_clk,
		P =>s_out(5));
mul7 : mul
port map( A => s_in(6),
		B =>"00011000101",
		clk => m_clk,
		P =>s_out(6));		
mul8 : mul
port map( A => s_in(7),
		B =>"00011010001",
		clk => m_clk,
		P =>s_out(7));
mul9 : mul
port map( A => s_in(8),
		B =>"00011010001",
		clk => m_clk,
		P =>s_out(8));
mul10 : mul
port map( A => s_in(9),
		B =>"00011000101",
		clk => m_clk,
		P =>s_out(9));		
mul11 : mul
port map( A => s_in(10),
		B =>"00010101111",
		clk => m_clk,
		P =>s_out(10));
mul12 : mul
port map( A => s_in(11),
		B =>"00010010010",
		clk => m_clk,
		P =>s_out(11));		
mul13 : mul
port map( A => s_in(12),
		B =>"00001110000",
		clk => m_clk,
		P =>s_out(12));
mul14 : mul
port map( A => s_in(13),
		B =>"00001010000",
		clk => m_clk,
		P =>s_out(13));		
mul15 : mul
port map( A => s_in(14),
		B =>"00000110010",
		clk => m_clk,
		P =>s_out(14));
mul16 : mul
port map( A => s_in(15),
		B =>"00000100011",
		clk => m_clk,
		P =>s_out(15));

		
process(m_clk, m_reset)
begin
	if m_reset ='0' or m_filter_sel = '0' then
		s_in <= (others=> (others=>'0'));
	elsif rising_edge(m_clk) then
		for i in 15 downto 1 loop
			s_in(i) <= s_in(i-1); 
		end loop;
		s_in(0) <= m_filter_in;
		s_sum <= (X"0"&s_out(0)) + (x"0"&s_out(1)) + (x"0"&s_out(2)) + (x"0"&s_out(3)) + 
					(x"0"&s_out(4)) + (x"0"&s_out(5)) + (x"0"&s_out(6)) + (x"0"&s_out(7)) + 
					(x"0"&s_out(8)) + (x"0"&s_out(9)) + (x"0"&s_out(10)) + (x"0"&s_out(11)) +
					(x"0"&s_out(12)) + (x"0"&s_out(13)) + (x"0"&s_out(14)) + (x"0"&s_out(15));
	end if;
	--if (m_filter_en = '1') then
		
	--end if;
	-- m_filter_sel 은 filter 작동 타이밍을 결정해주는 signal이고
	-- m_filter_en  은 filter 출력 타이밍을 조정해주는 signal이다.
	-- 이렇게 설계한 이유는 앞, 뒤 signal 중 일부를 ram1에 저장하지 않도록 방지하기 위함이다.
end process;
	m_filter_out <= s_sum(18 downto 11);
end Behavioral;

