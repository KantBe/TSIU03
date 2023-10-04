library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ctrl is
	port(clk, rstn : in std_logic;
        mclk, bclk,adclrc, daclrc, ADC_en, lrsel, men : out std_logic;
		  SCCnt: out unsigned (1 downto 0);
		  BitCnt: out unsigned (4 downto 0));
end entity;

architecture rtl of ctrl is

signal cntr:  unsigned (9 downto 0);
signal cntr_men: std_logic :='1';
signal mclk_int: std_logic;
signal bclk_int: std_logic;
signal men_int: std_logic;
signal SCCnt_int: unsigned(1 downto 0);
signal BitCnt_int: unsigned(4 downto 0);
signal adclrc_int: std_logic;
signal daclrc_int: std_logic;
signal lrsel_int:std_logic;
signal ADC_en_int:std_logic;

begin

process (clk, rstn) 

begin
	
	if (rstn = '0') then
		cntr<= "1111111111";
		mclk_int<= '0';
bclk_int<= '0';
men_int<= '1';
SCCnt_int<="11";
BitCnt_int<="11111";
adclrc_int<='0';
daclrc_int<='0';
lrsel_int<='1';
ADC_en_int<='0';
		
	elsif rising_edge(clk) then
		cntr <= cntr + 1;
		
 -- Generation of mclk
		
		if cntr(1 downto 0) = "01" then			
			mclk_int<='0';			
		elsif cntr (1 downto 0) = "11" then	
			mclk_int<='1';		
		end if;
		
 -- Generation of bclk
		
		if cntr(3 downto 0) = "0111" then		
			bclk_int<='1';		
		elsif cntr(3 downto 0) = "1111" then
			bclk_int<='0';	
		end if;

	-- Generation of men
	
	if cntr(1 downto 0) = "10" then	
		men_int<='1';
	else	
		men_int<='0';
	end if;

	-- Generation of SCCnt
	
	if cntr(1 downto 0) = "11" then
		SCCnt_int<= SCCnt_int + 1;
	end if;
	
	-- Generation BitCnt
	
	if cntr(3 downto 0) = "1111" then
		BitCnt_int<= BitCnt_int + 1;
	end if;
	
	-- Generation adclrc and daclrc
	
	if cntr = 511 or cntr = 1023 then
		daclrc_int<= not daclrc_int;
		adclrc_int<=not adclrc_int;
	end if;
		
	-- Generation of ADC_en
	if cntr = 511 then
		ADC_en_int<='1';
	elsif cntr = 1023 then
		ADC_en_int<='1';
	else
		ADC_en_int<='0';
	end if;
	
end if; 

end process;

--mclk <= not(cntr(1));
mclk<=mclk_int;
bclk<=bclk_int;
men<=men_int;
SCCnt<= SCCnt_int;
BitCnt<=BitCnt_int;
adclrc<= adclrc_int;
daclrc<= daclrc_int;
lrsel<= not adclrc_int;
ADC_en<=ADC_en_int;

end architecture;
	  