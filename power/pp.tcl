#####################################################
#Enable power analysis
#####################################################
set power_enable_analysis "true"
#####################################################
#Perform vector analysis
#####################################################
#write_activity_waveforms
#####################################################
#Read design data & technology
#####################################################
source "./envset.tcl"

set_app_var link_path $LINK_PATH

read_verilog "$NETLIST_FILE"
list_design
current_design $TOP_DESIGN
link
read_sdc "$SDC_FILE"

set power_model_preference "ccs"
#####################################################
#Specify variables
#####################################################
#set_operating_conditions 
set power_limit_extrapolation_range "false"
#####################################################
#Perform timing analysis
#####################################################
update_timing
#####################################################
#Check for potential errors that might affect accuracy
#####################################################
check_power
#####################################################
#Select power analysis mode
#####################################################
#set_app_var power_analysis_mode "averaged"
set_app_var power_analysis_mode "time_based"
set_host_options -max_cores 4
#####################################################
#Specify switching activity data
#####################################################
# RYAN: Debug Prints:
puts "STRIP_PATH: $STRIP_PATH"
puts "ACTIVITY_FILE: $ACTIVITY_FILE"
puts "START_TIME: $START_TIME"
puts "END_TIME: $END_TIME"
#set_switching_activity
# read_vcd -strip_path $STRIP_PATH $ACTIVITY_FILE -time { $START_TIME $END_TIME}
read_vcd -strip_path $STRIP_PATH $ACTIVITY_FILE -time [list $START_TIME $END_TIME]
#saif(switching activity interface) : only in averaged power analysis mode
#vcd (verilog change dump)          : both
#fsdb(fast switching data dump)     : both
report_switching_activity -list_not_annotated
#####################################################
#Specify options for power analysis
#####################################################
set_power_analysis_options
#####################################################
#Perform power analysis
#####################################################
update_power
#####################################################
#Generate report
#####################################################
report_power -nosplit -verbose > "${TOP_DESIGN}_power.rpt"
report_power -nosplit -verbose -hier > "${TOP_DESIGN}_power_hier.rpt"
report_hierarchy > "${TOP_DESIGN}_hier.rpt"
report_units > "${TOP_DESIGN}_units.rpt"

# Report switching activity
report_switching_activity > "${TOP_DESIGN}_switching_activity.rpt"

quit
