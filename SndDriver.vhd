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
-- CREATED		"Wed Oct 04 11:08:58 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY SndDriver IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		rstn :  IN  STD_LOGIC;
		adcdat :  IN  STD_LOGIC;
		DAC_en :  IN  STD_LOGIC;
		LDAC :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		RDAC :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		dacdat :  OUT  STD_LOGIC;
		mclk :  OUT  STD_LOGIC;
		bclk :  OUT  STD_LOGIC;
		adclrc :  OUT  STD_LOGIC;
		daclrc :  OUT  STD_LOGIC;
		lrsel :  OUT  STD_LOGIC;
		ADC_en :  OUT  STD_LOGIC;
		LADC :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		RADC :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END SndDriver;

ARCHITECTURE bdf_type OF SndDriver IS 

COMPONENT my_mux
	PORT(dacdatR : IN STD_LOGIC;
		 dacdatL : IN STD_LOGIC;
		 daclrc : IN STD_LOGIC;
		 dacdat : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT ctrl
	PORT(clk : IN STD_LOGIC;
		 rstn : IN STD_LOGIC;
		 mclk : OUT STD_LOGIC;
		 bclk : OUT STD_LOGIC;
		 adclrc : OUT STD_LOGIC;
		 daclrc : OUT STD_LOGIC;
		 ADC_en : OUT STD_LOGIC;
		 lrsel : OUT STD_LOGIC;
		 men : OUT STD_LOGIC;
		 BitCnt : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 SCCnt : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT channel_mod
	PORT(clk : IN STD_LOGIC;
		 men : IN STD_LOGIC;
		 rstn : IN STD_LOGIC;
		 lrsel : IN STD_LOGIC;
		 DAC_en : IN STD_LOGIC;
		 adcdat : IN STD_LOGIC;
		 BitCnt : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 LDAC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 SCCnt : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 dacdat : OUT STD_LOGIC;
		 LADC : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	BitCnt :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	dacdatL :  STD_LOGIC;
SIGNAL	dacdatR :  STD_LOGIC;
SIGNAL	daclrc_ALTERA_SYNTHESIZED :  STD_LOGIC;
SIGNAL	lrsel_ALTERA_SYNTHESIZED :  STD_LOGIC;
SIGNAL	men :  STD_LOGIC;
SIGNAL	SCCnt :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;


BEGIN 



b2v_inst : my_mux
PORT MAP(dacdatR => dacdatR,
		 dacdatL => dacdatL,
		 daclrc => daclrc_ALTERA_SYNTHESIZED,
		 dacdat => dacdat);


SYNTHESIZED_WIRE_0 <= NOT(lrsel_ALTERA_SYNTHESIZED);



b2v_inst_ctrl : ctrl
PORT MAP(clk => clk,
		 rstn => rstn,
		 mclk => mclk,
		 bclk => bclk,
		 adclrc => adclrc,
		 daclrc => daclrc_ALTERA_SYNTHESIZED,
		 ADC_en => ADC_en,
		 lrsel => lrsel_ALTERA_SYNTHESIZED,
		 men => men,
		 BitCnt => BitCnt,
		 SCCnt => SCCnt);


b2v_inst_left : channel_mod
PORT MAP(clk => clk,
		 men => men,
		 rstn => rstn,
		 lrsel => lrsel_ALTERA_SYNTHESIZED,
		 DAC_en => DAC_en,
		 adcdat => adcdat,
		 BitCnt => BitCnt,
		 LDAC => LDAC,
		 SCCnt => SCCnt,
		 dacdat => dacdatL,
		 LADC => LADC);


b2v_inst_right : channel_mod
PORT MAP(clk => clk,
		 men => men,
		 rstn => rstn,
		 lrsel => SYNTHESIZED_WIRE_0,
		 DAC_en => DAC_en,
		 adcdat => adcdat,
		 BitCnt => BitCnt,
		 LDAC => RDAC,
		 SCCnt => SCCnt,
		 dacdat => dacdatR,
		 LADC => RADC);

daclrc <= daclrc_ALTERA_SYNTHESIZED;
lrsel <= lrsel_ALTERA_SYNTHESIZED;

END bdf_type;