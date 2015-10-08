library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity rx is
	generic (wtime : std_logic_vector(15 downto 0) := x"1ADB");
	port (
		clk   : in  std_logic;
		data  : out std_logic_vector(7 downto 0);
		go    : in  std_logic;
		busy  : out std_logic;
		rs_rx : in  std_logic);
end entity;

architecture struct of rx is
	signal count : std_logic_vector(15 downto 0) := (others => '0');
	signal buf   : std_logic_vector(7 downto 0) := (others => '1');
	signal state : integer range -1 to 10 := 0;
	signal rxb   : std_logic;
begin
	statemachine : process(clk)
	begin
		if rising_edge(clk) then
			rxb <= rs_rx;
			case state is
				when -1 =>
					state <= 10;
					data <= buf;
				when 10 =>
					if rxb = '0' then
						state <= 9;
						count <= wtime;
					end if;
				when others =>
					if count = 0 then
						state <= state-1;
						if state = 0 then
							count <= "0"&wtime(14 downto 0);
						else
							count <= wtime;
						end if;
					else
						if state /= 0 and count = "0"&wtime(14 downto 0) then
							buf <= rxb&buf(7 downto 1);
						end if;
						count <= count -1;
					end if;
			end case;
		end if;
	end process;
end architecture;
