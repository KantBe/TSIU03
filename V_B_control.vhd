library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity V_B_control is
	port(rstn, clk, PS2_CLK, PS2_DAT : in std_logic ; 
	--HEX0, HEX6 : out std_logic_vector(6 downto 0); 
	v_cont, b_cont : out unsigned(3 downto 0));
	--LEDR : out std_logic_vector(9 downto 0));
end entity;

architecture rtl of V_B_control is
	signal PS2_CLK2, PS2_CLK2_old, PS2_DAT2, detected_fall : std_logic ;
	signal shiftreg : std_logic_vector(9 downto 0) := (others=> '1');
	signal PS2_byte : std_logic_vector(7 downto 0);
	signal PS2_byte_en : std_logic;
	signal scancode : std_logic_vector(9 downto 0);
	signal E0, F0 : std_logic;	
	signal press_b : std_logic;
	signal v_sig, b_sig : unsigned(3 downto 0);

begin
	
	--Process 1: Synchronize the in input
	p1 : process(clk) begin
		if rising_edge(clk) then
			PS2_DAT2 <= PS2_DAT;
			PS2_CLK2 <= PS2_CLK;
			PS2_CLK2_old <= PS2_CLK2;
		end if;
	end process;
	detected_fall <= not(PS2_CLK2) AND PS2_CLK2_old;

	--Process 2: Handle shiftreg
	p2 : process(clk, rstn, detected_fall, PS2_byte_en) begin
		PS2_byte <= shiftreg(8 downto 1);
		PS2_byte_en <= not shiftreg(0);
		if  rstn = '0' then
			shiftreg <= (others=> '1');
		elsif rising_edge(clk) and detected_fall = '1' then
			shiftreg(8 downto 0) <= shiftreg(9 downto 1);
			shiftreg(9) <= PS2_DAT2;
		elsif rising_edge(clk) and PS2_byte_en = '1' then
			shiftreg <= (others=> '1');
		end if;
	end process;
	
	--Process 3: Byte to scancode
	p3 : process(clk, rstn, PS2_byte, PS2_byte_en) 
	variable v_var : unsigned(3 downto 0);
	variable b_var : unsigned(3 downto 0);
	
	begin
		v_var := v_sig;
		b_var := b_sig;
		if rising_edge(clk) then
			if PS2_byte_en = '1' then
				if PS2_byte = "11100000" then
					E0 <= '1';
				elsif PS2_byte = "11110000" then
					F0 <= '1';
					press_b <= '1';
				elsif press_b = '1' then
					if PS2_byte = "01110101" and v_sig < 9 then
						v_var := v_var + 1;
					elsif PS2_byte = "01110010" and v_sig > 0 then
						v_var := v_var - 1;
					elsif PS2_byte = "01110100" and b_sig < 8 then
						b_var := b_var + 1;
					elsif PS2_byte = "01101011" and b_sig > 0 then
						b_var := b_var - 1;
					end if;
					scancode <= F0 & E0 & std_logic_vector(b_var) & std_logic_vector(v_var);
					--scancode <= F0 & E0 & PS2_byte;
					F0 <= '0';
					E0 <= '0';
					press_b <= '0';
					v_sig <= v_var;
					b_sig <= b_var;
				end if;
			end if;
		end if;
		
	end process;

	--Output the last byte of the scan code
	--LEDR <= scancode;
	v_cont <= v_sig;
	b_cont <= b_sig;
	
--	HEX0 <=
--		"1111001" when scancode(3 downto 0) = "0001" else -- 1
--		"0100100" when scancode(3 downto 0) = "0010" else -- 2
--		"0110000" when scancode(3 downto 0) = "0011" else -- 3
--		"0011001" when scancode(3 downto 0) = "0100" else -- 4
--		"0010010" when scancode(3 downto 0) = "0101" else -- 5
--		"0000010" when scancode(3 downto 0) = "0110" else -- 6
--		"1111000" when scancode(3 downto 0) = "0111" else -- 7
--		"0000000" when scancode(3 downto 0) = "1000" else -- 8
--		"0010000" when scancode(3 downto 0) = "1001" else -- 9
--		"1000000" when scancode(3 downto 0) = "0000" else -- 0
--		"0000110"; -- else
--		
--	HEX6 <=
--		"1111001" when scancode(7 downto 4) = "0001" else -- 1
--		"0100100" when scancode(7 downto 4) = "0010" else -- 2
--		"0110000" when scancode(7 downto 4) = "0011" else -- 3
--		"0011001" when scancode(7 downto 4) = "0100" else -- 4
--		"0010010" when scancode(7 downto 4) = "0101" else -- 5
--		"0000010" when scancode(7 downto 4) = "0110" else -- 6
--		"1111000" when scancode(7 downto 4) = "0111" else -- 7
--		"0000000" when scancode(7 downto 4) = "1000" else -- 8
--		"1000000" when scancode(7 downto 4) = "0000" else -- 0
--		"0000110"; -- else

end architecture;


