
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Use ieee.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_TOP IS
END TB_TOP;
 
ARCHITECTURE behavior OF TB_TOP IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
 
 
  
    COMPONENT PCFG_TOP
    PORT(
         m_reset_b : IN  std_logic;
         m_clk : IN  std_logic;
         m_address : IN  std_logic_vector(8 downto 0);
         m_cmd_data : IN  std_logic;
         m_wen : IN  std_logic;
         m_ren : IN  std_logic;
         m_ADC_data : IN  std_logic_vector(7 downto 0);
         m_ready : OUT  std_logic;
         m_DAC_data : OUT  std_logic_vector(7 downto 0);
         m_DAC_clk : OUT  std_logic;
         m_AD9283_clk : OUT  std_logic;
         m_data : INOUT  std_logic_vector(7 downto 0);
         m_led : OUT  std_logic_vector(7 downto 0);
         m_TP : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
     
    
   --Inputs
   signal m_reset_b : std_logic := '0';
   signal m_clk : std_logic := '0';
   signal m_address : std_logic_vector(8 downto 0) := (others => '0');
   signal m_cmd_data : std_logic := '0';
   signal m_wen : std_logic := '0';
   signal m_ren : std_logic := '0';
   signal m_ADC_data : std_logic_vector(7 downto 0) := (others => '0');

	--BiDirs
   signal m_data : std_logic_vector(7 downto 0);
	   --BiDirs


   signal s_data : std_logic_vector(7 downto 0):="00000001";

 	--Outputs
   signal m_ready : std_logic;
   signal m_DAC_data : std_logic_vector(7 downto 0);
   signal m_DAC_clk : std_logic;
   signal m_AD9283_clk : std_logic;
   signal m_led : std_logic_vector(7 downto 0);
   signal m_TP : std_logic_vector(1 downto 0);

   procedure CMD_WR(
				Addr 						: in 	std_logic_vector(8 downto 0);
				Data_in	 					: in	std_logic_vector(7 downto 0);
				signal 		Address_tmp		: out	std_logic_vector(8 downto 0);
				signal		Data_tmp		: out	std_logic_vector(7 downto 0);
				signal		CMD_DATA_tmp	: out	std_logic;
				signal		WEN_tmp			: out	std_logic;
				signal		REN_tmp			: out	std_logic;
				signal		READY_tmp		: in	std_logic) is
	begin
	 
		Address_tmp				<= Addr; 
		Data_tmp   				<= (others=>'Z');
		CMD_DATA_tmp 			<= '1';
		WEN_tmp 				<= '0';
		REN_tmp 				<= '0';
		wait until READY_tmp = '1';
		wait for 18 ns;
	
		Address_tmp				<= Addr; 
		Data_tmp   				<= Data_in;
		WEN_tmp 				<= '1';
		
		wait until READY_tmp = '0';
		wait for 70 ns;    
		
		Address_tmp				<= (others=>'0'); 
		Data_tmp   				<= (others=>'Z');
		CMD_DATA_tmp			<= '0';
		WEN_tmp 				<= '0';
		wait for 100 ns;
	end CMD_WR; 

	----CMD_RD------------------------------------------------------------------
	procedure CMD_RD(
				Addr						: in	std_logic_vector(8 downto 0);
				signal 		Address_tmp		: out	std_logic_vector(8 downto 0);
				signal 		Data_tmp		: inout	std_logic_vector(7 downto 0);
				signal		CMD_DATA_tmp	: out	std_logic;
				signal		WEN_tmp			: out	std_logic;
				signal		REN_tmp			: out	std_logic;
				signal		READY_tmp		: in	std_logic
				) is
	begin
		Address_tmp				<= Addr; 
		CMD_DATA_tmp 			<= '1';
		WEN_tmp 				<= '0';
		REN_tmp 				<= '0';
		wait until READY_tmp = '1';
		wait for 18 ns;
		Data_tmp				<= "ZZZZZZZZ";
		REN_tmp 				<= '1';
		wait until READY_tmp='0';
		wait for 50 ns;
		Address_tmp				<= (others=>'0'); 
		CMD_DATA_tmp			<= '0';
		REN_tmp 				<= '0';
		wait for 100 ns;
	end CMD_RD;
	
	---------- CMD_AD ---------------------------
	procedure CMD_AD(
				Addr 						: in 	std_logic_vector(8 downto 0);
				Data_in	 					: in	std_logic_vector(7 downto 0);
				signal 		Address_tmp		: out	std_logic_vector(8 downto 0);
				signal		Data_tmp		: out	std_logic_vector(7 downto 0);
				signal		adc_tmp		: out	std_logic_vector(7 downto 0);
				signal		CMD_DATA_tmp	: out	std_logic;
				signal		WEN_tmp			: out	std_logic;
				signal		REN_tmp			: out	std_logic;
				signal		READY_tmp		: in	std_logic) is
	begin
	 
		Address_tmp				<= Addr; 
		Data_tmp   				<= (others=>'Z');
		CMD_DATA_tmp 			<= '1';
		WEN_tmp 				<= '0';
		REN_tmp 				<= '0';
		wait until READY_tmp = '1';
		wait for 18 ns;
	
		Address_tmp				<= Addr; 
		Data_tmp   				<= Data_in;
		WEN_tmp 				<= '1';
		
		
		wait for 142 ns;
		adc_tmp<="00000001";--1
		wait for 80 ns;
		adc_tmp<="00000010";--2
		wait for 80 ns;
		adc_tmp<="00000011";--3
		wait for 80 ns;
		adc_tmp<="00000100";--4
		wait for 80 ns;
		adc_tmp<="00000101";--5
		wait for 80 ns;
		adc_tmp<="00000110";--6
		wait for 80 ns;
		adc_tmp<="00000111";--7
		wait for 80 ns;
		adc_tmp<="00001000";--8
		wait for 80 ns;
		adc_tmp<="00001001";--9
		wait for 80 ns;
		adc_tmp<="00001010";--10
		wait for 80 ns;
		
		
		----------Loop must be consecutive.
		wait for 142 ns;
		adc_tmp<="00000001";--1
		wait for 80 ns;
		adc_tmp<="00000010";--2
		wait for 80 ns;
		adc_tmp<="00000011";--3
		wait for 80 ns;
		adc_tmp<="00000100";--4
		wait for 80 ns;
		adc_tmp<="00000101";--5
		wait for 80 ns;
		adc_tmp<="00000110";--6
		wait for 80 ns;
		adc_tmp<="00000111";--7
		wait for 80 ns;
		adc_tmp<="00001000";--8
		wait for 80 ns;
		adc_tmp<="00001001";--9
		wait for 80 ns;
		adc_tmp<="00001010";--10
		wait for 80 ns;
		wait for 142 ns;
		adc_tmp<="00000001";--11
		wait for 80 ns;
		adc_tmp<="00000010";--12
		wait for 80 ns;
		adc_tmp<="00000011";--13
		
		adc_tmp <="Z";
		
		wait until READY_tmp = '0';
		wait for 70 ns;    
		
		Address_tmp				<= (others=>'0'); 
		Data_tmp   				<= (others=>'Z');
		CMD_DATA_tmp			<= '0';
		WEN_tmp 				<= '0';
		wait for 100 ns;
	end CMD_AD; 
	
	
	
	
	
	
	
	
	
   -- Clock period definitions
   constant m_clk_period : time := 10 ns;
   constant m_DAC_clk_period : time := 10 ns;
   constant m_AD9283_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PCFG_TOP PORT MAP (
          m_reset_b => m_reset_b,
          m_clk => m_clk,
          m_address => m_address,
          m_cmd_data => m_cmd_data,
          m_wen => m_wen,
          m_ren => m_ren,
          m_ADC_data => m_ADC_data,
          m_ready => m_ready,
          m_DAC_data => m_DAC_data,
          m_DAC_clk => m_DAC_clk,
          m_AD9283_clk => m_AD9283_clk,
          m_data => m_data,
          m_led => m_led,
          m_TP => m_TP
        );

   -- Clock process definitions
 m_clk <= not m_clk after m_clk_period/2;    -- clk�process문을 �용�� �고 �� 같이 만드�요
 
 m_ADC_data <= m_ADC_data + "00000001" after m_clk_period*8;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
	m_reset_b		<= '0';  -- m_reset_bactive low (_b가 bar�는 
    wait for 100 ns;	
	m_reset_b  <= '1';
	wait for 1000 ns;
		
    
   -- 8254 setting (m_clk�� 8�����ؼ� sys_clk�� ����� ���� �Ʒ��� ���� �����ϸ�˴ϴ�
	CMD_WR("101000011","00110110",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
		wait for 10 us;
	CMD_WR("101000000","00001000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);	-- LSB 08
		wait for 10 us;
	CMD_WR("101000000","00000000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- MSB 00
		wait for 10 us;
		
		
    -- write 		

   for i in 2 to 51 loop
      s_data <= std_logic_vector(to_unsigned(i,s_data'length));
      CMD_WR("101100000",s_data,m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;
   end loop;
   wait for 10 us;


   
    -- read   


   for i in 1 to 50 loop
      CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;
   end loop;
   wait for 10 us;
		
		
		
-------- filter -----------

	CMD_WR("101110000","00001000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);   -- RAM02갰기
      wait for 1 us;	
	 

   
    -- read   


      
  for i in 1 to 250 loop
      CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;
   end loop;
   wait for 10 us;
		


 
		
		
	----------- �ٽ� �׽�Ʈ---------

		
		
    -- write 		

		
		CMD_WR("101100000","00000001",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);   -- RAM02갰기
      wait for 1 us;
		CMD_WR("101100000","00000010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;
      CMD_WR("101100000","00000100",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;
      CMD_WR("101100000","00001000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;
		CMD_WR("101100000","00001001",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);   -- RAM02갰기
      wait for 1 us;
		CMD_WR("101100000","00001010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;
      CMD_WR("101100000","00001011",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;
      CMD_WR("101100000","00001100",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;

   
    -- read   


      
   CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
	 CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;

		
	 

-----ram1
	 -- write 		

		
		CMD_WR("101100010","00000001",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);   -- RAM02갰기
      wait for 1 us;
		CMD_WR("101100010","00000010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;
      CMD_WR("101100010","00000100",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;
      CMD_WR("101100010","00001000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;
		CMD_WR("101100010","00001001",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);   -- RAM02갰기
      wait for 1 us;
		CMD_WR("101100010","00001010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;
      CMD_WR("101100010","00001011",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;
      CMD_WR("101100010","00001100",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;

   
    -- read   


      
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
	 CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;




--- ra,0 �ٽ�

    -- write 		

		
		CMD_WR("101100000","10000001",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);   -- RAM02갰기
      wait for 1 us;
		CMD_WR("101100000","10000001",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;
      CMD_WR("101100000","10000010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;
      CMD_WR("101100000","10000011",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;
		CMD_WR("101100000","10000100",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);   -- RAM02갰기
      wait for 1 us;
		CMD_WR("101100000","10000101",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;
      CMD_WR("101100000","10000110",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;
      CMD_WR("101100000","10000111",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
      wait for 1 us;

   
    -- read   


      
   CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
	 CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
		
		
		
		
		
		
		------- Ʈ������--
	CMD_WR("101100100","10000001",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);   -- RAM02갰기
      wait for 1 us;
		
		
		-------- ram1 read 2��
		      
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
	 CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;      
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
	 CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
   CMD_RD("101100010",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM02갽기
      wait for 1 us;
		
		
		

		
		
		
	   --      -- AD mode
   CMD_WR("101101010","00001000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);
   wait for 10 us;
	
	
	CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM0 read
      wait for 1 us;
   CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM0 read
      wait for 1 us;
   CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM0 read
      wait for 1 us;
	CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM0 read
      wait for 1 us;
	CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM0 read
      wait for 1 us;
	CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM0 read
      wait for 1 us;
   CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM0 read
      wait for 1 us;
   CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM0 read
      wait for 1 us;
	CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM0 read
      wait for 1 us;
	CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM0 read
      wait for 1 us;
	CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM0 read
      wait for 1 us;
   CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM0 read
      wait for 1 us;
   CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM0 read
      wait for 1 us;
	CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM0 read
      wait for 1 us;
	CMD_RD("101100000",m_address,m_data,m_cmd_data,m_wen,m_ren,m_ready);  -- RAM0 read
      wait for 1 us;
		
		
			
		
		
		
		
   end process;
end behavior;