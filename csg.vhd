library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; -- integer과 + operator를 사용하기 위한 library.
use ieee.std_logic_arith.all; -- integer과 + operator를 사용하기 위한 library.
use IEEE.std_logic_unsigned.all; -- unsigned와 + operator를 사용하기 위한 library.
entity csg is
    Port ( m_clk : in  STD_LOGIC;
           m_pcs_addr : in  STD_LOGIC;
           m_mode_control_addr : in STD_LOGIC_vector(3 downto 0);
           m_cmd_data : in  STD_LOGIC;
			  ad_data : in std_logic_vector(7 downto 0);
           m_latch_out_en : out  STD_LOGIC;
           m_latch_in_en : out  STD_LOGIC;
           m_wen : in  STD_LOGIC;
           m_ren : in  STD_LOGIC;
           m_ready : out  STD_LOGIC;
           m_tri_buffer_en : out  STD_LOGIC;
           m_addr_ram0 : out STD_LOGIC_vector(10 downto 0);
           m_addr_ram1 : out STD_LOGIC_vector(10 downto 0);
           m_led : out STD_LOGIC_vector(7 downto 0);
           m_latch_adc_en : out  STD_LOGIC;
           m_latch_dac_en : out  STD_LOGIC;
           m_ram0_wen : out  STD_LOGIC_vector(0 downto 0);
           m_ram0_ren : out  STD_LOGIC:= '0';
           m_ram1_wen : out  STD_LOGIC_vector(0 downto 0);
           m_ram1_ren : out  STD_LOGIC:= '0';
           m_mux_in_sel : out  STD_LOGIC_vector(1 downto 0);
           m_mux_out_sel : out  STD_LOGIC_vector(1 downto 0);
           m_mux_tran_sel : out STD_LOGIC_vector(1 downto 0);
			  m_reset : in  STD_LOGIC;
			  m_filter_en : out std_logic;
			  m_filter_sel : out std_logic
			  );	
end csg;

architecture Behavioral of csg is

-- portmap 연결하장
COMPONENT ram0_address_cnt is 
    PORT(
         ram0_address_cnt_clk : IN  std_logic;
         ram0_address_cnt_reset : IN  std_logic;
         ram0_address_cnt_en : IN  std_logic;
         ram0_address_cnt_addr : OUT  std_logic_vector(10 downto 0)
        );
 END COMPONENT;
 
 COMPONENT ram1_address_cnt is
    PORT(
         ram1_address_cnt_clk : IN  std_logic;
         ram1_address_cnt_reset : IN  std_logic;
         ram1_address_cnt_en : IN  std_logic;
         ram1_address_cnt_addr : OUT  std_logic_vector(10 downto 0)
        );
 END COMPONENT;
 
 COMPONENT ram2_address_cnt is 
    PORT(
         ram2_address_cnt_clk : IN  std_logic;
         ram2_address_cnt_reset : IN  std_logic;
         ram2_address_cnt_en : IN  std_logic;
         ram2_address_cnt_addr : OUT  std_logic_vector(10 downto 0)
        );
 END COMPONENT;
 
 COMPONENT ram3_address_cnt is
    PORT(
         ram3_address_cnt_clk : IN  std_logic;
         ram3_address_cnt_reset : IN  std_logic;
         ram3_address_cnt_en : IN  std_logic;
         ram3_address_cnt_addr : OUT  std_logic_vector(10 downto 0);
			ram3_count_num : in std_logic_vector(10 downto 0));
  END COMPONENT;
  
  COMPONENT ram4_address_cnt is
    PORT(
         ram4_address_cnt_clk : IN  std_logic;
         ram4_address_cnt_reset : IN  std_logic;
         ram4_address_cnt_en : IN  std_logic;
         ram4_address_cnt_addr : OUT  std_logic_vector(10 downto 0));
  END COMPONENT;
  
  COMPONENT ram5_address_cnt is
    PORT(
         ram5_address_cnt_clk : IN  std_logic;
         ram5_address_cnt_reset : IN  std_logic;
         ram5_address_cnt_en : IN  std_logic;
         ram5_address_cnt_addr : OUT  std_logic_vector(10 downto 0));
  END COMPONENT;
 
 
-- address counter의 reset과 en을 control하기 위한 signal
-- (완료) 초기화값 '0' 입력시키는 법.......................................................
signal s_cnt_reset : std_logic := '0';
signal s_ram0_cnt_en : std_logic := '0';
signal s_ram1_cnt_en : std_logic := '0';
signal s_ram2_cnt_en : std_logic := '0';
signal s_ram3_cnt_en : std_logic := '0';

signal s_ram0_cnt_addr : std_logic_vector(10 downto 0):= (others => '0');
signal s_ram1_cnt_addr : std_logic_vector(10 downto 0):= (others => '0');
signal s_ram2_cnt_addr : std_logic_vector(10 downto 0):= (others => '0');
signal s_ram3_cnt_addr : std_logic_vector(10 downto 0):= (others => '0');
signal ram_trans_tmp  : std_logic_vector(10 downto 0):= (others => '0'); --- 트랜스퍼용
signal s_led : STD_LOGIC_vector(7 downto 0);
signal s_ram3_count_num : std_logic_vector(10 downto 0);


signal s_ram4_cnt_en : std_logic := '0';
signal s_ram5_cnt_en : std_logic := '0';
signal s_ram4_cnt_addr : std_logic_vector(10 downto 0):= (others => '0');
signal s_ram5_cnt_addr : std_logic_vector(10 downto 0):= (others => '0');
--real

-- 수정 #4
signal s_ready : std_logic := '0';
signal s_temp : std_logic := '0'; 
signal s_ad_data : std_logic_vector(10 downto 0):= (others => '0');

signal ram0_write_cnt : std_logic_vector(10 downto 0):= (others => '0');  -- 원재랑 이야기할 당시에 A라고 부른 변수
signal ram0_read_cnt : std_logic_vector(10 downto 0):= (others => '0');  -- 원재랑 이야기할 당시에 B라고 부른 변수 
signal ram0_data_cnt : std_logic_vector(10 downto 0):= (others => '0');  -- 원재랑 이야기할 당시에 C라고 부른 변수

signal ram1_write_cnt : std_logic_vector(10 downto 0):= (others => '0');  -- 원재랑 이야기할 당시에 D라고 부른 변수
signal ram1_read_cnt : std_logic_vector(10 downto 0):= (others => '0');  -- 원재랑 이야기할 당시에 E라고 부른 변수
signal ram1_data_cnt : std_logic_vector(10 downto 0):= (others => '0');  -- 원재랑 이야기할 당시에 F라고 부른 변수

signal ram3_read_cnt : std_logic_vector(10 downto 0):= (others => '0');  -- 원재랑 이야기할 당시에 E라고 부른 변수
signal ram3_data_cnt : std_logic_vector(10 downto 0):= (others => '0');  -- 원재랑 이야기할 당시에 F라고 부른 변수


--------state 구문 ---------

type mode_pc_ram0 is (s100,s101,s102,s103,s104,s105,s106,s107,s108,s109,s112,s113,s114,s1142,s115,s116,s117,s118,s1181,s1182,s119);
signal state_pc_ram0 : mode_pc_ram0; -- pc mode(ram0) state machine

type mode_pc_ram1 is (s200,s201,s202,s203,s204,s205,s206,s207,s208,s209,s212,s213,s214,s2142,s215,s216,s217,s218,s2181,s2182,s219);
signal state_pc_ram1 : mode_pc_ram1; -- pc mode(ram0) state machine\

type mode_8254 is (s10,s11,s12,s13,s14);
signal state_8254 : mode_8254;


type mode_data_transfer is (s300,s301,s302,s3021 ,s303,s304,s305,s306,s307,s308,s309,s310,s311,s312,s313);
signal state_data_transfer : mode_data_transfer; -- transfer mode state machine

type mode_da is (s400,s401,s402,s403,s404,s405,s406,s407,s408,s409,s410,s411,s412,s413,s414,s415);
signal state_da : mode_da; -- DA mode state machine
-- DA mode는 start mode만 할당하고 DA stop은 따로 할당하지 않는다.

type mode_ad is (s600,s601,s602,s603,s604,s605,s606,s607,s608,s609,s610,s611,s612,s613,s614,s615);
signal state_ad : mode_ad; -- ad mode state machine

type mode_inter is (s700,s701,s702,s703,s704,s705,s7051,s706,s707,s7071,s708,s709,s710,s711,s712,s713,s7110,s7111,s7112,s714,s715,s716,s717,s718,s719,s720,s721,s722,s723,s724,s725,s726,s727,s728,s729);
signal state_inter : mode_inter; -- interpolation mode state machine

type mode_reset is (ss1,ss2);
signal sreset : mode_reset;


--type mode_ad is ( .. );
--signal state_ad : mode_mode_ad; -- DA mode state machine

--type mode_interpolation is (s40,s41,s42,s43,s44);
--signal state_interpolation : mode_interpolation ; -- DA mode state machine

begin
   M1 : ram0_address_cnt port map(
      ram0_address_cnt_clk => m_clk,
      ram0_address_cnt_reset => s_cnt_reset,
      ram0_address_cnt_en => s_ram0_cnt_en,
      ram0_address_cnt_addr => s_ram0_cnt_addr --(7 downto 0) 써줄 필요 없음.
      );
   M2 : ram1_address_cnt port map(
      ram1_address_cnt_clk => m_clk,
      ram1_address_cnt_reset => s_cnt_reset,
      ram1_address_cnt_en => s_ram1_cnt_en,
      ram1_address_cnt_addr => s_ram1_cnt_addr --m_addr_ram1 --(7 downto 0) 써줄 필요 없음.
      );
      M3 : ram2_address_cnt port map(
      ram2_address_cnt_clk => m_clk,
      ram2_address_cnt_reset => s_cnt_reset,
      ram2_address_cnt_en => s_ram2_cnt_en,
      ram2_address_cnt_addr => s_ram2_cnt_addr  
		);
	M4 : ram3_address_cnt port map(
      ram3_address_cnt_clk => m_clk,
      ram3_address_cnt_reset => s_cnt_reset,
      ram3_address_cnt_en => s_ram3_cnt_en,
      ram3_address_cnt_addr => s_ram3_cnt_addr,
		ram3_count_num=> s_ram3_count_num		
		);
   M5 : ram4_address_cnt port map(
      ram4_address_cnt_clk => m_clk,
      ram4_address_cnt_reset => s_cnt_reset,
      ram4_address_cnt_en => s_ram4_cnt_en,
      ram4_address_cnt_addr => s_ram4_cnt_addr
		);
	M6 : ram5_address_cnt port map(
      ram5_address_cnt_clk => m_clk,
      ram5_address_cnt_reset => s_cnt_reset,
      ram5_address_cnt_en => s_ram5_cnt_en,
      ram5_address_cnt_addr => s_ram5_cnt_addr
		);	
	m_led<=s_led;
	
	
	
	 process(m_clk, m_reset)
	 begin
		if m_reset='0' then
			state_8254 <= s10;
			
		elsif	m_pcs_addr = '0' then
			state_8254 <= s10;
			
		elsif rising_edge(m_clk) then
			case state_8254 is
				when s10 =>
					if m_cmd_data = '1' then
						state_8254 <= s11;
					else
						state_8254 <= s10;
					end if;
				
				when s11 =>
					if m_wen='1' then
						state_8254 <= s12;
					else
						state_8254 <= s11;
					end if;
					
				when s12 =>
					state_8254 <=s13;
				when s13 =>
					state_8254 <= s14;
				when s14 =>
					state_8254 <=s10;
				
			end case;
		end if;
		
		
end process;
	
--------------ram 0

	process (m_clk,m_reset)
	begin
	
	if m_reset='0' then
			state_pc_ram0 <= s100;
			
	elsif	m_mode_control_addr="0001" then
			
		if rising_edge(m_clk) then
			case state_pc_ram0 is
				when s100=>
					if m_cmd_data='1' then
						state_pc_ram0<=s101;
					else
						state_pc_ram0<=s100;
					end if;
				
				when s101=>
					if m_wen='1' then
						state_pc_ram0<=s102;
					elsif m_ren='1' then
						state_pc_ram0<=s112;
					else
						state_pc_ram0<=s101;
					end if;
				
				when s102 =>
					if (ram0_read_cnt/="00000000000") then
						state_pc_ram0<=s103;
					else
						state_pc_ram0<=s104;
					end if;
					
				when s103 => ---- read에서 write 로 올떄 reset state
					
					state_pc_ram0<=s104;
				
				when s104=>  ---- write write 일 경우. 더미기능도함.
				
					state_pc_ram0<=s105;
				
				when s105 => --- 기록 시작
					state_pc_ram0<=s106;
				
				when s106 => --- 더미스테이트
					state_pc_ram0<=s107;
				when s107=> --- 더미스테이트 + data cnt , 램잠그고
					state_pc_ram0<=s108;
				when s108 => -- cnt_en
					state_pc_ram0<=s109;
				when s109 => -- 
					state_pc_ram0<=s100;
					
	-------------- read				
				when s112=>
					if (ram0_write_cnt/="00000000000") then
						state_pc_ram0<=s113;
					elsif (ram0_read_cnt= ram0_data_cnt) then
						state_pc_ram0<=s113;
					else
						state_pc_ram0<=s114;
					end if;
					
				when s113 => ---- write에서 read 로 올떄 reset state
					
					state_pc_ram0<=s114;
				
				when s114=>  ---- read read 일 경우. 더미기능도함.
				
					state_pc_ram0<=s1142;
					
				when s1142=>  ---- read read 일 경우. 더미기능도함.
				
					state_pc_ram0<=s115;
				
				when s115 => --- 읽기 시작
					state_pc_ram0<=s116;
				
				when s116 => --- 더미스테이트
					state_pc_ram0<=s117;
				when s117=> --- 더미스테이트 + data cnt , 램잠그고
					state_pc_ram0<=s118;
				when s118 => -- cnt_en
					state_pc_ram0<=s1181;
					
				when s1181 => -- cnt_en
					state_pc_ram0<=s1182;
					
				when s1182 => -- cnt_en
					state_pc_ram0<=s119;
				when s119 => -- 
					state_pc_ram0<=s100;
		
			end case;
			
		end if;
			
	else	
		state_pc_ram0 <= s100;
	end if;

end process;


------------ ram1


	process (m_clk,m_reset)
	begin
	
	if m_reset='0' then
			state_pc_ram1 <= s200;
			
	elsif	m_mode_control_addr="0010" then
			
		if rising_edge(m_clk) then
			case state_pc_ram1 is
				when s200=>
					if m_cmd_data='1' then
						state_pc_ram1<=s201;
					else
						state_pc_ram1<=s200;
					end if;
				
				when s201=>
					if m_wen='1' then
						state_pc_ram1<=s202;
					elsif m_ren='1' then
						state_pc_ram1<=s212;
					else
						state_pc_ram1<=s201;
					end if;
				
				when s202 =>
					if (ram1_read_cnt/="00000000000") then
						state_pc_ram1<=s203;
					else
						state_pc_ram1<=s204;
					end if;
					
				when s203 => ---- read에서 write 로 올떄 reset state
					
					state_pc_ram1<=s204;
				
				when s204=>  ---- write write 일 경우. 더미기능도함.
				
					state_pc_ram1<=s205;
				
				when s205 => --- 기록 시작
					state_pc_ram1<=s206;
				
				when s206 => --- 더미스테이트
					state_pc_ram1<=s207;
				when s207=> --- 더미스테이트 + data cnt , 램잠그고
					state_pc_ram1<=s208;
				when s208 => -- cnt_en
					state_pc_ram1<=s209;
				when s209 => -- 
					state_pc_ram1<=s200;
					
	-------------- read				
				when s212=>
					if (ram1_write_cnt/="00000000000") then
						state_pc_ram1<=s213;
					elsif (ram1_read_cnt= ram1_data_cnt) then
						state_pc_ram1<=s213;
					else
						state_pc_ram1<=s214;
					end if;
					
				when s213 => ---- write에서 read 로 올떄 reset state
					
					state_pc_ram1<=s214;
				
				when s214=>  ---- read read 일 경우. 더미기능도함.
				
					state_pc_ram1<=s2142;
					
				when s2142=>  ---- read read 일 경우. 더미기능도함.
				
					state_pc_ram1<=s215;
				
				when s215 => --- 읽기 시작
					state_pc_ram1<=s216;
				
				when s216 => --- 더미스테이트
					state_pc_ram1<=s217;
				when s217=> --- 더미스테이트 + data cnt , 램잠그고
					state_pc_ram1<=s218;
				when s218 => -- cnt_en
					state_pc_ram1<=s2181;
					
				when s2181 => -- cnt_en
					state_pc_ram1<=s2182;
					
				when s2182 => -- cnt_en
					state_pc_ram1<=s219;
				when s219 => -- 
					state_pc_ram1<=s200;
		
			end case;
			
		end if;
			
	else	
		state_pc_ram1 <= s200;
	end if;

end process;	
	
	
	
	
	
------------------------ data transfer mode -----------------------
--type mode_data_transfer is (s300,s301,s302,s303,s304,s305,s306,s307,s308,s309,s310,s311,s312,s313);
--signal state_data_transfer : mode_data_transfer; -- transfer mode state machine













-------------------------- Reference ----------------------------- ㄴ

------------------------------ 추가해준 내용. --------------------------
 process(m_clk,m_reset)
	 begin
		if m_reset='0' then
			state_data_transfer <= s300;	
		elsif rising_edge(m_clk) then
			case state_data_transfer is
				when s300 =>
					if m_mode_control_addr="0011" then						
						state_data_transfer <= s301;
					else
						state_data_transfer <= s300;
					end if;
            when s301 =>--------------- wen신호 대기
					--m_ready <= '1';
					--s_cnt_reset<='0'
					--ram1_write_cnt <= "00000000000"
					--ram0_read_cnt <= "00000000000" 
					--ram0_write_cnt <= "00000000000"
					--ram1_read_cnt <= "00000000000"
					if m_wen='1' then
						state_data_transfer <= s302; 
					end if;
				when s302 =>
					--m_ready <= '1'
					--s_cnt_reset<='1'
					--s_ram0_cnt_en <= '1'
					
					--m_ram0_ren<='1'
					
					
					--m_addr_ram0 <= s_ram0_cnt_addr
					--ram_trans_tmp <= s_ram1_cnt_addr
					state_data_transfer <= s3021;
				when s3021 =>
					--s_ram1_cnt_en <= '1'
					--m_ram1_wen<="1"
					--m_addr_ram1 <= s_ram1_cnt_addr
					state_data_transfer <= s303;
				when s303 => -------------------- transfer 시작..................................................	
					--m_ready <= '1'
					--s_cnt_reset<='1'
					--s_ram0_cnt_en <= '1'
					--s_ram1_cnt_en <= '1'
					--m_ram0_ren<='1'
					--ram1_data_cnt <= s_ram1_cnt_addr
					--m_addr_ram1 <= s_ram1_cnt_addr
					--m_addr_ram0 <= s_ram0_cnt_addr
					--ram_trans_tmp <= s_ram1_cnt_addr
					if (ram0_data_cnt) = (ram_trans_tmp + "1")  then
						state_data_transfer <= s304;
					end if;
				when s304 =>  -------------------- transfer stop -------------------------------
					--m_ready <= '1'
					--s_cnt_reset<='0'
					--m_ram0_ren<='0';
					--m_ram1_wen<="0";
					--s_ram0_cnt_en <='0'; -- cnt disable
               --s_ram1_cnt_en <='0';
					state_data_transfer <= s305;					
					
				when s305 => 
					state_data_transfer <= s300;
				when others =>
					state_data_transfer <= s300;
			end case;
		end if;
end process;
								
                       
--------------------------------------- ssignal -----------------------------------					
--m_ready <= '1' when (state_data_transfer=s301) or (state_data_transfer=s302)or (state_data_transfer=s303)or (state_data_transfer=s304);

--ram1_write_cnt <= "00000000000" when (state_data_transfer=s301);
--ram0_read_cnt <= "00000000000" when (state_data_transfer=s301);
--ram0_write_cnt <= "00000000000" when (state_data_transfer=s301);
--ram1_read_cnt <= "00000000000" when (state_data_transfer=s301);
--ram1_data_cnt <= s_ram1_cnt_addr + "1" when (state_data_transfer=s303);--------"1" 을 더한 이유는 304에서 한 번 더 conter가 증가하기 때문에.

-- s_cnt_reset <= '0' when (state_data_transfer=s301) or (state_data_transfer=s304) else '1';	

--s_ram0_cnt_en <= '1' when (state_data_transfer=s302) or (state_data_transfer=s303) else '0';					
--s_ram1_cnt_en <= '1' when (state_data_transfer=s302) or (state_data_transfer=s303) else '0';	

--m_ram0_ren<='1' when (state_data_transfer=s302) or (state_data_transfer=s303) else '0';
--m_ram1_wen<="1" when (state_data_transfer=s302) or (state_data_transfer=s303)	else "0";				

--m_addr_ram1 <= s_ram1_cnt_addr when (state_data_transfer=s302) or (state_data_transfer=s303)	else "00000000000";
--m_addr_ram0 <= s_ram0_cnt_addr when (state_data_transfer=s302) or (state_data_transfer=s303)	else "00000000000";	
------------LED 처리 요망 -----------------------------
--s_led<="00000110" when (state_data_transfer=s301);		
			
					
--ram_trans_tmp <= s_ram1_cnt_addr when (state_data_transfer=s302) or (state_data_transfer=s303) else "00000000000";                       
                     
                  
				
				
--------------------------------------------- DA mode state machine	---------------------------------			
				
--type mode_da is (s400,s401,s402,s403,s404,s405,,s407,s408);
--signal state_da : mode_da; -- DA mode state machine
--DA mode는 start mode만 할당하고 DA stop은 따로 할당하지 않는다.
--signal s_temp : std_logic := '0';


------------------------------------------------- 추가했어용 -------------------------------------------
--signal ram3_read_cnt : std_logic_vector(10 downto 0):= (others => '0');  -- 원재랑 이야기할 당시에 E라고 부른 변수
--signal ram3_data_cnt : std_logic_vector(10 downto 0):= (others => '0');  -- 원재랑 이야기할 당시에 F라고 부른 변수

 process(m_clk,m_reset)
	 begin
		if m_reset='0' then
			state_da <= s400;
			
		--elsif	m_pcs_addr = '0' then
		--	state_da <= s400;
			
		elsif rising_edge(m_clk) then
			case state_da is
				when s400 =>
					if m_mode_control_addr="0100" then						
						state_da <= s401;
					else
						state_da <= s400;
					end if;
				when s401 =>
					--m_ready <= '1';
					--s_temp <= '0';
					--s_cnt_reset <='0'; -- active low / s_ram3_cnt_addr 초기화
					--m_addr_ram1 <= "00000000000";
					--m_ready <= '1';
					state_da <= s402;
				when s402 =>					
					if m_ren = '1' then
						state_da <= s403;
					else
						state_da <= s403;
					end if;
				WHEN s403 =>
					--s_cnt_reset <='1'; -- active low                                                  
					--state_da <= s43; 
					--s_ram3_count_num <= ram1_data_cnt;
					state_da <= s404;
				when s404 => ----------- Counting 준비 완료 -----------------
					--m_mux_out_sel <='1';
					--m_ready<= '0';
               --s_ram3_cnt_en <='1';
					--m_latch_dac_en <= '1'
					--m_addr_ram1 <= s_ram3_cnt_addr;	
					state_da <= s405;
				when s405 =>   --------------------- 뺑뻉 돌면서 counter 증가 ------------
					--s_led<="00000111";
					--m_ram1_ren <='1';
               --m_addr_ram1 <= s_ram3_cnt_addr;
               if m_mode_control_addr = "0101" then
                  state_da <= s407;
						--s_ram3_cnt_en <='0'; -- (완료)counter disable
                  --m_ram1_ren <='0';
                  --m_latch_dac_en <='0';                                             
						--m_ready <='1';						
					elsif ram3_data_cnt = s_ram3_cnt_addr + "1" then
					end if;
					
				-- S406 삭제	
				--when s406 =>
				--	state_da <= s405;
					
					
				when s407 => ---------------------- 종료 --------------
					if m_ren = '1' then                       
						--m_ready <= '0';
						state_da <= s408;
					end if;
				when s408 =>
					state_da <= s400;
				when others => ------------ 처음으로 가랏---------------
					state_da <= s400;
				end case;
			end if;
end process;

--------------------------------------- ssignal -----------------------------------
--m_ready <= '1' when (state_da = s401) or (state_da = s402) or (state_da =s403) or (state_da =s407) else '0';
--s_cnt_reset <='0'	when (state_da = s401) or (state_da = s406)		else '1';
--s_ram3_cnt_en <= '1' when (state_da = s404) or (state_da=s405) or (state_da = s406) 		else '0';
--m_ram1_ren <= '1' when (state_da = s405) or (state_da = s406) else '0';
--s_ram3_count_num <= s_ram3_cnt_addr when (state_da = s405) or (state_da =s406) else "00000000000";
--ram3_data_cnt <= ram1_data_cnt when (state_da = s403) or(state_da = s404) or (state_da=s405) or (state_da = s406) else "00000000000" ; 
--m_latch_dac_en <= '1' when (state_da=s405) or (state_da = s406) else '0';
--m_addr_ram1 <= s_ram3_cnt_addr when (state_da = s404) or (state_da = s405) or (state_da=s406) else "00000000000"; 
-- LED 값 넣는법.
--s_led <= "00000111" when (state_da = s405)

-------------------------------------------- ad mode ---------------------------------------------------------------

-- type mode_ad is (s600,s601,s602,s603,s604,s605,s606,s607,s608,s609,s610,s611,s612,s613,s614,s615);
-- signal state_ad : mode_ad; -- ad mode state machine   

process(m_clk,m_reset)
	 begin
		if m_reset='0' then
			state_ad <= s600;			
		elsif rising_edge(m_clk) then
			case state_ad is
				when s600 =>
					if m_mode_control_addr="0110" then						
						state_ad <= s601;
					else
						state_ad <= s600;
					end if;
				when s601 =>
					if m_wen = '1' then
						state_ad <= s602;
						--s_ad_data <= ad_data ----   data bus로 저장할 데이터 개수 인식
					
					end if;
				when s602 => --------------------- ad mode 준비 모두 완료
					--m_latch_in_en<='1'
					state_ad <= s603;
				when s603 => ----------------------------- digital 갯수만큼 저장하자
					if s_ad_data = (s_ram2_cnt_addr +"1" ) then
						state_ad <= s604;
					else 
						state_ad <= s603;
					end if;
				when s604 =>
					state_ad <= s605;
				when s605 => 
					state_ad <= s600;	
				when others =>
					state_ad <= s600;
			end case;
		end if;
end process;

--------------------------------------- ssignal -----------------------------------

--m_ready <= '1' when (state_ad=s601) or (state_ad=s602) or (state_ad=s603) else '0';
--s_cnt_reset <= '0' when (state_ad=s600) or (state_ad=s601) or (state_ad=s604) else '1';
--s_ram2_cnt_en <= '1' when (state_ad=s602) or (state_ad=s603)else '0'; 
--m_latch_adc_en<='1' when (state_ad=s602) or (state_ad=s603)	else '0';
--m_mux_in_sel <= '1' when (state_ad=s602) or (state_ad=s603)	else '0';
--m_ram0_wen <= "1" when (state_ad=s603) or (state_ad=s603) else "0";

--ram0_data_cnt <= ad_data - "1" (state_ad=s601);
--m_latch_in_en<='1' when (state_ad=s602) or (state_ad=s603)	else '0';
-- LED 추가 ?!
--s_led<="00001000";
--m_addr_ram0 <= s_ram2_cnt_addr when (state_ad=s603) or (state_ad=s604) else "00000000000";


----------------------------------- interpolation mode -------------------------------------

process(m_clk,m_reset)
	 begin
		if m_reset='0' then
			state_inter <= s700;			
		elsif rising_edge(m_clk) then
			case state_inter is
				when s700 =>
					if m_mode_control_addr="0111" then						
						state_inter <= s701;
						
					else
						state_inter <= s700;
					end if;
				when s701 =>
					--s_cnt_reset <= '0'
					if m_wen = '1' then
						state_inter <= s702;
					end if;
				
				when s702 => --초기화
					--s_cnt_reset <= '1'
					
					state_inter <= s703;
					
				when s703 =>
					--램주소 넣어주자
					--s_ram5_cnt_en <='0';
					--s_ram4_cnt_en <='0';
					--s_ram0_ren <= '1';
					state_inter <=s704;
					
				when s704 => -- transfer 시작. 데이터 1회 전송
						--램주소 넣어주자
					--m_mux_tran_sel<="10"
					--s_ram0_ren <= '0';
					--s_ram1_wen <= '1';
					--s_ram4_cnt_en <='1';
					--s_ram5_cnt_en <='1';
					
					
					state_inter <= s705;
					
				when s705 =>
					--램주소 넣어주자
					--m_mux_tran_sel<="11"
					--s_ram0_ren <= '0';
					--s_ram1_wen <= '1';
					--s_ram4_cnt_en <='0';
					--s_ram5_cnt_en <='1';
					state_inter <=s7051;
					
				when s7051 =>
					--램주소 넣어주자
					--m_mux_tran_sel<="11"
					--s_ram0_ren <= '0';
					--s_ram1_wen <= '1';
					--s_ram4_cnt_en <='0';
					--s_ram5_cnt_en <='1';
					state_inter <=s706;
					
				when s706 =>
					--램주소 넣어주자
					--m_mux_tran_sel<="11"
					--s_ram0_ren <= '1';
					--s_ram1_wen <= '1';
					--s_ram4_cnt_en <='0';
					--s_ram5_cnt_en <='1';
					
					if s_ram4_cnt_addr = ram0_data_cnt then
						state_inter <= s707;
						--ram1_data_cnt<= s_ram4_cnt_addr;
					else
						state_inter <= s704;
					end if;
						
				when s707 =>
					--s_ram4_cnt_en <='0';
					--s_ram5_cnt_en <='0';
					--s_cnt_reset <= '0'
					--mux in 은 10
					state_inter <= s7071;
			
					
				when s7071 =>
					
					state_inter <= s708;
					--s_ram1_ren <= '1';
					--s_ram5_cnt_en <='1';
				
				
				when s708 =>
					--램주소 넣어주자
					--s_ram0_ren <= '1';
					--s_ram1_wen <= '1';
					--s_ram4_cnt_en <='1';
					--s_ram5_cnt_en <='1';
					
					if s_ram4_cnt_addr = ram1_data_cnt -"1" then
						state_inter <= s709;
						--ram0_data_cnt<= s_ram4_cnt_addr;
					else
						state_inter <= s708;
					end if;	
					
				when s709 =>
					--램주소 넣어주자
					--s_ram4_cnt_en <='0';
					--s_ram5_cnt_en <='0';
					--s_cnt_reset <= '0'
					--mux in 은 10
					state_inter <= s710;
					
					
				
				when s710 =>
					--s_cnt_reset <= '1'
					state_inter <= s711;
					
				when s711 =>
					--램주소 넣어주자
					--s_ram0_ren <= '1';
					-- m_filter_en <= '1';
					--m_filter_sel <= '1';
					--s_ram1_wen <= '0';
					--s_ram4_cnt_en <='1';
					--s_ram5_cnt_en <='0';				
					--mux in 은 10
					state_inter <= s7110;
				when s7110 =>
					--램주소 넣어주자
					--s_ram0_ren <= '1';
					-- m_filter_en <= '1';
					--m_filter_sel <= '1';
					--s_ram1_wen <= '0';
					--s_ram4_cnt_en <='1';
					--s_ram5_cnt_en <='0';				
					--mux in 은 10
					state_inter <= s7111;
				when s7111 =>
					--램주소 넣어주자
					--s_ram0_ren <= '1';
					-- m_filter_en <= '1';
					--m_filter_sel <= '1';
					--s_ram1_wen <= '0';
					--s_ram4_cnt_en <='1';
					--s_ram5_cnt_en <='0';				
					--mux in 은 10
					state_inter <= s7112;
				when s7112 =>
					--램주소 넣어주자
					--s_ram0_ren <= '1';
					-- m_filter_en <= '1';
					--m_filter_sel <= '1';
					--s_ram1_wen <= '0';
					--s_ram4_cnt_en <='1';
					--s_ram5_cnt_en <='0';				
					--mux in 은 10
					
					state_inter <= s712;
				when s712 =>
					--램주소 넣어주자
					--mux trans 은 00
					--s_ram0_ren <= '1';
					-- m_filter_en <= '1';
					--m_filter_sel <= '1';
					
					--s_ram1_wen <= '1';
					--s_ram4_cnt_en <='0';
					--s_ram5_cnt_en <='1';
					
					
					if ( s_ram5_cnt_addr = ram0_data_cnt ) then
						state_inter <= s713;
					else
						state_inter <= s712;
					end if;
					
				
				when s713 =>
					state_inter <= s714;
				when s714 =>
					state_inter <= s715;
				when s715 =>
					state_inter <= s716;
				when s716 =>
					state_inter <= s717;
				when s717 =>
					state_inter <= s718;
				when s718 =>
					state_inter <= s719;
				when s719 =>
					state_inter <= s720;
				when s720 =>
					state_inter <= s721;
				when s721 =>
					state_inter <= s722;
				when s722 =>
					state_inter <= s723;
				when s723 =>
					state_inter <= s724;
				when s724 =>
					state_inter <= s725;
				when s725 =>
					state_inter <= s726;
				when s726 =>
					state_inter <= s700;
				 
				 
				
			
			
			
			
				when others =>
					state_inter <= s700;
			end case;
		end if;
end process;





---------------------------------------------------------------------------------
-------공통신호

m_ready <= '1' when ( state_8254=s11 or state_8254=s12 or state_8254=s13)
		or (state_pc_ram0=s101 or state_pc_ram0=s102 or state_pc_ram0=s103 or state_pc_ram0=s104 or state_pc_ram0=s105 or state_pc_ram0=s106 or state_pc_ram0=s107 or state_pc_ram0=s108)
or (state_pc_ram1=s201 or state_pc_ram1=s202 or state_pc_ram1=s203 or state_pc_ram1=s204 or state_pc_ram1=s205 or state_pc_ram1=s206 or state_pc_ram1=s207 or state_pc_ram1=s208)
or (state_pc_ram0=s112 or state_pc_ram0=s113 or state_pc_ram0=s114 or state_pc_ram0=s1142 or state_pc_ram0=s115 or state_pc_ram0=s116 or state_pc_ram0=s117 or state_pc_ram0=s118 or state_pc_ram0=s1181 or state_pc_ram0=s1182)  
or (state_pc_ram1=s212 or state_pc_ram1=s213 or state_pc_ram1=s214 or state_pc_ram1=s2142 or state_pc_ram1=s215 or state_pc_ram1=s216 or state_pc_ram1=s217 or state_pc_ram1=s218 or state_pc_ram1=s2181 or state_pc_ram1=s2182)  
or ((state_data_transfer=s301) or (state_data_transfer=s302)or (state_data_transfer=s303)or (state_data_transfer=s304)) 
or ((state_da = s401) or (state_da = s402) or (state_da =s403) or (state_da =s407)) 
or ((state_ad=s601) or (state_ad=s602) or (state_ad=s603)) 
or (state_inter=s701)  or (state_inter = s702) or (state_inter = s703) or (state_inter=s704)  or (state_inter = s705) or (state_inter = s7051) or (state_inter = s706) or (state_inter=s707) or (state_inter = s7071) or (state_inter = s708) or (state_inter = s709)  
or (state_inter=s710) or (state_inter=s711)   or state_inter=s7110 or state_inter=s7111 or state_inter=s7112 or (state_inter=s712) or (state_inter=s713) or (state_inter=s714)  or (state_inter = s715)  or (state_inter = s716) or (state_inter=s717) or  (state_inter = s718) or (state_inter = s719)  
or (state_inter=s720) or (state_inter=s721)   or (state_inter=s722) or (state_inter=s723) or (state_inter=s724)  or (state_inter = s725)  or (state_inter = s726) 
else '0';

------램관련 신호

------램 초기화 신호
s_cnt_reset <='0' when (state_pc_ram0=s103 or state_pc_ram0=s113 )
or (state_pc_ram1=s203 or state_pc_ram1=s213 )
or ((state_data_transfer=s301) or (state_data_transfer=s304)) 
or ((state_da = s401) or (state_da = s406))
or (state_ad=s602)
or m_reset='0'
or (state_inter=s701)  or (state_inter = s707) or (state_inter = s709) 
else '1';


-----램 write 신호

m_addr_ram0 <= s_ram0_cnt_addr when (state_pc_ram0=s105 or state_pc_ram0=s114)or ((state_data_transfer=s302)or(state_data_transfer=s3021)or (state_data_transfer=s303))
 else s_ram2_cnt_addr when ((state_ad=s602) or (state_ad=s603))
 else s_ram4_cnt_addr when (state_inter=s703 or state_inter=s704 or state_inter=s705 or state_inter=s7051  or state_inter=s706 or state_inter=s707 or state_inter=s708 or state_inter=s709 or state_inter=s711 or state_inter=s7110 or state_inter=s7111 or state_inter=s7112 or state_inter=s712 or state_inter=s713)
-- empty state
or (state_inter=s714)  or (state_inter = s715)  or (state_inter = s716) or (state_inter=s717) or  (state_inter = s718) or (state_inter = s719)  
or (state_inter=s720) or (state_inter=s721)   or (state_inter=s722) or (state_inter=s723) or (state_inter=s724)  or (state_inter = s725)  or (state_inter = s726);
 
m_addr_ram1 <= s_ram1_cnt_addr when (state_pc_ram1=s205 or state_pc_ram1=s214) or ((state_data_transfer=s302)or(state_data_transfer=s3021) or (state_data_transfer=s303))
else s_ram3_cnt_addr when ((state_da = s404) or (state_da = s405) or (state_da=s406))
else s_ram5_cnt_addr when (state_inter=s704 or state_inter=s705  or state_inter=s7051 or state_inter=s706 or state_inter=s707 or state_inter=s708 or state_inter=s709 or state_inter=s7112   or state_inter=s712 or state_inter=s713
-- empty state
or (state_inter=s714)  or (state_inter = s715)  or (state_inter = s716) or (state_inter=s717) or  (state_inter = s718) or (state_inter = s719)  
or (state_inter=s720) or (state_inter=s721)   or (state_inter=s722) or (state_inter=s723) or (state_inter=s724)  or (state_inter = s725)  or (state_inter = s726));


m_latch_in_en<='1' when (state_pc_ram0=s104 or state_pc_ram0=s105 or state_pc_ram0=s106 or state_pc_ram0=s107) 
or (state_pc_ram1=s204 or state_pc_ram1=s205 or state_pc_ram1=s206 or state_pc_ram1=s207)
else '0';	

m_mux_in_sel<="00" when (state_pc_ram0=s104 or state_pc_ram0=s105 or state_pc_ram0=s106 or state_pc_ram0=s107)
else "01" when (state_ad=s601) or (state_ad=s602) or (state_ad=s603)
else "10" when  (state_inter = s707) or (state_inter = s708) or (state_inter = s709); 

m_mux_tran_sel<="01" when (state_pc_ram1=s204 or state_pc_ram1=s205 or state_pc_ram1=s206 or state_pc_ram1=s207)
else "10" when (state_data_transfer=s3021) or (state_data_transfer=s303) or (state_inter = s704)
else "11" when (state_inter = s705) or (state_inter = s7051) or (state_inter = s706)
else "00" when (state_inter = s711) or (state_inter = s7110) or (state_inter = s7111) or (state_inter = s7112)or (state_inter = s712) or (state_inter = s713)
-- empty state
or (state_inter=s714)  or (state_inter = s715)  or (state_inter = s716) or (state_inter=s717) or  (state_inter = s718) or (state_inter = s719)  
or (state_inter=s720) or (state_inter=s721)   or (state_inter=s722) or (state_inter=s723) or (state_inter=s724)  or (state_inter = s725)  or (state_inter = s726);

m_ram0_wen<="1" when (state_pc_ram0=s105 or state_pc_ram0=s106 or state_pc_ram0=s107)							
or (state_ad=s603) or (state_inter = s708) 
else "0";								
								
m_ram1_wen<="1" when (state_pc_ram1=s205 or state_pc_ram1=s206 or state_pc_ram1=s207)							
or (state_data_transfer=s3021) or (state_data_transfer=s303)	
or (state_inter = s704) or (state_inter = s705) or (state_inter = s7051) or (state_inter = s706) or (state_inter = s712) or  (state_inter = s713)
or (state_inter=s714)  or (state_inter = s715)  or (state_inter = s716) or (state_inter=s717) or  (state_inter = s718) or (state_inter = s719)  
or (state_inter=s720) or (state_inter=s721)   or (state_inter=s722) or (state_inter=s723) or (state_inter=s724)  or (state_inter = s725)  or (state_inter = s726)
else "0";

ram0_write_cnt <= s_ram0_cnt_addr+"1" when (state_pc_ram0=s107) 
else "00000000000"  when (state_pc_ram0=s103 or state_pc_ram0=s113 ) or (state_data_transfer=s301);

ram0_data_cnt <= s_ad_data when (state_ad=s603)
else s_ram0_cnt_addr+"1" when (state_pc_ram0=s107)
else s_ram4_cnt_addr+"1" when (state_inter=s708);

ram1_write_cnt <= s_ram1_cnt_addr+"1" when (state_pc_ram1=s207) else "00000000000"  when (state_pc_ram1=s203 or state_pc_ram1=s213 ) or (state_data_transfer=s301);

ram1_data_cnt <= s_ram1_cnt_addr+"1" when (state_pc_ram1=s207) or (state_data_transfer=s303)
					else s_ram5_cnt_addr+"1"when (state_inter = s706);

ram3_data_cnt <= ram1_data_cnt when(state_da = s403) or(state_da = s404) or (state_da=s405) or (state_da = s406) else "00000000000" ; 

s_ram0_cnt_en <='1' when (state_pc_ram0=s109 or state_pc_ram0=s119) 
or (state_data_transfer=s302) or (state_data_transfer=s3021)or (state_data_transfer=s303) 
else '0';		

s_ram1_cnt_en <='1'when (state_pc_ram1=s209 or state_pc_ram1=s219) 			
or (state_data_transfer=s3021) or (state_data_transfer=s3021)or (state_data_transfer=s303) 
else '0';
	
s_ram2_cnt_en <= '1' when (state_ad=s603)
else '0'; 

s_ram3_cnt_en <= '1' when (state_da = s404) or (state_da=s405) or (state_da = s406) 		
else '0';

s_ram4_cnt_en <= '1' when (state_inter = s704) or (state_inter = s708) or (state_inter = s711)  or state_inter=s7110  or state_inter=s7111  or state_inter=s7112  or (state_inter = s712) or (state_inter=s713)
-- empty state
or (state_inter=s714)  or (state_inter = s715)  or (state_inter = s716) or (state_inter=s717) or  (state_inter = s718) or (state_inter = s719)  
or (state_inter=s720) or (state_inter=s721)   or (state_inter=s722) or (state_inter=s723) or (state_inter=s724)  or (state_inter = s725)  or (state_inter = s726)
else '0';

s_ram5_cnt_en <= '1' when (state_inter = s704) or (state_inter = s705) or (state_inter = s7051) or (state_inter = s706) or (state_inter = s7071)  or (state_inter = s708) or (state_inter = s712) 		 
or (state_inter=s713)
-- empty state
or (state_inter=s714)  or (state_inter = s715)  or (state_inter = s716) or (state_inter=s717) or  (state_inter = s718) or (state_inter = s719)  
or (state_inter=s720) or (state_inter=s721)   or (state_inter=s722) or (state_inter=s723) or (state_inter=s724)  or (state_inter = s725)  or (state_inter = s726)
else '0';


--- lach 재성
m_latch_adc_en<='1' when (state_ad=s601) or (state_ad=s602) or (state_ad=s603)	else '0';
m_latch_dac_en <= '1' when (state_da=s405) or (state_da = s406) else '0';



--=--- 기타 signal

ram_trans_tmp <= s_ram1_cnt_addr when (state_data_transfer=s302) or (state_data_transfer=s303) else "00000000000";
s_ram3_count_num <= ram1_data_cnt when (state_da = s405) or (state_da =s406);

m_filter_en <= '1' when (state_inter = s711) or (state_inter = s7110) or (state_inter = s7111) or (state_inter = s7112) or (state_inter = s712)
or (state_inter=s713) or (state_inter=s714)  or (state_inter = s715)  or (state_inter = s716) or (state_inter=s717) or  (state_inter = s718) or (state_inter = s719)  
or (state_inter=s720) or (state_inter=s721)   or (state_inter=s722) or (state_inter=s723) or (state_inter=s724)  or (state_inter = s725)  or (state_inter = s726)
else '0';
m_filter_sel <= '1' when (state_inter = s711) or(state_inter = s7110)  or (state_inter = s7111) or (state_inter = s7112) or  (state_inter = s712)
or (state_inter=s713) or (state_inter=s714)  or (state_inter = s715)  or (state_inter = s716) or (state_inter=s717) or  (state_inter = s718) or (state_inter = s719)  
or (state_inter=s720) or (state_inter=s721)   or (state_inter=s722) or (state_inter=s723) or (state_inter=s724)  or (state_inter = s725)  or (state_inter = s726)
else '0';


-----램 read 신호


m_tri_buffer_en<='1' when (state_pc_ram0=s117 or state_pc_ram0=s118 or state_pc_ram0=s1181 or state_pc_ram0=s1182 )
								or (state_pc_ram1=s217 or state_pc_ram1=s218 or state_pc_ram1=s2181 or state_pc_ram1=s2182 ) else '0';
								
								
								
								
								
m_latch_out_en<='1' when  (state_pc_ram0=s116 or state_pc_ram0=s117 or state_pc_ram0=s118 or state_pc_ram0=s1181 or state_pc_ram0=s1182 )
								or (state_pc_ram1=s216 or state_pc_ram1=s217 or state_pc_ram1=s218 or state_pc_ram1=s2181 or state_pc_ram1=s2182 )  else '0';
								
								
								
								
m_mux_out_sel <="00" when  (state_pc_ram0=s115 or state_pc_ram0=s116 or state_pc_ram0=s117 or state_pc_ram0=s118 or state_pc_ram0=s1181 or state_pc_ram0=s1182 )
								else "01" when  (state_pc_ram1=s215 or state_pc_ram1=s216 or state_pc_ram1=s217 or state_pc_ram1=s218 or state_pc_ram1=s2181 or state_pc_ram1=s2182 );
								
								
								
m_ram0_ren <='1' when (state_pc_ram0=s1142 or state_pc_ram0=s115 or state_pc_ram0=s116 or state_pc_ram0=s117 or state_pc_ram0=s118 or state_pc_ram0=s1181 or state_pc_ram0=s1182 )
or (state_data_transfer=s302)or (state_data_transfer=s3021) or (state_data_transfer=s303)
or (state_inter = s703) or (state_inter = s706) or (state_inter = s711)   or state_inter=s7110 or (state_inter = s7111) or (state_inter = s7112) or (state_inter = s712)
or (state_inter=s713)
-- empty state
or (state_inter=s714)  or (state_inter = s715)  or (state_inter = s716) or (state_inter=s717) or  (state_inter = s718) or (state_inter = s719)  
or (state_inter=s720) or (state_inter=s721)   or (state_inter=s722) or (state_inter=s723) or (state_inter=s724)  or (state_inter = s725)  or (state_inter = s726)
else '0';


m_ram1_ren <='1' when (state_pc_ram1=s2142 or state_pc_ram1=s215 or state_pc_ram1=s216 or state_pc_ram1=s217 or state_pc_ram1=s218 or state_pc_ram1=s2181 or state_pc_ram1=s2182 )
or  (state_da = s404) or  (state_da = s405) or (state_da = s406) or (state_inter = s7071) or (state_inter = s708) else '0';


ram0_read_cnt <= s_ram0_cnt_addr+"1" when (state_pc_ram0=s119) else "00000000000"  when (state_pc_ram0=s103 or state_pc_ram0=s113 ) or (state_data_transfer=s301);
ram1_read_cnt <= s_ram1_cnt_addr+"1" when (state_pc_ram1=s219) else "00000000000"  when (state_pc_ram1=s203 or state_pc_ram1=s213 ) or (state_data_transfer=s301);

s_ad_data (7 downto 0) <= ad_data when (state_ad=s602);	
end Behavioral;