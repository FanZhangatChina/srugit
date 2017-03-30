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

entity siu_framing is

  port (
    clock      : in  std_logic;         -- TX clock
    arst      : in  std_logic;         -- asynch reset
    txidle     : in  std_logic;         -- Force IDLE
    txdiag     : in  std_logic;         -- Send diagnostic frame
    txdf_empty : in  std_logic;         -- TX FIFO empty
    txdf_rdreq : out std_logic;         -- TX FIFO read request
    txdf_q     : in  std_logic_vector (33 downto 0);  -- TX FIFO data
    txst_req   : in  std_logic;         -- TX status request
    txst_ack   : out std_logic;         -- TX status acknowledge
    txst_data  : in  std_logic_vector (31 downto 0);  -- TX status data
    tx_dxdata  : in  std_logic_vector (15 downto 0);  -- diagnostic data
    perr       : in  std_logic;         -- Parity error
    txd        : out std_logic_vector (15 downto 0);  -- SERDES data
    tx_en      : out std_logic;         -- SERDES data enable
    tx_er      : out std_logic);        -- SERDES error indication

end siu_framing;

library ieee;
use ieee.std_logic_1164.all;

use work.siu_my_conversions.all;
use work.siu_my_utilities.all;

architecture SYN of siu_framing is

  component siu_crc16
    port (
      clock : in  std_logic;
      srst  : in  std_logic;
      ena   : in  std_logic;
      d     : in  std_logic_vector (15 downto 0);
      q     : out std_logic_vector (15 downto 0)
      );
  end component;

  signal s_crc_in  : std_logic_vector (15 downto 0);
  signal s_crc_out : std_logic_vector (15 downto 0);
  signal s_crc_sld : std_logic;
  signal s_crc_ena : std_logic;

  constant SC_CODE : std_logic_vector := "0101010101010101";
  constant SD_CODE : std_logic_vector := "0100101001001010";

  type tx_state is (
    TX_IDLE1,  -- 1st IDLE
    TX_IDLE2,  -- 2nd IDLE
    TX_DIAG1,  -- Diagnostic Frame delimiter
    TX_DIAG2,  -- Diagnostic Frame data
    TX_IDLE3,  -- 3rd IDLE
    TX_IDLE4,  -- 4th IDLE
    TX_CFRSC,  -- Control Frame delimiter
    TX_C1FD1L, -- Control Frame data word
    TX_C1FD1H, -- Control Frame data word
    TX_C1FD2L, -- Control Frame data word
    TX_C1FD2H, -- Control Frame data word
    TX_C2FD1L, -- Control Frame data word
    TX_C2FD1H, -- Control Frame data word
    TX_C2FD2L, -- Control Frame data word
    TX_C2FD2H, -- Control Frame data word
    TX_DFRSD,  -- Data Frame delimiter
    TX_DFRDWL, -- Data Frame data word
    TX_DFRDWH, -- Data Frame data word
    TX_DFRCRC  -- Data Frama CRC word
    );

begin

  CRC_INST : siu_crc16
    port map (
      clock  => clock,
      srst   => s_crc_sld,
      ena    => s_crc_ena,
      d      => s_crc_in,
      q      => s_crc_out
      );

  proc_main : process (clock)
    variable errflag    : std_logic;
    variable errflag_r  : std_logic;
    variable stswflag   : std_logic;
    variable stswflag_r : std_logic;
    variable specflag   : std_logic;
    variable specmask   : std_logic;
    variable closeframe : std_logic;
    variable frlength   : std_logic_vector ( 7 downto 0);
    variable txdf_q16   : std_logic_vector (15 downto 0);
    variable tx_en_r1   : std_logic;
    variable tx_er_r1   : std_logic;
    variable tx_en_r2   : std_logic;
    variable tx_er_r2   : std_logic;
    variable txd_dxd    : std_logic_vector (15 downto 0);
    variable txd_dat    : std_logic_vector (15 downto 0);
    variable txd_crc    : std_logic_vector (15 downto 0);
    variable txd_sts1   : std_logic_vector (15 downto 0);
    variable txd_sts2   : std_logic_vector (15 downto 0);
    variable txd_diag   : std_logic_vector (15 downto 0);
    variable txd_dfrm   : std_logic_vector (15 downto 0);
    variable txd_sfrm   : std_logic_vector (15 downto 0);
    variable tx_d_sel   : std_logic;
    variable wd_timer   : std_logic_vector (11 downto 0);
    variable b_wd_reset : boolean;
    variable b_wd_oflow : boolean;
    variable b_txdiag   : boolean;
    variable tx_present : tx_state;
    variable tx_next    : tx_state;
  begin
    if (clock'event and clock='1') then
      if (arst = '1') then

        txd        <= (others => '0');
        tx_en      <= '0';
        tx_er      <= '0';
        txdf_rdreq <= '0';
        txst_ack   <= '0';
        s_crc_in   <= (others => '0');
        s_crc_sld  <= '1';
        s_crc_ena  <= '0';

        tx_en_r1   := '0';
        tx_er_r1   := '0';
        tx_en_r2   := '0';
        tx_er_r2   := '0';
        txd_dxd    := (others => '0');
        txd_dat    := (others => '0');
        txd_crc    := (others => '0');
        txd_sts1   := (others => '0');
        txd_sts2   := (others => '0');
        txd_diag   := (others => '0');
        txd_dfrm   := (others => '0');
        txd_sfrm   := (others => '0');
        tx_d_sel   := '0';
        errflag    := '0';
        errflag_r  := '0';
        stswflag   := '0';
        stswflag_r := '0';
        specflag   := '0';
        specmask   := '1';
        closeframe := '0';
        frlength   := (others => '0');
        txdf_q16   := (others => '0');
        wd_timer   := (others => '0');
        b_wd_reset := true;
        b_wd_oflow := false;
        b_txdiag   := false;
        tx_present := TX_IDLE1;
        tx_next    := TX_IDLE1;

      else


        tx_en <= tx_en_r2;
        tx_er <= tx_er_r2;
        tx_en_r2 := tx_en_r1;
        tx_er_r2 := tx_er_r1;

        txd <= txd_dfrm or txd_sfrm or txd_diag;
        txd_diag := txd_dxd;
        txd_crc := s_crc_out;
        if (tx_d_sel = '1') then
          txd_dfrm := txd_crc;
        else
          txd_dfrm := txd_dat;
        end if;
        txd_sfrm := txd_sts1 or txd_sts2;

        errflag_r := errflag;
        if perr = '1' then
          errflag := '1';
        elsif tx_present = TX_C2FD2H then
          errflag := '0';
        end if;

        -- There are two bits used as data qualifier in the FIFO: txdf_q(33..32)
        -- Truth table: txdf_q(33) txdf_q(32)  type of data at FIFO output
        --              (specflag) (stswflag)
        --                     '0'        '0'    FEE data word
        --                     '1'        '0'    FEE data word (2MB boundary)
        --                     '1'        '1'    FEE status word or DTSTW
        -- Whenever the specflag is set, we will have to send a control frame.
        -- If we are inside a data frame, the frame must be closed. Depending
        -- on the status of the stswflag, we will have to send a FEE status,
        -- or a DTSTW with or without the continuation bit set. If we have to
        -- send a DTSTW with the continuation bit set (txdf_q(33..32) = "10"),
        -- the specflag will have to be masked to avoid multiple transmission.
        stswflag_r := stswflag;
        stswflag   := txdf_q(32);
        specflag   := txdf_q(33) and specmask;
        if tx_present = TX_C2FD2H and stswflag_r = '0' then
          specmask := '0';
        elsif tx_present = TX_DFRSD then
          specmask := '1';
        end if;
        closeframe := specflag or frlength(7) or txdf_empty;

        txdf_rdreq <= '0';
        txst_ack   <= '0';
        s_crc_sld  <= '0';
        s_crc_ena  <= '0';
        tx_d_sel   := '0';

        -- Watchdog
        b_wd_oflow := wd_timer(11) = '1';
        if b_wd_reset then
          wd_timer := (others => '0');
        else
          wd_timer := inc(wd_timer);
        end if;
        b_wd_reset := false;

        if txdiag = '1' then
          b_txdiag := true;
        elsif tx_present = TX_DIAG2 then
          b_txdiag := false;
        end if;

        txd_dxd  := (others => '0');
        txd_dat  := (others => '0');
        txd_sts1 := (others => '0');
        txd_sts2 := (others => '0');
        case tx_present is
          when TX_IDLE1 =>
            tx_en_r1  := '0';
            tx_er_r1  := '0';
            frlength  := (others => '0');
            b_wd_reset := true;           -- clear watchdog timer
            tx_next := TX_IDLE2;
          when TX_IDLE2 =>
            tx_en_r1 := '0';
            tx_er_r1 := '0';
            if (txidle = '1') then
              tx_next := TX_IDLE1;
            else
              tx_next := TX_DIAG1;
            end if;
          when TX_DIAG1 =>
            b_wd_reset := true;           -- clear watchdog timer
            tx_en_r1 := '0';
            tx_er_r1 := '1';
            tx_next := TX_DIAG2;
          when TX_DIAG2 =>
            tx_en_r1 := '1';
            tx_er_r1 := '0';
            txd_dxd := tx_dxdata;
            if (txidle = '1') then
              tx_next := TX_IDLE1;
            elsif (txdf_empty = '0' or txst_req = '1') then
              tx_next := TX_IDLE3;
            else
              tx_next := TX_IDLE1;
            end if;
          when TX_IDLE3 =>
            tx_en_r1 := '0';
            tx_er_r1 := '0';
            tx_next := TX_IDLE4;
          when TX_IDLE4 =>
            s_crc_sld <= '1';
            tx_en_r1 := '0';
            tx_er_r1 := '0';
            if txidle = '1' then
              tx_next := TX_IDLE1;
            elsif txst_req = '1' then
              tx_next := TX_CFRSC;
            elsif b_txdiag then
              tx_next := TX_DIAG1;
            elsif txdf_empty = '0' and specflag = '1' then
              tx_next := TX_CFRSC;
            elsif txdf_empty = '0' then
              tx_next := TX_DFRSD;
            else
              tx_next := TX_DIAG1;
            end if;
          when TX_CFRSC =>
            tx_en_r1 := '1';
            tx_er_r1 := '0';
            txd_sts1 := SC_CODE;
            txd_sts2 := SC_CODE;
            if (txst_req = '1') then
              tx_next := TX_C1FD1L;
            else
              tx_next := TX_C2FD1L;
            end if;
          when TX_C1FD1L =>
            tx_en_r1 := '1';
            tx_er_r1 := '0';
            txd_sts1 := txst_data(15 downto  0);
            tx_next := TX_C1FD1H;
          when TX_C1FD1H =>
            tx_en_r1 := '1';
            tx_er_r1 := '0';
            txd_sts1 := txst_data(15 downto  0);
            tx_next := TX_C1FD2L;
          when TX_C1FD2L =>
            tx_en_r1 := '1';
            tx_er_r1 := '0';
            txd_sts1 := txst_data(31 downto 16);
            tx_next := TX_C1FD2H;
          when TX_C1FD2H =>
            txst_ack <= '1';
            tx_en_r1 := '1';
            tx_er_r1 := '0';
            txd_sts1 := txst_data(31 downto 16);
            tx_next := TX_IDLE1;
          when TX_C2FD1L =>
            tx_en_r1 := '1';
            tx_er_r1 := '0';
            if stswflag_r = '0' then
              txd_sts2 := "1111000110000010";
            else
              txd_sts2 := txdf_q(15 downto  0);
            end if;
            tx_next := TX_C2FD1H;
          when TX_C2FD1H =>
            tx_en_r1 := '1';
            tx_er_r1 := '0';
            if stswflag_r = '0' then
              txd_sts2 := "1111000110000010";
            else
              txd_sts2 := txdf_q(15 downto  0);
            end if;
            tx_next := TX_C2FD2L;
          when TX_C2FD2L =>
            tx_en_r1 := '1';
            tx_er_r1 := '0';
            if stswflag_r = '0' then
              txd_sts2 := errflag_r & "111111111111111";
            else
              txd_sts2 := (errflag_r or txdf_q(31)) & txdf_q(30 downto 16);
            end if;
            tx_next := TX_C2FD2H;
          when TX_C2FD2H =>
            tx_en_r1 := '1';
            tx_er_r1 := '0';
            if stswflag_r = '0' then
              txd_sts2 := errflag_r & "111111111111111";
            else
              txdf_rdreq <= '1';
              txd_sts2 := (errflag_r or txdf_q(31)) & txdf_q(30 downto 16);
            end if;
            tx_next := TX_IDLE1;
          when TX_DFRSD =>
            txdf_rdreq <= '1';
            tx_en_r1 := '1';
            tx_er_r1 := '0';
            txd_dat := SD_CODE;
            txdf_q16   := txdf_q(15 downto  0);
            frlength  := inc(frlength);
            s_crc_ena <= '1';
            s_crc_in  <= txdf_q16;
            tx_next := TX_DFRDWL;
          when TX_DFRDWL =>
            txdf_rdreq <= '0';
            tx_en_r1 := '1';
            tx_er_r1 := '0';
            txd_dat := txdf_q16;
            txdf_q16  := txdf_q(31 downto 16);
            s_crc_ena <= '1';
            s_crc_in  <= txdf_q16;
            tx_next := TX_DFRDWH;
          when TX_DFRDWH =>
            tx_en_r1 := '1';
            tx_er_r1 := '0';
            txd_dat := txdf_q16;
            txdf_q16  := txdf_q(15 downto  0);
            frlength  := inc(frlength);
            s_crc_ena <= '1';
            s_crc_in  <= txdf_q16;
            if closeframe = '1' or b_txdiag then
              txdf_rdreq <= '0';
              tx_next := TX_DFRCRC;
            else
              txdf_rdreq <= '1';
              tx_next := TX_DFRDWL;
            end if;
          when TX_DFRCRC =>
            txdf_rdreq <= '0';
            tx_en_r1 := '1';
            tx_er_r1 := '0';
            tx_d_sel  := '1';
            tx_next := TX_IDLE1;
        end case;
        if b_wd_oflow then
          tx_present := TX_IDLE1;
        else
          tx_present := tx_next;
        end if;

      end if;
    end if;
  end process;

end SYN;
