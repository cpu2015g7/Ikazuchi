library ieee;
use ieee.std_logic_1164.all;

use work.types.all;

entity sram is
	port (
		clk : in std_logic;
		sram_in : in sram_in_t;
		sram_out : out sram_out_t;
		
		zd : inout std_logic_vector(31 downto 0);
		za : out std_logic_vector(19 downto 0);
		xwa : out std_logic);
end entity;

architecture struct of sram is
	signal we1, we2 : std_logic;
	signal data1, data2 : std_logic_vector(31 downto 0);
begin
	process(clk) is
	begin
		if rising_edge(clk) then
			we1 <= sram_in.we;
			we2 <= we1;
			data1 <= sram_in.data;
			data2 <= data1;
		end if;
	end process;

	sram_out.data <= zd;
	zd <= data2 when we2 = '1' else (others => '0');
	za <= sram_in.addr;
	xwa <= not sram_in.we;
end architecture;
