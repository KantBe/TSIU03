library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ce_gen is
  Port ( clk : in std_logic;
         rstn : in std_logic;
         ce : out std_logic;
			lclk: out std_logic);
end entity;

architecture rtl of ce_gen is
	signal cntr: unsigned(17 downto 0);
	signal ce_2, lclk_2: std_logic;
	type stateFSM is (zero, one);
	signal state: stateFSM;
begin
	process (state, clk)
	begin
		if rstn = '0' then
				cntr <= "111111111111111110";
				ce_2 <= '0';
				state <= zero;
				lclk_2 <= '0';
		elsif rising_edge(clk) then
			cntr <= cntr + "000000000000000001";
			case state is
				when zero =>
					ce_2 <= '0';
					state <= one;
				when one =>
					state <= zero;
					ce_2 <= '1';
			end case;
			
			if cntr = "111111111111111111" then
				lclk_2 <= '1';
			else
				lclk_2 <= '0';
			end if;
		end if;
	end process;
	ce <= ce_2;
	lclk <= lclk_2;
end architecture;
