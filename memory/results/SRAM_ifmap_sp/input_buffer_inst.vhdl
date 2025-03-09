--*********************************************************************
--  saed_mc : input_buffer_inst Vhdl description                    *
--  ---------------------------------------------------------------   *
--  Filename      : /home/rlhou/eecs598-002/project/matmul-free-accelerator/memory/mc_work/input_buffer_inst.vhdl                         *
--  SRAM name     : input_buffer_inst                                 *
--  Word width    : 8     bits                                        *
--  Word number   : 128                                               *
--  Adress width  : 7     bits                                        *
--  ---------------------------------------------------------------   *
--  Creation date : Mon November 18 2024                              *
--*********************************************************************

use std.textio.all;
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
entity input_buffer_inst is
	port (
		A   : in  std_logic_vector( 6  downto 0 );
		O   : out std_logic_vector( 7  downto 0 );
		I   : in  std_logic_vector( 7  downto 0 );
		WEB  : in  std_logic;
		CSB  : in  std_logic;
		OEB  : in  std_logic;
		CE  : in  std_logic
	);

end input_buffer_inst ;

architecture input_buffer_inst_behaviour of input_buffer_inst is
begin
	mem: process
		constant numAddr: natural := 7;
		constant numWords: natural := 128;
		constant wordLength: natural := 8;

		constant nw_m: natural := numWords-1;
		constant wl_m: natural := wordLength-1;
		constant low_address: natural := 0;
		constant high_address: natural := nw_m;
		subtype word is std_logic_vector( wl_m downto 0 );
		type memory_array is
			array (natural range low_address to high_address) of word;
		variable mem: memory_array;
		variable address   : natural;
		variable data_out1 : word;
		

	begin
		O <= "ZZZZZZZZ";
	

		loop

			if  ((CSB = '0') and (CE= '1') and (CE'event )  and (CE'last_value = '0'))	then
	 			address := conv_integer( A );
 				if WEB = '0' then
             			mem( address ) := I(wl_m downto 0);
            				elsif WEB = '1' then
						data_out1 := mem( address );
						if OEB = '0' then
							O <= data_out1;
						else 
							O <= "ZZZZZZZZ";
						end if;
					else
						O <= "ZZZZZZZZ";
				end if;
			end if;

			if ( OEB = '0') then
				O <= data_out1;
				else
					O <= "ZZZZZZZZ";
			    end if;
				wait on CE, OEB;
		end loop;
	end process;

end input_buffer_inst_behaviour;