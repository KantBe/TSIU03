library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity log2 is
  Port ( clk : in std_logic;
			power_in : in signed(31 downto 0);
			log2_power : out unsigned(4 downto 0) ); -- log2(29) ~ 4.9 => 5
end entity;

architecture rtl of log2 is
	signal power_memory : signed(31 downto 0);
	signal power_process : unsigned(29 downto 0);
	signal log2_wip : unsigned(4 downto 0);
	signal log2_ready : std_logic := '1';

begin
	process(clk)
	begin
		if rising_edge(clk) then
			if log2_ready = '1' then
				power_memory <= power_in;
				if power_in = 0 then
					log2_power <= (others => '0');
				elsif not (power_memory = power_in) then
					power_process <= unsigned(power_in(29 downto 0));
					log2_ready <= '0';
					log2_wip <= (others => '0');
				end if;
			else
				if power_process = 0 then
					log2_power <= log2_wip -1;
					log2_ready <= '1';
				else
					power_process <= '0' & power_process(29 downto 1);
					log2_wip <= log2_wip + 1;
				end if;
			end if;
		end if;
	end process;
end architecture;