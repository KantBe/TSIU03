-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 64-Bit"
-- VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Full Version"
-- CREATED		"Wed Oct 04 11:06:50 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY VGA_PRJT IS 
	PORT
	(
		fpga_clk :  IN  STD_LOGIC;
		KEY0 :  IN  STD_LOGIC;
		a :  IN  STD_LOGIC;
		b :  IN  STD_LOGIC;
		c :  IN  STD_LOGIC;
		d :  IN  STD_LOGIC;
		b_cont :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		sram_data :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		v_cont :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		hsync :  OUT  STD_LOGIC;
		vsync :  OUT  STD_LOGIC;
		vga_clk :  OUT  STD_LOGIC;
		vga_blank :  OUT  STD_LOGIC;
		vga_sync :  OUT  STD_LOGIC;
		sram_ce :  OUT  STD_LOGIC;
		sram_oe :  OUT  STD_LOGIC;
		sram_lb :  OUT  STD_LOGIC;
		sram_ub :  OUT  STD_LOGIC;
		sram_we :  OUT  STD_LOGIC;
		HEX6 :  OUT  STD_LOGIC_VECTOR(0 TO 6);
		HEX7 :  OUT  STD_LOGIC_VECTOR(0 TO 6);
		sram_addr :  OUT  STD_LOGIC_VECTOR(19 DOWNTO 0);
		vga_b :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		vga_g :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		vga_r :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END VGA_PRJT;

ARCHITECTURE bdf_type OF VGA_PRJT IS 

COMPONENT ce_gen
	PORT(clk : IN STD_LOGIC;
		 rstn : IN STD_LOGIC;
		 ce : OUT STD_LOGIC;
		 lclk : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT group_no
GENERIC (number : INTEGER
			);
	PORT(		 HEX6 : OUT STD_LOGIC_VECTOR(0 TO 6);
		 HEX7 : OUT STD_LOGIC_VECTOR(0 TO 6)
	);
END COMPONENT;

COMPONENT hs_gen
	PORT(clk : IN STD_LOGIC;
		 rstn : IN STD_LOGIC;
		 hcnt : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 hsync : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT linecounter
	PORT(clk : IN STD_LOGIC;
		 rstn : IN STD_LOGIC;
		 ce : IN STD_LOGIC;
		 hcnt : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 vcnt : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END COMPONENT;

COMPONENT pixelcounter
	PORT(clk : IN STD_LOGIC;
		 rstn : IN STD_LOGIC;
		 ce : IN STD_LOGIC;
		 hcnt : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END COMPONENT;

COMPONENT pixel_reg
	PORT(clk : IN STD_LOGIC;
		 rstn : IN STD_LOGIC;
		 lclk : IN STD_LOGIC;
		 up_lo_byte : IN STD_LOGIC;
		 a : IN STD_LOGIC;
		 b : IN STD_LOGIC;
		 c : IN STD_LOGIC;
		 d : IN STD_LOGIC;
		 b_cont : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 hcnt : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 higher_byte : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 lower_byte : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 v_cont : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 vcnt : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 pixcode : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT rgb_gen
	PORT(clk : IN STD_LOGIC;
		 rstn : IN STD_LOGIC;
		 ce : IN STD_LOGIC;
		 pixcode : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 vga_sync : OUT STD_LOGIC;
		 vga_b : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 vga_g : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 vga_r : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT vs_gen
	PORT(clk : IN STD_LOGIC;
		 rstn : IN STD_LOGIC;
		 vcnt : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 vsync : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT blank_gen
	PORT(hcnt : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 vcnt : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 blank : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT ram_control
	PORT(hcnt : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 vcnt : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 sram_ce : OUT STD_LOGIC;
		 sram_oe : OUT STD_LOGIC;
		 sram_we : OUT STD_LOGIC;
		 sram_lb : OUT STD_LOGIC;
		 sram_ub : OUT STD_LOGIC;
		 up_lo_byte : OUT STD_LOGIC;
		 addr : OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	blank1 :  STD_LOGIC;
SIGNAL	blank2 :  STD_LOGIC;
SIGNAL	blank3 :  STD_LOGIC;
SIGNAL	ce :  STD_LOGIC;
SIGNAL	clk :  STD_LOGIC;
SIGNAL	hcnt :  STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL	hsync_ALTERA_SYNTHESIZED :  STD_LOGIC_VECTOR(4 DOWNTO 2);
SIGNAL	lclk :  STD_LOGIC;
SIGNAL	rstn :  STD_LOGIC;
SIGNAL	up_lo_byte :  STD_LOGIC;
SIGNAL	vcnt :  STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL	vsync_ALTERA_SYNTHESIZED :  STD_LOGIC_VECTOR(4 DOWNTO 2);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(7 DOWNTO 0);


BEGIN 



PROCESS(clk,rstn)
BEGIN
IF (rstn = '0') THEN
	blank2 <= '0';
ELSIF (RISING_EDGE(clk)) THEN
	blank2 <= blank1;
END IF;
END PROCESS;


PROCESS(clk,rstn)
BEGIN
IF (rstn = '0') THEN
	blank3 <= '0';
ELSIF (RISING_EDGE(clk)) THEN
	blank3 <= blank2;
END IF;
END PROCESS;


b2v_i_ce_gen : ce_gen
PORT MAP(clk => clk,
		 rstn => rstn,
		 ce => ce,
		 lclk => lclk);


b2v_i_GrNo : group_no
GENERIC MAP(number => 6
			)
PORT MAP(		 HEX6 => HEX6,
		 HEX7 => HEX7);


PROCESS(clk,rstn)
BEGIN
IF (rstn = '0') THEN
	hsync_ALTERA_SYNTHESIZED(3) <= '0';
ELSIF (RISING_EDGE(clk)) THEN
	hsync_ALTERA_SYNTHESIZED(3) <= hsync_ALTERA_SYNTHESIZED(2);
END IF;
END PROCESS;


PROCESS(clk,rstn)
BEGIN
IF (rstn = '0') THEN
	hsync_ALTERA_SYNTHESIZED(4) <= '0';
ELSIF (RISING_EDGE(clk)) THEN
	hsync_ALTERA_SYNTHESIZED(4) <= hsync_ALTERA_SYNTHESIZED(3);
END IF;
END PROCESS;


b2v_i_hs_gen : hs_gen
PORT MAP(clk => clk,
		 rstn => rstn,
		 hcnt => hcnt,
		 hsync => hsync_ALTERA_SYNTHESIZED(2));


b2v_i_linecounter : linecounter
PORT MAP(clk => clk,
		 rstn => rstn,
		 ce => ce,
		 hcnt => hcnt,
		 vcnt => vcnt);


b2v_i_pixcounter : pixelcounter
PORT MAP(clk => clk,
		 rstn => rstn,
		 ce => ce,
		 hcnt => hcnt);


b2v_i_pixreg1 : pixel_reg
PORT MAP(clk => clk,
		 rstn => rstn,
		 lclk => lclk,
		 up_lo_byte => up_lo_byte,
		 a => a,
		 b => b,
		 c => c,
		 d => d,
		 b_cont => b_cont,
		 hcnt => hcnt,
		 higher_byte => sram_data(15 DOWNTO 8),
		 lower_byte => sram_data(7 DOWNTO 0),
		 v_cont => v_cont,
		 vcnt => vcnt,
		 pixcode => SYNTHESIZED_WIRE_0);


b2v_i_RGB_gen : rgb_gen
PORT MAP(clk => clk,
		 rstn => rstn,
		 ce => ce,
		 pixcode => SYNTHESIZED_WIRE_0,
		 vga_sync => vga_sync,
		 vga_b => vga_b,
		 vga_g => vga_g,
		 vga_r => vga_r);


PROCESS(clk,rstn)
BEGIN
IF (rstn = '0') THEN
	vsync_ALTERA_SYNTHESIZED(3) <= '0';
ELSIF (RISING_EDGE(clk)) THEN
	vsync_ALTERA_SYNTHESIZED(3) <= vsync_ALTERA_SYNTHESIZED(2);
END IF;
END PROCESS;


PROCESS(clk,rstn)
BEGIN
IF (rstn = '0') THEN
	vsync_ALTERA_SYNTHESIZED(4) <= '0';
ELSIF (RISING_EDGE(clk)) THEN
	vsync_ALTERA_SYNTHESIZED(4) <= vsync_ALTERA_SYNTHESIZED(3);
END IF;
END PROCESS;


b2v_i_vs_gen : vs_gen
PORT MAP(clk => clk,
		 rstn => rstn,
		 vcnt => vcnt,
		 vsync => vsync_ALTERA_SYNTHESIZED(2));


b2v_iBlank_gen : blank_gen
PORT MAP(hcnt => hcnt,
		 vcnt => vcnt,
		 blank => blank1);


b2v_iRAMcontrol : ram_control
PORT MAP(hcnt => hcnt,
		 vcnt => vcnt,
		 sram_ce => sram_ce,
		 sram_oe => sram_oe,
		 sram_we => sram_we,
		 sram_lb => sram_lb,
		 sram_ub => sram_ub,
		 up_lo_byte => up_lo_byte,
		 addr => sram_addr);

rstn <= KEY0;
clk <= fpga_clk;
hsync <= hsync_ALTERA_SYNTHESIZED(4);
vsync <= vsync_ALTERA_SYNTHESIZED(4);
vga_clk <= ce;
vga_blank <= blank3;

END bdf_type;