library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity apply_volume_balance is
port(clk, rstn: in std_logic;
		v_cont, b_cont: in unsigned(3 downto 0);
		l_channel, r_channel: in signed (15 downto 0);
		lrsel     : in  std_logic;
	   ADC_en    : in  std_logic;
	   DAC_en    : out std_logic;
		l_channel_modi, r_channel_modi: out signed(15 downto 0));

end entity;

architecture rtl of apply_volume_balance is

	signal l_channel_modi_int_B: signed (15 downto 0) ;
	signal r_channel_modi_int_B: signed (15 downto 0) ;

begin



	process (rstn, clk)
	
		variable bound: integer;	
		variable bal, vol: unsigned(3 downto 0);
		variable l_channel_modi_int_V: signed (15 downto 0) ;
		variable r_channel_modi_int_V: signed (15 downto 0) ;
		variable l_channel_int:  signed (15 downto 0) ;
		variable r_channel_int:  signed (15 downto 0) ;
		
	begin
	vol := v_cont;
	bal := b_cont;
	
	
	l_channel_int:=l_channel;
	r_channel_int:=r_channel;
	
	if rstn = '0' then
	
		l_channel_modi_int_B<= "0000000000000000";
		r_channel_modi_int_B<= "0000000000000000";
		l_channel_modi_int_V:= "0000000000000000";
		r_channel_modi_int_V:= "0000000000000000";
		bound:=0;
	
	elsif rising_edge(clk) then
	
		-- Apply volume

			
			if (vol=0) then
			
				l_channel_modi_int_V:="0000000000000000";
				r_channel_modi_int_V:="0000000000000000";

			elsif (vol=9) then
			
				l_channel_modi_int_V:=l_channel;
				r_channel_modi_int_V:=r_channel;
			
			else
			
			bound:= 9 - TO_INTEGER(v_cont);
			--bound:= 9 - TO_INTEGER(vol);
			
				for i in 1 to 9 loop
					l_channel_modi_int_V:= resize(shift_right(l_channel_int,2)*"0000000000000011",16); -- multiply by 3/4
					r_channel_modi_int_V:= resize(shift_right(r_channel_int,2)*"0000000000000011",16); -- multiply by 3/4
					l_channel_int:=l_channel_modi_int_V;
					r_channel_int:=r_channel_modi_int_V;
					exit when i=bound;
				end loop;
			end if;
		
		-- Apply balance
		case b_cont is
		--case bal is
		
			 --0
			when "1000" => l_channel_modi_int_B<=l_channel_modi_int_V;   
								r_channel_modi_int_B<= resize(0*r_channel_modi_int_V,16); -- multiply by 0
			--1					
			when "0111" => l_channel_modi_int_B<=l_channel_modi_int_V;  
								r_channel_modi_int_B<= shift_right(r_channel_modi_int_V,2); -- multiply by 1/4
			-- 2					
			when "0110" => l_channel_modi_int_B<=l_channel_modi_int_V;  
								r_channel_modi_int_B<= shift_right(r_channel_modi_int_V,1); -- multiply by 1/2
			--3					
			when "0101" => l_channel_modi_int_B<=l_channel_modi_int_V; 
								r_channel_modi_int_B<= resize(shift_right(r_channel_modi_int_V,2)*3,16); 
			--4					
			when "0100" => l_channel_modi_int_B<=l_channel_modi_int_V; 
								r_channel_modi_int_B<=r_channel_modi_int_V;
			--5					
			when "0011" => l_channel_modi_int_B<=resize(shift_right(l_channel_modi_int_V,2)*3,16); -- multiply by 3/4
								r_channel_modi_int_B<=r_channel_modi_int_V; 
			--6				
			when "0010" => l_channel_modi_int_B<=shift_right(l_channel_modi_int_V,1); -- multiply by 1/2
								r_channel_modi_int_B<=r_channel_modi_int_V;
			--7						
			when "0001" => l_channel_modi_int_B<=shift_right(l_channel_modi_int_V,2); -- multiply by 1/4
								r_channel_modi_int_B<=r_channel_modi_int_V;
			--8			
			when "0000" => l_channel_modi_int_B<=resize(0*l_channel_modi_int_V,16); -- multiply by 0
								r_channel_modi_int_B<=r_channel_modi_int_V;  
			
			when others => l_channel_modi_int_B<=l_channel_modi_int_V; 
								r_channel_modi_int_B<=r_channel_modi_int_V;
		
		end case;	
	end if;
	
	end process;
	
	process(clk) begin
		if rising_edge(clk) then
			DAC_en <= '0'; -- default
			if ADC_en = '1' and lrsel = '1' then -- activate left channel
				l_channel_modi <= l_channel_modi_int_B; -- put calculation results onto the output.
				r_channel_modi <= (others => '0'); --shift_right(signed(noise),4); -- put some noise onto the output.
				DAC_en <= '1';
				
			elsif ADC_en = '1' and lrsel = '0' then -- activate right channel
				r_channel_modi <= r_channel_modi_int_B;
				l_channel_modi <= (others => '0'); --shift_right(signed(noise),4);
				DAC_en <= '1';
			end if;
		end if;
	end process;
	
end architecture;