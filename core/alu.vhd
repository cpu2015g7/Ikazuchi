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
	type reg_t is record
		res : std_logic_vector(31 downto 0);
	end record;
	constant reg_z : reg_t := (
		res => (others => '0')
	);

	signal r, rin : reg_t := reg_z;

begin
	comb : process(r, alu_in) is
		variable v : reg_t;
		variable a : std_logic_vector(31 downto 0);
		variable b : std_logic_vector(31 downto 0);
	begin
		v := r;

		a := alu_in.data_a;
		b := alu_in.data_b;
		case alu_in.funct is
			when ALU_ADD => v.res := a + b;
			when ALU_SUB => v.res := a - b;
			when others => v.res := x"00000000";
		end case;

		-- end
		rin <= v;

		alu_out.data_c <= r.res;
	end process;

	regs : process(clk, rst) is
	begin
		if rst = '1' then
			r <= reg_z;
		elsif rising_edge(clk) then
			r <= rin;
		end if;
	end process;
end architecture;
