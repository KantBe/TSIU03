library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity log2 is
  Port ( clk : in std_logic;
			signal_in : in signed(15 downto 0);
			log2_signal : out signed(3 downto 0) );
end entity;

architecture rtl of log2 is
	signal signal_memory : signed(15 downto 0);
	signal signal_process : signed(15 downto 0);
	signal log2_wip : signed(3 downto 0);
	signal log2_ready : std_logic := '1';

begin
	process(clk)
	begin
		if rising_edge(clk) then
			if log2_ready = '1' then
				signal_memory <= signal_in;
				if signal_in = 0 then
					log2_signal <= "0000";
				elsif not (signal_memory = signal_in) then
					signal_process <= abs(signal_in);
					log2_ready <= '0';
					log2_wip <= "0000";
				end if;
			else
				if signal_process = 0 then
					log2_signal <= log2_wip -1;
					log2_ready <= '1';
				else
					signal_process <= '0' & signal_process(15 downto 1);
					log2_wip <= log2_wip + 1;
				end if;
			end if;
		end if;
	end process;
end architecture;