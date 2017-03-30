--******************************************************************************
-- PHOS SRU
-- Designer : Fan Zhang (zhangfan@mail.hbut.edu.cn)
-- Last Updated: 2015-06-25
--*******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity siu_top is
  generic (CH : integer range 0 to 11 := 0);
  port (
    reset : out std_logic;
    reset_dcs : in std_logic;

    tx_clk   : in    std_logic;
    tx_en    : out   std_logic;
    tx_er    : out   std_logic;
    txd      : out   std_logic_vector (15 downto 0);
    rx_clk   : in    std_logic;
    rx_dv    : in    std_logic;
    rx_er    : in    std_logic;
    rxd      : in    std_logic_vector (15 downto 0);
    prbsen   : out   std_logic;
    loopen   : out   std_logic;
    enable   : out   std_logic;
    lckrefn  : out   std_logic;
    --
    fbD      : inout std_logic_vector (31 downto 0);
    fbTEN_N  : inout std_logic;
    fbCTRL_N : inout std_logic;
    fiBEN_N  : out   std_logic;
    fiDIR    : out   std_logic;
    fiLF_N   : out   std_logic;
    foBSY_N  : in    std_logic;
    foCLK    : in    std_logic;
    --
    -- Unused DIU pins reserved as inputs
    --rod      : in  std_logic_vector (31 downto 0);
    --rocmd_n  : in  std_logic;
    --roten_n  : in  std_logic;
    ----
    --tap_tck  : in    std_logic;
    --tap_tdo  : in    std_logic;
    --tap_tdi  : in    std_logic;
    --tap_trst : in    std_logic;
    --tap_tms  : in    std_logic;
    --self_tdo : in    std_logic;         -- reserved as input
    --self_tdi : in    std_logic;         -- reserved as input
    --self_tms : in    std_logic;         -- reserved as input
    --self_tck : in    std_logic;         -- reserved as input
    --
    ot_los   : in    std_logic;
    ot_td    : out   std_logic;
    ot_tf    : in    std_logic;
    ot_rs    : in    std_logic;         -- reserved as input
    md       : in    std_logic_vector ( 2 downto 0);
    --
    ddl_mode : out   std_logic_vector ( 1 downto 0);
	 led1     : out   std_logic;
    led2     : out   std_logic;
    led3     : out   std_logic;         -- GREENLED
    led4     : out   std_logic;         -- REDLED
    pm_dout  : in    std_logic;
    pm_ncs   : out   std_logic;
    pm_clk   : out   std_logic;
    i2c_scl  : out   std_logic;
    i2c_sda  : inout std_logic;
    pwr_good : in    std_logic;
    -- SET_SPEED
	 siusn : in std_logic_vector(31 downto 0);
    set_speed : in std_logic_vector(1 downto 0)
    );

end siu_top;

library ieee;
use ieee.std_logic_1164.all;

use work.siu_my_conversions.all;
use work.siu_my_utilities.all;

architecture SYN of siu_top is

  signal s_rxd      : std_logic_vector (15 downto 0);
  signal s_rx_dv    : std_logic;
  signal s_rx_er    : std_logic;
  signal s_ot_sd    : std_logic;
  signal s_ot_tf    : std_logic;
  signal s_arst    : std_logic := '0';
  signal s_sreset   : std_logic;
  signal s_por   		: std_logic;
  signal s_sd_los   : std_logic;
  signal s_txd      : std_logic_vector (15 downto 0);
  signal s_tx_en    : std_logic;
  signal s_tx_er    : std_logic;
  signal tx_clk_2   : std_logic;
  signal tx_data    : std_logic;
  signal tx_xoff    : std_logic;
  --signal s_por      : std_logic;
  signal ddl_reset  : std_logic;

  component siu_rx_in
    port (
      clock   : in  std_logic;            -- receiver clock
      arst   : in  std_logic;            -- async reset (active low)
      ot_sd   : in  std_logic;            -- OT signal detect
      rxd     : in  std_logic_vector (15 downto 0);
      rx_dv   : in  std_logic;            -- SERDES receiver data valid
      rx_er   : in  std_logic;            -- SERDES receiver error
      rxidle  : out std_logic;            -- Idle stream is detected
      rxlosy  : out std_logic;            -- Loss of Synchronization
      suspend : out std_logic;            -- Suspend is received
      por     : out std_logic);           -- Power-on Reset (active high)
  end component;
  signal s_rxidle  : std_logic;
  signal s_rxlosy  : std_logic;
  signal s_suspend : std_logic;
  --signal s_por     : std_logic;

  component siu_rx_crc
    port (
      clock   : in  std_logic;            -- receiver clock
      arst   : in  std_logic;            -- async reset (active low)
      por     : in  std_logic;            -- Power-on Reset (active high)
      rxd     : in  std_logic_vector (15 downto 0);
      rx_dv   : in  std_logic;            -- SERDES receiver data valid
      rx_er   : in  std_logic;            -- SERDES receiver error
      err_clr : in  std_logic;            -- Clear errors
      err_crc : out std_logic);           -- CRC error
  end component;
  signal s_err_crc : std_logic;

  component siu_rx_cmd
    port (
      clock      : in  std_logic;         -- receiver clock
      arst      : in  std_logic;         -- async reset (active low)
      por        : in  std_logic;         -- Power-on Reset (active high)
      rxd        : in  std_logic_vector (15 downto 0);
      rx_dv      : in  std_logic;         -- SERDES receiver data valid
      rx_er      : in  std_logic;         -- SERDES receiver error
      rx_diag    : out std_logic;         -- Diagnostic frame received
      rx_dxdata  : out std_logic_vector (15 downto 0);
      scmd_data  : out std_logic_vector (31 downto 0);
      scmd_req   : out std_logic;         -- SIU command request
      scmd_ack   : in  std_logic;         -- SIU command is serviced
      jcmd_data  : out std_logic_vector (31 downto 0);
      jcmd_req   : out std_logic;         -- JTAG command reqest
      jcmd_ack   : in  std_logic;         -- JTAG command is serviced
      err_clr    : in  std_logic;         -- Clear errors
      err_scof   : out std_logic;         -- SIU command overflow
      err_jcof   : out std_logic;         -- JTAG command overflow
      err_osincf : out std_logic;         -- Ordered set inside the fram
      err_cframe : out std_logic);        -- Incomplete frame
  end component;
  signal s_rxdiag     : std_logic;
  signal s_rxdxdata   : std_logic_vector (15 downto 0);
  signal s_scmd_data  : std_logic_vector (31 downto 0);
  signal s_scmd_req   : std_logic;
  signal s_jcmd_data  : std_logic_vector (31 downto 0);
  signal s_jcmd_req   : std_logic;
  signal s_err_scof   : std_logic;
  signal s_err_jcof   : std_logic;
  signal s_err_osincf : std_logic;
  signal s_err_cframe : std_logic;

  component siu_rx_data
    port (
      clock      : in  std_logic;         -- receiver clock
      arst      : in  std_logic;         -- async reset (active low)
      por        : in  std_logic;         -- Power-on Reset (active high)
      rxd        : in  std_logic_vector (15 downto 0);
      rx_dv      : in  std_logic;         -- SERDES receiver data valid
      rx_er      : in  std_logic;         -- SERDES receiver error
      jtag_open  : in  std_logic;         -- JTAG stream is open
      rxdf_d     : out std_logic_vector (32 downto 0);
      rxdf_wrreq : out std_logic;         -- Receiver FIFO write request
      rxdf_full  : in  std_logic;         -- Receiver FIFO full (error)
      err_clr    : in  std_logic;         -- Clear errors
      err_frlen  : out std_logic;         -- Too long frame
      err_osindf : out std_logic;         -- Ordered set inside the frame
      err_ivsof  : out std_logic;         -- Invalid SOF
      err_ildata : out std_logic;         -- Data word out of frame
      err_rxfull : out std_logic;         -- Receiver FIFO overflow
      err_icindf : out std_logic;         -- Invalid character inside the frame
      err_dframe : out std_logic);        -- Incomplete frame
  end component;
  signal s_rxdf_d     : std_logic_vector (35 downto 0);
  signal s_rxdf_wrreq : std_logic;
  signal s_err_frlen  : std_logic;
  signal s_err_osindf : std_logic;
  signal s_err_ivsof  : std_logic;
  signal s_err_ildata : std_logic;
  signal s_err_rxfull : std_logic;
  signal s_err_icindf : std_logic;
  signal s_err_dframe : std_logic;

  component siu_lm_siu
    port (
      clock       : in  std_logic;         -- transmitter clock
      arst       : in  std_logic;         -- async reset (active low)
      ot_sd       : in  std_logic;         -- OT signal detect
      ot_lon      : out std_logic;         -- OT laser on
      sd_enable   : out std_logic;         -- SERDES enable
      sd_los      : in  std_logic;         -- SERDES loss of signal (rx_dv)
      sd_prbsen   : out std_logic;         -- SERDES pseudo-random bit gen. ena.
      rx_dxdata   : in  std_logic_vector (15 downto 0);
      rx_suspend  : in  std_logic;         -- Suspend signal is detected
      rx_losy     : in  std_logic;         -- Loss of receiver synchronization
      tx_dxdata   : out std_logic_vector (15 downto 0);
      tx_txdiag   : out std_logic;         -- Transmit diagnostic frame
      tx_txidle   : out std_logic;         -- Transmit Idle stream
      lm_prbsen   : in  std_logic;         -- Pseudo-random bit gen. enable
      lm_status   : out std_logic_vector ( 2 downto 0);
      rxdf_afull  : in  std_logic;
      rxdf_aempty : in  std_logic);
  end component;
  signal s_ot_lon    : std_logic;
  signal s_sd_prbsen : std_logic;
  signal s_txdxdata  : std_logic_vector (15 downto 0);
  signal s_txdiag    : std_logic;
  signal s_txidle    : std_logic;
  signal s_lm_status : std_logic_vector ( 2 downto 0);

  component siu_cm_siu
    port (
      clock       : in  std_logic;        -- transmitter clock
      arst       : in  std_logic;        -- async reset (active low)
      lm_status   : in  std_logic_vector ( 2 downto 0);
      lm_prbsen   : out std_logic;        -- Pseudo-random bit gen. enable
      scmd_data   : in  std_logic_vector (31 downto 0);
      scmd_req    : in  std_logic;        -- SIU command request
      scmd_ack    : out std_logic;        -- SIU command acknowledged
      jcmd_data   : in  std_logic_vector (31 downto 0);
      jcmd_req    : in  std_logic;        -- JTAG command request
      jcmd_ack    : out std_logic;        -- JTAG command acknowledged
      txst_data   : out std_logic_vector (31 downto 0);
      txst_req    : out std_logic;        -- Transmit status request
      txst_ack    : in  std_logic;        -- Transmit status acknowledged
      jtag_open   : out std_logic;        -- JTAG stream is open
      bwtr_open   : in  std_logic;        -- Block write stream is open
      fb_lben     : out std_logic;        -- Front-end Bus loopback enable
      i2c_address : out std_logic_vector ( 7 downto 0);
      i2c_wrdata  : out std_logic_vector ( 7 downto 0);
      i2c_rddata  : in  std_logic_vector ( 7 downto 0);
      i2c_rdwrn   : out std_logic;
      i2c_req     : out std_logic;
      i2c_ack     : in  std_logic;
      i2c_error   : in  std_logic;
      pm_value    : in  std_logic_vector (12 downto 0);
      err_clear   : out std_logic;        -- Clear errors
      err_levnt   : in  std_logic;        -- Too long frame
      err_ilfdat  : in  std_logic;        -- Illegal data word from the FEE
      err_ilfsts  : in  std_logic;        -- Illegal status word from the FEE
      err_txof    : in  std_logic;        -- Transmit FIFO overflow
      err_wrdata  : in  std_logic;        -- Illegal data from the link
      err_osinfr  : in  std_logic;        -- Ordered set inside the frame
      err_icindf  : in  std_logic;        -- SERDES indicates invalid chracter
      err_crc     : in  std_logic;        -- CRC error
      err_ildata  : in  std_logic;        -- Data word out of frame
      err_ivsof   : in  std_logic;        -- Invalid frame delimiter
      err_frlen   : in  std_logic;        -- Frame length error
      err_rxof    : in  std_logic;        -- Receiver overflow
      err_frame   : in  std_logic;        -- Frame error (incomplete)
      err_block   : in  std_logic;        -- Block length mismatch
      err_prot    : in  std_logic;        -- Protocol error
      fee_isidle  : in  std_logic);       -- FEE bus is in idle state
  end component;
  signal s_lm_prbsen   : std_logic;
  signal s_scmd_ack    : std_logic;
  signal s_jcmd_ack    : std_logic;
  signal s_txst_data   : std_logic_vector (31 downto 0);
  signal s_txst_req    : std_logic;
  signal s_jtag_open   : std_logic;
  signal s_fb_lben     : std_logic;
  signal s_i2c_address : std_logic_vector ( 7 downto 0);
  signal s_i2c_wrdata  : std_logic_vector ( 7 downto 0);
  signal s_i2c_rdwrn   : std_logic;
  signal s_i2c_req     : std_logic;
  signal s_err_clr     : std_logic;
  signal s_err_osinfr  : std_logic;
  signal s_err_rxof    : std_logic;
  signal s_err_frame   : std_logic;

  component siu_framing
    port (
      clock      : in  std_logic;         -- transmitter clock
      arst      : in  std_logic;         -- asynch reset
      txidle     : in  std_logic;         -- Force IDLE
      txdiag     : in  std_logic;         -- Send diagnostic frame
      txdf_empty : in  std_logic;         -- TX FIFO empty
      txdf_rdreq : out std_logic;         -- TX FIFO read request
      txdf_q     : in  std_logic_vector (33 downto 0);  -- TX FIFO data
      txst_req   : in  std_logic;         -- Transmit status request
      txst_ack   : out std_logic;         -- Transmit status acknowledge
      txst_data  : in  std_logic_vector (31 downto 0);  -- TX status data
      tx_dxdata  : in  std_logic_vector (15 downto 0);  -- diagnostic data
      perr       : in  std_logic;         -- Parity error
      txd        : out std_logic_vector (15 downto 0);  -- SERDES data
      tx_en      : out std_logic;         -- SERDES data enable
      tx_er      : out std_logic);        -- SERDES error indication
  end component;
  signal s_txdf_rdreq : std_logic;
  signal s_txst_ack   : std_logic;

  component siu_fee_if
    port (
      foclk       : in    std_logic;
      arst       : in    std_logic;
      fiten       : in    std_logic;
      fictrl      : in    std_logic;
      fid         : in    std_logic_vector (31 downto 0);
      foten       : out   std_logic;
      foctrl      : out   std_logic;
      fod         : out   std_logic_vector (31 downto 0);
      fb_oen      : out   std_logic;
      fb_lben     : in    std_logic;
      fiben_n     : out   std_logic;
      fidir       : out   std_logic;
      filf_n      : out   std_logic;
      fobsy_n     : in    std_logic;
      rxdf_q      : in    std_logic_vector (32 downto 0);
      rxdf_empty  : in    std_logic;
      rxdf_rdreq  : out   std_logic;
      bwtr_open   : out   std_logic;
      brtr_open   : out   std_logic;
      txdf_d      : out   std_logic_vector (33 downto 0);
      txdf_wrreq  : out   std_logic;
      txdf_full   : in    std_logic;
      txdf_afull  : in    std_logic;
      txdf_aempty : in   std_logic;
      err_ilfdat  : out   std_logic;
      err_ilfsts  : out   std_logic;
      err_txof    : out   std_logic;
      err_wrdata  : out   std_logic;
      err_prot    : out   std_logic;
      err_levnt   : out   std_logic;
      err_block   : out   std_logic;
      fee_isidle  : out   std_logic);
  end component;
  signal s_fiten      : std_logic;
  signal s_fictrl     : std_logic;
  signal s_fid        : std_logic_vector (31 downto 0);
  signal s_foten      : std_logic;
  signal s_foctrl     : std_logic;
  signal s_fod        : std_logic_vector (31 downto 0);
  signal s_fobsy_n    : std_logic;
  signal s_filf_n     : std_logic;
  signal s_fidir      : std_logic;
  signal s_fiben_n    : std_logic;
  signal s_fb_oen     : std_logic;
  signal s_rxdf_rdreq : std_logic;
  signal s_bwtr_open  : std_logic;
  signal s_brtr_open  : std_logic;
  signal s_txdf_d     : std_logic_vector (35 downto 0);
  signal s_txdf_wrreq : std_logic;
  signal s_err_ilfdat : std_logic;
  signal s_err_ilfsts : std_logic;
  signal s_err_txof   : std_logic;
  signal s_err_wrdata : std_logic;
  signal s_err_prot   : std_logic;
  signal s_err_levnt  : std_logic;
  signal s_err_block  : std_logic;
  signal s_fee_isidle : std_logic;

  --component siu_i2c_if
  --  port (
  --    clock       : in    std_logic;
  --    arst       : in    std_logic;
  --    i2c_address : in    std_logic_vector ( 7 downto 0);
  --    i2c_wrdata  : in    std_logic_vector ( 7 downto 0);
  --    i2c_rddata  : out   std_logic_vector ( 7 downto 0);
  --    i2c_rdwrn   : in    std_logic;
  --    i2c_req     : in    std_logic;
  --    i2c_ack     : out   std_logic;
  --    i2c_error   : out   std_logic;
  --    i2c_sda     : inout std_logic;
  --    i2c_scl     : out   std_logic);
  --end component;
  signal s_i2c_rddata : std_logic_vector ( 7 downto 0);
  signal s_i2c_ack    : std_logic;
  signal s_i2c_error  : std_logic;

  component siu_rxd_fifo
    port (
      wrclock     : in  std_logic;       -- receiver clock
      rdclock     : in  std_logic;       -- Interface clock
      clr         : in  std_logic;
      rxdf_d      : in  std_logic_vector (35 downto 0);
      rxdf_wrreq  : in  std_logic;
      rxdf_rdreq  : in  std_logic;
      rxdf_q      : out std_logic_vector (35 downto 0);
      rxdf_empty  : out std_logic;
      rxdf_full   : out std_logic;
      rxdf_afull  : out std_logic;
      rxdf_aempty : out std_logic);
  end component;
  signal s_rxdf_q      : std_logic_vector (35 downto 0);
  signal s_rxdf_empty  : std_logic;
  signal s_rxdf_full   : std_logic;
  signal s_rxdf_afull  : std_logic;
  signal s_rxdf_aempty : std_logic;

  component siu_txd_fifo
    port (
      wrclock     : in  std_logic;       -- Interface clock
      rdclock     : in  std_logic;       -- transmitter clock
      clr         : in  std_logic;
      txdf_d      : in  std_logic_vector (35 downto 0);
      txdf_wrreq  : in  std_logic;
      txdf_rdreq  : in  std_logic;
      txdf_q      : out std_logic_vector (35 downto 0);
      txdf_empty  : out std_logic;
      txdf_full   : out std_logic;
      txdf_afull  : out std_logic;
      txdf_aempty : out std_logic
      );
  end component;
  signal s_txdf_q      : std_logic_vector (35 downto 0);
  signal s_txdf_q32_n  : std_logic;
  signal s_txdf_empty  : std_logic;
  signal s_txdf_full   : std_logic; 
  signal s_txdf_afull  : std_logic; 
  signal s_txdf_aempty : std_logic;

  component siu_pm_if
    port (
      clock    : in  std_logic;
      arst    : in  std_logic;
      pm_clk   : out std_logic;
      pm_ncs   : out std_logic;
      pm_dout  : in  std_logic;
      pm_value : out std_logic_vector (12 downto 0));
  end component;
  signal s_pm_value : std_logic_vector (12 downto 0);

  component siu_parity_gen
    port (
      clock : in  std_logic;
      arst : in  std_logic;
      d     : in  std_logic_vector (31 downto 0);
      par   : out std_logic_vector ( 1 downto 0));
  end component;
  component siu_parity_chk
    port (
      clock : in  std_logic;
      arst : in  std_logic;
      d     : in  std_logic_vector (31 downto 0);
      ena   : in  std_logic;
      par   : in  std_logic_vector ( 1 downto 0);
      perr  : out std_logic);
  end component;
  signal s_rxpargen_d   : std_logic_vector (31 downto 0);
  signal s_rxpargen_par : std_logic_vector ( 1 downto 0);
  signal s_txpargen_par : std_logic_vector ( 1 downto 0);
  signal s_lb_par       : std_logic_vector (1 downto 0);
  signal s_perr         : std_logic;

  -- MTSTB
  attribute ASYNC_REG : string;
  signal rst_txclk_r1,rst_txclk_r2 : std_logic;
  signal rst_foclk_r1,rst_foclk_r2 : std_logic;
  attribute ASYNC_REG of rst_txclk_r1,rst_txclk_r2,rst_foclk_r1,rst_foclk_r2 : signal is "TRUE";  
  
  -- SYNC RESET_DCS
  signal reset_dcs_r1,reset_dcs_r2 : std_logic;
  
begin  -- SYN
  
  -- fix assignments
  lckrefn  <= '1';
  loopen   <= '0';
  ddl_reset <= s_sreset or s_por;


    p_sync : process(rx_clk)
  begin
    if rising_edge(rx_clk) then
      reset_dcs_r1 <= reset_dcs;
      reset_dcs_r2 <= reset_dcs_r1;
    end if;      
  end process;

  --=====================
  -- SRC CLK RX_CLK
  -- DST CLK TX_CLK FOCLK
  --=====================
  p_foclkmtstb : process(FOCLK)
    begin
      if rising_edge(FOCLK) then
        rst_foclk_r1 <= s_sreset;
        rst_foclk_r2 <= rst_foclk_r1;        
      end if;
  end process;

  p_txclkmtstb : process(TX_CLK)
  begin
    if rising_edge(TX_CLK) then
      rst_txclk_r1 <= s_sreset;
      rst_txclk_r2 <= rst_txclk_r1;
    end if;
  end process;

  proc_txclk_divider: process (tx_clk)
    variable tx_data_d1 : std_logic;
    variable tx_data_d2 : std_logic;
    variable tx_xoff_d1 : std_logic;
    variable tx_xoff_d2 : std_logic;
  begin  -- process proc_txclk_divider
    if tx_clk'event and tx_clk = '1' then  -- rising clock edge
      if rst_txclk_r2 = '1' then              -- asynchronous reset (active low)
        --tx_clk_2 <= '0';
        tx_data  <= '0';
        tx_xoff  <= '0';
        tx_data_d1 := '0';
        tx_data_d2 := '0';
        tx_xoff_d1 := '0';
        tx_xoff_d2 := '0';
      else
        --tx_clk_2 <= not tx_clk_2;
        tx_data  <= tx_data_d1 or tx_data_d2;
        tx_data_d2 := tx_data_d1;
        tx_data_d1 := s_txdf_rdreq;
        tx_xoff  <= tx_xoff_d1 or tx_xoff_d2;
        tx_xoff_d2 := tx_xoff_d1;
        tx_xoff_d1 := not s_rxdxdata(11) or not s_rxdxdata(10);
      end if;
    end if;
  end process proc_txclk_divider;


  proc_leds: process (tx_clk)
    variable link_down    : std_logic;
    variable link_full    : std_logic;
    variable link_data    : std_logic;
    variable test_mode    : std_logic;
    variable mode_sel     : std_logic_vector ( 1 downto 0);
    variable slot_timer   : std_logic_vector ( 1 downto 0);
    variable blink_timer  : std_logic_vector (23 downto 0);
    variable b_blink_to   : boolean;
    variable b_led_update : boolean;
    variable b_tx_data    : boolean;
    variable b_tx_xoff    : boolean;
  begin  -- process proc_leds
    if rising_edge(tx_clk) then  -- rising clock edge
		ddl_mode <= mode_sel;
      if rst_txclk_r2 = '1' then            -- asynchronous reset (active low)
        led1 <= '0';
        led2 <= '0';
        led3 <= '1';
        led4 <= '0';
		  
        link_down    := '1';
        link_full    := '0';
        link_data    := '0';
        test_mode    := '0';
        mode_sel     := "00";
        slot_timer   := "00";
        blink_timer  := "010100010000111111110100";
        b_blink_to   := false;
        b_led_update := false;
        b_tx_data    := false;
        b_tx_xoff    := false;
      else
        -- YELLOW
        led1     <= '1';
        -- YELLOW
        led2     <= '1';

        case mode_sel is
          when "00" =>
            led3 <= '1';
            led4 <= test_mode and slot_timer(0);
          when "01" =>
            led3 <= '0';
            led4 <= '1';
          when "10" =>
            led3 <= slot_timer(0);
            led4 <= '1';
          when "11" =>
            led3 <= link_data and slot_timer(0);
            led4 <= blink_timer(9) or (link_data and slot_timer(0));
          when others => null;
        end case;

        if b_led_update then
          if link_down = '1' or test_mode = '1' then
            mode_sel := "00";
          elsif b_tx_xoff then
            mode_sel := "11";
          elsif link_data = '1' then
            mode_sel := "10";
          else
            mode_sel := "01";
          end if;
        end if;

        -- If the slot timer expires, the link_full bit will be cleared
        -- else it will be set if the flow control is active.
        if b_led_update then
          link_full := '0';
        elsif b_tx_xoff then
          link_full := '1';
        end if;
        b_tx_xoff := tx_xoff = '1';

        -- If the slot timer expires, the link_data bit will be cleared,
        -- else it will be set if any data transfer occures in the slot
        if b_led_update then
          link_data := '0';
        elsif b_tx_data then
          link_data := '1';
        end if;
        b_tx_data := tx_data = '1';

        -- If the slot timer expires, the link_down bit will be cleared,
        -- else it will be set if any error occures in the slot
        if b_led_update then
          link_down := '0';
        elsif s_ot_sd = '0'  or
          s_ot_tf = '1'  or
          s_ot_lon = '0' or
          s_rxlosy = '1' or
          s_txdxdata(0) = '0' or
          s_txdxdata(1) = '0' then
          link_down := '1';
        end if;

        -- If the PRBS enable is active, the card is in test mode
        test_mode := s_sd_prbsen;

        -- The blink timer expires after 1/4 of the slot time.
        b_blink_to := blink_timer(23) = '1'; 
        if b_blink_to then
          blink_timer := "010100010000111111110100";
        else
          blink_timer := dec(blink_timer);
        end if;

        -- The LEDs should be updated at the beginning of the slot.
        b_led_update := b_blink_to and slot_timer = "11";

        -- One slot is four times the blink time.
        if b_blink_to then
          slot_timer := inc(slot_timer);
        end if;
      end if;
    end if;
  end process proc_leds;

  proc_rxin : process (rx_clk)
  begin  -- process proc_rxin
    if rx_clk'event and rx_clk = '1' then  -- rising clock edge
      if pwr_good = '0' then
        s_rxd   <= (others => '0');
        s_rx_dv <= '0';
        s_rx_er <= '0';
      else
        s_rxd   <= rxd;
        s_rx_dv <= rx_dv;
        s_rx_er <= rx_er;
      end if;
    end if;
  end process;

  srst_i : entity work.siu_srst
    port map (
      clk => rx_clk,
      reset    => reset_dcs_r2,
      pwr_good => pwr_good,
      s_rx_dv => s_rx_dv,
      s_rx_er => s_rx_er,
      s_rxd => s_rxd,
      srst => s_sreset
      );
  
  --process (tx_clk)
  --begin  -- process
  --  if tx_clk'event and tx_clk = '1' then  -- rising clock edge
  --    if pwr_good = '0' then              -- asynchronous reset (active low)
  --      s_arst <= '0';
  --    else
  --      s_arst <= not s_sreset;
  --    end if;
  --  end if;
  --end process;

  proc_otsd : process (tx_clk)
  begin
    if tx_clk'event and tx_clk = '1' then  -- rising clock edge
      s_ot_sd  <= not ot_los;
      s_ot_tf  <= ot_tf;
      s_sd_los <= not rx_dv;
    end if;
  end process;

  RXIN_INST : siu_rx_in
    port map (
      clock   => rx_clk,
      arst   => s_sreset,
      ot_sd   => s_ot_sd,
      rxd     => s_rxd,
      rx_dv   => s_rx_dv,
      rx_er   => s_rx_er,
      rxidle  => s_rxidle,
      rxlosy  => s_rxlosy,
      suspend => s_suspend,
      por     => s_por);

  RXCRC_INST : siu_rx_crc
    port map (
      clock   => rx_clk,
      arst   => s_sreset,
      por        => ddl_reset,
      --por        => s_sreset,-- or s_por,
      rxd     => s_rxd,
      rx_dv   => s_rx_dv,
      rx_er   => s_rx_er,
      err_clr => s_err_clr,
      err_crc => s_err_crc);

  RXCMD_INST : siu_rx_cmd
    port map (
      clock      => rx_clk,
      arst      => s_sreset,
      --por        => s_sreset or s_por,
      por        => ddl_reset,-- or s_por,
      rxd        => s_rxd,
      rx_dv      => s_rx_dv,
      rx_er      => s_rx_er,
      rx_diag    => s_rxdiag,
      rx_dxdata  => s_rxdxdata,
      scmd_data  => s_scmd_data,
      scmd_req   => s_scmd_req,
      scmd_ack   => s_scmd_ack,
      jcmd_data  => s_jcmd_data,
      jcmd_req   => s_jcmd_req,
      jcmd_ack   => s_jcmd_ack,
      err_clr    => s_err_clr,
      err_scof   => s_err_scof,
      err_jcof   => s_err_jcof,
      err_osincf => s_err_osincf,
      err_cframe => s_err_cframe);

  RXDATA_INST : siu_rx_data
    port map (
      clock      => rx_clk,
      arst      => s_sreset,
      --por        => s_sreset or s_por,
      por        => ddl_reset,-- or s_por,
      rxd        => s_rxd,
      rx_dv      => s_rx_dv,
      rx_er      => s_rx_er,
      jtag_open  => s_jtag_open,
      rxdf_d     => s_rxdf_d(32 downto 0),
      rxdf_wrreq => s_rxdf_wrreq,
      rxdf_full  => s_rxdf_full,
      err_clr    => s_err_clr,
      err_frlen  => s_err_frlen,
      err_osindf => s_err_osindf,
      err_ivsof  => s_err_ivsof,
      err_ildata => s_err_ildata,
      err_rxfull => s_err_rxfull,
      err_icindf => s_err_icindf,
      err_dframe => s_err_dframe);

  LMSIU_INST : siu_lm_siu
    port map (
      clock       => tx_clk,
      arst        => rst_txclk_r2,
      ot_sd       => s_ot_sd,
      ot_lon      => s_ot_lon,
      sd_enable   => enable,
      sd_los      => s_sd_los,
      sd_prbsen   => s_sd_prbsen,
      rx_dxdata   => s_rxdxdata,
      rx_suspend  => s_suspend,
      rx_losy     => s_rxlosy,
      tx_dxdata   => s_txdxdata,
      tx_txdiag   => s_txdiag,
      tx_txidle   => s_txidle,
      lm_prbsen   => s_lm_prbsen,
      lm_status   => s_lm_status,
      rxdf_afull  => s_rxdf_afull,
      rxdf_aempty => s_rxdf_aempty);
  ot_td  <= not s_ot_lon;
  prbsen <= s_sd_prbsen;

  s_err_osinfr <= s_err_osindf or s_err_osincf;
  s_err_rxof   <= s_err_rxfull or s_err_scof or s_err_jcof;
  s_err_frame  <= s_err_dframe or s_err_cframe;
  CMSIU_INST : siu_cm_siu
    port map (
      clock       => tx_clk,
      arst        => rst_txclk_r2,
      lm_status   => s_lm_status,
      lm_prbsen   => s_lm_prbsen,
      scmd_data   => s_scmd_data,
      scmd_req    => s_scmd_req,
      scmd_ack    => s_scmd_ack,
      jcmd_data   => s_jcmd_data,
      jcmd_req    => s_jcmd_req,
      jcmd_ack    => s_jcmd_ack,
      txst_data   => s_txst_data,
      txst_req    => s_txst_req,
      txst_ack    => s_txst_ack,
      jtag_open   => s_jtag_open,
      bwtr_open   => s_bwtr_open,
      fb_lben     => s_fb_lben,
      i2c_address => s_i2c_address,
      i2c_wrdata  => s_i2c_wrdata,
      i2c_rddata  => s_i2c_rddata,
      i2c_rdwrn   => s_i2c_rdwrn,
      i2c_req     => s_i2c_req,
      i2c_ack     => s_i2c_ack,
      i2c_error   => s_i2c_error,
      pm_value    => s_pm_value,
      err_clear   => s_err_clr,
      err_levnt   => s_err_levnt,
      err_ilfdat  => s_err_ilfdat,
      err_ilfsts  => s_err_ilfsts,
      err_txof    => s_err_txof,
      err_wrdata  => s_err_wrdata,
      err_osinfr  => s_err_osinfr,
      err_icindf  => s_err_icindf,
      err_crc     => s_err_crc,
      err_ildata  => s_err_ildata,
      err_ivsof   => s_err_ivsof,
      err_frlen   => s_err_frlen,
      err_rxof    => s_err_rxof,
      err_frame   => s_err_frame,
      err_block   => s_err_block,
      err_prot    => s_err_prot,
      fee_isidle  => s_fee_isidle);

  FRAMING_INST : siu_framing
    port map (
      clock      => tx_clk,
      arst       => rst_txclk_r2,
      txidle     => s_txidle,
      txdiag     => s_txdiag,
      txdf_empty => s_txdf_empty,
      txdf_rdreq => s_txdf_rdreq,
      txdf_q     => s_txdf_q(33 downto 0),
      txst_req   => s_txst_req,
      txst_ack   => s_txst_ack,
      txst_data  => s_txst_data,
      tx_dxdata  => s_txdxdata,
      perr       => s_perr,
      txd        => s_txd,
      tx_en      => s_tx_en,
      tx_er      => s_tx_er);

  proc_tx_regs: process (tx_clk, pwr_good)
  begin  -- process proc_tx_regs
    if tx_clk'event and tx_clk = '1' then  -- rising clock edge
      if pwr_good = '0' then              -- asynchronous reset (active low)
        txd   <= (others => '0');
        tx_en <= '0';
        tx_er <= '0';
      else
        txd   <= s_txd;
        tx_en <= s_tx_en;
        tx_er <= s_tx_er;
      end if;
    end if;
  end process proc_tx_regs;

  fiLF_N   <= s_filf_n or s_fb_lben;
  fiDIR    <= s_fidir and not s_fb_lben;
  fiBEN_N  <= s_fiben_n or s_fb_lben;
  proc_fbdout: process (s_fb_oen, s_fod, s_foten, s_foctrl)
  begin  -- process proc_fbdout
    if s_fb_oen = '1' then
      fbD      <= s_fod;
      fbTEN_N  <= not s_foten;
      fbCTRL_N <= not s_foctrl;
    else
      fbD      <= (others => 'Z');
      fbTEN_N  <= 'Z';
      fbCTRL_N <= 'Z';
    end if;
  end process proc_fbdout;

  -- PAY attention here to be checked if the pwr_good signal is detected by
  -- foCLK 
  proc_fbdin : process (foCLK)
  begin
    if foCLK'event and foCLK = '1' then
      if pwr_good = '0' then
        s_fid    <= (others => '0');
        s_fiten  <= '0';
        s_fictrl <= '0';
      else
        s_fid    <= fbD;
        s_fiten  <= not fbTEN_N;
        s_fictrl <= not fbCTRL_N;
      end if;
    end if;
  end process;
  s_fobsy_n <= foBSY_N;

  FEEIF : siu_fee_if
    port map (
      foclk       => foCLK,
      arst        => rst_foclk_r2,
      fiten       => s_fiten,
      fictrl      => s_fictrl,
      fid         => s_fid,
      foten       => s_foten,
      foctrl      => s_foctrl,
      fod         => s_fod,
      fb_oen      => s_fb_oen,
      fb_lben     => s_fb_lben,
      fiben_n     => s_fiben_n,
      fidir       => s_fidir,
      filf_n      => s_filf_n,
      fobsy_n     => s_fobsy_n,
      rxdf_q      => s_rxdf_q(32 downto 0),
      rxdf_empty  => s_rxdf_empty,
      rxdf_rdreq  => s_rxdf_rdreq,
      bwtr_open   => s_bwtr_open,
      brtr_open   => s_brtr_open,
      txdf_d      => s_txdf_d(33 downto 0),
      txdf_wrreq  => s_txdf_wrreq,
      txdf_full   => s_txdf_full,
      txdf_afull  => s_txdf_afull,
      txdf_aempty => s_txdf_aempty,
      err_ilfdat  => s_err_ilfdat,
      err_ilfsts  => s_err_ilfsts,
      err_txof    => s_err_txof,
      err_wrdata  => s_err_wrdata,
      err_prot    => s_err_prot,
      err_levnt   => s_err_levnt,
      err_block   => s_err_block,
      fee_isidle  => s_fee_isidle);

  I2CIF_INST : entity work.siu_i2c_if
    generic map (CH => CH)
    port map (
      clock       => tx_clk,
      rst         => rst_txclk_r2,
      i2c_rddata  => s_i2c_rddata,
      i2c_req     => s_i2c_req,
      i2c_ack     => s_i2c_ack,
--		ip_sn			=> (x"30313439"),
		ip_sn			=> (siusn),
      --
      set_speed => set_speed );

  RXDF_INST : siu_rxd_fifo
    port map (
      wrclock     => rx_clk,
      rdclock     => foCLK,
      clr         => rst_foclk_r2,
      rxdf_d      => s_rxdf_d,
      rxdf_wrreq  => s_rxdf_wrreq,
      rxdf_rdreq  => s_rxdf_rdreq,
      rxdf_q      => s_rxdf_q,
      rxdf_empty  => s_rxdf_empty,
      rxdf_full   => s_rxdf_full,
      rxdf_afull  => s_rxdf_afull,
      rxdf_aempty => s_rxdf_aempty);

  TXDF_INST : siu_txd_fifo
    port map (
      wrclock     => foCLK,
      rdclock     => tx_clk,
      clr         => rst_txclk_r2,
      txdf_d      => s_txdf_d,
      txdf_wrreq  => s_txdf_wrreq,
      txdf_rdreq  => s_txdf_rdreq,
      txdf_q      => s_txdf_q,
      txdf_empty  => s_txdf_empty,
      txdf_full   => s_txdf_full,
      txdf_afull  => s_txdf_afull,
      txdf_aempty => s_txdf_aempty);

  INST_PMIF : siu_pm_if
    port map (
      clock    => tx_clk,
      arst     => rst_txclk_r2,
      pm_clk   => pm_clk,
      pm_ncs   => pm_ncs,
      pm_dout  => pm_dout,
      pm_value => s_pm_value);

  -- This process delays the parity bist stored in the RXDF fifo by two
  -- clock cycles. Signal s_lb_par should be in sync with the loop-back
  -- data on s_txdf_d(31 downto 0).
  process (foCLK)
    variable lb_par_d1 : std_logic_vector (1 downto 0);
  begin  -- process
    if foCLK'event and foCLK = '1' then  -- rising clock edge
      if rst_foclk_r2 = '1' then               -- asynchronous reset (active low)
        s_lb_par  <= (others => '0');
        lb_par_d1 := (others => '0');
      else
        s_lb_par  <= lb_par_d1;
        lb_par_d1 := s_rxdf_q(35 downto 34);
      end if;
    end if;
  end process;
  INST_PARGEN_TXDF : siu_parity_gen
    port map (
      clock => foCLK,
      arst => rst_foclk_r2,
      d     => s_fid,
      par   => s_txpargen_par);
  -- This process multiplexes the parity bits to be stored in the TXDF fifo.
  -- When s_fb_lben is set, the parity bits are taken from the RXDF fifo, which
  -- are delayed by two clock cycles. When the loop-back is disabled, the
  -- parity bits are taken from the parity generator.
  process (s_fb_lben, s_lb_par, s_txpargen_par)
  begin  -- process
    if s_fb_lben = '1' then
      s_txdf_d(35 downto 34) <= s_lb_par;
    else
      s_txdf_d(35 downto 34) <= s_txpargen_par;
    end if;
  end process;

  s_txdf_q32_n <= not s_txdf_q(32);

  INST_PARCHK_TXDF : siu_parity_chk
    port map (
      clock => tx_clk,
      arst  => rst_txclk_r2,
      d     => s_txdf_q(31 downto 0),
      par   => s_txdf_q(35 downto 34),
      ena   => s_txdf_q32_n,
      perr  => s_perr);

  -- In the receiver channel the parity bits are generated from the s_rxd
  -- signal. The parity bit of the lower half word is delayed by one clock
  -- cycle, in order to be in sync with the write signal of the RXDF fifo.
  process (rx_clk)
  begin  -- process
    if rx_clk'event and rx_clk = '1' then  -- rising clock edge
      if s_sreset = '1' then               -- asynchronous reset (active low)
        s_rxpargen_d <= (others => '0');
        s_rxdf_d(33) <= '0';
        s_rxdf_d(34) <= '0';
      else
        s_rxpargen_d <= s_rxd & s_rxd;
        s_rxdf_d(33) <= '0';
        s_rxdf_d(34) <= s_rxpargen_par(0);
      end if;
    end if;
  end process;
  s_rxdf_d(35) <= s_rxpargen_par(1);    -- No delay is needed here.
  INST_PARGEN_RXDF : siu_parity_gen
    port map (
      clock => rx_clk,
      arst  => s_sreset,
      d     => s_rxpargen_d,
      par   => s_rxpargen_par);

  reset <= s_sreset;
end SYN;
