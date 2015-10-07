library ieee;
use ieee.std_logic_1164.all;

use work.types.all;

entity top_tb is
end top_tb;

architecture struct of top_tb is

	component top is
  Port ( MCLK1 : in  std_logic;
         RS_RX : in  std_logic;
         RS_TX : out  std_logic;

		 ZD    : inout std_logic_vector(31 downto 0);
  		 ZA    : out std_logic_vector(19 downto 0);
  		 XWA   : out std_logic;
		 XE1   : out std_logic;
		 E2A   : out std_logic;
		 XE3   : out std_logic;
		 XGA   : out std_logic;
		 XZCKE : out std_logic;
		 ADVA  : out std_logic;
		 XLBO  : out std_logic;
		 ZZA   : out std_logic;
		 XFT   : out std_logic;
		 XZBE  : out std_logic_vector(3 downto 0);
		 ZCLKMA: out std_logic_vector(1 downto 0));
	end component;

  signal clk, xwa, xe1, e2a, xe3, xga, xzcke, adva, xlbo, zza, xft, rx, tx : std_logic;
  signal zd : std_logic_vector(31 downto 0);
  signal za : std_logic_vector(19 downto 0);
  signal xzbe : std_logic_vector(3 downto 0);
  signal zclkma : std_logic_vector(1 downto 0);
  signal rst : std_logic := '0';
--  signal cpu_in : cpu_in_t;
--  signal cpu_out : cpu_out_t;
--  signal alu_in : alu_in_t;
--  signal alu_out : alu_out_t;
  constant CP: time := 2.00 ns;
begin
	uut: top port map(
		mclk1 => clk,
		rs_rx => rx,
		rs_tx => tx,
		zd => zd,
		xwa => xwa,
		xe1 => xe1,
		e2a => e2a,
		xe3 => xe3,
		xga => xga,
		xzcke => xzcke,
		adva => adva,
		xlbo => xlbo,
		zza => zza,
		xft => xft,
		xzbe => xzbe,
		zclkma => zclkma);
--	cpu: entity work.cpu port map(clk, rst, cpu_in, cpu_out)
	clkgen : process
	begin
		clk <= '0';
		wait for CP / 2;
		clk <= '1';
		wait for CP / 2;
	end process;
end architecture;
