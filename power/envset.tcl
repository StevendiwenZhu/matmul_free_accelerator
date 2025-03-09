#####################################################
#Read design data & technology
#####################################################

set CURRENT_PATH [pwd]

# TOP_DESIGN is set from the Makefile instead
# set TOP_DESIGN mul_arr

set search_path [list \
					"$CURRENT_PATH" \
				]

## Add libraries below
## technology .db file, and memory .db files
set PDK_PATH $::env(SAED32_PATH)
puts "PDK PATH at $PDK_PATH"
set target_library "${PDK_PATH}/lib/stdcell_rvt/db_ccs/saed32rvt_tt1p05v25c.db"

set LINK_PATH [concat  "*" $target_library]

## Replace with your complete file paths
set SDC_FILE      	$CURRENT_PATH/../synth/$TOP_DESIGN.sdc
set NETLIST_FILE	$CURRENT_PATH/../synth/$TOP_DESIGN.vg

## Replace with your instance hierarchy
set STRIP_PATH    testbench/${TOP_DESIGN}0

## Replace with your activity file dumped from vcs simulation
set ACTIVITY_FILE 	$CURRENT_PATH/../${TOP_DESIGN}_tb.vcd

######## Timing Sections ########
set	START_TIME 80
set	END_TIME 4960
