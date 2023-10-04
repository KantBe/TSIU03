library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pixel_reg is
  Port ( clk, rstn, lclk : in std_logic;
         hcnt, vcnt      : in unsigned (9 downto 0);
         pixcode         : out unsigned(7 downto 0);
			up_lo_byte      : in std_logic;
			b_cont, v_cont : in unsigned(3 downto 0);
			--amplitude : in unsigned(16 downto 0);
			a, b, c, d      : in std_logic;
         higher_byte, lower_byte : in unsigned(7 downto 0));
end entity;

architecture rtl of pixel_reg is
	signal pixreg: unsigned(7 downto 0);
begin
	process(rstn,clk)
	
		variable b_place, v_place, l_place, r_place, pl_place, pr_place: boolean;
		variable lgth_l: integer := 215;
		variable lgth_r: integer := 215;
		variable total_lgth: integer := 215;
		variable bottom: integer := 431;
		variable vol: unsigned(3 downto 0);
		variable volume_lgth, balance_pos: integer;
		variable pl_bottom, pr_bottom: integer := 0;
		
	begin
		vol(0) := d;
		vol(1) := c;
		vol(2) := b;
		vol(3) := a;
		
		l_place := (hcnt > 357 and hcnt < 397 and vcnt > bottom - lgth_l and vcnt < bottom) or (vcnt = bottom + total_lgth);
		r_place := (hcnt > 483 and hcnt < 523 and vcnt > bottom - lgth_r and vcnt < bottom) or (vcnt = bottom + total_lgth);
		if rstn ='0' then
			pixreg <= "00000000";
			
		elsif rising_edge(clk) then
			--case vol is
			case v_cont is
				when "0000" => volume_lgth := 0;
				when "0001" => volume_lgth := 33;
				when "0010" => volume_lgth := 71;
				when "0011" => volume_lgth := 109;
				when "0100" => volume_lgth := 148;
				when "0101" => volume_lgth := 186;
				when "0110" => volume_lgth := 223;
				when "0111" => volume_lgth := 257;
				when "1000" => volume_lgth := 290;
				when "1001" => volume_lgth := 320;
				when others => volume_lgth := 320;
			end case;
			v_place := hcnt > 275 and hcnt < 275 + volume_lgth and vcnt > 13 and vcnt < 42;
			
			--case vol is
			case b_cont is
				when "0000" => balance_pos := 282;
				when "0001" => balance_pos := 317;
				when "0010" => balance_pos := 359;
				when "0011" => balance_pos := 398;
				when "0100" => balance_pos := 439;
				when "0101" => balance_pos := 481;
				when "0110" => balance_pos := 523;
				when "0111" => balance_pos := 564;
				when "1000" => balance_pos := 590;
				when others => balance_pos := 439;
			end case;
			b_place := hcnt > balance_pos - 5 and hcnt < balance_pos + 5 and vcnt > 96 and vcnt < 125;
			
			case vol is
				when "0000" => lgth_l := total_lgth;
									lgth_r := total_lgth;
				when "0001" => lgth_l := 10;
									lgth_r := 10;
				when others => lgth_l := 100;
									lgth_r := 100;
			end case;				
			
			--lgth_l := ;
			--lgth_r := ;
			
			
			if pl_bottom > bottom - lgth_l then
				pl_bottom := bottom - lgth_l + 1;
				
			elsif lclk = '1' then
				pl_bottom := pl_bottom + 2;
				
			end if;
			if pl_bottom < bottom - total_lgth then
				pl_bottom := bottom - total_lgth;
			end if;
			pl_place := hcnt > 357 and hcnt < 397 and vcnt > pl_bottom - 15 and vcnt < pl_bottom;
			
			
			if pr_bottom > bottom - lgth_r then
				pr_bottom := bottom - lgth_r + 1;
				
			elsif lclk = '1' then
				pr_bottom := pr_bottom + 2;
				
			end if;
			if pr_bottom < bottom - total_lgth then
				pr_bottom := bottom - total_lgth;
			end if;
			pr_place := hcnt > 483 and hcnt < 523 and vcnt > pr_bottom - 15 and vcnt < pr_bottom;
			
			
			if v_place then
				pixreg <= "10011111";
				
			elsif b_place then
				pixreg <= "11100001";
				
			elsif l_place then
				if vcnt < bottom - total_lgth + 30  then
					pixreg <= "11110000";
				elsif vcnt < bottom - total_lgth + 75 then
					pixreg <= "11111100";
				else
					pixreg <= "10011000";
				end if;
				
			elsif r_place then	
				if vcnt < bottom - total_lgth + 30  then
					pixreg <= "11110000";
				elsif vcnt < bottom - total_lgth + 75 then
					pixreg <= "11111100";
				else
					pixreg <= "10011000";
				end if;
				
			elsif pl_place then
				pixreg <= "11100000";
				
			elsif pr_place then
				pixreg <= "11100000";
				
			else
				if up_lo_byte='0' then
					pixreg <= lower_byte;
				else
					pixreg <= higher_byte;
				end if;
				
			end if;
		end if;	
	end process;
	
	pixcode <= pixreg;
end architecture;
