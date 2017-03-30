--345678901234567890123456789012345678901234567890123456789012345678901234567890
--******************************************************************************
--*
--* Module          : RXD_FIFO
--* File            : rxd_fifo.vhd
--* Library         : ieee, APA
--* Description     : It is a FIFO, which stores the data and status, which are
--*                   coming from the link.
--* Simulator       : Modelsim
--* Synthesizer     : Synplify (Libero IDE)
--* Author/Designer : C. SOOS ( Csaba.Soos@cern.ch)
--*
--* Revision history:
--*   1-Feb-2005 CS  rxdf_empty signal has been changed
--*  19-May-2005 CS  Clear signals for each clock domain have been added
--*  21-Oct-2005 CS  Width has been changed (parity bits have been added)
--*   20-06-13 PC moved to active high sync reset, removed double clr from the
--                top entity
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

entity siu_rxd_fifo is
  
  port (
    wrclock     : in  std_logic;
    rdclock     : in  std_logic;
    clr         : in  std_logic;
    rxdf_d      : in  std_logic_vector (35 downto 0);
    rxdf_wrreq  : in  std_logic;
    rxdf_rdreq  : in  std_logic;
    rxdf_q      : out std_logic_vector (35 downto 0);
    rxdf_empty  : out std_logic;
    rxdf_full   : out std_logic;
    rxdf_afull  : out std_logic;
    rxdf_aempty : out std_logic);

end siu_rxd_fifo;

architecture SYN of siu_rxd_fifo is

  type read_state is (
    RD_EMPTY,
    RD_FETCH,
    RD_NEMPTY);

--   component rxdf_core
--     port (
--       DATA   : in std_logic_vector (35 downto 0);
--       Q      : out std_logic_vector (35 downto 0);
--       WE     : in std_logic;
--       RE     : in std_logic;
--       RCLOCK : in std_logic;
--       WCLOCK : in std_logic;
--       FULL   : out std_logic;
--       EMPTY  : out std_logic;
--       RESET  : in std_logic;
--       AEMPTY : out std_logic;
--       AFULL  : out std_logic);
--   end component;

  COMPONENT fifo_36x256_ae_af
    PORT (
      rst : IN STD_LOGIC;
      wr_clk : IN STD_LOGIC;
      rd_clk : IN STD_LOGIC;
      din : IN STD_LOGIC_VECTOR(35 DOWNTO 0);
      wr_en : IN STD_LOGIC;
      rd_en : IN STD_LOGIC;
      dout : OUT STD_LOGIC_VECTOR(35 DOWNTO 0);
      full : OUT STD_LOGIC;
      empty : OUT STD_LOGIC;
      almost_empty : OUT STD_LOGIC;
      prog_full : OUT STD_LOGIC
      );
  END COMPONENT;


  signal Q      : std_logic_vector (35 downto 0);
  signal RCLOCK : std_logic;
  signal WCLOCK : std_logic;
  signal DATA   : std_logic_vector (35 downto 0);
  signal WE     : std_logic;
  signal RE     : std_logic;
  signal RESET  : std_logic;
  signal FULL   : std_logic;
  signal EMPTY  : std_logic;
  signal AFULL  : std_logic;
  signal AEMPTY : std_logic;

  signal read_ena : std_logic;
  signal fetch    : std_logic;  
  
begin

  -- Assignment
  DATA   <= rxdf_d;
  RE     <= fetch or (rxdf_rdreq and read_ena);
  WE     <= rxdf_wrreq;
  RESET  <= clr;
  WCLOCK <= wrclock;
  RCLOCK <= rdclock;

--   rxdf_core_inst : rxdf_core
--     port map (
--       DATA   => DATA,
--       Q      => Q,
--       RCLOCK => RCLOCK,
--       WCLOCK => WCLOCK,
--       WE     => WE,
--       RE     => RE,
--       RESET  => RESET,
--       FULL   => FULL,
--       EMPTY  => EMPTY,
--       AFULL  => AFULL,
--       AEMPTY => AEMPTY);

  rxdf_core_inst: fifo_36x256_ae_af port map 
    (
      rst => RESET,
      wr_clk => WCLOCK,
      rd_clk => RCLOCK,
      wr_en => WE,
      rd_en => RE,
      full => FULL,
      prog_full => AFULL,
      empty => EMPTY,
      almost_empty => AEMPTY,
      din => DATA,
      dout => Q
      );

  rxdf_q      <= Q;
  rxdf_full   <= FULL;
  rxdf_afull  <= AFULL;
  rxdf_aempty <= AEMPTY;  
  
  proc_read: process (rdclock)
    variable read_present : read_state;
    variable read_next    : read_state;
  begin  -- process proc_read
  if rdclock'event and rdclock = '1' then  -- rising clock edge
    if clr = '1' then                  -- asynchronous reset (active low)
      read_ena   <= '0';
      fetch      <= '0';
      rxdf_empty <= '1';
      read_present := RD_EMPTY;
      read_next    := RD_EMPTY;
      else
      fetch <= '0';
      case read_present is
        when RD_EMPTY =>
          read_ena <= '0';
          if EMPTY = '0' then
            fetch <= '1';
            read_next := RD_FETCH;
          else
            read_next := RD_EMPTY;
          end if;
        when RD_FETCH =>
          read_ena <= '1';
          read_next := RD_NEMPTY;
        when RD_NEMPTY =>
          if EMPTY = '1' and rxdf_rdreq = '1' then
            read_ena <= '0';
            read_next := RD_EMPTY;
          else
            read_ena <= '1';
            read_next := RD_NEMPTY;
          end if;
      end case;
      read_present := read_next;
      if fetch = '1' then
        rxdf_empty <= '0';
      elsif EMPTY = '1' and rxdf_rdreq = '1' then
        rxdf_empty <= '1';
      end if;
    end if;
    end if;
  end process proc_read;

end SYN;
