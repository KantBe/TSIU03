library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LP_filter is
  Port ( clk : in std_logic;
			power : in unsigned(4 downto 0);
			filtered_power : out unsigned(4 downto 0) );
end entity;

architecture rtl of LP_filter is
	signal processed_power : unsigned(13 downto 0) := (others => '0'); -- 5 + 9 => 14
	signal time_counter : unsigned(10 downto 0) := (others => '0'); -- 50 MHz/44100 ~ 1134 => 11
	--signal sample_counter : unsigned(10 downto 0) := (others => '0'); -- 44100/24=1837.5 ~ 2048 => 11
	signal sample_counter : unsigned(8 downto 0) := (others => '0'); -- 44100/60=735 ~ 512 => 9

begin
	process(clk)
	begin
		if rising_edge(clk) then
			if time_counter = 1133 then
				time_counter <= (others => '0');
				
				if power > 0 then
					sample_counter <= sample_counter + 1;
					
					if sample_counter > 0 then
						processed_power <= processed_power + ("000000000" & power);
					else
						processed_power <= ("000000000" & power);
					end if;

					if sample_counter = 511 then
						filtered_power <= processed_power(13 downto 9);
					end if;
				end if;
			else
				time_counter <= time_counter + 1;
			end if;
		end if;
	end process;
end architecture;
