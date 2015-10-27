library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.types.all;
use work.util.all;

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
		pc      : std_logic_vector(31 downto 0);
		npc      : std_logic_vector(31 downto 0);
		opcode   : std_logic_vector(5 downto 0);
		reg_a    : std_logic_vector(4 downto 0);
		reg_b    : std_logic_vector(4 downto 0);
		reg_c    : std_logic_vector(4 downto 0);
		funct    : std_logic_vector(5 downto 0);
		data_a   : std_logic_vector(31 downto 0);
		data_b   : std_logic_vector(31 downto 0);
		data_c   : std_logic_vector(31 downto 0);
		reg_we   : std_logic;
		fpu_we   : std_logic;
		mem_we   : std_logic;
		mem_re   : std_logic;
		tx_go    : std_logic;
		rx_go    : std_logic;
	end record;

	type execute_reg_t is record
		reg_c    : std_logic_vector(4 downto 0);
		data_c   : std_logic_vector(31 downto 0);
		data_res   : std_logic_vector(31 downto 0);
		reg_we   : std_logic;
		fpu_we   : std_logic;
		mem_we   : std_logic;
		mem_re   : std_logic;
		tx_go    : std_logic;
		rx_go    : std_logic;
	end record;

	type memory_reg_t is record
		data_c : std_logic_vector(31 downto 0);
		reg_c  : std_logic_vector(4 downto 0);
		reg_c1  : std_logic_vector(4 downto 0);
		mem_re : std_logic;
		mem_re1 : std_logic;
		fpu_we : std_logic;
		fpu_we1 : std_logic;
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
		pc => (others => '0'),
		npc => (others => '0'),
		opcode => (others => '0'),
		funct => (others => '0'),
		reg_a => (others => '0'),
		reg_b => (others => '0'),
		reg_c => (others => '0'),
		data_a => (others => '0'),
		data_b => (others => '0'),
		data_c => (others => '0'),
		reg_we => '0',
		fpu_we => '0',
		mem_we => '0',
		mem_re => '0',
		tx_go => '0',
		rx_go => '0'
	);

	constant execute_reg_z : execute_reg_t := (
		reg_c  => (others => '0'),
		data_c => (others => '0'),
		data_res => (others => '0'),
		reg_we => '0',
		fpu_we => '0',
		mem_we => '0',
		mem_re => '0',
		tx_go => '0',
		rx_go => '0'
	);

	constant memory_reg_z : memory_reg_t := (
		data_c => (others => '0'),
		reg_c => (others => '0'),
		reg_c1 => (others => '0'),
		mem_re => '0',
		mem_re1 => '0',
		fpu_we => '0',
		fpu_we1 => '0'
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
		variable pc_src : std_logic;
		variable pc_addr : std_logic_vector(31 downto 0);
		variable stall : std_logic;
	begin
		v := r;
		stall := cpu_in.stall;
		-- write
		if r.e.reg_we = '1' then
			v.regfile(conv_integer(r.e.reg_c)) := r.e.data_res;
		end if;

		-- decode
		v.d.pc := r.f.pc;
		v.d.npc := r.f.npc;
		v.d.opcode := r.f.inst(31 downto 26);
		case v.d.opcode is
			when OP_ALU | OP_FPU  => v.d.funct := r.f.inst(5 downto 0);
			when OP_ADDI | OP_JAL | OP_SW | OP_LW => v.d.funct := ALU_ADD;
			when OP_ORI  => v.d.funct := ALU_OR;
			when OP_RSB  => v.d.funct := ALU_ADD;
			when OP_BEQ  => v.d.funct := ALU_SUB;
			when others  => v.d.funct := ALU_ADD;
		end case;

		if v.d.opcode = OP_RSB then
			v.d.tx_go := '1';
		else
			v.d.tx_go := '0';
		end if;
		if v.d.opcode = OP_RRB then
			v.d.rx_go := '1';
		else
			v.d.rx_go := '0';
		end if;

		v.d.reg_a := r.f.inst(25 downto 21);
		v.d.data_a := v.regfile(conv_integer(v.d.reg_a));
		case v.d.funct is
			when ALU_SLL | ALU_SRL =>
				v.d.reg_a := (others => '0');
				v.d.data_a := ext('0', 27)&r.f.inst(10 downto 6);
			when others =>
		end case;
		case v.d.opcode is
			when OP_ALU | OP_FPU =>
			   	v.d.reg_b := r.f.inst(20 downto 16);
				v.d.data_b := v.regfile(conv_integer(v.d.reg_b));
				v.d.reg_c := r.f.inst(15 downto 11);
--				v.d.data_c := (others => '0');
			when OP_JAL =>
				v.d.data_a := (others => '0');
				v.d.data_b := v.d.pc + 4;
				v.d.reg_c := "11111";
			when others =>
				v.d.reg_b := "00000";
				if v.d.opcode = OP_ORI then
					v.d.data_b := ext('0', 16)&r.f.inst(15 downto 0);
				else
					v.d.data_b := ext(r.f.inst(15), 16)&r.f.inst(15 downto 0);
				end if;
				v.d.reg_c := r.f.inst(20 downto 16);
				v.d.data_c := v.regfile(conv_integer(v.d.reg_c));
		end case;
		case v.d.opcode is
			when OP_FPU | OP_SW | OP_LW | OP_BEQ | OP_RSB | OP_RRB => v.d.reg_we := '0';
			when others => v.d.reg_we := '1';
		end case;
		case v.d.opcode is
			when OP_FPU => v.d.fpu_we := '1';
			when others => v.d.fpu_we := '0';
		end case;
		if v.d.opcode = OP_SW then
			v.d.mem_we := '1';
			v.d.mem_re := '0';
		elsif v.d.opcode = OP_LW then
			v.d.mem_we := '0';
			v.d.mem_re := '1';
		else
			v.d.mem_we := '0';
			v.d.mem_re := '0';
		end if;

		-- fetch
		if v.d.opcode = OP_BEQ and (v.d.data_a = v.d.data_c) then
			pc_src := '1';
		else
			pc_src := '0';
		end if;

		v.f.pc := r.f.npc;
		if cpu_in.inst_data(31 downto 26) = OP_JAL then
			v.f.npc := (r.f.npc(31 downto 28)&cpu_in.inst_data(25 downto 0)&"00");
		elsif cpu_in.inst_data(31 downto 26) = OP_ALU and cpu_in.inst_data(5 downto 0) = FN_JR then
			-- bug (reg_we will be expected to '0')
			v.f.npc := v.regfile(conv_integer(cpu_in.inst_data(25 downto 21)));
		elsif pc_src = '1' then
			v.f.npc := (v.d.pc + (ext(v.d.data_b(15), 14)&v.d.data_b(15 downto 0)&"00")) + 4;
		else
			v.f.npc := r.f.npc + 4;
		end if;
		v.f.inst := cpu_in.inst_data;

		-- alu
		v.e.reg_c := r.d.reg_c;
		v.e.data_c := r.d.data_c;
		v.e.data_res := cpu_in.alu_data;
		v.e.reg_we := r.d.reg_we;
		v.e.fpu_we := r.d.fpu_we;
		v.e.mem_we := r.d.mem_we;
		v.e.mem_re := r.d.mem_re;
		v.e.tx_go := r.d.tx_go;
		v.e.rx_go := r.d.rx_go;

		-- memory
		v.m.reg_c := r.e.reg_c;
		v.m.reg_c1 := r.m.reg_c;
		v.m.mem_re := r.e.mem_re;
		v.m.mem_re1 := r.m.mem_re;
		if r.m.mem_re1 = '1' then
			v.regfile(conv_integer(r.m.reg_c1)) := cpu_in.mem_data;
		end if;
		v.m.fpu_we := r.e.fpu_we;
		v.m.fpu_we1 := r.m.fpu_we;
		if r.m.fpu_we1 = '1' then
			v.regfile(conv_integer(r.m.reg_c1)) := cpu_in.fpu_data;
		end if;
		if r.e.rx_go = '1' then
			v.regfile(conv_integer(r.e.reg_c))(7 downto 0) := cpu_in.rx_data;
		end if;
		-- end
		if stall = '1' then
			v := r;
		end if;
		rin <= v;

		cpu_out.inst_addr <= r.f.npc;
		cpu_out.mem_we <= '0';
		cpu_out.funct  <= r.d.funct;
		cpu_out.data_a <= r.d.data_a;
		cpu_out.data_b <= r.d.data_b;
		cpu_out.fpu_en <= r.d.fpu_we;
		cpu_out.tx_go  <= r.e.tx_go;
		cpu_out.rx_go  <= r.e.rx_go;
		cpu_out.data_c <= r.e.data_c;
		cpu_out.data_res <= r.e.data_res;
		cpu_out.mem_we <= r.e.mem_we;
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
