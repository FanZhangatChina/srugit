--******************************************************************************
--*
--* Module          : GTX_RESET
--* File            : gtx_reset.vhd
--* Library         : ieee
--* Description     : Component to generate GTXTXRESET and GTXRXRESET (tied together)
--                    GTX_RST act as an asycnhronous reset signal and it should
--                    be one REF CLOCK CYCLE
--* Author/Designer : Filippo Costa (filippo.costa@cern.ch)
--*
--*  Revision history:
--*     20-02-14 PC improved the GTXRST
--*     
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity gtx_reset is
  port (
    clk : in std_logic;
    rst : in std_logic;
    --==============================--
    -- DRP interface
    --==============================--
    drp_start : out std_logic;
    drp_done  : in std_logic;
    --==============================--
    -- GTX resets
    --==============================--
   -- qsfp_rst_n : out std_logic_vector (2 downto 0); -- QSFP RESET
    gtx_rst : out std_logic);                       -- GTX RST
end gtx_reset;

architecture rtl of gtx_reset is
  -- CONSTANTs
  constant DLY : TIME := 1 ns;
  -- debouncer
  attribute shreg_extract : string;  
  signal ff : std_logic_vector(1 downto 0);
  attribute shreg_extract of ff : signal is "no";
  signal counter_set : std_logic;
  signal counter_out : std_logic_vector(19 downto 0) := (others => '0');
  -- SIGNALs
  signal rst_detected : std_logic := '0';
  type reset_state is (IDLE,DRP_SSTART,DRP_SDONE,QSFP_RESET,GTX_RESET,WAITST );
  signal state : reset_state := IDLE;
  -- DRP interface
  signal drpdone : std_logic_vector(1 downto 0);
  attribute shreg_extract of drpdone : signal is "no";
  signal qsfp_rst_n : std_logic_vector (2 downto 0);
begin

  p_debpb : process(clk)
  begin
    if rising_edge(clk) then
      counter_set <= ff(0) xor ff(1) after DLY;
      ff(0) <= rst after DLY;
      ff(1) <= ff(0) after DLY;      
      if (counter_set = '1') then
        counter_out <= (others => '0') after DLY;
      elsif (counter_out(19) = '0') then
        counter_out <= counter_out + 1 after DLY;
      else
        rst_detected <= not ff(1) after DLY;
      end if;
    end if;
  end process;

  p_drpdone : process(clk)
  begin
    if rising_edge(clk) then
      drpdone(0) <= drp_done;
      drpdone(1) <= drpdone(0);
    end if;
  end process;
  
  -- Process to RESET QSFP and activate GTXRST for one REFCLK cycle
  p_reset : process (clk)
    variable counter : integer range 0 to 10 := 0;
  begin
    if rising_edge(clk) then
      if rst_detected = '1' then
        state <= IDLE;
        counter := 0;          
      else
        -- DEFAULT value
        qsfp_rst_n <= (others => '1') after DLY;
        gtx_rst <= '0' after DLY;
        drp_start <= '0' after  DLY;
        case state is
          when IDLE =>
            state <= DRP_SSTART;--QSFP_RESET;
          when DRP_SSTART =>
            drp_start <= '1' after DLY;
            state <= DRP_SSTART;
            if drpdone(1) = '1' then                         
              state <= DRP_SDONE;
            end if;            
          when DRP_SDONE =>
            state <= DRP_SDONE;
            if drpdone(1) = '0' then
              qsfp_rst_n <= (others => '0') after DLY;              
              state <= QSFP_RESET;
              counter := 0;     
            end if;            
          when QSFP_RESET =>
            qsfp_rst_n <= "000" after DLY;
            state <= QSFP_RESET;
            if counter = 2 then
              state <= GTX_RESET;
              counter := 0;
            else
              counter := counter + 1;
            end if;
          when GTX_RESET =>
            state <= GTX_RESET;
            if counter = 5 then
              gtx_rst <= '1' after DLY; -- wait a bit after the QSFP RESET and
              -- GTXRST 1 REFCLK cycle
              counter := 0;
              state <= WAITST;
            else
              counter := counter + 1;
            end if;
          when WAITST =>
            state <= WAITST;
        end case;
      end if;
    end if;
  end process;
  
end rtl;

