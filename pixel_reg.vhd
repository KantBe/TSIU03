library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;

entity pixel_reg is
  Port ( clk, rstn, lclk : in std_logic;
         hcnt, vcnt      : in unsigned (9 downto 0);
         pixcode         : out unsigned(23 downto 0);
			up_lo_byte      : in std_logic;
			b_cont, v_cont : in unsigned(3 downto 0);
			r_sound, l_sound: in unsigned(4 downto 0);
			a, b, c, d      : in std_logic;
         higher_byte, lower_byte : in unsigned(7 downto 0);
			game_control : in std_logic);
end entity;

architecture rtl of pixel_reg is
	signal pixreg: unsigned(23 downto 0);
	signal first_pixreg: unsigned(7 downto 0);
begin
	process(rstn,clk)
	
		variable b_place, v_place, l_place, r_place, pl_place, pr_place, rgame, lgame, rwinning, lwinning: boolean;
		variable lgth_l: integer := 215;
		variable lgth_r: integer := 215;
		variable total_lgth: integer := 215;
		variable bottom: integer := 431;
		variable vol: unsigned(3 downto 0);
		variable volume_lgth, balance_pos: integer;
		variable pl_bottom, pr_bottom: integer := 0;
		variable rcolor, gcolor: integer;
		variable game_pos : integer;
		
	begin
		vol(0) := d;
		vol(1) := c;
		vol(2) := b;
		vol(3) := a;
		
--		l_place := (hcnt > 357 and hcnt < 397 and vcnt > bottom - lgth_l and vcnt < bottom) or (vcnt = bottom + total_lgth);
--		r_place := (hcnt > 483 and hcnt < 523 and vcnt > bottom - lgth_r and vcnt < bottom) or (vcnt = bottom + total_lgth);
		if rstn ='0' then
			pixreg <= "00000000" & "00000000" & "00000000";
			game_pos := bottom;
			
		elsif rising_edge(clk) then
		
			------------------------- COMPUTING PART -----------------------------------
			--Volume computation
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
			
			--Balance computation
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
			
			
			--Right and left amplitude computation
			case vol is
				when "0001" => lgth_l := total_lgth;
									lgth_r := total_lgth;
				when others => lgth_l := (to_integer(l_sound) * total_lgth)/8;
									lgth_r := (to_integer(r_sound) * total_lgth)/8;
			end case;				
			
			--lgth_l := (abs(to_integer(l_sound)) * total_lgth)/10000;  --65535 v_max for 16 bits and map = (x -in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
			--lgth_r := (abs(to_integer(r_sound)) * total_lgth)/10000;
			if lgth_l > total_lgth then
				lgth_l := total_lgth;
			end if;
			if lgth_r > total_lgth then
				lgth_r := total_lgth;
			end if;
			
			l_place := hcnt > 357 and hcnt < 397 and vcnt > bottom - lgth_l and vcnt < bottom;
			r_place := hcnt > 483 and hcnt < 523 and vcnt > bottom - lgth_r and vcnt < bottom;
			
			
			--Color gradient generation
			rcolor := bottom - to_integer(vcnt) + 30;
			gcolor := 340 - rcolor;
			
			if gcolor > 255	then
				gcolor := 255;
			end if;
			
			--Left peak indicator
			if pl_bottom > bottom - lgth_l then
				pl_bottom := bottom - lgth_l + 1;
				
			elsif lclk = '1' then
				pl_bottom := pl_bottom + 2;		
			end if;
			if pl_bottom < bottom - total_lgth then
				pl_bottom := bottom - total_lgth;
			end if;
			pl_place := hcnt > 357 and hcnt < 397 and vcnt > pl_bottom - 15 and vcnt < pl_bottom;
			
			--Right peak indicator
			if pr_bottom > bottom - lgth_r then
				pr_bottom := bottom - lgth_r + 1;
			elsif lclk = '1' then
				pr_bottom := pr_bottom + 2;
			end if;
			if pr_bottom < bottom - total_lgth then
				pr_bottom := bottom - total_lgth;
			end if;
			pr_place := hcnt > 483 and hcnt < 523 and vcnt > pr_bottom - 15 and vcnt < pr_bottom;
			
			--Game position computing
			if game_control = '1' and lclk = '1' then
				game_pos := game_pos - 1;
			elsif lclk = '1' then
				game_pos := game_pos + 1;
			end if;			
			
			if game_pos > bottom then
				game_pos := bottom;
			elsif game_pos < bottom - total_lgth then
				game_pos := bottom - total_lgth;
			end if;
			
			rwinning := hcnt > 310 and hcnt < 330 and vcnt > bottom - 20 and vcnt < bottom;
			lwinning := hcnt > 550 and hcnt < 570 and vcnt > bottom - 20 and vcnt < bottom;
			rgame := hcnt > 495 and hcnt < 511 and vcnt > game_pos - 15 and vcnt < game_pos;
			lgame := hcnt > 369 and hcnt < 385 and vcnt > game_pos - 15 and vcnt < game_pos;
			
			
			------------------------ DISPLAYING PART ---------------------------------
			--Game displaying
			if (rgame or lgame) and game_pos < bottom then
				pixreg <= "11111101" & "01101100" & "10011110";
			
			--Winning indicator
			elsif rwinning and game_pos < bottom then
				if game_pos < pr_bottom then
					pixreg <= "00000000" & "11111111" & "00000000";
				else
					pixreg <= "11111111" & "00000000" & "00000000";
				end if;
				
			elsif lwinning and game_pos < bottom then
				if game_pos < pl_bottom then
					pixreg <= "00000000" & "11111111" & "00000000";
				else
					pixreg <= "11111111" & "00000000" & "00000000";
				end if;
				
			--Volume displaying
			elsif v_place then
				pixreg <= "00000000" & "11111111" & "11111111";
				
			--Balance displaying
			elsif b_place then
				pixreg <= "11111111" & "00000000" & "01010101";
				
			--Amplitude displaying
			elsif l_place then
				pixreg <= to_unsigned(rcolor,8) & to_unsigned(gcolor,8) & "00000000";
				
			elsif r_place then	
				pixreg <= to_unsigned(rcolor,8) & to_unsigned(gcolor,8) & "00000000";
				
			--Peak indicators displaying	
			elsif pl_place or pr_place then
				pixreg <= "11111111" & "00000000" & "00000000";
				
			--Background displaying
			else				
				if up_lo_byte='0' then
				
					--Lower byte reading
					if lower_byte(7)='0' then
						pixreg <= lower_byte (6 downto 0) & lower_byte(6) & lower_byte (6 downto 0) & lower_byte(6) & lower_byte (6 downto 0) & lower_byte(6);
					else
						pixreg <= lower_byte(6 downto 5) & lower_byte(6 downto 5) & lower_byte(6 downto 5) & lower_byte(6 downto 5) & 
							lower_byte(4 downto 2) & lower_byte(4 downto 2) & lower_byte(4 downto 3) & 
							lower_byte(1 downto 0) & lower_byte(1 downto 0) & lower_byte(1 downto 0) & lower_byte(1 downto 0);
					end if;
				else
				
					--Upper byte reading
					if higher_byte(7)='0' then
						pixreg <= higher_byte (6 downto 0) & higher_byte(6) & higher_byte (6 downto 0) & higher_byte(6) & higher_byte (6 downto 0) & higher_byte(6);
					else
						pixreg <= higher_byte(6 downto 5) & higher_byte(6 downto 5) & higher_byte(6 downto 5) & higher_byte(6 downto 5) & 
							higher_byte(4 downto 2) & higher_byte(4 downto 2) & higher_byte(4 downto 3) & 
							higher_byte(1 downto 0) & higher_byte(1 downto 0) & higher_byte(1 downto 0) & higher_byte(1 downto 0);
					end if;
				end if;
			end if;
		end if;
	end process;
	
	pixcode <= pixreg;
end architecture;
