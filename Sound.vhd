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
-- CREATED		"Wed Oct 04 11:10:28 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 
use numeric_std.all;

LIBRARY work;

ENTITY Sound IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		rstn :  IN  STD_LOGIC;
		adcdat :  IN  STD_LOGIC;
		b_cont :  IN  unsigned(3 DOWNTO 0);
		v_cont :  IN  unsigned(3 DOWNTO 0);
		mclk :  OUT  STD_LOGIC;
		bclk :  OUT  STD_LOGIC;
		adclrc :  OUT  STD_LOGIC;
		daclrc :  OUT  STD_LOGIC;
		dacdat :  OUT  STD_LOGIC
	);
END Sound;

ARCHITECTURE bdf_type OF Sound IS 

COMPONENT apply_volume_balance
	PORT(clk : IN STD_LOGIC;
		 rstn : IN STD_LOGIC;
		 lrsel : IN STD_LOGIC;
		 ADC_en : IN STD_LOGIC;
		 b_cont : IN unsigned(3 DOWNTO 0);
		 l_channel : IN signed(15 DOWNTO 0);
		 r_channel : IN signed(15 DOWNTO 0);
		 v_cont : IN unsigned(3 DOWNTO 0);
		 DAC_en : OUT STD_LOGIC;
		 l_channel_modi : OUT signed(15 DOWNTO 0);
		 r_channel_modi : OUT signed(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT snddriver
	PORT(clk : IN STD_LOGIC;
		 rstn : IN STD_LOGIC;
		 adcdat : IN STD_LOGIC;
		 DAC_en : IN STD_LOGIC;
		 LDAC : IN signed(15 DOWNTO 0);
		 RDAC : IN signed(15 DOWNTO 0);
		 mclk : OUT STD_LOGIC;
		 bclk : OUT STD_LOGIC;
		 adclrc : OUT STD_LOGIC;
		 daclrc : OUT STD_LOGIC;
		 lrsel : OUT STD_LOGIC;
		 dacdat : OUT STD_LOGIC;
		 ADC_en : OUT STD_LOGIC;
		 LADC : OUT signed(15 DOWNTO 0);
		 RADC : OUT signed(15 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	ADC_en :  STD_LOGIC;
SIGNAL	DAC_en :  STD_LOGIC;
SIGNAL	LADC :  signed(15 DOWNTO 0);
SIGNAL	LDAC :  signed(15 DOWNTO 0);
SIGNAL	lrsel :  STD_LOGIC;
SIGNAL	RADC :  signed(15 DOWNTO 0);
SIGNAL	RDAC :  signed(15 DOWNTO 0);


BEGIN 



b2v_inst2 : apply_volume_balance
PORT MAP(clk => clk,
		 rstn => rstn,
		 lrsel => lrsel,
		 ADC_en => ADC_en,
		 b_cont => b_cont,
		 l_channel => LADC,
		 r_channel => RADC,
		 v_cont => v_cont,
		 DAC_en => DAC_en,
		 l_channel_modi => LDAC,
		 r_channel_modi => RDAC);


b2v_instSndDrv : snddriver
PORT MAP(clk => clk,
		 rstn => rstn,
		 adcdat => adcdat,
		 DAC_en => DAC_en,
		 LDAC => LDAC,
		 RDAC => RDAC,
		 mclk => mclk,
		 bclk => bclk,
		 adclrc => adclrc,
		 daclrc => daclrc,
		 lrsel => lrsel,
		 dacdat => dacdat,
		 ADC_en => ADC_en,
		 LADC => LADC,
		 RADC => RADC);


END bdf_type;