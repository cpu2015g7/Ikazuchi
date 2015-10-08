library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.types.all;

entity cpu is
	port (
		clk : in std_logic;
		rst : in std_logic;
		cpu_in : in cpu_in_t;
		cpu_out : out cpu_out_t);
end entity;

architecture struct of cpu is
	type regfile_t is
		array(0 to 31) of std_logic_vector(31 downto 0);
	
	type fetch_reg_t is record
		pc   : std_logic_vector(31 downto 0);
		npc  : std_logic_vector(31 downto 0);
		inst : std_logic_vector(31 downto 0);
	end record;

	type decode_reg_t is record
		npc      : std_logic_vector(31 downto 0);
		opcode   : std_logic_vector(5 downto 0);
		reg_a    : std_logic_vector(4 downto 0);
		reg_b    : std_logic_vector(4 downto 0);
		reg_c    : std_logic_vector(4 downto 0);
		funct    : std_logic_vector(5 downto 0);
		data_a   : std_logic_vector(31 downto 0);
		data_b   : std_logic_vector(31 downto 0);
--		imm      : std_logic_vector(31 downto 0);
	end record;

	type execute_reg_t is record
		reg_c : std_logic_vector(4 downto 0);
		alu_we   : std_logic;
	end record;

	type memory_reg_t is record
		data_c : std_logic_vector(31 downto 0);
		reg_c  : std_logic_vector(4 downto 0);
		reg_we : std_logic;
	end record;

	type reg_t is record
		regfile : regfile_t;
		f       : fetch_reg_t;
		d       : decode_reg_t;
		e       : execute_reg_t;
		m       : memory_reg_t;
	end record;

	constant fetch_reg_z : fetch_reg_t := (
		pc => (others => '0'),
		npc => (others => '0'),
		inst => (others => '0')
	);

	constant decode_reg_z : decode_reg_t := (
		npc => (others => '0'),
		opcode => (others => '0'),
		funct => (others => '0'),
		reg_a => (others => '0'),
		reg_b => (others => '0'),
		reg_c => (others => '0'),
		data_a => (others => '0'),
		data_b => (others => '0')
--		imm => (others => '0')
	);

	constant execute_reg_z : execute_reg_t := (
		reg_c  => (others => '0'),
		alu_we => '0'
	);

	constant memory_reg_z : memory_reg_t := (
		data_c => (others => '0'),
		reg_c => (others => '0'),
		reg_we => '0'
	);

	constant reg_z : reg_t := (
		regfile => (others => (others => '0')),
		f => fetch_reg_z,
		d => decode_reg_z,
		e => execute_reg_z,
		m => memory_reg_z
	);

	signal r, rin : reg_t := reg_z;

begin
	comb : process(r, cpu_in) is
		variable v : reg_t;
		variable funct  : std_logic_vector(5 downto 0);
		variable data_a : std_logic_vector(31 downto 0);
		variable data_b : std_logic_vector(31 downto 0);
		variable data_c : std_logic_vector(31 downto 0);
	begin
		v := r;
		-- fetch
		v.f.pc := r.f.npc;
		v.f.npc := v.f.pc + 4;
		v.f.inst := cpu_in.inst_data;

		-- decode
		v.d.npc := r.f.npc;
		v.d.opcode := r.f.inst(31 downto 26);
		case v.d.opcode is
			when OP_ALU | OP_FPU  => v.d.funct := r.f.inst(5 downto 0);
			when OP_ADDI => v.d.funct := ALU_ADD;
			when OP_BEQ  => v.d.funct := ALU_SUB;
			when others  => v.d.funct := ALU_ADD;
		end case;

		v.d.reg_a := r.f.inst(25 downto 21);
		v.d.data_a := v.regfile(conv_integer(v.d.reg_a));
		case v.d.opcode is
			when OP_ALU | OP_FPU =>
			   	v.d.reg_b := r.f.inst(20 downto 16);
				v.d.data_b := v.regfile(conv_integer(v.d.reg_b));
				v.d.reg_c := r.f.inst(15 downto 11);
			when others =>
				v.d.reg_b := "00000";
				v.d.data_b := x"0000"&r.f.inst(15 downto 0);
				v.d.reg_c := r.f.inst(20 downto 16);
		end case;

		-- alu
		v.e.reg_c := r.d.reg_c;
		v.e.alu_we := '1';

		-- memory
		v.m.reg_c := r.e.reg_c;
		v.m.data_c := cpu_in.alu_data;
		v.m.reg_we := r.e.alu_we;

		-- write
		if r.m.reg_we = '1' then
			v.regfile(conv_integer(r.m.reg_c)) := r.m.data_c;
		end if;

		-- end
		rin <= v;

		cpu_out.inst_addr <= "0000000000000000000000000000"&r.f.npc(3 downto 0);
		cpu_out.mem_data <= (others => '0');
		cpu_out.mem_addr <= (others => '0');
		cpu_out.mem_we <= '0';
		cpu_out.funct  <= r.d.funct;
		cpu_out.data_a <= r.d.data_a;
		cpu_out.data_b <= r.d.data_b;
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
