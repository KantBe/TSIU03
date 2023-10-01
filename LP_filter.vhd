library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LP_filter is
  Port ( clk : in std_logic;
				 sound : in signed(5 downto 0);
				 filtered_power : out unsigned(11 downto 0));
end entity;

architecture rtl of LP_filter is
	signal power : unsigned(11 downto 0);
	signal processed_power : unsigned(25 downto 0); -- 12 + 14
	signal counter : unsigned(13 downto 0); --44000/5=8800 => 13.1

begin
	process(clk)
	begin
		if rising_edge(clk) then
			if counter < 8800
				power <= sound*sound;
				processed_power <= processed_power + power;
			elsif counter = 8800
				filtered_power <= (processed_power + power)/8800;
			else
				processed_power <= 0;
				counter <= 0;
			end if;
		end if;
	end process;
end architecture;