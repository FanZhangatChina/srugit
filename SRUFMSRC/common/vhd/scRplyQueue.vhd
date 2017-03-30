----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:18:57 02/25/2011 
-- Design Name: 
-- Module Name:    scRplyQueue - Behavioral 
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

entity scRplyQueue is
    Port ( clk : in  STD_LOGIC;
           eclk : in  STD_LOGIC;
           rstn : in  STD_LOGIC;
			  ------------------
           sc_frame : in  STD_LOGIC;
           sc_ack, sc_op : in  STD_LOGIC;
           sc_ip : in  STD_LOGIC_VECTOR (31 downto 0);
           sc_port : in  STD_LOGIC_VECTOR (15 downto 0);
           sc_rply_bulk : in  STD_LOGIC_VECTOR (127 downto 0);
           sc_rply_error : in  STD_LOGIC_VECTOR (31 downto 0);
           sc_rply_data : in  STD_LOGIC_VECTOR (31 downto 0);
			  -----------------
           txreq : out  STD_LOGIC;
           txstart : out  STD_LOGIC;
           txack : in  STD_LOGIC;
           txdstrdy : in  STD_LOGIC;
           txdata : out  STD_LOGIC_VECTOR (7 downto 0);
           txsrcPort : out  STD_LOGIC_VECTOR (15 downto 0);
           txdstIP : out  STD_LOGIC_VECTOR (31 downto 0);
           txlength : out  STD_LOGIC_VECTOR (15 downto 0);
           txdone : out  STD_LOGIC);
end scRplyQueue;

architecture Behavioral of scRplyQueue is
component fifo16kx64x8
	port (
	rst: IN std_logic;
	wr_clk: IN std_logic;
	rd_clk: IN std_logic;
	din: IN std_logic_VECTOR(63 downto 0);
	wr_en: IN std_logic;
	rd_en: IN std_logic;
	dout: OUT std_logic_VECTOR(7 downto 0);
	full: OUT std_logic;
	empty: OUT std_logic;
	wr_data_count: OUT std_logic_VECTOR(9 downto 0));
end component;
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

signal df_wr_en, df_rd_en, df_full, df_empty: std_logic;
signal df_din: std_logic_VECTOR(63 downto 0);
signal df_dout: std_logic_VECTOR(7 downto 0);
signal df_wr_data_count, wrcounter: std_logic_VECTOR(9 downto 0);

signal sc_frame_q, sc_ack_q, fifo_rst, pf_empty_q : std_logic;
signal frame_ip: std_logic_VECTOR(31 downto 0);
signal frame_port, frame_length, txframe_length: std_logic_VECTOR(15 downto 0);

   type state_type is (stIdle, stReadPkg, stTXREQ, stTX); 
   signal state : state_type; 
	signal txcounter : std_logic_vector(15 downto 0);
	signal txdstrdy_q : std_logic_vector(1 downto 0);

	signal sc_ack_i, wrb, wrb_q, wrd: std_logic;
	signal wrdata: std_logic_vector(63 downto 0);
	
begin
	
	fifo_rst <= not rstn;
	sc_ack_i <= sc_ack and sc_op;
	
	wrb <= sc_frame and (not sc_frame_q);
	
	
	df_wr_en <= wrb or wrb_q or wrd;
	
	
	df_din <= 	sc_rply_bulk(127 downto 64) when wrb = '1' else
					sc_rply_bulk(63 downto 0) when wrb_q = '1' else
					wrdata;
	pf_din <= frame_ip & frame_port & frame_length;
	
	process(clk, rstn)
	begin
		if rstn = '0' then
			wrcounter <= (others => '0');
			sc_frame_q <= '0';
			sc_ack_q <= '0';
			wrb_q <= '0';
			wrd <= '0';
			frame_ip <= (others => '0');
			frame_port <= (others => '0');
			wrdata <= (others => '0');
			pf_wr_en <= '0';
		elsif clk'event and clk = '1' then
			sc_frame_q <= sc_frame;
			sc_ack_q <= sc_ack_i;
			wrb_q <= wrb;
			wrd <= sc_ack_i and (not sc_ack_q);
			wrdata <= sc_rply_error & sc_rply_data;
			pf_wr_en <= (not sc_frame) and sc_frame_q;
			if wrb = '1' then
				frame_ip <= sc_ip;
				frame_port <= sc_port;
			elsif pf_wr_en = '1' then
				frame_ip <= (others => '0');
				frame_port <= (others => '0');
			end if;
			if pf_wr_en = '1' then 
				wrcounter <= (others => '0');
			elsif df_wr_en = '1' then
				wrcounter <= wrcounter + 1;
			end if;
		end if;
	end process;
	
	frame_length <= "000" & wrcounter & "000";
				
					
rdataFIFO : fifo16kx64x8
		port map (
			rst => fifo_rst,
			wr_clk => clk,
			rd_clk => eclk,
			din => df_din,
			wr_en => df_wr_en,
			rd_en => df_rd_en,
			dout => df_dout,
			full => df_full,
			empty => df_empty,
			wr_data_count => df_wr_data_count);
rpkgFIFO : distFIFOrx
		port map (
			din => pf_din,
			rd_clk => eclk,
			rd_en => pf_rd_en,
			rst => fifo_rst,
			wr_clk => clk,
			wr_en => pf_wr_en,
			dout => pf_dout,
			empty => pf_empty,
			full => pf_full);

	
	process(eclk, rstn)
	begin
		if rstn = '0' then
			state <= stIdle;
			txdone <= '1';
			txreq <= '0';
			pf_rd_en <= '0';
			df_rd_en <= '0';
			txstart <= '0';
			txdstIP <= (others => '0');
			txsrcPort <= (others => '0');
			txlength <= (others => '0');
--			txdata <= (others => '0');
			txcounter <= (others => '0');
			txframe_length <= (others => '0');
			pf_empty_q <= '1';
		elsif eclk'event and eclk = '1' then
			pf_empty_q <= pf_empty;
			-- ff insertion (txdstrdy is anticipated 2 clks at source)
			txdstrdy_q(1) <= txdstrdy_q(0);
			txdstrdy_q(0) <= txdstrdy;
			case state is
				when stIdle =>
					txdone <= '1';
					txreq <= '0';
					pf_rd_en <= '0';
					df_rd_en <= '0';
					txdstIP <= (others => '0');
					txsrcPort <= (others => '0');
					txlength <= (others => '0');
					txframe_length <= (others => '0');
--					txdata <= (others => '0');
					txcounter <= (others => '0');
					txstart <= '0';
					if pf_empty_q = '0' then
						state <= stReadPkg;
						pf_rd_en <= '1';
					end if;
				when stReadPkg => 
					pf_rd_en <= '0';
					df_rd_en <= '0';
					txstart <= '0';
					txdone <= '0';
					txreq <= '1';
					state <= stTXREQ;
				when stTXREQ =>
					txdstIP <= pf_dout(63 downto 32);
					txsrcPort  <= pf_dout(31 downto 16);
					txlength <= pf_dout(15 downto 0) + 8;
					txframe_length <= pf_dout(15 downto 0);
					pf_rd_en <= '0';
					df_rd_en <= '0';
					txdone <= '0';
					txreq <= '1';
					txstart <= '0';
					if txack = '1' then
						state <= stTX;
						txreq <= '0';
						txstart <= '1';
						-- read first data
						df_rd_en <= '1';
					end if;
				when stTx =>
					pf_rd_en <= '0';
					df_rd_en <= '0';
					txdone <= '0';
					txreq <= '0';
					txstart <= '0';
					if (txdstrdy_q(1) = '1') and (txcounter < txframe_length) then
						txcounter <= txcounter + 1;
						df_rd_en <= '1';
					elsif txcounter > 0 then
						state <= stIdle;
					end if;
				when others =>
					txstart <= '0';
					pf_rd_en <= '0';
					df_rd_en <= '0';
					txdone <= '0';
					txreq <= '0';
					txcounter <= (others => '0');
					txdstIP <= (others => '0');
					txsrcPort <= (others => '0');
					txlength <= (others => '0');
--					txdata <= (others => '0');
					state <= stIdle;
			end case;
		end if;
	end process;
	
	txdata <= df_dout;
	
end Behavioral;

