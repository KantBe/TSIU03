library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity power is
  Port ( clk : in std_logic;
			signal_in : in signed(15 downto 0);
			power : out unsigned(29 downto 0) );
end entity;

architecture rtl of power is
	signal power_tmp : signed(31 downto 0);

begin
	process(clk)
	begin
		if rising_edge(clk) then
			power_tmp <= signal_in*signal_in;
			power <= unsigned(power_tmp(29 downto 0));
		end if;
	end process;
end architecture;