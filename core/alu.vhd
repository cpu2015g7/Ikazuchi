library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.types.all;

entity alu is
	port (
		clk : in std_logic;
		rst : in std_logic;
		alu_in : in alu_in_t;
		alu_out : out alu_out_t);
end entity;

architecture struct of alu is
begin
	comb : process(alu_in) is
		variable a : std_logic_vector(31 downto 0);
		variable b : std_logic_vector(31 downto 0);
		variable c : std_logic_vector(31 downto 0);
	begin

		a := alu_in.data_a;
		b := alu_in.data_b;
		case alu_in.funct is
			when ALU_ADD => c := a + b;
			when ALU_SUB => c := a - b;
			when ALU_SLT =>
				if signed(a) < signed(b) then
					c := x"00000001";
			  	else
				   	c := x"00000000";
				end if;
			when others => c := x"00000000";
		end case;

		-- end
		alu_out.data_c <= c;
	end process;
end architecture;
