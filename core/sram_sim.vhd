library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.types.all;

entity sram_sim is
	port (
		clk : in std_logic;
		sram_in : in sram_in_t;
		sram_out : out sram_out_t;
		
		zd : inout std_logic_vector(31 downto 0);
		za : out std_logic_vector(19 downto 0);
		xwa : out std_logic);
end entity;

architecture struct of sram_sim is
	type ram_t is array(0 to 8191) of std_logic_vector(31 downto 0);

	signal we1, we2 : std_logic;
	signal data1, data2 : std_logic_vector(31 downto 0);
	signal addr1, addr2 : std_logic_vector(19 downto 0) := (others => '0');
	signal mem : ram_t := (others => (others => '0'));
begin
	process(clk) is
	begin
		if rising_edge(clk) then
			we1 <= sram_in.we;
			we2 <= we1;
			data1 <= sram_in.data;
			data2 <= data1;
			addr1 <= sram_in.addr;
			addr2 <= addr1;
		end if;
	end process;

	process(we2, data2, addr2, mem) is
	begin
		if we2 = '1' then
			mem(conv_integer(addr2(12 downto 0))) <= data2;
		else
			sram_out.data <= mem(conv_integer(addr2(12 downto 0)));
		end if;
	end process;
end architecture;
