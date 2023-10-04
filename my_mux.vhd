library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity my_mux is 
	port(dacdatR, dacdatL, daclrc: in std_logic;
		dacdat:out std_logic);
end entity;

architecture rtl of my_mux is

begin

dacdat<=dacdatR when daclrc ='0' else dacdatL;

end architecture;