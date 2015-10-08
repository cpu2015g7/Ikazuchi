library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.vcomponents.all;

use work.types.all;

entity top is
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
end entity;

architecture struct of top is
  signal clk, iclk: std_logic := '0';

  signal rst : std_logic := '0';

  signal cpu_in : cpu_in_t := cpu_in_z;
  signal cpu_out : cpu_out_t := cpu_out_z;
  signal alu_in : alu_in_t := alu_in_z;
  signal alu_out : alu_out_t := alu_out_z;
  signal sram_in : sram_in_t := sram_in_z;
  signal sram_out : sram_out_t := sram_out_z;
-- test
  type rom_t is array(0 to 3) of std_logic_vector(31 downto 0);
  signal rom : rom_t := (
  	"00110000000000010000000000000001",
	"00000000000000000000000000100000",
	"00000000001000100001000000100000",
	"00000000000000000000000000100000");

begin
	ib : IBUFG port map (
		i => MCLK1,
    	o => iclk);
	bg : BUFG port map (
    	i => iclk,
    	o => clk);
	cpu_1 : entity work.cpu port map (clk, rst, cpu_in, cpu_out);
	alu_1 : entity work.alu port map (clk, rst, alu_in, alu_out);
	sram_1 : entity work.sram port map (clk, sram_in, sram_out, zd, za, xwa);

	alu_in.funct <= cpu_out.funct;
	alu_in.data_a <= cpu_out.data_a;
	alu_in.data_b <= cpu_out.data_b;
	cpu_in.alu_data <= alu_out.data_c;
	cpu_in.inst_data <= rom(conv_integer(cpu_out.inst_addr)/4);
	cpu_in.mem_data <= sram_out.data;
	sram_in.we <= cpu_out.mem_we;
	sram_in.data <= cpu_out.mem_data;
	sram_in.addr <= cpu_out.mem_addr;

	ZCLKMA(0) <= clk;
	ZCLKMA(1) <= clk;
	XE1   <= '0';
	E2A   <= '1';
	XE3   <= '0';
	XGA   <= '0';
	XZCKE <= '0';
	ADVA  <= '0';
	XLBO  <= '1';
	ZZA   <= '0';
	XFT   <= '1';
	XZBE  <= "0000";
end architecture;
