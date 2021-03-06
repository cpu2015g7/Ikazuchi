library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package types is
	-- cpu
	type cpu_in_t is record
		stall : std_logic;
		rx_data : std_logic_vector(7 downto 0);
		alu_data : std_logic_vector(31 downto 0);
		inst_data : std_logic_vector(31 downto 0);
		mem_data : std_logic_vector(31 downto 0);
		fpu_data : std_logic_vector(31 downto 0);
	end record;
	constant cpu_in_z : cpu_in_t := (
		stall => '0',
		rx_data => (others => '0'),
		alu_data => (others => '0'),
		inst_data => (others => '0'),
		mem_data => (others => '0'),
		fpu_data => (others => '0')
	);

	type cpu_out_t is record
		inst_addr : std_logic_vector(31 downto 0);
		mem_we : std_logic;
		fpu_en : std_logic;
		tx_go  : std_logic;
		rx_go  : std_logic;
		funct  : std_logic_vector(5 downto 0);
		data_a : std_logic_vector(31 downto 0);
		data_b : std_logic_vector(31 downto 0);
		data_c : std_logic_vector(31 downto 0);
		data_res : std_logic_vector(31 downto 0);
	end record;
	constant cpu_out_z : cpu_out_t := (
		inst_addr => (others => '0'),
		mem_we => '0',
		fpu_en => '0',
		tx_go => '0',
		rx_go => '0',
		funct  => (others => '0'),
		data_a => (others => '0'),
		data_b => (others => '0'),
		data_c => (others => '0'),
		data_res => (others => '0')
	);

	-- alu
	type alu_in_t is record
		funct  : std_logic_vector(5 downto 0);
		data_a : std_logic_vector(31 downto 0);
		data_b : std_logic_vector(31 downto 0);
	end record;
	constant alu_in_z : alu_in_t := (
		funct  => (others => '0'),
		data_a => (others => '0'),
		data_b => (others => '0')
	);

	type alu_out_t is record
		data_c : std_logic_vector(31 downto 0);
	end record;
	constant alu_out_z : alu_out_t := (
		data_c => (others => '0')
	);

	-- fpu
	type fpu_in_t is record
		funct  : std_logic_vector(5 downto 0);
		data_a : std_logic_vector(31 downto 0);
		data_b : std_logic_vector(31 downto 0);
		enable : std_logic;
	end record;
	constant fpu_in_z : fpu_in_t := (
		funct  => (others => '0'),
		data_a => (others => '0'),
		data_b => (others => '0'),
		enable => '0'
	);

	type fpu_out_t is record
		data_c : std_logic_vector(31 downto 0);
	end record;
	constant fpu_out_z : fpu_out_t := (
		data_c => (others => '0')
	);

	-- sram
	type sram_in_t is record
		we : std_logic;
		data : std_logic_vector(31 downto 0);
		addr : std_logic_vector(19 downto 0);
	end record;
	constant sram_in_z : sram_in_t := (
		we => '0',
		data => (others => '0'),
		addr => (others => '0')
	);

	type sram_out_t is record
		data : std_logic_vector(31 downto 0);
	end record;
	constant sram_out_z : sram_out_t := (
		data => (others => '0')
	);

	type rom_t is array(0 to 32767) of std_logic_vector(31 downto 0);

	-- constants
	constant OP_ALU   : std_logic_vector(5 downto 0) := "000000";
	constant OP_J     : std_logic_vector(5 downto 0) := "000010";
	constant OP_JAL   : std_logic_vector(5 downto 0) := "000011";
	constant OP_BEQ   : std_logic_vector(5 downto 0) := "000100";
	constant OP_BNE   : std_logic_vector(5 downto 0) := "000101";
	constant OP_FPU   : std_logic_vector(5 downto 0) := "001011";
	constant OP_ADDI  : std_logic_vector(5 downto 0) := "001100";
	constant OP_ORI   : std_logic_vector(5 downto 0) := "001101";
	constant OP_LW    : std_logic_vector(5 downto 0) := "100011";
	constant OP_SW    : std_logic_vector(5 downto 0) := "101011";
	constant OP_RRB   : std_logic_vector(5 downto 0) := "111110";
	constant OP_RSB   : std_logic_vector(5 downto 0) := "111111";

	constant FN_JR    : std_logic_vector(5 downto 0) := "001000";
	constant ALU_SLL  : std_logic_vector(5 downto 0) := "000000";
	constant ALU_SRL  : std_logic_vector(5 downto 0) := "000010";
	constant ALU_ADD  : std_logic_vector(5 downto 0) := "100000";
	constant ALU_SUB  : std_logic_vector(5 downto 0) := "100010";
	constant ALU_OR   : std_logic_vector(5 downto 0) := "100101";
	constant ALU_SLT  : std_logic_vector(5 downto 0) := "101010";
	constant ALU_FSLT : std_logic_vector(5 downto 0) := "101011";
	constant ALU_FNEG : std_logic_vector(5 downto 0) := "101100";
	constant ALU_F2I  : std_logic_vector(5 downto 0) := "101101";
	constant ALU_I2F  : std_logic_vector(5 downto 0) := "101110";
	constant ALU_FLR  : std_logic_vector(5 downto 0) := "101111";

	constant FPU_FADD : std_logic_vector(5 downto 0) := "100000";
	constant FPU_FMUL : std_logic_vector(5 downto 0) := "000001";
	constant FPU_FINV : std_logic_vector(5 downto 0) := "000011";
	constant FPU_FSQRT: std_logic_vector(5 downto 0) := "011000";
	constant FPU_F2I  : std_logic_vector(5 downto 0) := "101101";
	constant FPU_I2F  : std_logic_vector(5 downto 0) := "101110";
	constant FPU_FLR  : std_logic_vector(5 downto 0) := "101111";
end package;
