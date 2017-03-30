----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:36:36 04/27/2011 
-- Design Name: 
-- Module Name:    sc_flash_if - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity sc_flash_if is
	 Generic (
			flash_port : std_logic_vector(15 downto 0) := x"0000"
			);
    Port ( clk : in  STD_LOGIC;
           rstn : in  STD_LOGIC;
			  state_led : out  STD_LOGIC;
           sc_port : in  STD_LOGIC_VECTOR (15 downto 0);
           sc_data : in  STD_LOGIC_VECTOR (31 downto 0);
           sc_addr : in  STD_LOGIC_VECTOR (31 downto 0);
           sc_subaddr : in  STD_LOGIC_VECTOR (31 downto 0);
           sc_op : in  STD_LOGIC;
           sc_frame : in  STD_LOGIC;
           sc_wr : in  STD_LOGIC;
           sc_ack : out  STD_LOGIC;
           sc_rply_data : out  STD_LOGIC_VECTOR (31 downto 0);
           sc_rply_error : out  STD_LOGIC_VECTOR (31 downto 0);
			  --flash
			A: out std_logic_vector(23 downto 0);
			DQout: OUT std_logic_vector(15 downto 0);
			DQin: IN std_logic_vector(15 downto 0);
			DQ_T: out  std_logic;
         FLASH_CS_B : out  std_logic;
         FLASH_OE_B : out  std_logic;
         FLASH_WE_B : out  std_logic
			  );
end sc_flash_if;

architecture Behavioral of sc_flash_if is
type state_type is (stIdle, stRD0, stRD1, stRD2, stRD3, stRD30,
							stSR0, stSR1,
							stWR0, stWR1, stWR2, stWR3, stWR4, stWR5, stWR50, 
							stWP0, stWP1, stWP2, stWP3, stWP30, stWP4, stWP5, stWP6, stWP7, stWP8, stWP9, 
							stAck0, stAck1);
signal state: state_type;

type state_monitor_type is (stmIdle, stmReading, stmWriting, stmProgramming, stmEnd);
signal stmstate, stmstate2: state_monitor_type;
signal stmcounter : std_logic_vector(21 downto 0);

--signal dqin, dqout : std_logic_vector(15 downto 0);
--signal dq_t, FLASH_OE_B_i : std_logic;
signal FLASH_OE_B_i : std_logic;
SIGNAL wpcount : std_logic_vector(15 downto 0);

attribute KEEP : boolean;
attribute KEEP of dqout: signal is true;
attribute KEEP of dq_t: signal is true;
attribute KEEP of A: signal is true;
attribute KEEP of FLASH_OE_B_i: signal is true;
attribute KEEP of FLASH_WE_B: signal is true;
attribute KEEP of FLASH_CS_B: signal is true;

begin

	process(clk, rstn)
	begin	
		if rstn = '0' then
			stmstate <= stmIdle;
			stmstate2 <= stmIdle;
			stmcounter <= (others => '0');
		elsif clk'event and clk = '1' then
			if (stmstate = stmIdle) then
				stmcounter <= (others => '0');
			else 
				stmcounter <= stmcounter + 1;
			end if;
			if stmstate = stmIdle then
				if state = stRD0 then
					stmstate <= stmReading;
					stmstate2 <= stmReading;
				elsif state = stWR0 then
					stmstate <= stmWriting;
					stmstate2 <= stmWriting;
				elsif state = stWP0 then
					stmstate <= stmProgramming;
					stmstate2 <= stmProgramming;
				end if;
			elsif stmstate = stmEnd then
				if ((not stmcounter) = 0) then
					stmstate <= stmIdle;
					stmstate2 <= stmIdle;
				end if;
			else
				if state = stIdle then	
					stmstate <= stmEnd;
				end if;
			end if;
		end if;
	end process;
	
	state_led <= 	(not stmcounter(19)) 																		when (stmstate2 = stmProgramming) else
					((not stmcounter(19)) and (not stmcounter(21))) 									when (stmstate2 = stmWriting) else
					((not stmcounter(19)) and (not stmcounter(21)) and (not stmcounter(20)))	when (stmstate2 = stmReading) else '0';
				
--	dqbuf: for i in 0 to 15 generate
--	begin
--		dqIOBUF : IOBUF
--		generic map (	DRIVE => 12,	IOSTANDARD => "DEFAULT",	SLEW => "FAST")
--		port map (	O => dqin(i),   IO => dq(i),   I => dqout(i),  T => dq_t   );
--	end generate;
  	
--	dq <= dqout when dq_t = '0' else "ZZZZZZZZZZZZZZZZ";
--	dqin <= dq;
	
	FLASH_OE_B <= FLASH_OE_B_i;

	process(clk, rstn)
	begin
		if rstn = '0' then
			state <= stIdle;
			sc_ack <= '0';
			sc_rply_data <= (others => '0');
			sc_rply_error <= (others => '0');
			a <= x"000000";
			dq_t 	<= '1';
			FLASH_CS_B <= '1';
			FLASH_WE_B <= '1';
			FLASH_OE_B_i <= '1';
			dqout <= x"0000";
			wpcount <= x"0000";
		elsif clk'event and clk = '1' then
			case state is
				when stIdle =>
					wpcount <= x"0000";
					sc_ack <= '0';
					sc_rply_data <= (others => '0');
					sc_rply_error <= (others => '0');
					dq_t 	<= '1';
					FLASH_CS_B <= '1';
					FLASH_WE_B <= '1';
					FLASH_OE_B_i <= '1';
					if ((sc_frame and sc_op) = '1') and (sc_port = flash_port) then
						if sc_wr = '0' then
							state <= stRD0;
						else
							state <= stSR0;
						end if;
					end if;
				when stRD0 =>
					state <= stRD1;
					a 		<= x"000000";
					dqout <= x"00" & sc_subaddr(7 downto 0);
					dq_t 	<= '0';
					FLASH_CS_B <= '0';
					FLASH_WE_B <= '0';
					FLASH_OE_B_i <= '1';
				when stRD1 =>
					FLASH_WE_B <= '1';
					state <= stRD2;
				when stRD2 =>
					a <= sc_addr(23 downto 0);
					dq_t 	<= '1';
					FLASH_OE_B_i <= '1';
					state <= stRD3;
				when stRD3 =>
					FLASH_OE_B_i <= '0';
					if sc_subaddr(31) = '1' then
						state <= stRD30;
					else
						state <= stAck0;
					end if;
				when stRD30 =>
					FLASH_OE_B_i <= '0';
					state <= stAck0;
					
				when stSR0 =>
					state <= stSR1;
					a 		<= sc_addr(23 downto 0);
					dqout <= x"0050";
					dq_t 	<= '0';
					FLASH_CS_B <= '0';
					FLASH_WE_B <= '0';
					FLASH_OE_B_i <= '1';
				when stSR1 =>
					FLASH_WE_B <= '1';
					if sc_subaddr(7 downto 0) = x"E8" then
						state <= stWP0;
					else
						state <= stWR0;
					end if;
					
				when stWP0 =>
					state <= stWP1;
					a 		<= sc_addr(23 downto 0);
					dqout <= x"00E8";
					dq_t 	<= '0';
					FLASH_CS_B <= '0';
					FLASH_WE_B <= '0';
					FLASH_OE_B_i <= '1';
				when stWP1 =>
					FLASH_WE_B <= '1';
					state <= stWP2;
				when stWP2 =>
					dq_t 	<= '1';
					FLASH_OE_B_i <= '1';
					if (FLASH_OE_B_i = '0') and (dqin(7) = '1') then
						if wpcount > sc_subaddr(23 downto 8) then
							state <= stAck0;
							sc_rply_error <= x"0000" & dqin;
						else
							state <= stWP4;
						end if;
--						sc_rply_error <= x"0000" & dqin;
--						sc_rply_data <= sc_data;
					else
						state <= stWP3;
					end if;
				when stWP3 =>
					FLASH_OE_B_i <= '0';
					if sc_subaddr(31) = '1' then
						state <= stWP30;
					else
						state <= stWP2;
					end if;
				when stWP30 =>
					FLASH_OE_B_i <= '0';
					state <= stWP2;
				when stWP4 =>
					state <= stWP5;
					a 		<= sc_addr(23 downto 0);
					dqout <= sc_subaddr(23 downto 8);
					dq_t 	<= '0';
					FLASH_CS_B <= '0';
					FLASH_WE_B <= '0';
					FLASH_OE_B_i <= '1';
				when stWP5 =>
					FLASH_WE_B <= '1';
					state <= stWP6;
				when stWP6 =>
					if wpcount > sc_subaddr(23 downto 8) then
						sc_rply_data <= sc_data;
						sc_rply_error <= x"FFFFFFFF";
						state <= stAck0;
					else
						state <= stWP7;
						a 		<= sc_addr(23 downto 0);
						dqout <= sc_data(15 downto 0);
						dq_t 	<= '0';
						FLASH_CS_B <= '0';
						FLASH_WE_B <= '0';
						FLASH_OE_B_i <= '1';
					end if;
				when stWP7 =>
					FLASH_WE_B <= '1';
						sc_rply_data <= x"0000" & dqin;
						sc_rply_error <= x"00000000";
					wpcount <= wpcount + 1;
					if wpcount = sc_subaddr(23 downto 8) then
						state <= stWP8;
					else
						state <= stAck0;
					end if;
				when stWP8 =>
					state <= stWP9;
					a 		<= sc_addr(23 downto 0);
					dqout <= x"00D0";
					dq_t 	<= '0';
					FLASH_CS_B <= '0';
					FLASH_WE_B <= '0';
					FLASH_OE_B_i <= '1';
				when stWP9 =>
					FLASH_WE_B <= '1';
					state <= stWP2;

				when stWR0 =>
					state <= stWR1;
					a 		<= sc_addr(23 downto 0);
					dqout <= sc_data(31 downto 16);
					dq_t 	<= '0';
					FLASH_CS_B <= '0';
					FLASH_WE_B <= '0';
					FLASH_OE_B_i <= '1';
				when stWR1 =>
					FLASH_WE_B <= '1';
					state <= stWR2;
				when stWR2 =>
					state <= stWR3;
					a 		<= sc_addr(23 downto 0);
					dqout <= sc_data(15 downto 0);
					dq_t 	<= '0';
					FLASH_CS_B <= '0';
					FLASH_WE_B <= '0';
					FLASH_OE_B_i <= '1';
				when stWR3 =>
					FLASH_WE_B <= '1';
					state <= stWR4;
				when stWR4 =>
					dq_t 	<= '1';
					FLASH_OE_B_i <= '1';
					if (FLASH_OE_B_i = '0') and (dqin(7) = '1') then
						state <= stAck0;
						sc_rply_error <= x"0000" & dqin;
						sc_rply_data <= sc_data;
					else
						state <= stWR5;
					end if;
				when stWR5 =>
					FLASH_OE_B_i <= '0';
					if sc_subaddr(31) = '1' then
						state <= stWR50;
					else
						state <= stWR4;
					end if;
				when stWR50 =>
					FLASH_OE_B_i <= '0';
					state <= stWR4;

				when stAck0 =>
					sc_ack <= '1';
					if sc_wr = '0' then
						sc_rply_data <= x"0000" & dqin;
						sc_rply_error <= x"00000000";
					end if;
					if sc_op = '0' then
						state <= stAck1;
						sc_ack <= '0';
					end if;
				when stAck1 =>
					sc_ack <= '0';
					if sc_frame = '0' then
						state <= stIdle;
					elsif sc_op = '1' then
						if sc_wr = '0' then
							state <= stRD2;
						else
							if sc_subaddr(7 downto 0) = x"E8" then
								state <= stWP6;
							else
								state <= stWR0;
							end if;
						end if;
					end if;
				when others =>
					state <= stIdle;
			end case;
		end if;
	end process;


end Behavioral;

