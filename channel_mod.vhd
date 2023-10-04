library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Channel_Mod is
	port(clk, men, rstn, lrsel : in std_logic;
			SCCnt: in unsigned (1 downto 0);
			BitCnt: in unsigned (4 downto 0);
			DAC_en: in std_logic;
			adcdat:in std_logic;
			dacdat: out std_logic;
			LDAC: in signed(15 downto 0);
			LADC: out signed(15 downto 0));		
end entity;

architecture rtl of Channel_Mod is

signal RXReg: signed(15 downto 0);
signal TXReg: signed(15 downto 0);

begin

rx : process(rstn, clk)
begin

	if rstn = '0' then
		RXReg<="0000000000000000";
	elsif rising_edge(clk) then
		
		if lrsel = '0' then 
		
			if SCCnt = "01" and men = '1' and BitCnt < 16 then
			
				RXReg(15 downto 1)<=RXReg(14 downto 0);
				RXReg(0)<=adcdat;
			
			end if;
		end if;
	end if;
end process;

LADC<=RXReg;

tx : process(rstn, clk)

begin

	if rstn = '0' then
		TXReg<="0000000000000000";		
	elsif rising_edge(clk) then	
		if lrsel = '0' then
			dacdat<=TXReg(15);		
			if SCCnt = "11" and men = '1' then	
				TXReg(15 downto 0)<=TXReg(14 downto 0)&'0';
			end if;
		elsif lrsel = '1' and DAC_en = '1' then
			TXReg<=LDAC;
		end if;	
	end if;
end process;


end architecture;