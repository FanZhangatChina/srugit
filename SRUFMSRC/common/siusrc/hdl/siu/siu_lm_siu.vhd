--******************************************************************************
--*
--* Module          : TOP
--* File            : top.vhd
--* Library         : ieee
--* Description     : 
--* Author/Designer : Filippo Costa (filippo.costa@cern.ch)
--*
--*  Revision history:
--*     28-05-13 1.0 sync reset
--*   20-06-13 PC moved to active high synch reset
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity siu_lm_siu is
  
  port (
    clock       : in  std_logic;         -- transmitter clock
    arst        : in  std_logic;         -- async reset (active low)
    ot_sd       : in  std_logic;         -- OT signal detect
    ot_lon      : out std_logic;         -- OT laser on
    sd_enable   : out std_logic;         -- SERDES enable
    sd_los      : in  std_logic;         -- SERDES loss of signal (rx_dv)
    sd_prbsen   : out std_logic;         -- SERDES pseudo-random bit gen. enable
    rx_dxdata   : in  std_logic_vector (15 downto 0);
    rx_suspend  : in  std_logic;         -- Suspend signal is detected
    rx_losy     : in  std_logic;         -- Loss of receiver synchronization
    tx_dxdata   : out std_logic_vector (15 downto 0);
    tx_txdiag   : out std_logic;         -- Transmit diagnostic frame
    tx_txidle   : out std_logic;         -- Transmit Idle stream
    lm_prbsen   : in  std_logic;         -- Pseudo-random bit sequence enable
    lm_status   : out std_logic_vector ( 2 downto 0);
    rxdf_afull  : in  std_logic;
    rxdf_aempty : in  std_logic);

end siu_lm_siu;

library ieee;
use ieee.std_logic_1164.all;

use work.siu_my_conversions.all;
use work.siu_my_utilities.all;

architecture SYN of siu_lm_siu is

  -- type tx_state
  -- Controls the incoming data flow using the XON/XOFF, which are encoded
  -- in the diagnostic frames.
  type tx_state is (
    TX_DISABLED,
    TX_ENABLED
    );

  -- type rx_state
  -- Controls the outgoing data flow based on the local/remote link state,
  -- and the flow control (XON/XOFF) received in the diagnostic frames.
  type rx_state is (
    RX_DISABLED,
    RX_GOENA,
    RX_ENABLED,
    RX_GODIS
    );

  -- type lm_state
  -- Controls the link using the diagnostic frames.
  type lm_state is (
    LM_SIURESET,
    LM_LOWPOWER,
    LM_POWERONRST,
    LM_OFFLINE,
    LM_ONLINE,
    LM_TESTMODE,
    LM_RXSUSPEND,
    LM_GOLOWPWR
    );

  -- SYNC
  attribute SHREG_EXTRACT : string;
  signal rxdf_aempty_r1,rxdf_aempty_r2 : std_logic;
  signal rx_losy_r1,rx_losy_r2 : std_logic;
  attribute SHREG_EXTRACT of rxdf_aempty_r1,rxdf_aempty_r2,rx_losy_r1,rx_losy_r2 : signal is "NO";
  
begin  -- SYN

  p_sync : process(clock)
    begin
      if rising_edge(clock) then
        rxdf_aempty_r1 <= rxdf_aempty;
        rxdf_aempty_r2 <= rxdf_aempty_r1;
        --
        rx_losy_r1 <= rx_losy;
        rx_losy_r2 <= rx_losy_r1;
      end if;
  end process;

  proc_main : process (clock)
    variable rx_dxdata_d1 : std_logic_vector (15 downto 0);
    variable b_srst_to    : boolean;
    variable b_por_to     : boolean;
    variable b_sync_to    : boolean;
    variable b_poff_to    : boolean;
    variable b_SDsigok    : boolean;
    variable b_RXnosig    : boolean;
    variable b_RXbadsig   : boolean;
    variable b_RXsusp     : boolean;
    variable b_RXonline   : boolean;
    variable b_RXxon      : boolean;
    variable b_RXlomark   : boolean;
    variable b_RXhimark   : boolean;
    variable b_TXonline   : boolean;
    variable b_TXxoff     : boolean;
    variable b_TXxon      : boolean;
    variable srst_timer   : std_logic_vector ( 8 downto 0);
    variable por_timer    : std_logic_vector (10 downto 0);
    variable sync_timer   : std_logic_vector ( 7 downto 0);
    variable poff_timer   : std_logic_vector (18 downto 0);
    variable sdlos_filt   : std_logic_vector ( 4 downto 0);
    variable rx_present   : rx_state;
    variable rx_next      : rx_state;
    variable tx_present   : tx_state;
    variable tx_next      : tx_state;
    variable lm_present   : lm_state;
    variable lm_next      : lm_state;
  begin  -- process proc_main 
    if clock'event and clock = '1' then  -- rising clock edge
      if arst = '1' then                 -- asynchronous reset (active low)
        ot_lon    <= '1';
        sd_enable <= '1';
        sd_prbsen <= '0';
        tx_dxdata <= (others => '0');
        tx_txdiag <= '0';
        tx_txidle <= '1';
        lm_status <= (others => '0');

        rx_dxdata_d1 := (others => '0');
        b_srst_to    := false;
        b_por_to     := false;
        b_sync_to    := false;
        b_poff_to    := false;
        b_SDsigok    := false;
        b_RXnosig    := false;
        b_RXbadsig   := false;
        b_RXsusp     := false;
        b_RXonline   := false;
        b_RXxon      := false;
        b_RXlomark   := false;
        b_RXhimark   := false;
        b_TXonline   := false;
        b_TXxoff     := false;
        b_TXxon      := false;
        srst_timer   := (others => '0');
        por_timer    := (others => '0');
        sync_timer   := (others => '0');
        poff_timer   := (others => '0');
        sdlos_filt   := (others => '0');
        rx_present   := RX_DISABLED;
        rx_next      := RX_DISABLED;
        tx_present   := TX_DISABLED;
        tx_next      := TX_DISABLED;
        lm_present   := LM_SIURESET;
        lm_next      := LM_SIURESET;
      else
        -- Default values. For actual values see the code below.
        sd_enable  <= '1';
        sd_prbsen  <= '0';
        ot_lon     <= '1';
        tx_txidle  <= '0';
        tx_dxdata  <= (others => '0');

        tx_dxdata(15 downto 14) <= rx_dxdata_d1(11 downto 10);
        b_TXxoff := rx_present = RX_GODIS;
        b_TXxon  := rx_present = RX_GOENA;
        case rx_present is
          when RX_DISABLED =>
            tx_dxdata(11 downto 10) <= "00";
            if b_RXonline and b_RXlomark then
              rx_next := RX_GOENA;
            else
              rx_next := RX_DISABLED;
            end if;
          when RX_GOENA =>
            tx_dxdata(11 downto 10) <= "11";
            rx_next := RX_ENABLED;
          when RX_ENABLED =>
            tx_dxdata(11 downto 10) <= "11";
            if b_RXonline and not b_RXhimark then
              rx_next := RX_ENABLED;
            else
              rx_next := RX_GODIS;
            end if;
          when RX_GODIS =>
            tx_dxdata(11 downto 10) <= "00";
            rx_next := RX_DISABLED;
        end case;
        rx_present := rx_next;

        case tx_present is
          when TX_DISABLED =>
            tx_txdiag <= '1';
            if b_TXxoff or b_TXxon then
              tx_next := TX_DISABLED;
            elsif b_TXonline and b_RXonline and b_RXxon then
              tx_next := TX_ENABLED;
            else
              tx_next := TX_DISABLED;
            end if;
          when TX_ENABLED =>
            tx_txdiag <= '0';
            if b_TXxoff or b_TXxon then
              tx_next := TX_DISABLED;
            elsif b_TXonline and b_RXonline and b_RXxon then
              tx_next := TX_ENABLED;
            else
              tx_next := TX_DISABLED;
            end if;
        end case;
        tx_present := tx_next;
        b_TXonline := (lm_present = LM_ONLINE);

--      b_srst_to := srst_timer(4) = '1';   -- use low order bit for simulation
        b_srst_to := srst_timer(8) = '1';
        if not b_srst_to and lm_present = LM_SIURESET then
          srst_timer := inc(srst_timer);
        else
          srst_timer := (others => '0');
        end if;

--      b_por_to := por_timer(4) = '1';   -- use low order bit for simulation
        b_por_to := por_timer(10) = '1';
        if not b_por_to and lm_present = LM_POWERONRST then
          por_timer := inc(por_timer);
        else
          por_timer := (others => '0');
        end if;

--      b_sync_to := sync_timer(4) = '1';  -- use low order bit for simulation
        b_sync_to := sync_timer(7) = '1';
        if not b_sync_to and lm_present = LM_OFFLINE then
          sync_timer := inc(sync_timer);
        else
          sync_timer := (others => '0');
        end if;

        b_poff_to := poff_timer(18) = '1';
        if not b_poff_to and lm_present = LM_GOLOWPWR then
          poff_timer := inc(poff_timer);
        else
          poff_timer := (others => '0');
        end if;

        b_SDsigok := sdlos_filt(4) = '1';
        if (lm_present = LM_LOWPOWER and sd_los = '0') then
          sdlos_filt := inc(sdlos_filt);
        else
          sdlos_filt := (others => '0');
        end if;

        tx_dxdata(7 downto 4) <= rx_dxdata_d1(3 downto 0);  -- Debug
        case lm_present is
          when LM_SIURESET =>
            tx_dxdata(3 downto 0) <= "0000";
            tx_txidle  <= '1';
            lm_status <= "000";
            if b_srst_to then
              if b_RXnosig then
                lm_next := LM_LOWPOWER;
              else
                lm_next := LM_POWERONRST;
              end if;
            else
              lm_next := LM_SIURESET;
            end if;
          when LM_LOWPOWER =>
            sd_enable <= '0';
            ot_lon    <= '0';
            tx_dxdata(3 downto 0) <= "0000";
            lm_status <= "110";
            if (b_SDsigok and not b_RXnosig) then
              lm_next := LM_POWERONRST;
            else
              lm_next := LM_LOWPOWER;
            end if;
          when LM_POWERONRST =>
            tx_dxdata(3 downto 0) <= "0000";
            tx_txidle  <= '1';
            lm_status  <= "000";
            if b_por_to then
              lm_next := LM_OFFLINE;
            else
              lm_next := LM_POWERONRST;
            end if;
          when LM_OFFLINE =>
            tx_dxdata(0) <= bool2sl(b_RXnosig);
            tx_dxdata(1) <= bool2sl(not b_RXnosig and b_RXbadsig);
            tx_dxdata(2) <= '0';
            tx_dxdata(3) <= '0';
            if b_RXnosig then
              lm_status <= "100";
            elsif b_RXbadsig then
              lm_status <= "101";
            else
              lm_status <= "001";
            end if;
            if b_RXsusp then
              lm_next := LM_RXSUSPEND;
            elsif lm_prbsen = '1' then
              lm_next := LM_TESTMODE;
            elsif b_sync_to then
              lm_next := LM_ONLINE;
            else
              lm_next := LM_OFFLINE;
            end if;
          when LM_ONLINE =>
            tx_dxdata(3 downto 0) <= "0011";
            lm_status <= "010";
            if b_RXsusp then
              lm_next := LM_RXSUSPEND;
            elsif lm_prbsen = '1' then
              lm_next := LM_TESTMODE;
            elsif b_RXnosig or b_RXbadsig then
              lm_next := LM_OFFLINE;
            else
              lm_next := LM_ONLINE;
            end if;
          when LM_TESTMODE =>
            sd_prbsen <= '1';
            if b_RXnosig then
              lm_next := LM_LOWPOWER;
            else
              lm_next := LM_TESTMODE;
            end if;
          when LM_RXSUSPEND =>
            tx_dxdata(3 downto 0) <= "1100";
            lm_status <= "011";
            if b_RXnosig then
              lm_next := LM_GOLOWPWR;
            else
              lm_next := LM_RXSUSPEND;
            end if;
          when LM_GOLOWPWR =>
            sd_enable <= '0';
            ot_lon    <= '0';
            tx_dxdata(3 downto 0) <= "1100";
            lm_status <= "011";
            if b_poff_to then
              lm_next := LM_LOWPOWER;
            else
              lm_next := LM_GOLOWPWR;
            end if;
        end case;
        lm_present := lm_next;

        b_RXsusp     := rx_suspend = '1';
        b_RXnosig    := ot_sd = '0';
        b_RXbadsig   := rx_losy_r2 = '1';
        b_RXonline   := rx_dxdata_d1( 1 downto  0) = "11";
        b_RXxon      := rx_dxdata_d1(11 downto 10) = "11";
        b_RXlomark   := rxdf_aempty_r2 = '1';
        b_RXhimark   := rxdf_afull = '1';
        rx_dxdata_d1 := rx_dxdata;

      end if;
    end if;
  end process proc_main ;

end SYN;
