
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity PCFG_TOP is
PORT( ---------------------------------------------INPUT
	 	m_reset_b : IN std_logic;								
		m_clk : IN std_logic;		
		m_address : IN std_logic_vector(8 downto 0);		
		m_cmd_data : IN std_logic;
		m_wen : IN std_logic;
		m_ren : IN std_logic;
		
		m_ADC_data : IN std_logic_vector(7 downto 0);
		
	
		 
		---------------------------------------------OUTPUT
		 
		m_ready : OUT std_logic;		
		
		m_DAC_data : OUT std_logic_vector(7 downto 0);
		m_DAC_clk : OUT std_logic;
		
		m_AD9283_clk : OUT std_logic;	
		
		-------------------------------------------------INOUT
		
		m_data : INOUT std_logic_vector(7 downto 0);
		
		-------------------------------------------------simulation위한 port
		
		m_led : OUT std_logic_vector(7 downto 0);
		m_TP		: out std_logic_vector(1 downto 0)
		
		);
end PCFG_TOP;


architecture Behavioral of PCFG_TOP is



signal s_ready : std_logic;			



------ addr_ decoder

component AD is
   Port ( AD_in : in  STD_LOGIC_VECTOR (8 downto 0);
          pcs_addr : out  STD_LOGIC;
          MC_addr : out  STD_LOGIC_VECTOR (3 downto 0));
end component;

signal s_pcs_addr : std_logic;
signal s_mc_addr : std_logic_vector(3 downto 0);


---8254
component top_8254 is
Port ( m_clk0    : in  STD_LOGIC;
	  m_clk1    : in  STD_LOGIC;
	  m_clk2    : in  STD_LOGIC;
	  m_clk_ctr : in  STD_LOGIC;
	  m_reset   : in STD_LOGIC;
	  m_data    : in  STD_LOGIC_VECTOR (7 downto 0);
	  m_gate0   : in  STD_LOGIC;
	  m_gate1   : in  STD_LOGIC;
	  m_gate2   : in  STD_LOGIC;
	  m_addr    : in  STD_LOGIC_VECTOR (1 downto 0);
	  m_cs_b    : in  STD_LOGIC;
	  m_wr_b    : in  STD_LOGIC;
	  	  
	  m_out0    : out  STD_LOGIC;
	  m_out1    : out  STD_LOGIC;
	  m_out2    : out  STD_LOGIC);
end component;

signal s_reset : std_logic;
signal sys_clk				: std_logic;
signal s_m_8254_gate0				: std_logic; 
signal s_m_8254_gate1				: std_logic; 
signal s_m_8254_gate2				: std_logic; 

---- filter 
component filter_interp is
    Port ( m_filter_in : in  STD_LOGIC_VECTOR (7 downto 0);
           m_filter_out : out  STD_LOGIC_VECTOR (7 downto 0);
			  m_filter_en : in  STD_LOGIC;
			  m_filter_sel : in  STD_LOGIC;
           m_reset : in  STD_LOGIC;
           m_clk : in  STD_LOGIC
			  );
end component;

signal s_filter_en : std_logic;
signal s_filter_sel : std_logic;
signal s_filter_out : STD_LOGIC_VECTOR (7 downto 0);
signal s_filter_in : STD_LOGIC_VECTOR (7 downto 0);


---TRI_STATE_BUFFER
component TRI_STATE_BUFFER is
PORT(   bidir   : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        oe		 : IN STD_LOGIC;
		  ie		 : IN STD_LOGIC;
        inp     : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        outp    : OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
end component;

signal s_tri_bidir : std_logic_vector(7 downto 0);
signal s_tri_in : std_logic_vector(7 downto 0);
signal s_tri_out : std_logic_vector(7 downto 0);
signal s_tri_en			: std_logic;



--- Control Signal Generator
component csg is
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
           m_ram0_ren : out  STD_LOGIC;
           m_ram1_wen : out  STD_LOGIC_vector(0 downto 0);
           m_ram1_ren : out  STD_LOGIC;
           m_mux_in_sel : out STD_LOGIC_vector(1 downto 0);
           m_mux_out_sel : out STD_LOGIC_vector(1 downto 0);
           m_mux_tran_sel : out STD_LOGIC_vector(1 downto 0);
			  m_reset : in  STD_LOGIC;
			  m_filter_en : out std_logic;
			  m_filter_sel : out std_logic
			  );	
end component;

signal s_addr_ram0 : std_logic_vector(10 downto 0);
signal s_addr_ram1 : std_logic_vector(10 downto 0);
signal s_led : std_logic_vector(7 downto 0);
signal s_latch_out			: std_logic;
signal s_latch_in			: std_logic;
signal s_mux_trans_sel				: std_logic_vector(1 downto 0);
signal s_mux_out_sel				: std_logic_vector(1 downto 0);
signal s_mux_in_sel				: std_logic_vector(1 downto 0);
signal s_ram1_ren				: std_logic;
signal s_ram1_wen				: std_logic;
signal s_ram0_ren				: std_logic;
signal s_ram0_wen				: std_logic;
signal s_latch_dac				: std_logic;
signal s_latch_adc				: std_logic;
signal s_ram1_wea : std_logic_vector(0 downto 0);
signal s_ram0_wea : std_logic_vector(0 downto 0);

--DUAL_PORT_RAM
component ram is
PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;

signal s_ram0_dout : std_logic_vector(7 downto 0);
signal s_ram1_dout : std_logic_vector(7 downto 0);


-------latch

component latch is
    Port ( latchin : in  STD_LOGIC_VECTOR (7 downto 0);
           latchout : out  STD_LOGIC_VECTOR (7 downto 0);
           latchclk : in  STD_LOGIC;
           latchrst : in  STD_LOGIC;
           latchen : in  STD_LOGIC);

end component;

			  signal s_latchin_out : STD_LOGIC_VECTOR (7 downto 0);
           signal s_latchout_out :   STD_LOGIC_VECTOR (7 downto 0);
           signal s_latchadc_out :  STD_LOGIC_VECTOR (7 downto 0);
     
	  
---mux
component mux is
    Port ( din0 : in STD_LOGIC_vector(7 downto 0);
           din1 : in STD_LOGIC_vector(7 downto 0);
			  din2 : in STD_LOGIC_vector(7 downto 0);
           sel : in  STD_LOGIC_vector(1 downto 0);
			  reset : in STD_LOGIC;	
           dout : out STD_LOGIC_vector(7 downto 0));
end component;

component mux_trans is
    Port ( din0 : in STD_LOGIC_vector(7 downto 0);
           din1 : in STD_LOGIC_vector(7 downto 0);
			  din2 : in STD_LOGIC_vector(7 downto 0);
           sel : in  STD_LOGIC_vector(1 downto 0);
			  reset : in STD_LOGIC;	
           dout : out STD_LOGIC_vector(7 downto 0));
			  
end component;


signal s_mux0_out : std_logic_vector (7 downto 0);
signal s_mux1_out : std_logic_vector (7 downto 0);
signal s_mux2_out : std_logic_vector (7 downto 0);

	  
      
begin

	AD1: AD port map (
			AD_in=>m_address,
			pcs_addr=>s_pcs_addr,
			MC_addr=>s_mc_addr);
	
	
	s_m_8254_gate0	<= '1';
	s_m_8254_gate1	<= '1';
	s_m_8254_gate2	<= '1';

	TOP8254: top_8254 port map (
			m_clk0=> m_clk,
			m_clk1 => m_clk,
			m_clk2 => m_clk,
			m_clk_ctr => m_clk,
			m_gate0=>s_m_8254_gate0,
			m_gate1=>s_m_8254_gate1,
			m_gate2=>s_m_8254_gate2,
			m_addr=> m_address(1 downto 0),
			m_cs_b => not s_pcs_addr,
			m_wr_b => not m_wen,
			m_out0 => sys_clk,
			
			
			m_data => s_tri_out,
			m_reset => not m_reset_b
			);
			
			
			
	TSB: tri_state_buffer port map (	
				bidir=>m_data,
				oe=>s_tri_en,
				ie=>m_wen,
				inp=>s_latchout_out,
				outp=>s_tri_out);
				
				
		CSG1: csg port map (	
				m_clk=>sys_clk,
				m_pcs_addr=>s_pcs_addr,
				m_mode_control_addr=>s_mc_addr,
				m_cmd_data => m_cmd_data,
				ad_data => m_data,
				m_latch_out_en => s_latch_out,
				m_latch_in_en=>s_latch_in,
				m_wen=>m_wen,
				m_ren=>m_ren,
				m_ready=>s_ready,
				m_tri_buffer_en=>s_tri_en,
				m_addr_ram0=>s_addr_ram0,
				m_addr_ram1=>s_addr_ram1,
				m_mux_in_sel=>s_mux_in_sel,
				m_mux_out_sel=>s_mux_out_sel,
				m_mux_tran_sel=>s_mux_trans_sel,
				m_ram0_wen=>s_ram0_wea,
				m_ram0_ren=>s_ram0_ren,
				m_ram1_wen=>s_ram1_wea,
				m_ram1_ren=>s_ram1_ren,
				m_latch_dac_en=>s_latch_dac,
				m_latch_adc_en=>s_latch_adc,
				m_led=>s_led,
				m_reset=> s_reset,
				m_filter_en => s_filter_en,
			   m_filter_sel => s_filter_sel
				);
		
		s_ram0_wen <= s_ram0_wea(0);
		s_ram1_wen <= s_ram1_wea(0);
		
		filter_version2 : filter_interp port map(
			m_filter_in => s_ram0_dout,
		   m_clk => sys_clk,
		   m_reset => s_reset,
		   m_filter_en => s_filter_en,
		   m_filter_sel => s_filter_sel,
		   m_filter_out => s_filter_out
			);
		
		ram0 : ram port map(
			 clka	=> sys_clk,
			 ena	=> s_ram0_wen,
			 wea	=> s_ram0_wea,
			 addra=> s_addr_ram0,
			 dina	=> s_mux0_out,
			 clkb	=> sys_clk,
			 enb	=> s_ram0_ren,
			 addrb=> s_addr_ram0,
			 doutb=> s_ram0_dout
			 );

		ram1 : ram port map(
   		 clka	=> sys_clk,
			 ena	=> s_ram1_wen,
			 wea	=> s_ram1_wea,
			 addra=> s_addr_ram1,
			 dina	=> s_mux1_out,
			 clkb	=> sys_clk,
			 enb	=> s_ram1_ren,
			 addrb=> s_addr_ram1,
			 doutb=> s_ram1_dout
			 );
	


	LatchIn: latch port map(
				latchin => s_tri_out,
				latchout => s_latchin_out,
				latchen=>s_latch_in,
				latchclk=>sys_clk,
				latchrst=> not s_reset
				);
				
		
	LatchOut: latch port map(
				latchin => s_mux2_out,
				latchout => s_latchout_out,
				latchen=>s_latch_out,
				latchclk=>sys_clk,
				latchrst=> not s_reset
				);
				
	LatchDAC: latch port map(
				latchin => s_mux2_out,
				latchout => m_dac_data,
				latchen=> s_latch_dac,
				latchclk=> not sys_clk,
				latchrst=> not s_reset
				);
				
	LatchADC: latch port map(
				latchin => m_adc_data,
				latchout => s_latchadc_out,
				latchen=> s_latch_adc,
				latchclk=>sys_clk,
				latchrst=> not s_reset
				);
								
	
	mux0 : mux port map(
			din0 => s_latchin_out,
			din1=> s_latchadc_out,
			din2=> s_ram1_dout,
			sel=> s_mux_in_sel,
			dout=>s_mux0_out,
			reset=> s_reset);
			
	mux1 : mux_trans port map(
			din0 => s_filter_out,
			din1=> s_mux0_out,
			din2=> s_ram0_dout,
			sel=> s_mux_trans_sel,
			dout=>s_mux1_out,
			reset=> s_reset);
			
	mux2 : mux port map(
			din0 => s_ram0_dout,
			din1=> s_ram1_dout,
			din2=> (others=>'Z'),
			sel=> s_mux_out_sel,
			dout=>s_mux2_out,
			reset=> s_reset);
				
				
				
				
				
				
-- signal들을 8254 gate들과 연결하여 주세요

s_m_8254_gate0	<= '1';
s_m_8254_gate1	<= '1';
s_m_8254_gate2	<= '1';

----------기본 output 들
m_DAC_clk <= sys_clk;
m_ready<=s_ready;
		
m_TP(0)	<= m_clk;
m_TP(1)	<= sys_clk; --- 의무 (sys_clk 은 signal로 선언하신 후 8254 module에서 분주되어 나오는 clk을 연결하시면 되요~) 

m_led(0) <= s_ready;--- 의무
m_led(1) <= m_wen;
m_led(2) <= s_tri_en;
m_led(3) <= '0';

m_AD9283_clk <= sys_clk;

m_led (7 downto 4) <= s_led ( 3 downto 0);


--------------- 8254에는 m_reset 물리고, 나머지에는 180H와 m_reset묶어서 s_reset으로 하여 입력.

		process (m_reset_b, s_mc_addr)
				begin
				
				 if (m_reset_b='1' and not(s_mc_addr="1000")) then
					s_reset<='1';
					
				else
					s_reset<='0';
					
				end if;
				
				end process;
				



-- m_led 1부터 7까지는 DEBUGGING 하고 싶은 핀을 MAPPING하세요


end Behavioral;