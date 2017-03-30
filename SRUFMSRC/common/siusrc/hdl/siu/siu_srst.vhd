--******************************************************************************
-- PHOS SRU
-- Designer : Fan Zhang (zhangfan@mail.hbut.edu.cn)
-- Last Updated: 2015-06-25
--*******************************************************************************


library ieee;
use ieee.std_logic_1164.all;

use work.siu_my_conversions.all;
use work.siu_my_utilities.all;

entity siu_srst is
  port (
    clk : in std_logic;
    reset : in std_logic;
    pwr_good : in std_logic;
    s_rx_dv : in std_logic;
    s_rx_er : in std_logic;
    s_rxd : in std_logic_vector (15 downto 0);
    srst : out std_logic);
end siu_srst;

architecture SYN of siu_srst is
begin
  
  proc_srst : process (clk)
    variable b_rx_cext    : boolean;
    variable b_rx_cext_d1 : boolean;
    variable b_rx_data    : boolean;
    variable b_srst_set   : boolean;
    variable b_srst_nset  : boolean;
    variable v_rxd9_d1    : std_logic;
    variable v_rxd8_d1    : std_logic;
    variable srst_count   : std_logic_vector (1 downto 0);
    variable srst_pipe    : std_logic_vector (3 downto 0);
  begin
    if rising_edge(clk) then  -- rising clock edge
      if pwr_good = '0' then
        srst <= '1';
        b_rx_cext    := false;
        b_rx_cext_d1 := false;
        b_rx_data    := false;
        b_srst_set   := false;
        b_srst_nset  := false;
        v_rxd9_d1    := '0';
        v_rxd8_d1    := '0';
        srst_count   := "00";
        srst_pipe    := "1111";
      else
        srst <= reset or
                srst_pipe(3) or srst_pipe(2) or srst_pipe(1) or srst_pipe(0);
        srst_pipe(3) := srst_pipe(2);
        srst_pipe(2) := srst_pipe(1);
        srst_pipe(1) := srst_pipe(0);
        srst_pipe(0) := srst_count(1) and srst_count(0);
        if b_srst_nset then
          srst_count := "00";
        elsif b_srst_set and srst_count /= "11" then
          srst_count := inc(srst_count);
        end if;

        b_srst_set  := b_rx_cext_d1 and b_rx_data and
                       v_rxd9_d1 = '1' and v_rxd8_d1 = '1';
        b_srst_nset := b_rx_cext_d1 and b_rx_data and
                       (v_rxd9_d1 = '0' or v_rxd8_d1 = '0');
        
        b_rx_cext_d1 := b_rx_cext;
        b_rx_cext := s_rx_dv = '0' and s_rx_er = '1';
        b_rx_data := s_rx_dv = '1' and s_rx_er = '0';
        v_rxd8_d1 := s_rxd(8);
        v_rxd9_d1 := s_rxd(9);
      end if;
    end if;
  end process;
end;
