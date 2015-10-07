library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package types is
	-- cpu
	type cpu_in_t is record
		alu_data : std_logic_vector(31 downto 0);
		inst_data : std_logic_vector(31 downto 0);
	end record;
	constant cpu_in_z : cpu_in_t := (
		alu_data => (others => '0'),
		inst_data => (others => '0'));

	type cpu_out_t is record
		inst_addr : std_logic_vector(31 downto 0);
		funct  : std_logic_vector(5 downto 0);
		data_a : std_logic_vector(31 downto 0);
		data_b : std_logic_vector(31 downto 0);
	end record;
	constant cpu_out_z : cpu_out_t := (
		inst_addr => (others => '0'),
		funct  => (others => '0'),
		data_a => (others => '0'),
		data_b => (others => '0'));
	
	-- alu
	type alu_in_t is record
		funct  : std_logic_vector(5 downto 0);
		data_a : std_logic_vector(31 downto 0);
		data_b : std_logic_vector(31 downto 0);
	end record;
	constant alu_in_z : alu_in_t := (
		funct  => (others => '0'),
		data_a => (others => '0'),
		data_b => (others => '0'));

	type alu_out_t is record
		data_c : std_logic_vector(31 downto 0);
	end record;
	constant alu_out_z : alu_out_t := (
		data_c => (others => '0'));

	-- constants
	constant OP_ALU   : std_logic_vector(5 downto 0) := "000000";
	constant OP_ADDI  : std_logic_vector(5 downto 0) := "001100";
	constant OP_BEQ   : std_logic_vector(5 downto 0) := "000100";
	constant OP_FPU   : std_logic_vector(5 downto 0) := "000111";

	constant ALU_SLL  : std_logic_vector(5 downto 0) := "000000";
	constant ALU_SRL  : std_logic_vector(5 downto 0) := "000010";
	constant ALU_ADD  : std_logic_vector(5 downto 0) := "100000";
	constant ALU_SUB  : std_logic_vector(5 downto 0) := "100010";
end package;
