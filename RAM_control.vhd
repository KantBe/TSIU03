library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM_control is
  Port ( hcnt, vcnt    : in unsigned(9 downto 0);
         -- RAM signals
         addr                    : out unsigned(19 downto 0);
         sram_ce,sram_oe,sram_we : out std_logic;
         sram_lb,sram_ub         : out std_logic;
         up_lo_byte  : out std_logic); -- '0' <=> read lo byte.);
end entity;

architecture rtl of RAM_control is
begin
	sram_ce <= '0';
	sram_we <= '1';
	sram_oe <= '0';
	addr <= resize(shift_right((vcnt*640+hcnt),1),20);
	up_lo_byte <= hcnt(0);
	--sram_lb <= '1' when hcnt(0)='0' else '0';
	--sram_ub <= '1' when hcnt(0)='1' else '0';
	sram_ub <= '0';
	sram_lb <= '0';
end architecture;
