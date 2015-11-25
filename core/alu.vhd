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
			when ALU_OR  => c := a or b;
			when ALU_SLL =>
				case a(4 downto 0) is
					when "00000" => c := b;
					when "00001" => c := b(30 downto 0)&"0";
					when "00010" => c := b(29 downto 0)&"00";
					when "00011" => c := b(28 downto 0)&"000";
					when "00100" => c := b(27 downto 0)&"0000";
					when "00101" => c := b(26 downto 0)&"00000";
					when "00110" => c := b(25 downto 0)&"000000";
					when "00111" => c := b(24 downto 0)&"0000000";
					when "01000" => c := b(23 downto 0)&"00000000";
					when "01001" => c := b(22 downto 0)&"000000000";
					when "01010" => c := b(21 downto 0)&"0000000000";
					when "01011" => c := b(20 downto 0)&"00000000000";
					when "01100" => c := b(19 downto 0)&"000000000000";
					when "01101" => c := b(18 downto 0)&"0000000000000";
					when "01110" => c := b(17 downto 0)&"00000000000000";
					when "01111" => c := b(16 downto 0)&"000000000000000";
					when "10000" => c := b(15 downto 0)&"0000000000000000";
					when "10001" => c := b(14 downto 0)&"00000000000000000";
					when "10010" => c := b(13 downto 0)&"000000000000000000";
					when "10011" => c := b(12 downto 0)&"0000000000000000000";
					when "10100" => c := b(11 downto 0)&"00000000000000000000";
					when "10101" => c := b(10 downto 0)&"000000000000000000000";
					when "10110" => c := b(9 downto 0)&"0000000000000000000000";
					when "10111" => c := b(8 downto 0)&"00000000000000000000000";
					when "11000" => c := b(7 downto 0)&"000000000000000000000000";
					when "11001" => c := b(6 downto 0)&"0000000000000000000000000";
					when "11010" => c := b(5 downto 0)&"00000000000000000000000000";
					when "11011" => c := b(4 downto 0)&"000000000000000000000000000";
					when "11100" => c := b(3 downto 0)&"0000000000000000000000000000";
					when "11101" => c := b(2 downto 0)&"00000000000000000000000000000";
					when "11110" => c := b(1 downto 0)&"000000000000000000000000000000";
					when "11111" => c := b(0 downto 0)&"0000000000000000000000000000000";
					when others => c := b;
				end case;
			when ALU_SRL =>
				case a(4 downto 0) is
					when "00000" => c := b;
					when "00001" => c := "0"&b(31 downto 1);
					when "00010" => c := "00"&b(31 downto 2);
					when "00011" => c := "000"&b(31 downto 3);
					when "00100" => c := "0000"&b(31 downto 4);
					when "00101" => c := "00000"&b(31 downto 5);
					when "00110" => c := "000000"&b(31 downto 6);
					when "00111" => c := "0000000"&b(31 downto 7);
					when "01000" => c := "00000000"&b(31 downto 8);
					when "01001" => c := "000000000"&b(31 downto 9);
					when "01010" => c := "0000000000"&b(31 downto 10);
					when "01011" => c := "00000000000"&b(31 downto 11);
					when "01100" => c := "000000000000"&b(31 downto 12);
					when "01101" => c := "0000000000000"&b(31 downto 13);
					when "01110" => c := "00000000000000"&b(31 downto 14);
					when "01111" => c := "000000000000000"&b(31 downto 15);
					when "10000" => c := "0000000000000000"&b(31 downto 16);
					when "10001" => c := "00000000000000000"&b(31 downto 17);
					when "10010" => c := "000000000000000000"&b(31 downto 18);
					when "10011" => c := "0000000000000000000"&b(31 downto 19);
					when "10100" => c := "00000000000000000000"&b(31 downto 20);
					when "10101" => c := "000000000000000000000"&b(31 downto 21);
					when "10110" => c := "0000000000000000000000"&b(31 downto 22);
					when "10111" => c := "00000000000000000000000"&b(31 downto 23);
					when "11000" => c := "000000000000000000000000"&b(31 downto 24);
					when "11001" => c := "0000000000000000000000000"&b(31 downto 25);
					when "11010" => c := "00000000000000000000000000"&b(31 downto 26);
					when "11011" => c := "000000000000000000000000000"&b(31 downto 27);
					when "11100" => c := "0000000000000000000000000000"&b(31 downto 28);
					when "11101" => c := "00000000000000000000000000000"&b(31 downto 29);
					when "11110" => c := "000000000000000000000000000000"&b(31 downto 30);
					when "11111" => c := "0000000000000000000000000000000"&b(31 downto 31);
					when others => c := b;
				end case;
			when ALU_SLT =>
				if signed(a) < signed(b) then
					c := x"00000001";
			  	else
				   	c := x"00000000";
				end if;
			when ALU_FSLT =>
				if (a(31)>b(31) and (a(30 downto 0) /= 0 or b(30 downto 0) /= 0)) or (a(31)=b(31) and (a(31)='1' xor a(30 downto 0)<b(30 downto 0))) then
					c := x"00000001";
				else
					c := x"00000000";
				end if;
			when ALU_FNEG =>
				c := a xor x"80000000";
			when others => c := x"00000000";
		end case;

		-- end
		alu_out.data_c <= c;
	end process;
end architecture;
