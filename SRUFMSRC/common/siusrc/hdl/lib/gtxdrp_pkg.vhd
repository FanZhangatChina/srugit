library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

package gtxdrp_pkg is

  type drp_rec is
  record
    ccseq : std_logic_vector(9 downto 0);
    pllcpcfg : std_logic_vector (7 downto 0);
    plldivselfb : std_logic_vector (4 downto 0);
    plldiv : std_logic_vector(1 downto 0);
    plldivselref : std_logic_vector(4 downto 0);
    plldivsel45fb : std_logic;
    clk25_div : std_logic_vector(4 downto 0); 
    tx_tdcc : std_logic_vector(1 downto 0);
  end record;

  -- 2.125 Gb/s
  constant drp2125 : drp_rec := ("0011000101",
                                 x"0D",
                                 "00000",
                                 "01",
                                 "10000",
                                 '1',
                                 "01000",
                                 "00");
  -- 3.125 Gb/s
  constant drp3125 : drp_rec := ("0010010101",
                                 x"0D",
                                 "00000",
                                 "00",
                                 "10000",
                                 '1',
                                 "00110",
                                 "11");
  -- 4 Gb/s
  constant drp4 : drp_rec := ("0011000101",
                              x"0D",
                              "00000",
                              "00",
                              "10000",                           
                              '1',
                              "00111",
                              "11");

  -- 4.25 Gb/s
  constant drp425 : drp_rec := ("0011000101",
                                 x"0D",
                                 "00000",
                                 "00",
                                 "10000",
                                 '1',
                                 "01000",
                                 "11");
  -- 5 Gb/s
  constant drp5 : drp_rec := ("0011000101",
                              x"0D",
                              "00010",
                              "00",
                              "10000",                            
                              '0',
                              "00110",
                              "11");

  -- 5.3125 Gb/s
  constant drp53125 : drp_rec := ("0010010101",
                                  x"07",
                                  "00011",
                                  "00",
                                  "00000",
                                  '1',
                                  "01000",
                                  "11");

  type addr_array is array (0 to 9) of std_logic_vector (7 downto 0);
  constant addrs : addr_array := (x"0E",x"1A",x"1B",x"1C",x"17",
                                  x"1E",x"1F",x"20",x"39",x"23");

  
end;

