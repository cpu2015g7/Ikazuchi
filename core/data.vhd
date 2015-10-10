library ieee;
use ieee.std_logic_1164.all;

use work.types.all;

package data is
	constant test_prog1 : rom_t := (
		"00110000000000010000000000001001",
		"00110000000000100000000000100110",
		"00000000000000000000000000000000",
		"00000000000000000000000000000000",
		"00000000000000000000000000000000",
		"00000000001000100001000000100000",
		"00000000000000000000000000000000",
		"00000000000000000000000000000000",
		"00000000000000000000000000000000",
		"00000000000000000000000000000000",
		"11111100000000010000000000000000",
		"00000000000000000000000000000000",
		"00000000000000000000000000000000",
		"00000000000000000000000000000000",
		"00000000000000000000000000000000",
		"00000000000000000000000000000000",
		others => (others => '0')
	);

	constant test_prog2 : rom_t := (
		x"3002000A",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"30210001",
		x"00000000",
		x"00000000",
		x"00000000",
		x"10410004",
		x"00000000",
		x"00000000",
		x"1000FFF6",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"30210000",
		x"00000000",
		x"1000FFFB",
		x"00000000",
		x"00000000",
		x"00000000",
		others => (others => '0')
	);

end package;
