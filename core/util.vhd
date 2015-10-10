library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package util is
	function ext(x : std_logic; n : natural) return std_logic_vector;
end package;

package body util is
	function ext(x : std_logic; n : natural)
		return std_logic_vector is
			variable res : std_logic_vector(n-1 downto 0);
	begin
		for i in 0 to n-1 loop
			res(i) := x;
		end loop;
		return res;
	end;
end package body;
