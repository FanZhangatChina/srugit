--345678901234567890123456789012345678901234567890123456789012345678901234567890
--******************************************************************************
--*
--* Package         : MY_CONVERSIONS
--* File            : my_conversions.vhd
--* Library         : ieee
--* Description     : It is a package with custom functions for conversion.
--* Simulator       : Modelsim
--* Synthesizer     : Lenoardo Spectrum + Quartus II
--* Author/Designer : C. SOOS ( Csaba.Soos@cern.ch)
--*
--******************************************************************************

library ieee;
use ieee.std_logic_1164.all;

package siu_my_conversions is
  function bool2sl (b : boolean) return std_logic;
  function int2slv (int : integer; w : natural) return std_logic_vector;
  function slv2int (slv : std_logic_vector) return integer;
  function sl2int  (sl : std_logic) return integer;
  function slv2hstr (slv : std_logic_vector) return string;
  function rotate  (slv : std_logic_vector) return std_logic_vector;
end siu_my_conversions;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

package body siu_my_conversions is

  function bool2sl (b : boolean) return std_logic is
  begin
    if b then
      return '1';
    else
      return '0';
    end if;
  end bool2sl;

  function int2slv (int : integer; w : natural) return std_logic_vector is
  begin
    return std_logic_vector(to_unsigned(int,w));
  end int2slv;

  function sl2int (sl : std_logic) return integer is
  begin  -- sl2int
    if sl = '0' then
      return 0;
    else
      return 1;
    end if;
  end sl2int;

  function slv2int (slv : std_logic_vector) return integer is
    variable result : integer;
  begin
-- pragma synthesis_off
    assert (slv'length < 33) report "Too long vector";
-- pragma synthesis_on
    result := 0;
    for i in slv'range loop
      if (slv(i) = '1') then
        result := result + 2**i;
      end if;
    end loop;
    return result;
  end slv2int;

    function slv2hstr (slv : std_logic_vector) return string is
      variable slv32 : std_logic_vector (31 downto 0);
      variable nib_slv : std_logic_vector (3 downto 0);
      variable nib_int : integer;
      variable result : string (10 downto 1) := "0x00000000";
    begin  -- slv2str
    -- pragma synthesis_off
      assert (slv'length < 33) report "Too long vector";
    -- pragma synthesis_on
      if slv'length < 32 then
        slv32 := int2slv(slv2int(slv), 32);
      else
        slv32 := slv;
      end if;
      for i in 7 downto 0 loop
        nib_slv := slv32(i*4+3 downto i*4);
        nib_int := slv2int(nib_slv);
        if nib_int < 10 then
          result(i+1) := character'val(character'pos('0')+nib_int);
        else
          result(i+1) := character'val(character'pos('A')+nib_int-10);
        end if;
      end loop;  -- i
      return result;
    end slv2hstr;

  function rotate (slv : std_logic_vector) return std_logic_vector is
    variable result : std_logic_vector (slv'range);
  begin
    for i in slv'range loop
      result(slv'length - 1 - i) := slv(i);
    end loop;
    return result;
  end;

end siu_my_conversions;



