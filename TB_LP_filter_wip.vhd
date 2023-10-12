library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_LP_filter is
end entity;

architecture sim of TB_LP_filter is
	-- DUT signals:
	signal clk : std_logic := '1'; -- clk must be initiated. 'U' is not a good state.
	signal sound : signed(3 downto 0) := "0111";
	signal filtered_power : unsigned(7 downto 0);
	signal power_out : unsigned(7 downto 0);
	signal process_out : unsigned(20 downto 0);
	signal sample_out : unsigned(12 downto 0);
	signal time_out : unsigned(10 downto 0);
	
	-- declare component DUT:
	-- The names and types are important. The order does not matter.
	component LP_filter IS 
		PORT(clk : in std_logic;
		     sound : in signed(3 downto 0);
			  power_out : out unsigned(7 downto 0);
		     filtered_power : out unsigned(7 downto 0);
			  process_out : out unsigned(20 downto 0);
			  sample_out : out unsigned(12 downto 0);
			  time_out : out unsigned(10 downto 0));
	END component;

begin
	clk <= not clk after 10 ns;
	
	process begin
		wait for 100us;
	end process;
	
	DUT : LP_filter
		port map(clk=>clk,
		         sound=>sound,
					filtered_power=>filtered_power,
					power_out=>power_out,
					process_out=>process_out,
					sample_out=>sample_out,
					time_out=>time_out);
	
end architecture;