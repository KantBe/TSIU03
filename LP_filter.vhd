library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LP_filter is
  Port ( clk : in std_logic;
			sound : in signed(3 downto 0);
			filtered_power : out unsigned(7 downto 0) );
end entity;

architecture rtl of LP_filter is
	signal power : unsigned(7 downto 0);
	signal processed_power : unsigned(20 downto 0); -- 8 + 13
	signal time_counter : unsigned(12 downto 0); --44100/5=8820 ~ 8192 => 13 
	signal sample_counter : unsigned(23 downto 0); --50 MHz*0.2s=10^7 => 23.3 // We take a sample every 8192/44100 s : 50MHz*8192/44100=9287981 => 23.1

begin
	process(clk)
	begin
		if rising_edge(clk) then
			if sample_counter = 10000000 then
				power <= unsigned(sound*sound);
				time_counter <= time_counter + 1;
				sample_counter <= "000000000000000000000000";
				
				if time_counter <= 8800 then
					processed_power <= processed_power + ("00000000000000" & power);
				else
					processed_power <= "000000000000000000000";
				end if;
				
				if time_counter = 8800 then
					filtered_power <= processed_power(20 downto 13);
				end if;
		  else
		  	sample_counter <= sample_counter + 1;
		  end if;
		end if;
	end process;
end architecture;