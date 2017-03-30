--******************************************************************************
--*
--* Module          : siu_txd_fifo
--* File            : siu_txd_fifo.vhd
--* Library         : ieee
--* Description     : 
--* Author/Designer : Filippo Costa (filippo.costa@cern.ch)
--*
--*  Revision history:
--*     28-05-13 1.0 moved to sync reset
--*   20-06-13 PC moved to active high sync reset, removed double clr
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

entity siu_txd_fifo is
  
  port (
    wrclock     : in  std_logic;
    rdclock     : in  std_logic;
    clr         : in  std_logic;   
    txdf_d      : in  std_logic_vector (35 downto 0);
    txdf_wrreq  : in  std_logic;
    txdf_rdreq  : in  std_logic;
    txdf_q      : out std_logic_vector (35 downto 0);
    txdf_empty  : out std_logic;
    txdf_full   : out std_logic;
    txdf_afull  : out std_logic;
    txdf_aempty : out std_logic);

end siu_txd_fifo;

architecture SYN of siu_txd_fifo is

  type read_state is (
    RD_EMPTY,
    RD_FETCH,
    RD_NEMPTY);

--  component txdf_core
--    port (
--      DATA   : in  std_logic_vector (35 downto 0);
--      Q      : out std_logic_vector (35 downto 0);
--      RCLOCK : in  std_logic;
--      WCLOCK : in  std_logic;
--      WE     : in  std_logic;
--      RE     : in  std_logic;
--      RESET  : in  std_logic;
--      FULL   : out std_logic;
--      EMPTY  : out std_logic;
--      AFULL  : out std_logic;
--      AEMPTY : out std_logic);
--  end component;
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

  signal txdf_r_i : std_logic;
  signal txdf_e_i : std_logic;
  signal read_ena : std_logic;
  signal fetch    : std_logic;

  -- CS
  attribute keep : string;
  signal txdf_q_i,txdf_q_cs,txdf_d_cs : std_logic_vector(35 downto 0);
  signal txdf_wrreq_cs,txdf_afull_cs,txdf_r_i_cs,txdf_e_i_cs,txdf_rdreq_cs,txdf_empty_cs : std_logic;
  attribute keep of txdf_wrreq_cs,txdf_afull_cs,txdf_q_i,txdf_q_cs,txdf_d_cs,txdf_r_i_cs,txdf_e_i_cs,txdf_rdreq_cs,txdf_empty_cs : signal is "true";

begin  -- SYN
  -- Assignment
  txdf_q <= txdf_q_i;
  
  txdf_r_i <= fetch or (txdf_rdreq and read_ena);
--  TXDF_CORE_INST : txdf_core
--    port map (
--      DATA   => txdf_d,
--      Q      => txdf_q,
--      RCLOCK => rdclock,
--      WCLOCK => wrclock,
--      WE     => txdf_wrreq,
--      RE     => txdf_r_i,
--      RESET  => txdf_rdclr,
--      FULL   => txdf_full,
--      EMPTY  => txdf_e_i,
--      AFULL  => txdf_afull,
--      AEMPTY => txdf_aempty
--    );
  
  -- AFULL is not sufficient for Xilinx FIFOs:
  -- use PROG_FULL with limit set to 250 of 255
  TXDF_CORE_INST: fifo_36x256_ae_af
    port map (
      rst => clr,
      wr_clk => wrclock,
      rd_clk => rdclock,
      wr_en => txdf_wrreq,
      rd_en => txdf_r_i,
      full => txdf_full,
      prog_full => txdf_afull,
      empty => txdf_e_i,
      almost_empty => txdf_aempty,
      din => txdf_d,
      dout => txdf_q_i
      );

  proc_read: process (rdclock)
    variable read_present : read_state;
    variable read_next    : read_state;
  begin  -- process proc_read
    if rdclock'event and rdclock = '1' then  -- rising clock edge
      if clr = '1' then                  -- asynchronous reset (active low)
        read_ena   <= '0';
        fetch      <= '0';
        txdf_empty <= '1';
        read_present := RD_EMPTY;
        read_next    := RD_EMPTY;
      else
        fetch <= '0';
        case read_present is
          when RD_EMPTY =>
            read_ena <= '0';
            if txdf_e_i = '0' then
              fetch <= '1';
              read_next := RD_FETCH;
            else
              read_next := RD_EMPTY;
            end if;
          when RD_FETCH =>
            txdf_empty <= '0';
            read_ena <= '1';
            read_next := RD_NEMPTY;
          when RD_NEMPTY =>
            if txdf_e_i = '1' and txdf_rdreq = '1' then
              txdf_empty <= '1';
              read_ena <= '0';
              read_next := RD_EMPTY;
            else
              read_ena <= '1';
              read_next := RD_NEMPTY;
            end if;
        end case;
        read_present := read_next;
      end if;
    end if;
  end process proc_read;

  p_cs : process(wrclock)
    begin
      if rising_edge(wrclock) then
        txdf_d_cs <= txdf_d;
        txdf_wrreq_cs <= txdf_wrreq;
      end if;
  end process;

  p_c1s : process(rdclock)
    begin
      if rising_edge(rdclock) then
        txdf_q_cs <= txdf_q_i;
        txdf_r_i_cs <= txdf_r_i;
        txdf_e_i_cs <= txdf_e_i;
        txdf_rdreq_cs <= txdf_rdreq;
      end if;
  end process;
end SYN;
