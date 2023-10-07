library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LP_filter is
  Port ( clk : in std_logic;
			sound : in signed(3 downto 0);
			filtered_power : out unsigned(7 downto 0) );
end entity;

architecture rtl of LP_filter is
	signal power : unsigned(7 downto 0) := "00000000";
	signal processed_power : unsigned(20 downto 0) := "000000000000000000000"; -- 8 + 13
	signal time_counter : unsigned(10 downto 0) := "00000000000"; --50 MHz/44100 ~ 1134 => 11
	signal sample_counter : unsigned(12 downto 0) := "0000000000000"; --44100/5=8820 ~ 8192 => 13

begin
	process(clk)
	begin
		if rising_edge(clk) then
			if time_counter = 1133 then
				power <= unsigned(sound*sound);
				sample_counter <= sample_counter + 1;
				time_counter <= "00000000000";

				if sample_counter > 0 then
					processed_power <= processed_power + ("0000000000000" & power);
				else
					processed_power <= ("0000000000000" & power);
				end if;

				if sample_counter = 8191 then
					filtered_power <= processed_power(20 downto 13);
				end if;
			else
				time_counter <= time_counter + 1;
			end if;
		end if;
	end process;
end architecture;
