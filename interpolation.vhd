library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity interpolation is
  Port ( clk : in std_logic;
			power_in : in unsigned(4 downto 0);
			power_out : out unsigned(4 downto 0) );
end entity;

architecture rtl of interpolation is
	signal memory_power_in : unsigned(4 downto 0);
	signal memory_power_tmp : unsigned(4 downto 0);
	signal old_power_in : unsigned(4 downto 0);
	signal power_to_add : signed(5 downto 0);
	signal power_to_add_tmp : signed(5 downto 0);
	signal power_signed : signed(5 downto 0);
	signal time_counter : unsigned(10 downto 0) := (others => '0');
	signal sample_counter : unsigned(9 downto 0) := (others => '0');

begin
	process(clk)
	begin
		if rising_edge(clk) then
			if time_counter = 1133 then
				sample_counter <= sample_counter + 1;
				time_counter <= (others => '0');

				if sample_counter = 0 then
					old_power_in <= memory_power_in;
					memory_power_tmp <= power_in;
				elsif sample_counter = 1 then
					memory_power_in <= memory_power_tmp;
					power_to_add_tmp <= signed('0' & memory_power_in) - signed('0' & old_power_in);
				elsif sample_counter = 2 then
				--	power_to_add <= power_to_add_tmp(5) & power_to_add_tmp(5) & power_to_add_tmp(5) & power_to_add_tmp(5) & power_to_add_tmp(4 downto 3);
				--elsif sample_counter = 639 or sample_counter = 703 or sample_counter = 767 or sample_counter = 831 or sample_counter = 895 or sample_counter = 895 or sample_counter = 959 then
					power_to_add <= power_to_add_tmp(5) & power_to_add_tmp(5) & power_to_add_tmp(5) & power_to_add_tmp(4 downto 2);
				elsif sample_counter = 255 or sample_counter = 511 or sample_counter = 767 then
					power_signed <= power_signed + power_to_add;
				elsif sample_counter = 1023 then
					power_signed <= signed('0' & memory_power_in);
				end if;

				power_out <= unsigned(power_signed(4 downto 0));
			else
				time_counter <= time_counter + 1;
			end if;
		end if;
	end process;
end architecture;