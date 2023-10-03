library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LP_filter is
  Port ( clk : in std_logic;
				 sound : in signed(3 downto 0);
				 filtered_power : out unsigned(7 downto 0));
end entity;

architecture rtl of LP_filter is
	signal power : unsigned(7 downto 0);
	signal processed_power : unsigned(21 downto 0); -- 8 + 14
	signal time_counter : unsigned(13 downto 0); --44100/5=8820 => 13.1
	signal sample_counter : unsigned(23 downto 0); --50 MHz*0.2s=10^7 => 23.3

begin
	process(clk)
	begin
		if rising_edge(clk) then
			if sample_counter = 10000000 then 
				if time_counter < 8800
					power <= sound*sound;
					processed_power <= processed_power + ("00000000000000" & power);
					time_counter <= time_counter + 1;
				elsif counter = 8800 then
					filtered_power <= (processed_power + power)/8800;
					time_counter <= time_counter + 1;
				else
					processed_power <= 0;
					time_counter <= 0;
				end if;
				sample_counter <= 0;
		  else
		  	sample_counter <= sample_counter + 1;
		  end if;
		end if;
	end process;
end architecture;