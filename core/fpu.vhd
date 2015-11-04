library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.types.all;

entity fpu is
	port (
		clk : in std_logic;
		rst : in std_logic;
		fpu_in : in fpu_in_t;
		fpu_out : out fpu_out_t);
end entity;

architecture struct of fpu is
	signal a : std_logic_vector(31 downto 0);
	signal b : std_logic_vector(31 downto 0);
	signal c : std_logic_vector(31 downto 0);
	signal faddc : std_logic_vector(31 downto 0);
	signal fmulc : std_logic_vector(31 downto 0);
	signal finvc : std_logic_vector(31 downto 0);
	signal fsqrtc : std_logic_vector(31 downto 0);
	signal f2ic : std_logic_vector(31 downto 0);
	signal funct : std_logic_vector(5 downto 0);
begin
	fadd_1 : entity work.fadd  port map (a, b, faddc);
	fmul_1 : entity work.fmul  port map (a, b, fmulc);
	finv_1 : entity work.finv  port map (a, finvc);
	fsqrt_1: entity work.fsqrt port map (a, fsqrtc);
	f2i_1  : entity work.f2i   port map (a, f2ic);

	fpu_out.data_c <= faddc  when funct = FPU_FADD  else
					  fmulc  when funct = FPU_FMUL  else
					  finvc  when funct = FPU_FINV  else
					  fsqrtc when funct = FPU_FSQRT else
					  f2ic   when funct = FPU_F2I   else
					  x"7fffffff";
	comb : process(clk, fpu_in) is
	begin
		if rising_edge(clk) and fpu_in.enable = '1' then
			a <= fpu_in.data_a;
			b <= fpu_in.data_b;
			funct <= fpu_in.funct;
		end if;
	end process;
end architecture;
