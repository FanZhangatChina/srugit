----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:11:20 02/24/2011 
-- Design Name: 
-- Module Name:    scRXErrorQueue - Behavioral 
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity scRXErrorQueue is
    Port ( clk : in  STD_LOGIC;
           rstn : in  STD_LOGIC;
           error_flag : in  STD_LOGIC;
           error_data : in  STD_LOGIC_VECTOR (7 downto 0);
           error_IP : in  STD_LOGIC_VECTOR (31 downto 0);
           error_reqID : in  STD_LOGIC_VECTOR (31 downto 0);
           txreq, txstart : out  STD_LOGIC;
           txack : in  STD_LOGIC;
           txdstrdy : in  STD_LOGIC;
           txdata : out  STD_LOGIC_VECTOR (7 downto 0);
           txdstPort : out  STD_LOGIC_VECTOR (15 downto 0);
           txsrcPort : out  STD_LOGIC_VECTOR (15 downto 0);
           txdstIP : out  STD_LOGIC_VECTOR (31 downto 0);
           txlength : out  STD_LOGIC_VECTOR (15 downto 0);
           txdone : out  STD_LOGIC);
end scRXErrorQueue;

architecture Behavioral of scRXErrorQueue is
component distFIFO32x72sf
	port (
	clk: IN std_logic;
	rst: IN std_logic;
	din: IN std_logic_VECTOR(71 downto 0);
	wr_en: IN std_logic;
	rd_en: IN std_logic;
	dout: OUT std_logic_VECTOR(71 downto 0);
	full: OUT std_logic;
	empty: OUT std_logic);
end component;

signal fifo_din, fifo_dout: std_logic_vector(71 downto 0);
signal fifo_rd_en, fifo_full, fifo_empty, fifo_rst: std_logic;
   type state_type is (stIdle, stTXREQ, stTX, stDone); 
   signal state : state_type; 
signal txcounter : std_logic_vector(3 downto 0);
signal txdstrdy_q : std_logic_vector(1 downto 0);
begin

fifo_din <= error_IP & error_reqId & error_data;
fifo_rst <= not rstn;

rxerrorFIFO : distFIFO32x72sf
		port map (
			clk => clk,
			rst => fifo_rst,
			din => fifo_din,
			wr_en => error_flag,
			rd_en => fifo_rd_en,
			dout => fifo_dout,
			full => fifo_full,
			empty => fifo_empty);

	txlength <= x"0010";
	txdstPort <= x"1777";
	txsrcPort <= x"1777";

	process(clk, rstn)
	begin
		if rstn = '0' then
			state <= stIdle;
			txdone <= '1';
			txreq <= '0';
			fifo_rd_en <= '0';
			txstart <= '0';
			txdstIP <= (others => '0');
			txcounter <= (others => '0');
			txdata <= (others => '0');
		elsif clk'event and clk = '1' then
			-- ff insertion (txdstrdy is anticipated 2 clks at source)
			txdstrdy_q(1) <= txdstrdy_q(0);
			txdstrdy_q(0) <= txdstrdy;
			case state is
				when stIdle =>
					txdone <= '1';
					txreq <= '0';
					fifo_rd_en <= '0';
					txcounter <= (others => '0');
					txdata <= (others => '0');
					txstart <= '0';
					if fifo_empty = '0' then
						state <= stTXREQ;
						txdone <= '0';
						fifo_rd_en <= '1';
						txreq <= '1';
					end if;
				when stTXREQ =>
					fifo_rd_en <= '0';
					txdone <= '0';
					txreq <= '1';
					txstart <= '0';
					txdstIP <= fifo_dout(71 downto 40);
					if txack = '1' then
						state <= stTX;
						txreq <= '0';
						txstart <= '1';
					end if;
				when stTx =>
					fifo_rd_en <= '0';
					txdone <= '0';
					txreq <= '0';
					txstart <= '0';
					if txdstrdy_q(1) = '1' then
						txcounter <= txcounter + 1;
						case (conv_integer(txcounter)) is
							when 0 => txdata <= fifo_dout(39 downto 32);
							when 1 => txdata <= fifo_dout(31 downto 24);
							when 2 => txdata <= fifo_dout(23 downto 16);
							when 3 => txdata <= fifo_dout(15 downto  8);
							when 4 => txdata <= fifo_dout( 7 downto  0);
							when others => txdata <= (others => '0');
						end case;
					elsif txcounter > 0 then
						state <= stDone;
					end if;
				when stDone =>
					-- realease the tx channel, wait for the realease confirmaion
					txstart <= '0';
					fifo_rd_en <= '0';
					txdone <= '1';
					txreq <= '0';
					if txack = '0' then
						state <= stIdle;
					end if;
				when others =>
					txstart <= '0';
					fifo_rd_en <= '0';
					txdone <= '1';
					txreq <= '0';
					state <= stIdle;
			end case;
		end if;
	end process;
				

end Behavioral;

