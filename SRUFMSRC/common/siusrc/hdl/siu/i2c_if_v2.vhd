--******************************************************************************
--*
--* Module          : I2C_IF
--* File            : i2c_if.vhd
--* Library         : ieee
--* Description     : It is the I2C interface module
--* Author/Designer : Filippo Costa (filippo.costa@cern.ch)
--*
--*  Revision history:
--*     16/01/13 PC I2C fake interface to retireve information of the S/N from
--*                 the EPROM not installed in the VHDL version
--*   20-06-13 PC moved to active high synch reset
--*   02-07-14 PC set new serial number for each channels
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.siu_my_conversions.all;
use work.siu_my_utilities.all;

entity siu_i2c_if is
  generic (CH : integer range 0 to 1 := 0);
  port (
    clock       : in    std_logic;
    rst         : in    std_logic;
--    i2c_address : in    std_logic_vector ( 7 downto 0);
--    i2c_wrdata  : in    std_logic_vector ( 7 downto 0);
    ip_sn	: in std_logic_vector(31 downto 0);	
	 i2c_rddata  : out   std_logic_vector ( 7 downto 0);
--    i2c_rdwrn   : in    std_logic;
    i2c_req     : in    std_logic;
    i2c_ack     : out   std_logic;
--    i2c_error   : out   std_logic;
--    i2c_sda     : inout std_logic;
--    i2c_scl     : out   std_logic;
    -- SET SPEED
    set_speed : in std_logic_vector(1 downto 0));

end siu_i2c_if;

architecture SYN of siu_i2c_if is

  type eprom_data_array is array (40 downto 0) of std_logic_vector (7 downto 0);
  constant EPROM_DATA : eprom_data_array := (x"00",x"20",x"3a",x"4e",x"2f",x"53",x"20",x"73",x"70",x"62",x"4d",x"20",x"20",x"3a",x"50",x"53",x"20",x"20",x"58",x"4c",x"56",x"36",x"43",x"58",x"20",x"3a",x"44",x"4c",x"20",x"31",x"76",x"33",x"20",x"64",x"72",x"61",x"63",x"20",x"4c",x"44",x"44");

  type serial_number_array is array (4 downto 0) of std_logic_vector(7 downto 0);
--  signal SERIAL_NUMBER_CH0 : serial_number_array := (x"30",x"31",x"31",x"31",x"32");
--  signal SERIAL_NUMBER_CH1 : serial_number_array := (x"31",x"32",x"32",x"32",x"32");
  signal SERIAL_NUMBER_CH0 : serial_number_array;
  signal SERIAL_NUMBER_CH1 : serial_number_array;
--  constant SERIAL_NUMBER_CH2 : serial_number_array := (x"33",x"33",x"33",x"33",x"33");
--  constant SERIAL_NUMBER_CH3 : serial_number_array := (x"34",x"34",x"34",x"34",x"34");
--  constant SERIAL_NUMBER_CH4 : serial_number_array := (x"35",x"35",x"35",x"35",x"35");
--  constant SERIAL_NUMBER_CH5 : serial_number_array := (x"36",x"36",x"36",x"36",x"36");
--  constant SERIAL_NUMBER_CH6 : serial_number_array := (x"37",x"37",x"37",x"37",x"37");
--  constant SERIAL_NUMBER_CH7 : serial_number_array := (x"38",x"38",x"38",x"38",x"38");
--  constant SERIAL_NUMBER_CH8 : serial_number_array := (x"39",x"39",x"39",x"39",x"39");
--  constant SERIAL_NUMBER_CH9 : serial_number_array := (x"40",x"40",x"40",x"40",x"40");
--  constant SERIAL_NUMBER_CH10 : serial_number_array := (x"41",x"41",x"41",x"41",x"41");
--  constant SERIAL_NUMBER_CH11 : serial_number_array := (x"42",x"42",x"42",x"42",x"42");

  type link_speed_array is array (3 downto 0) of std_logic_vector(7 downto 0);
  constant LINK_SPEED_00 : link_speed_array := (x"35",x"32",x"31",x"32");
  constant LINK_SPEED_01 : link_speed_array := (x"30",x"35",x"32",x"34");
  constant LINK_SPEED_11 : link_speed_array := (x"32",x"31",x"33",x"35"); 
  --
  type i2c_state is (
    I2C_IDLE,
    I2C_TXDATA,
    I2C_TXSN,
    I2C_TXLS,
    I2C_TXWAITACK
    );  
  signal state : i2c_state;

  signal wr_sn : std_logic := '0';
  signal wr_ls : std_logic := '0';
  
begin  -- SYN 
  SERIAL_NUMBER_CH0(4) <= x"30";
  SERIAL_NUMBER_CH1(4) <= x"31";
  SERIAL_NUMBER_CH0(3) <= ip_sn(7 downto 0);
  SERIAL_NUMBER_CH1(3) <= ip_sn(7 downto 0);
  SERIAL_NUMBER_CH0(2) <= ip_sn(15 downto 8);
  SERIAL_NUMBER_CH1(2) <= ip_sn(15 downto 8);
  SERIAL_NUMBER_CH0(1) <= ip_sn(23 downto 16);
  SERIAL_NUMBER_CH1(1) <= ip_sn(23 downto 16);
  SERIAL_NUMBER_CH0(0) <= ip_sn(31 downto 24);
  SERIAL_NUMBER_CH1(0) <= ip_sn(31 downto 24);  

  p_main: process (clock)
    variable index : integer range 0 to 49 := 0;
    variable index_speed : integer range 0 to 4 := 0;
    variable index_ch : integer range 0 to 5 := 0;
  begin
    if rising_edge(clock) then
      if rst = '1' then
        state <= I2C_IDLE;
        index := 0;
        index_speed := 0;
        index_ch := 0;
      else
        i2c_ack <= '0';
        case state is
          when I2C_IDLE =>
            if i2c_req = '1' then
              state <= I2C_TXDATA;
              if wr_ls = '1' then
                state <= I2C_TXLS;
              end if;
              if wr_sn = '1' then
                state <= I2C_TXSN;
              end if;
            else
              state <= I2C_IDLE;
            end if;
          when I2C_TXDATA =>
            state <= I2C_TXWAITACK;
            i2c_rddata <= EPROM_DATA(index);
            index := index + 1; -- increase address
            if index = 29 then
              wr_ls <= '1';
            end if;
            if index = 40 then
              wr_sn <= '1';
            end if;
          when I2C_TXLS =>
            state <= I2C_TXWAITACK;
            case set_speed is
              when "00" => i2c_rddata <= LINK_SPEED_00(index_speed);
              when "01" => i2c_rddata <= LINK_SPEED_01(index_speed);
              when "11" => i2c_rddata <= LINK_SPEED_11(index_speed);
              when others => i2c_rddata <= LINK_SPEED_00(index_speed);
            end case;             
            index_speed := index_speed + 1; -- increase address
            if index_speed = 4 then
              wr_ls <= '0';
              index_speed := 0;
            end if;
          when I2C_TXSN =>
            state <= I2C_TXWAITACK;
            case CH is
              when 0 => i2c_rddata <= SERIAL_NUMBER_CH0(index_ch);
              when 1 => i2c_rddata <= SERIAL_NUMBER_CH1(index_ch);
--              when 2 => i2c_rddata <= SERIAL_NUMBER_CH2(index_ch);
--              when 3 => i2c_rddata <= SERIAL_NUMBER_CH3(index_ch);
--              when 4 => i2c_rddata <= SERIAL_NUMBER_CH4(index_ch);
--              when 5 => i2c_rddata <= SERIAL_NUMBER_CH5(index_ch);
--              when 6 => i2c_rddata <= SERIAL_NUMBER_CH6(index_ch);
--              when 7 => i2c_rddata <= SERIAL_NUMBER_CH7(index_ch);
--              when 8 => i2c_rddata <= SERIAL_NUMBER_CH8(index_ch);
--              when 9 => i2c_rddata <= SERIAL_NUMBER_CH9(index_ch);
--              when 10 => i2c_rddata <= SERIAL_NUMBER_CH10(index_ch);
--              when 11 => i2c_rddata <= SERIAL_NUMBER_CH11(index_ch);
            end case;             
            index_ch := index_ch + 1; -- increase address
            if index_ch = 5 then
              wr_sn <= '0';
              index_ch := 0;
            end if;
          when I2C_TXWAITACK =>
            i2c_ack <= '1';
            if i2c_req = '1' then
              state <= I2C_TXWAITACK;
            else
              state <= I2C_IDLE;
            end if;
            if index = 41 then
              index := 0;           
            end if;
            when others => null;
        end case;
      end if;
    end if;
  end process;
  
end SYN;
