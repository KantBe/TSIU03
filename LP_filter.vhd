library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LP_filter is
  Port ( clk : in std_logic;
			power : in unsigned(29 downto 0);
			filtered_power : out unsigned(29 downto 0) );
end entity;

architecture rtl of LP_filter is
	signal processed_power : unsigned(29 downto 0) := (others => '0');
	signal time_counter : unsigned(10 downto 0) := (others => '0'); -- 50 MHz/44100 ~ 1134 => 11
	signal sample_counter : unsigned(8 downto 0) := (others => '0'); -- 44100/60 => 9

begin
	process(clk)
	begin
		if rising_edge(clk) then
			if time_counter = 1133 then
				time_counter <= (others => '0');
				
				sample_counter <= sample_counter + 1;
				processed_power <= to_unsigned(to_integer(processed_power) * 4095 / 4096, 30) + to_unsigned(to_integer(power) * 1 / 4096, 30);

				if sample_counter = 511 then
					filtered_power <= processed_power;
				end if;
			else
				time_counter <= time_counter + 1;
			end if;
		end if;
	end process;
end architecture;
