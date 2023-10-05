library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_log2 is
end entity;

architecture sim of TB_log2 is
	-- DUT signals:
	signal clk : std_logic := '1'; -- clk must be initiated. 'U' is not a good state.
	signal signal_in : signed(15 downto 0) := "0000000000001000";
	signal log2_signal : signed(3 downto 0);
	
	-- declare component DUT:
	-- The names and types are important. The order does not matter.
	component log2 IS 
		PORT(clk : in std_logic;
		     signal_in : in signed(15 downto 0);
		     log2_signal : out signed(3 downto 0));
	END component;

begin
	clk <= not clk after 10 ns;
	
	process begin
		wait for 100us;
	end process;
	
	DUT : log2
		port map(clk=>clk,
		         signal_in=>signal_in,
					log2_signal=>log2_signal);
	
end architecture;
		