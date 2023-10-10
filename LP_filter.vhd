library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LP_filter is
  Port ( clk : in std_logic;
			power : in unsigned(4 downto 0);
			filtered_power : out unsigned(4 downto 0) );
end entity;

architecture rtl of LP_filter is
	signal processed_power : unsigned(14 downto 0) := (others => '0'); -- 5 + 10
	signal time_counter : unsigned(10 downto 0) := (others => '0'); -- 50 MHz/44100 ~ 1134 => 11
	signal sample_counter : unsigned(9 downto 0) := (others => '0'); -- 44100/24=1837.5 ~ 1024 => 10

begin
	process(clk)
	begin
		if rising_edge(clk) then
			if time_counter = 1133 then
				sample_counter <= sample_counter + 1;
				time_counter <= (others => '0');

				if sample_counter > 0 then
					processed_power <= processed_power + ("0000000000" & power);
				else
					processed_power <= ("0000000000" & power);
				end if;

				if sample_counter = 1023 then
					filtered_power <= processed_power(17 downto 13);
				end if;
			else
				time_counter <= time_counter + 1;
			end if;
		end if;
	end process;
end architecture;
