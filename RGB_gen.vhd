library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RGB_gen is
  Port ( clk, rstn, ce : in std_logic;
         pixcode :  in unsigned(7 downto 0);
         -- Signals to the video DAC:
         vga_r :  out unsigned(7 downto 0);
         vga_g :  out unsigned(7 downto 0);
         vga_b :  out unsigned(7 downto 0);
         vga_sync  : out std_logic);
end entity;

architecture rtl of RGB_gen is
begin
	vga_sync <= '0';
	process(clk,rstn)
	begin
		if rstn='0' then
			vga_r <= "00000000";
			vga_b <= "00000000";
			vga_g <= "00000000";
		elsif rising_edge(clk) and ce='1' then
			if pixcode(7)='0' then
				vga_b <= pixcode (6 downto 0) & pixcode(6);
				vga_g <= pixcode (6 downto 0) & pixcode(6);
				vga_r <= pixcode (6 downto 0) & pixcode(6);
			else
				vga_r <= pixcode(6 downto 5) & pixcode(6 downto 5) & pixcode(6 downto 5) & pixcode(6 downto 5);
				
				vga_b <= pixcode(1 downto 0) & pixcode(1 downto 0) & pixcode(1 downto 0) & pixcode(1 downto 0);
				
				vga_g <= pixcode(4 downto 2) & pixcode(4 downto 2) & pixcode(4 downto 3);
			end if;
		end if;
	end process;
end architecture;
