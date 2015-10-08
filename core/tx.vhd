library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tx is
	generic (wtime : std_logic_vector(15 downto 0) := x"1ADB");
	port (
		clk   : in std_logic;
		data  : in std_logic_vector(7 downto 0);
		go    : in std_logic;
		busy  : out std_logic;
		rs_tx : out std_logic);
end entity;

architecture struct of tx is
	signal count : std_logic_vector(15 downto 0) := (others => '0');
	signal buf   : std_logic_vector(8 downto 0) := (others => '1');
	signal state : integer range -1 to 9 := -1;
begin
	statemachine : process(clk)
	begin
		if rising_edge(clk) then
			case state is
				when -1 =>
					if go = '1' then
						buf <= data&"0";
						count <= wtime;
						state <= 9;
					end if;
				when others =>
					if count /= 0 then
						count <= count-1;
					else
						count <= wtime;
						buf <= "1"&buf(8 downto 1);
						state <= state-1;
					end if;
			end case;
		end if;
	end process;

	rs_tx <= buf(0);
	busy <= '0' when state = -1 else '1';
end architecture;
