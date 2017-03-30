----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:54:22 02/18/2011 
-- Design Name: 
-- Module Name:    scRXdecode2 - Behavioral 
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity scRXdecode2 is
    Port ( clk : in  STD_LOGIC;
           rstn : in  STD_LOGIC;
			  -------------------------------
           scq_full : in  STD_LOGIC;
           scq_empty : in  STD_LOGIC;
           scq_data : in  STD_LOGIC_VECTOR (31 downto 0);
           scq_datavalid : in  STD_LOGIC;
           scq_length : in  STD_LOGIC_VECTOR (15 downto 0);
           scq_srcIP : in  STD_LOGIC_VECTOR (31 downto 0);
           scq_dstPort : in  STD_LOGIC_VECTOR (15 downto 0);
           scq_sof : in  STD_LOGIC;
           scq_eof : in  STD_LOGIC;
           scq_ren : out  STD_LOGIC;
			  -------------------------------
			  error_flag : out std_logic;
			  frame_error : out STD_LOGIC_VECTOR (7 downto 0);
			  -------------------------------
           sc_port : out  STD_LOGIC_VECTOR (15 downto 0);
           sc_ip : out  STD_LOGIC_VECTOR (31 downto 0);
           sc_rply_bulk : out  STD_LOGIC_VECTOR (127 downto 0);
           sc_data : out  STD_LOGIC_VECTOR (31 downto 0);
           sc_addr : out  STD_LOGIC_VECTOR (31 downto 0);
           sc_subaddr : out  STD_LOGIC_VECTOR (31 downto 0);
           sc_wr : out  STD_LOGIC;
           sc_op : out  STD_LOGIC;
           sc_frame : out  STD_LOGIC;
           sc_ack : in  STD_LOGIC
);
end scRXdecode2;

architecture Behavioral of scRXdecode2 is

constant CMD_WRITE_PAIRS : std_logic_vector(31 downto 0) := x"AAAAFFFF";
constant CMD_WRITE_BURST : std_logic_vector(31 downto 0) := x"AABBFFFF";
constant CMD_READ_BURST : std_logic_vector(31 downto 0) := x"BBBBFFFF";
constant CMD_READ_LIST : std_logic_vector(31 downto 0) := x"BBAAFFFF";

   type state_type is (stIdle, stQWaitSOF, stFlushFrame, stQReadSubaddr, stQReadCmd, stQReadCmdInfo, stCmdEx, stWaitPeripheral); 
   signal state, next_state : state_type; 
 signal frame_id, frame_IP, frame_subaddress, frame_cmdinfo, frame_cmd: std_logic_vector(31 downto 0);
 signal frame_port: std_logic_vector(15 downto 0);
 signal frame_length, frame_counter: std_logic_vector(8 downto 0);
 signal frame_checksum: std_logic_vector(1 downto 0);
 signal eof_flag, abort_on_checksum, sc_op_i: std_logic;
 
 signal frame_error_i: std_logic_vector(7 downto 0);
 --- fatal errors causing frame to be dropped
 ---		[0] - checksum error
 ---		[2] - illformed command
 ---		[3] - command unrecognized

begin
	
	abort_on_checksum <= '1';
	
	sc_port <= frame_port;
	sc_ip <= frame_ip;
	sc_subaddr <= frame_subaddress;
	sc_op <= sc_op_i;
	
	
	
   SYNC_PROC: process (clk, rstn)
   begin
		if (rstn = '0') then
			state <= stIdle;
			frame_error <= (others => '0');
			error_flag <= '0';
      elsif (clk'event and clk = '1') then
          state <= next_state;
			 if (state = stFlushFrame) and (next_state /= stFlushFrame) then
				error_flag <= '1';
			 else
				error_flag <= '0';
			 end if;
			 if state = stIdle then
				frame_error <= (others => '0');
			 elsif (next_state = stFlushFrame) and (state /= stFlushFrame) then
				frame_error <= frame_error_i;
			 end if;
      end if;
   end process;
 
 OUTPUT_DECODE: process (clk, rstn)
   begin
		if (rstn = '0') then
			frame_counter <= (others => '0');
			frame_id <= (others => '0');
			frame_port  <= (others => '0'); 
			frame_IP <= (others => '0');
			frame_length <= (others => '0');
			frame_checksum <= (others => '0');
			frame_subaddress <= (others => '0');
			frame_cmd <= (others => '0');
			frame_cmdinfo <= (others => '0');
			eof_flag <= '0';
			sc_addr <= (others => '0');
			sc_data <= (others => '0');
			sc_op_i <= '0';
			sc_wr <= '0';
			sc_frame <= '0';
			sc_rply_bulk <= (others => '0');
      elsif (clk'event and clk = '1') then
			-- default values
			sc_op_i <= '0';
			-- state switch
			case (state) is
				when stIdle =>
					frame_counter <= (others => '0');
					eof_flag <= '0';
					sc_addr <= (others => '0');
					sc_data <= (others => '0');
					sc_wr <= '0';
					sc_frame <= '0';
					sc_rply_bulk <= (others => '0');
				when stQWaitSOF =>
					-- read frame information
					if scq_sof = '1' then
						frame_id <= scq_data;
						-- first bit is set to 0 to signal a reply
						sc_rply_bulk(127 downto 96) <= '0' & scq_data(30 downto 0);
						frame_port <= scq_dstPort;
						frame_IP <= scq_srcIP;
						frame_length <= scq_length(10 downto 2);
						frame_checksum <= scq_length(1 downto 0);
						frame_counter <= frame_counter + 1;
					end if;
				when stFlushFrame =>
				when stQReadSubaddr =>
					if scq_datavalid = '1' then
						frame_subaddress <= scq_data;
						sc_rply_bulk( 95 downto 64) <= scq_data;
						frame_counter <= frame_counter + 1;
					end if;
				when stQReadCmd =>
					if scq_datavalid = '1' then 
						frame_counter <= frame_counter + 1; 
						frame_cmd <= scq_data;
						sc_rply_bulk( 63 downto 32) <= scq_data;
					end if;
				when stQReadCmdInfo => 
					if scq_datavalid = '1' then 
						frame_counter <= frame_counter + 1; 
						frame_cmdinfo <= scq_data;
						sc_rply_bulk( 31 downto  0) <= scq_data;
					end if;
				when stCmdEx =>
					sc_frame <= '1';
					if scq_eof = '1' then
						eof_flag <= '1';
					end if;
					case frame_cmd is
						when CMD_WRITE_PAIRS =>
							sc_wr <= '1';
							if scq_datavalid = '1' then 
								frame_counter <= frame_counter + 1; 
								if frame_counter(0) = '0' then
									sc_addr <= scq_data;
								else
									sc_data <= scq_data;
									sc_op_i <= '1';
								end if;
							end if;
						when CMD_WRITE_BURST =>
							sc_wr <= '1';
							if scq_datavalid = '1' then 
								frame_counter <= frame_counter + 1;
								sc_addr <= frame_cmdinfo;
								sc_data <= scq_data;
								frame_cmdinfo <= frame_cmdinfo + 1;
								sc_op_i <= '1';
							end if;
						when CMD_READ_BURST =>
							sc_wr <= '0';
							if scq_datavalid = '1' then 
								frame_counter <= frame_counter + 1;
								sc_addr <= frame_cmdinfo;
								sc_data <= x"00000000";
								frame_cmdinfo <= frame_cmdinfo + 1;
								sc_op_i <= '1';
							end if;
						when CMD_READ_LIST =>
							sc_wr <= '0';
							if scq_datavalid = '1' then 
								frame_counter <= frame_counter + 1;
								sc_addr <= scq_data;
								sc_data <= x"00000000";
								sc_op_i <= '1';
							end if;
						when others =>
							sc_frame <= '0';
					end case;
				
				when stWaitPeripheral =>
					if sc_ack = '0' then
						sc_op_i <= '1';
					elsif eof_flag = '1' then
						-- reset command bits at end of frame
						sc_frame <= '0';
						sc_wr <= '0';
					end if;
					
				when others =>
					-- nothing
			end case;
      end if;
   end process;
 
   NEXT_STATE_DECODE: process (state, frame_cmd,scq_empty, scq_sof, scq_datavalid, scq_length, abort_on_checksum, scq_eof, scq_data, frame_counter(0), sc_ack, eof_flag, sc_op_i, frame_length(0))
   begin
      --declare default state for next_state to avoid latches
      next_state <= state;  --default is to stay in current state
		scq_ren <= '0';
		frame_error_i <= (others => '0');
      case (state) is
         when stIdle =>
            if scq_empty = '0' then
               next_state <= stQWaitSOF;
					scq_ren <= '1';
            end if;
         when stQWaitSOF =>
				scq_ren <= '1';
            if scq_sof = '1' then
					if (scq_length(0) and abort_on_checksum) = '1' then
						next_state <= stFlushFrame;
						frame_error_i(0) <= '1';
					else
						next_state <= stQReadSubaddr;
					end if;
            end if;
			when stFlushFrame =>
				if scq_eof = '1' then
					next_state <= stIdle;
				else
					scq_ren <= '1';
				end if;
         when stQReadSubaddr =>
				scq_ren <= '1';
				if scq_datavalid = '1' then
					next_state <= stQReadCmd;
				end if;
			when stQReadCmd => 
				scq_ren <= '1';
				if scq_datavalid = '1' then
					next_state <= stQReadCmdInfo;
				end if;
			when stQReadCmdInfo =>
				scq_ren <= '1';
				if scq_datavalid = '1' then
					next_state <= stCmdEx;
				end if;
			when stCmdEx =>
--				if (eof_flag or scq_eof)= '1' then
--					next_state <= stIdle;
--				else
					next_state <= stCmdEx;
					scq_ren <= '1';
					case frame_cmd is
						when CMD_WRITE_PAIRS =>
							if frame_length(0) = '1' then
								-- ill formed request (odd length); flushing
								next_state <= stFlushFrame;
								frame_error_i(2) <= '1';
							elsif (scq_datavalid and frame_counter(0)) = '1' then
								next_state <= stWaitPeripheral;
								scq_ren <= '0';
							end if;
						when CMD_WRITE_BURST | CMD_READ_LIST | CMD_READ_BURST =>
							if (scq_datavalid = '1') then
								next_state <= stWaitPeripheral;
								scq_ren <= '0';
							end if;
						when others =>
							next_state <= stFlushFrame;
							frame_error_i(3) <= '1';
					end case;
--				end if;
			when stWaitPeripheral =>
				if (sc_op_i and sc_ack) = '1' then
					if eof_flag = '1' then
						next_state <= stIdle;
					else
						next_state <= stCmdEx;
						scq_ren <= '1';
					end if;
				else
					next_state <= stWaitPeripheral;
				end if;
							
         when others =>
            next_state <= stIdle;
      end case;      
   end process;


end Behavioral;

