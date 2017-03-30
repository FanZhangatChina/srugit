library ieee;
use ieee.std_logic_1164.all;

entity ddl_phy_byte_ordering is
  
  generic (
    ALIGNMENT_BYTE : std_logic_vector := x"BC");

  port (
    clock   : in  std_logic;
    srst    : in  std_logic;            -- restart ordering process
    datain  : in  std_logic_vector(15 downto 0);
    ctrlin  : in  std_logic_vector(1 downto 0);
    errin   : in  std_logic_vector(1 downto 0);
    dataout : out std_logic_vector(15 downto 0);
    ctrlout : out std_logic_vector(1 downto 0);
    errout  : out std_logic_vector(1 downto 0);
    status  : out std_logic);

end ddl_phy_byte_ordering;

architecture RTL of ddl_phy_byte_ordering is

  type ordering_state is (
    FSM_RESET,
    FSM_OO_SEARCH1,
    FSM_OO_SEARCH2,
    FSM_OO_SWAP,
    FSM_OO_WAIT1,
    FSM_OO_WAIT2,
    FSM_IN_ORDER
    );
  signal fsm_present : ordering_state := FSM_RESET;
  signal fsm_next    : ordering_state := FSM_RESET;
  signal data_r1 : std_logic_vector(15 downto 0);
  signal data_ordered : std_logic_vector(15 downto 0);
  signal ctrl_r1 : std_logic_vector(1 downto 0);
  signal ctrl_ordered : std_logic_vector(1 downto 0);
  signal err_r1 : std_logic_vector(1 downto 0);
  signal err_ordered  : std_logic_vector(1 downto 0);

begin  -- RTL

  p_fsm_r: process (clock)
  begin  -- process p_fsm_r
    if clock'event and clock = '1' then  -- rising clock edge
      fsm_present <= fsm_next;
    end if;
  end process p_fsm_r;

  p_fsm_c: process (fsm_present, srst, data_ordered, ctrl_ordered)
    variable need_to_swap : boolean;
    variable good_order   : boolean;
  begin  -- process p_fsm_c
    need_to_swap := ctrl_ordered(1) = '1' and data_ordered(15 downto 8) = ALIGNMENT_BYTE;
    good_order := ctrl_ordered(0) = '1' and data_ordered(7 downto 0) = ALIGNMENT_BYTE;
    fsm_next <= fsm_present;
    case fsm_present is
      when FSM_RESET =>
        if srst = '0' then
          fsm_next <= FSM_OO_SEARCH1;
        end if;
      when FSM_OO_SEARCH1 =>
        if need_to_swap then
          fsm_next <= FSM_OO_SWAP;
        elsif good_order then
          fsm_next <= FSM_OO_SEARCH2;
        end if;
      when FSM_OO_SEARCH2 =>
        if need_to_swap then
          fsm_next <= FSM_OO_SWAP;
        elsif good_order then
          fsm_next <= FSM_IN_ORDER;
        else
          fsm_next <= FSM_OO_SEARCH1;
        end if;
      when FSM_OO_SWAP =>
        fsm_next <= FSM_OO_WAIT1;
      when FSM_OO_WAIT1 =>
        fsm_next <= FSM_OO_WAIT2;
      when FSM_OO_WAIT2 =>
        fsm_next <= FSM_OO_SEARCH1;
      when FSM_IN_ORDER =>
        fsm_next <= FSM_IN_ORDER;
        if srst = '1' then
          fsm_next <= FSM_RESET;
        end if;
    end case;
  end process p_fsm_c;
  status <= '1' when fsm_present = FSM_IN_ORDER else '0';

  p_rx_byte_order: process (clock)
    variable lane_select : std_logic := '0';
  begin  -- process p_rx_byte_order
    if clock'event and clock = '1' then  -- rising clock edge
      data_r1 <= datain;
      ctrl_r1 <= ctrlin;
      err_r1 <= errin;
      if lane_select = '0' then
        data_ordered <= datain;
        ctrl_ordered <= ctrlin;
        err_ordered  <= errin;
      else
        data_ordered <= datain(7 downto 0) & data_r1(15 downto 8);
        ctrl_ordered <= ctrlin(0) & ctrl_r1(1);
        err_ordered  <= errin(0) & err_r1(1);
      end if;
      if fsm_present = FSM_OO_SWAP then
        lane_select := not lane_select;
      end if;
    end if;
  end process p_rx_byte_order;
  dataout <= data_ordered;
  ctrlout <= ctrl_ordered;
  errout  <= err_ordered;

end RTL;
