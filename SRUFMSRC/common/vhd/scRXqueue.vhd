----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:14:57 02/10/2011 
-- Design Name: 
-- Module Name:    scRXqueue - Behavioral 
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

--Library XilinxCoreLib;
--use XilinxCoreLib.all;
---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity scRXqueue is
    Port ( eclk : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rstn : in  STD_LOGIC;
			  cfg_scsrcport : in  STD_LOGIC_VECTOR (15 downto 0);
			  cfg_scmode : in  STD_LOGIC_VECTOR (15 downto 0);
			  --------------
           rxdata : in  STD_LOGIC_VECTOR (7 downto 0);
           rxdatavalid : in  STD_LOGIC;
           dstport : in  STD_LOGIC_VECTOR (15 downto 0);
			  rxchecksum : in STD_LOGIC_VECTOR (15 downto 0);
			  srcIP : in STD_LOGIC_VECTOR (31 downto 0);
           rxAck : out  STD_LOGIC;
			  -----------------
			  error_flag : out std_logic;
			  error : out STD_LOGIC_VECTOR (7 downto 0);
			  error_reqId : out STD_LOGIC_VECTOR (31 downto 0);
			  error_IP : out STD_LOGIC_VECTOR (31 downto 0);
			  -----------------
           queue_empty : out  STD_LOGIC;
           queue_full : out  STD_LOGIC;
			  -----------------
           rden : in  STD_LOGIC;
           rd_data : out  STD_LOGIC_VECTOR (31 downto 0);
			  rd_sof, rd_eof, rd_datavalid : out std_logic;
           length_out : out  STD_LOGIC_VECTOR (15 downto 0);
			  srcIP_out : out STD_LOGIC_VECTOR (31 downto 0);
           dstport_out : out  STD_LOGIC_VECTOR (15 downto 0));
end scRXqueue;

architecture Behavioral of scRXqueue is
-- data fifo and signals
component fifo16kx8x32 IS
	port (
	din: IN std_logic_VECTOR(7 downto 0);
	rd_clk: IN std_logic;
	rd_en: IN std_logic;
	rst: IN std_logic;
	wr_clk: IN std_logic;
	wr_en: IN std_logic;
	dout: OUT std_logic_VECTOR(31 downto 0);
	empty: OUT std_logic;
	full: OUT std_logic;
	valid: OUT std_logic;
	wr_data_count: OUT std_logic_VECTOR(10 downto 0));
END component;
signal rst, df_rd_en, df_rd_en_q, df_wr_en, df_empty, df_full, df_valid, df_valid_q: std_logic;
signal df_dout: std_logic_VECTOR(31 downto 0);
signal df_wr_data_count: std_logic_VECTOR(10 downto 0);
constant distFIFOwidth : integer := 63;
component distFIFOrx IS
	port (
	din: IN std_logic_VECTOR(distFIFOwidth downto 0);
	rd_clk: IN std_logic;
	rd_en: IN std_logic;
	rst: IN std_logic;
	wr_clk: IN std_logic;
	wr_en: IN std_logic;
	dout: OUT std_logic_VECTOR(distFIFOwidth downto 0);
	empty: OUT std_logic;
	full: OUT std_logic);
END component;
signal pf_rd_en, pf_wr_en, pf_empty, pf_full: std_logic;
signal pf_din, pf_dout: std_logic_VECTOR(distFIFOwidth downto 0);

constant dstport_pos: integer := 2;
constant length_pos: integer := 4;
constant data_pos: integer := 8;

signal portAck_f, lengthAck_f, portAck_i, lengthAck_i, lengthAck1_f, lengthAck1_i, frameAck, rxdatavalid_q, checksum_error, checksum_f: std_logic;
signal lengthAck2_f, lengthAck2_i, portAck1_f, portAck1_i: std_logic;
signal wrcounter: std_logic_vector(10 downto 0);
signal rdcounter, rdlength, rdlength_rx : std_logic_vector(8 downto 0);
signal dstport_i, length_i, srcport_i: std_logic_vector(15 downto 0);

signal rd_sof_i, rd_eof_i, src_rdy_i, pf_empty_q: std_logic;

attribute KEEP : string;
attribute KEEP of df_rd_en: signal is "TRUE";
attribute KEEP of df_wr_en: signal is "TRUE";

signal error_f, error_f1: std_logic_vector(7 downto 0);
signal reqId_i, srcIP_i: std_logic_vector(31 downto 0);
signal request_i, request_f, error_flag_f: std_logic;

begin

rst <= not rstn;
------------------------------------------- RX logic -----------------------------------------
process(eclk, rstn)
begin
	if rstn = '0' then
		wrcounter <= (others => '0');
		rxdatavalid_q <= '0';
		dstport_i <= (others => '0');
		srcport_i <= (others => '0');
		length_i <= (others => '0');
		portAck_i <= '0';
		portAck1_i <= '0';
		lengthAck_i <= '0';
		lengthAck1_i <= '0';
		lengthAck2_i <= '0';
		request_i <= '0';
		checksum_error <= '0';
		reqId_i  <= (others => '0');
		srcIP_i <= (others => '0');
		---------------------
		error <= (others => '0');
		error_flag <= '0';
		error_reqId <= (others => '0');
		error_IP <= (others => '0');
	elsif eclk'event and eclk = '1' then
		error <= (others => '0');
		error_reqId <= (others => '0');
		error_IP <= (others => '0');
		error_flag <= '0';
		rxdatavalid_q <= rxdatavalid;
		if ((not rxdatavalid) and rxdatavalid_q) = '1' then
			wrcounter <= (others => '0');
			dstport_i <= (others => '0');
			srcport_i <= (others => '0');
			portAck_i <= '0';
			portAck1_i <= '0';
			lengthAck_i <= '0';
			lengthAck1_i <= '0';
			lengthAck2_i <= '0';
			request_i <= '0';
			checksum_error <= '0';
			reqId_i  <= (others => '0');
			srcIP_i  <= (others => '0');
			-----------------------
			if srcport_i > 999 then
				-- do not reply to system requests
				error_flag <= not error_flag_f;
			else
				error_flag <= '0';
			end if;
			if frameAck = '0' then
				error_reqId <= '0' & reqId_i(30 downto 0);
				error_IP <= srcIP_i;
				error <= not error_f;
			end if;
		elsif rxdatavalid = '1' then
			wrcounter <= wrcounter + 1;
		end if;
		if rxdatavalid = '1' then
			if (wrcounter = 0) then
				srcIP_i <= srcIP;
			end if;
			if (wrcounter = 0) or (wrcounter = 1) then	
				srcport_i <= srcport_i(7 downto 0) & rxdata;
			end if;
		end if;
		if (wrcounter = dstport_pos) or (wrcounter = dstport_pos + 1) then
			dstport_i <= dstport_i(7 downto 0) & rxdata;
		end if;
		if (wrcounter = dstport_pos + 2) then
			portAck_i <= portAck_f;
			portAck1_i <= portAck1_f;
		end if;
		if (wrcounter = length_pos) or (wrcounter = length_pos + 1) then
			length_i <= length_i(7 downto 0) & rxdata;
		end if;
		if (wrcounter = length_pos + 2) then
			lengthAck_i <= lengthAck_f;
			lengthAck1_i <= lengthAck1_f;
			lengthAck2_i <= lengthAck2_f;
		end if;
		if (wrcounter = length_i - 1) then
			checksum_error <= checksum_f;
		end if;
		if ((wrcounter and "11111111100") = data_pos) then
			reqId_i <= reqId_i(23 downto 0) & rxdata;
		end if;
		if wrcounter = data_pos then
			request_i <= request_f;
		end if;
	end if;
end process;

--checksum_f <= '0' when rxchecksum = x"FFFF" else '1';
checksum_f <= '0' when rxchecksum = x"FFFF" else cfg_scmode(2);
	
portAck_f <= '1' when (dstport_i = x"1777") or
--							 (dstport_i = x"1787") or
--							 (dstport_i = x"1797") or
--							 (dstport_i = x"1877") or
--							 (dstport_i = x"1977") or
							 (dstport_i = x"2777") 
				 else '0';
--portAck1_f <= '1' when srcport_i = cfg_scsrcport else '0';
portAck1_f <= '1' when srcport_i = cfg_scsrcport else (not cfg_scmode(0));
lengthAck_f <= '1' when (("11111111111" - df_wr_data_count) > length_i) else '0';
lengthAck1_f <= '1' when length_i(1 downto 0) = "00" else '0';
lengthAck2_f <= '1' when length_i(15 downto 2) > 5 else '0';
--request_f <= rxdata(7) when wrcounter = data_pos else '0';
request_f <= rxdata(7) when wrcounter = data_pos else (not cfg_scmode(1));

frameAck <= portAck_i and portAck1_i and lengthAck_i and lengthAck1_i and lengthAck2_i and (request_f or request_i);
error_f1 <= portAck_i & portAck1_i & lengthAck_i & lengthAck1_i & lengthAck2_i & request_i & "11";
error_f <= error_f1 or (not cfg_scmode(15 downto 8));
error_flag_f <= '1' when (error_f = x"FF") or (dstport_i = x"1776") else '0';

rxAck <= portAck_i and portAck1_i;

df_wr_en <= (frameAck and rxdatavalid) when wrcounter >= data_pos else '0';
--pf_wr_en <= frameAck when wrcounter = data_pos else '0';
pf_wr_en <= frameAck when wrcounter = length_i else '0';

rdlength_rx <= length_i(10 downto 2) - "000000010";
pf_din <= srcIP_i & dstport_i & "00000" & rdlength_rx & '0' & checksum_error;

----------------------------------------- FIFOs --------------------------------------		
dataFIFO : fifo16kx8x32
		port map (
			din => rxdata,
			rd_clk => clk,
			rd_en => df_rd_en,
			rst => rst,
			wr_clk => eclk,
			wr_en => df_wr_en,
			dout => df_dout,
			empty => df_empty,
			full => df_full,
			valid => df_valid,
			wr_data_count => df_wr_data_count);
pkgFIFO : distFIFOrx
		port map (
			din => pf_din,
			rd_clk => clk,
			rd_en => pf_rd_en,
			rst => rst,
			wr_clk => eclk,
			wr_en => pf_wr_en,
			dout => pf_dout,
			empty => pf_empty,
			full => pf_full);

queue_full <= df_full or pf_full;
--queue_empty <= df_empty and pf_empty;
queue_empty <= pf_empty;

-------------------------------------------- Backend logic ----------------------------------------------
process(clk, rstn)
begin
	if rstn = '0' then 
		rdcounter <= (others => '0');
		rd_sof_i <= '0';
		rd_eof_i <= '0';
		pf_empty_q <= '0';
	elsif clk'event and clk = '1' then
		-- pf_empty delay to avoid read/write conflicts
		pf_empty_q <= pf_empty;
		if rdcounter = 0 then
			rd_eof_i <= '0';
			if (rden and not pf_empty_q) = '1' then
				rdcounter <= rdcounter + 1;
				rd_sof_i <= '1';
			else
				rd_sof_i <= '0';
			end if;
		elsif rden = '1' then
			rdcounter <= rdcounter + 1;
			if rdcounter = rdlength - 1 then
				rdcounter <= (others => '0');
				rd_eof_i <= '1';
			else
				rd_sof_i <= '0';
				rd_eof_i <= '0';
			end if;	
		end if;
	end if;
end process;

pf_rd_en <= '1' when (rdcounter = 0) and (rden = '1') and (pf_empty_q = '0') else '0';
src_rdy_i <= '1' when rdcounter > 0 else '0';
df_rd_en <= (rden and src_rdy_i) or pf_rd_en;

rd_eof <= rd_eof_i;
rd_sof <= rd_sof_i;

rdlength <= pf_dout(10 downto 2);
length_out <= pf_dout(15 downto 0);
dstport_out <= pf_dout(31 downto 16);
srcIP_out <= pf_dout(63 downto 32);
rd_data <= df_dout;
rd_datavalid <= df_valid;
--rd_datavalid <= not df_empty;


--rd_datavalid <= src_rdy_i or rd_eof_i;

end Behavioral;

