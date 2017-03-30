--******************************************************************************
--*
--* Module          : linkspeed_handler
--* File            : linkspeed_handler.vhd
--* Library         : ieee
--* Description     : 
--* Author/Designer : Filippo Costa (filippo.costa@cern.ch)
--*
--*  Revision history:
--*     12-07-13 PC component to handle the DRP port of the GTX to change the
--*                 speed of the link (2 Gb/s 4 Gb/s)
--*     02-08-13 PC new 5 Gb/s speed (2 - 5 Gb/s)
--*     21-02-14 PC improved the SM
--*     04-03-14 PC fixed a few bugs
--*
--******************************************************************************

library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_1164.all;

use work.gtxdrp_pkg.all;

entity linkspeed_handler is
  port ( 
    clk : in std_logic; -- DRP CLK
    rst : in std_logic; -- GTX RST
    set_speed : in std_logic_vector(1 downto 0);  --  SET SPEED
    -- PCIe interface cmd
    drp_start : in std_logic;
    drp_done : out std_logic;
    -- DRP interface
    addr : out std_logic_vector(7 downto 0); 
    den : out std_logic;
    di : out std_logic_vector (15 downto 0);
    drdy : in std_logic;
    drpdo : in std_logic_vector (15 downto 0);
    dwe : out std_logic);

end linkspeed_handler;

architecture rtl of linkspeed_handler is  
  constant DLY : TIME := 1 ns; 
  
  type DRPSTATE is (
    IDLE,
    READ_REGS,WAIT_RD_DRDY,
    ST_SPEED,SET_2GB,SET_3GB,SET_4GB,SET_425GB,SET_53125GB,
    WRITEREG,WAIT_DRDY,
    WAITSTATE
    );

  signal state : DRPSTATE := IDLE;

  type value_array is array (0 to 9) of std_logic_vector (15 downto 0);
  signal value_reg : value_array := (others => (others => '0'));

  -- MTSTB
  signal drp_startd,drp_startdd : std_logic;
  attribute shreg_extract : string;
  attribute shreg_extract of drp_startd,drp_startdd : signal is "no";
  
begin  -- structural
  
  p_mtstb : process (clk)
  begin
    if rising_edge(clk) then
      drp_startd <= drp_start;
      drp_startdd <= drp_startd;
    end if;
  end process;
  
  drp_proc : process (clk)
    variable i : integer range 0 to 20 := 0;
  begin
    if rising_edge(clk) then
      -- DEFAULT VALUE
      den <= '0' after DLY;
      dwe <= '0' after DLY;
      addr <= (others => '0') after DLY;
      di <= (others => '0') after DLY;
      drp_done <= '0' after DLY;
      --
      case state is
        when IDLE =>
          i := 0;
          state <= IDLE;
          if (drp_startdd = '1') then
            state <= READ_REGS;             
          end if;
        when READ_REGS =>
          den <= '1' after DLY;           
          addr <= addrs(i) after DLY;
          i := i + 1;
          state <= WAIT_RD_DRDY;
        when WAIT_RD_DRDY =>
          state <= WAIT_RD_DRDY;
          if drdy = '1' then
            state <= READ_REGS;
            if i = 10 then
              state <= ST_SPEED;
              i := 0;
            end if;
          end if;
        when ST_SPEED =>
          state <= ST_SPEED;
          case set_speed is
            when "00" => state <= SET_2GB;
            when "01" => state <= SET_425GB;
            when "10" => state <= SET_4GB;
            when "11" => state <= SET_53125GB;
            when others => state <= SET_2GB;
          end case;          
        when SET_2GB =>            
          state <= WRITEREG;
        when SET_3GB =>           
          state <= WRITEREG;
        when SET_4GB =>
          state <= WRITEREG;
        when SET_425GB =>
          state <= WRITEREG;
        when SET_53125GB =>
          state <= WRITEREG;            
        when WRITEREG =>
          den <= '1' after DLY;
          dwe <= '1' after DLY;
          addr <= addrs(i) after DLY;
          di <= value_reg(i) after DLY;
          i := i + 1;
          state <= WAIT_DRDY;
        when WAIT_DRDY =>
          state <= WAIT_DRDY;
          if DRDY = '1' then
            if i = 10 then
              state <= WAITSTATE;
            else
              state <= WRITEREG;
            end if;
          end if;
        when WAITSTATE =>
          drp_done <= '1' after DLY;
          state <= WAITSTATE;
          if drp_startdd = '0' then
            state <= IDLE;
          end if;
      end case;
    end if;
  end process;

  -- This process registers the output value from the DRP port when read.
  -- I read the value of the registers
  -- I write it back changing only the necessary fields
  p_set_value_reg : process (clk)
    variable index : integer range 0 to 20 := 0;
  begin
    if rising_edge(clk) then
      case state is
        when IDLE =>
          value_reg <= (others => (others=>'0')) after DLY;
          index := 0;
        when WAIT_RD_DRDY =>
          if drdy = '1' then
            value_reg(index) <= drpdo after DLY;
            index := index + 1;
          end if;
        when SET_2GB =>
          -- RX REG
          value_reg(0)(9 downto 0) <= drp2125.ccseq after DLY;
          value_reg(1)(15 downto 8) <= drp2125.pllcpcfg after DLY;
          value_reg(2)(15 downto 14) <= drp2125.plldiv after DLY;
          value_reg(2)(5 downto 1) <= drp2125.plldivselfb after DLY;
          value_reg(3)(5 downto 1) <= drp2125.plldivselref after DLY;
          value_reg(4)(9 downto 5) <= drp2125.clk25_div after DLY;
          -- TX REG
          value_reg(5)(15 downto 8) <= drp2125.pllcpcfg after DLY;
          value_reg(6)(15 downto 14) <= drp2125.plldiv after DLY;
          value_reg(6)(5 downto 1) <= drp2125.plldivselfb after DLY;
          value_reg(7)(5 downto 1) <= drp2125.plldivselref after DLY;
          value_reg(8)(15 downto 14) <= drp2125.tx_tdcc after DLY;
          value_reg(9)(14 downto 10) <= drp2125.clk25_div after DLY;
        when SET_3GB =>
          -- RX REG
          value_reg(0)(9 downto 0) <= drp3125.ccseq after DLY;
          value_reg(1)(15 downto 8) <= drp3125.pllcpcfg after DLY;
          value_reg(2)(15 downto 14) <= drp3125.plldiv after DLY;
          value_reg(2)(5 downto 1) <= drp3125.plldivselfb after DLY;
          value_reg(3)(5 downto 1) <= drp3125.plldivselref after DLY;
          value_reg(4)(9 downto 5) <= drp3125.clk25_div after DLY;
          -- TX REG
          value_reg(5)(15 downto 8) <= drp3125.pllcpcfg after DLY;
          value_reg(6)(15 downto 14) <= drp3125.plldiv after DLY;
          value_reg(6)(5 downto 1) <= drp3125.plldivselfb after DLY;
          value_reg(7)(5 downto 1) <= drp3125.plldivselref after DLY;
          value_reg(8)(15 downto 14) <= drp3125.tx_tdcc after DLY;
          value_reg(9)(14 downto 10) <= drp3125.clk25_div after DLY;
        when SET_4GB => -- TO BE CHANGED WITH 4GB parameters
          -- RX REG
          value_reg(0)(9 downto 0) <= drp3125.ccseq after DLY;
          value_reg(1)(15 downto 8) <= drp3125.pllcpcfg after DLY;
          value_reg(2)(15 downto 14) <= drp3125.plldiv after DLY;
          value_reg(2)(5 downto 1) <= drp3125.plldivselfb after DLY;
          value_reg(3)(5 downto 1) <= drp3125.plldivselref after DLY;
          value_reg(4)(9 downto 5) <= drp3125.clk25_div after DLY;
          -- TX REG
          value_reg(5)(15 downto 8) <= drp3125.pllcpcfg after DLY;
          value_reg(6)(15 downto 14) <= drp3125.plldiv after DLY;
          value_reg(6)(5 downto 1) <= drp3125.plldivselfb after DLY;
          value_reg(7)(5 downto 1) <= drp3125.plldivselref after DLY;
          value_reg(8)(15 downto 14) <= drp3125.tx_tdcc after DLY;
          value_reg(9)(14 downto 10) <= drp3125.clk25_div after DLY;
        when SET_425GB =>
          -- RX REG
          value_reg(0)(9 downto 0) <= drp425.ccseq after DLY;
          value_reg(1)(15 downto 8) <= drp425.pllcpcfg after DLY;
          value_reg(2)(15 downto 14) <= drp425.plldiv after DLY;
          value_reg(2)(5 downto 1) <= drp425.plldivselfb after DLY;
          value_reg(3)(5 downto 1) <= drp425.plldivselref after DLY;
          value_reg(4)(9 downto 5) <= drp425.clk25_div after DLY;
          -- TX REG
          value_reg(5)(15 downto 8) <= drp425.pllcpcfg after DLY;
          value_reg(6)(15 downto 14) <= drp425.plldiv after DLY;
          value_reg(6)(5 downto 1) <= drp425.plldivselfb after DLY;
          value_reg(7)(5 downto 1) <= drp425.plldivselref after DLY;
          value_reg(8)(15 downto 14) <= drp425.tx_tdcc after DLY;
          value_reg(9)(14 downto 10) <= drp425.clk25_div after DLY;          
        when SET_53125GB =>
          -- RX REG
          value_reg(0)(9 downto 0) <= drp53125.ccseq;
          value_reg(1)(15 downto 8) <= drp53125.pllcpcfg after DLY;
          value_reg(2)(15 downto 14) <= drp53125.plldiv after DLY;
          value_reg(2)(5 downto 1) <= drp53125.plldivselfb after DLY;
          value_reg(3)(5 downto 1) <= drp53125.plldivselref after DLY;
          value_reg(4)(9 downto 5) <= drp53125.clk25_div after DLY;
          -- TX REG
          value_reg(5)(15 downto 8) <= drp53125.pllcpcfg after DLY;
          value_reg(6)(15 downto 14) <= drp53125.plldiv after DLY;
          value_reg(6)(5 downto 1) <= drp53125.plldivselfb after DLY;
          value_reg(7)(5 downto 1) <= drp53125.plldivselref after DLY;
          value_reg(8)(15 downto 14) <= drp53125.tx_tdcc after DLY;
          value_reg(9)(14 downto 10) <= drp53125.clk25_div after DLY;
        when others => null;
      end case;
    end if;
  end process;
  
end rtl;
