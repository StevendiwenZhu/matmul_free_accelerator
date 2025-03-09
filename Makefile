#########################
# ---- Introduction ----
#########################

# here's a table contents with make targets for reference:

# ---- Module Testbenches ----
# make <module>_simv     <- compile the verilog executable for a module's testbench
# make <module>.vg       <- synthesize the module (not the testbench) to a synth/<module>.vg file
# make <module>_syn_simv <- compile the verilog executable for a module's synthesis testbench
# make <module>.sim      <- run the module testbench and save the output to output/<module>.sim.out
# make <module>.syn      <- run the synthesis testbench and save the output to output/<module>.syn.out
# make <module>.verdi     <- run a module testbench in verdi via <module>_simv
# make <module>.syn.verdi <- run a module testbench in verdi via <module>_syn_simv
# NOTE: these expect a module verilog/<module>.sv with a corresponding testbench/<module>_tb.sv

# ---- Executable Compilation ----
# make simv     <- compile the verilog executable simv from the testbench and SIMFILES
# make syn_simv <- compile the synthesis executable syn_simv from the testbench and SYNFILES

# ---- Cleanup ----
# make clean <- remove most created files except specific synthesis files and .mem files
# make nuke  <- remove all files created from make rules

# each of these will compile/run any of their dependencies as needed, and needs no other
# commands to be called first, this is one of the major improvements from the legacy system
# which would require recompiling multiple files before each run of a different program on simv

# credits:
# TAKEN FROM EECS 470 MAKEFILE

########################
# ---- Directories ----
########################

# this is a built-in Make variable that lets Make search folders to find dependencies and targets
# it can greatly simplify make rules and increase readability
VPATH = synth:testbench:test_progs:verilog:output

# stops the "Too Few Instance Port Connection" warnings that amount to ~2.4MiB of text when compiling simv
VCS_NO_WARNINGS = +warn=noTFIPC +warn=noDEBUG_DEP +warn=noENUMASSIGN
VCS = vcs -V -sverilog +vc -Mupdate -line -full64 +vcs+vcdpluson -kdb -lca -debug_access+all $(VCS_NO_WARNINGS)
# also gets appended with a +define+CLOCK_PERIOD in the Common Variables section below

# From eecs598-002 makefile (Original):
# VCS = SW_VCS=2020.12-SP2-1 vcs -sverilog +vc -Mupdate -line -full64 +define+

# LIB is the reference file for the standard structural cells
# this is what the synthesized code is linked against

LIB = /afs/umich.edu/class/eecs598-002/SAED32/SAED32_EDK/lib/stdcell_rvt/verilog/saed32nm.v

# Find all .v files recursively in the memory directory
# MEMORY_V_FILES := $(shell find memory -name "*.v" 2>/dev/null)

# ifneq ($(MEMORY_V_FILES),)
# LIB += $(MEMORY_V_FILES)
# else
# $(info No .v files found in the memory directory or its subdirectories. Skipping memory/*.v.)
# endif

#############################
# ---- Common Variables ----
#############################
# CLOCK PERIOD is defined now in synth.tcl

# referenced in sys_defs.svh
# VCS += +define+CLOCK_PERIOD=$(CLOCK_PERIOD)+

# nice to define the headers up here and export them statically
# HEADERS = sys_defs.svh test_utils.svh bresenham_circle.svh
HEADERS = $(wildcard *.svh)
# ^ note: could replace with $(wildcard *.svh)

# this is read by the .tcl scripts
# also the SOURCES and TOP_NAME variables, but those are set per-command using 'env'
# export CLOCK_PERIOD
export HEADERS
# ^ not currently used, but might be nice if you change the .tcl files

# dc_shell supports compiling with multiple cores to improve compile time
# this variable is used by the .tcl script in 'set_host_options -max_cores' to change that
export DC_SHELL_MULTICORE = 4

#####################
# ---- Printing ----
#####################

# this is a function with two arguments: PRINT_COLOR(color : int 0-7, msg : string)
PRINT_COLOR = if [ -t 0 ]; then tput setaf $(1) ; fi; echo $(2); if [ -t 0 ]; then tput sgr0; fi
# this decomposes to:
# first, check if in a terminal and in a compliant shell
# second, use tput setaf to set the ANSI Foreground color based on the number 0-7:
#   0:black, 1:red, 2:green, 3:yellow, 4:blue, 5:magenta, 6:cyan, 7:white
# third, echo the message
# finally, reset the terminal color (but still only if a terminal)
# make functions are called like this:
# $(call PRINT_COLOR,5,msg)
# add '@' at the start of the line so it doesn't print the command itself, only the output

GREP = grep --color=auto

###########################
# ---- Default Target ----
###########################

# The first make rule is the default target and is run when calling 'make' by itself
# it is often called "all" by convention, but you can change it to anything
# don't place any other make targets above this

all: pipeline.sim
# make won't check for the existence of .PHONY targets, and will run their commands every time
# since this is generally what we want for all, we declare it as phony like so:
.PHONY: all

###############################
# ---- Module Testbenches ----
###############################

# create module testbenches for your modules, and update the TESTED_MODULES variable below
# these targets expect you to follow the naming convention:
# for a module verilog/rob.sv
# declares a module named rob
# with a testbench as testbench/rob_tb.sv

# quick target reference:
# make <module>_simv      <- compile the testbench executable
# make <module>.sim       <- run the testbench (output is output/<module>.sim.out)
# make <module>.vg        <- synthesize the module (not the testbench)
# make <module>_syn_simv  <- compile the synthesis executable
# make <module>.syn       <- run the synthesis testbench (output is output/<module>.syn.out)
# make <module>.verdi     <- run in verdi via <module>_simv
# make <module>.syn.verdi <- run in verdi via <module>_syn_simv

# NOTE: if you make your testbenches print @@@Passed or @@@Failed
# you can use the 'testbench_passed' target below to quickly view success/failure

TESTED_MODULES = processing_element SystolicArray sram_weight_buffer sram_ifmap_buffer \
				vec_add vec_div vec_mult vec_sub fxp_div pwl_exp_lut exp_unit sigmoid_unit vec_sigmoid vec_mean fxp_sqrt qdiv rms rms_norm \
				vec_silu rms_norm_sf SystolicArray_w_buffer vector_unit SystolicArray_w_buffer_full_size sram_matrix_buffer_wide sram_weight_buffer_wide \
				top_level


# Export some variables for the synth.tcl script
export MK_COURSE_NAME = EECS598-002
# export MK_DESIGN_NAME = ${TOP_NAME}
export MK_USE_NUM_CORES = 6
export MK_MEM_SUFFIX = typ_1d05_25

# if a module includes other modules, add the dependencies explicitly here
# this works due to the targets using the $^ automatic variable
# example for an execute_stage module that uses mult:
#   execute_stage_simv: mult.sv
#   synth/execute_stage.vg: mult.sv
# must do for both .vg and _simv targets (_syn_simv gets it implicitly through the .vg file)

# Examples from 470 P4:
# ex_stage_simv: mult.sv mem_fus.sv
# synth/ex_stage.vg: mult.sv mem_fus.sv
# fetch_simv: icache_nway.sv
# synth/fetch.vg: icache_nway.sv

vec_div_simv: fxp_div.sv
synth/vec_div.vg: fxp_div.sv

exp_unit_simv: pwl_exp_lut.sv
synth/exp_unit.vg: pwl_exp_lut.sv

vec_sigmoid_simv: sigmoid_unit.sv
synth/vec_sigmoid.vg: sigmoid_unit.sv

rms_simv: vec_mult.sv vec_mean.sv fxp_sqrt.sv
synth/rms.vg: vec_mult.sv vec_mean.sv fxp_sqrt.sv
rms.dve: vec_mult.sv vec_mean.sv fxp_sqrt.sv

rms_norm_simv: vec_mult.sv vec_mean.sv fxp_sqrt.sv rms.sv fxp_div.sv vec_div.sv
synth/rms_norm.vg: vec_mult.sv vec_mean.sv fxp_sqrt.sv rms.sv fxp_div.sv vec_div.sv
rms_norm.dve: vec_mult.sv vec_mean.sv fxp_sqrt.sv rms.sv fxp_div.sv vec_div.sv

vec_silu_simv: sigmoid_unit.sv vec_sigmoid.sv vec_mult.sv
synth/vec_silu.vg: sigmoid_unit.sv vec_sigmoid.sv vec_mult.sv
vec_silu.dve: sigmoid_unit.sv vec_sigmoid.sv vec_mult.sv

rms_norm_sf_simv: vec_mult.sv vec_mean.sv fxp_sqrt.sv rms.sv fxp_div.sv vec_div.sv
synth/rms_norm_sf.vg: vec_mult.sv vec_mean.sv fxp_sqrt.sv rms.sv fxp_div.sv vec_div.sv
rms_norm_sf.dve: vec_mult.sv vec_mean.sv fxp_sqrt.sv rms.sv fxp_div.sv vec_div.sv

SystolicArray_w_buffer_simv: SystolicArray.sv
synth/SystolicArray_w_buffer.vg: SystolicArray.sv
SystolicArray_w_buffer.dve: SystolicArray.sv

SystolicArray_w_buffer_full_size_simv: SystolicArray.sv
synth/SystolicArray_w_buffer_full_size.vg: SystolicArray.sv
SystolicArray_w_buffer_full_size.dve: SystolicArray.sv

sram_ifmap_buffer_simv: memory/verilog/input_buffer_inst.v
sram_weight_buffer_simv: memory/verilog/weight_buffer_sram_inst.v
sram_ifmap_buffer.dve: memory/verilog/input_buffer_inst.v
sram_weight_buffer.dve: memory/verilog/weight_buffer_sram_inst.v
sram_matrix_buffer_wide_simv: memory/verilog/input_buffer_inst.v
sram_weight_buffer_wide_simv: memory/verilog/weight_buffer_sram_inst.v

vector_unit_simv: sigmoid_unit.sv vec_sigmoid.sv vec_mult.sv vec_silu.sv vec_sub.sv vec_add.sv
synth/vector_unit.vg: sigmoid_unit.sv vec_sigmoid.sv vec_mult.sv vec_silu.sv vec_sub.sv vec_add.sv
vector_unit.dve: sigmoid_unit.sv vec_sigmoid.sv vec_mult.sv vec_silu.sv vec_sub.sv vec_add.sv

# this make rule will generate <name>_simv targets from the TESTED_MODULES variable e.g. 'make rob_simv'
# it expects a <name>_tb.sv file in the testbench folder
$(TESTED_MODULES:=_simv): %_simv: $(HEADERS) %.sv testbench/%_tb.sv
	@$(call PRINT_COLOR, 5, compiling testbench for the $* module)
	@$(call PRINT_COLOR, 3, NOTE: if this is slow to startup: run '"module load vcs verdi"')
	$(VCS) $^ -o $@ -R -debug_access+all -kdb
	@$(call PRINT_COLOR, 6, finished compiling $@ testbench)
# NOTE: I don't need to add the verilog/ and testbench/ dirs in these recipes due to the VPATH variable

# this generates the <name>.sim targets that actually run the tesbench e.g. 'make rob_sim'
$(TESTED_MODULES:=.sim): %.sim: %_simv | output
	@$(call PRINT_COLOR, 5, running testbench for the $* module)
	./$< | tee output/$(@F).out
	@$(call PRINT_COLOR, 6, finished running $* testbench)
	@$(call PRINT_COLOR, 2, output is in output/$(@F).out)
.PHONY: %.sim

# synthesis is a bit more complicated, as we have to first generate .vg files for each module
# this is only set up to compile modules that only get instantiated at one parameter value
# if you need to instantiate multiple sizes of modules for one testbench, you can try editing this
# or ask one of the GSIs/IAs for help editing this (note you'll probably need more .tcl files)
MODULE_TCL_SCRIPT = synth.tcl

# use the module.tcl script to synthesize each module into .vg files e.g. 'make rob.vg'
$(TESTED_MODULES:%=synth/%.vg): synth/%.vg: %.sv | $(MODULE_TCL_SCRIPT) $(HEADERS)
	@$(call PRINT_COLOR, 5, synthesizing vg file for $* testbench)
	@$(call PRINT_COLOR, 3, this might take a while...)
	@$(call PRINT_COLOR, 3, NOTE: if this is slow to startup: run '"module load synopsys-synth"')
	# pipefail causes the command to exit on failure even though it's piping to tee
	set -o pipefail; cd synth && env TOP_NAME=$* SOURCES="$^" dc_shell-t -f $(MODULE_TCL_SCRIPT) | tee $*_synth.out
	@$(call PRINT_COLOR, 6, finished synthesizing $@)

# this make rule will generate <name>_syn_simv targets for compiling the .vg file into a testbench e.g. 'make rob_syn_simv'
# it expects a <name>_tb.sv file in the testbench folder
$(TESTED_MODULES:=_syn_simv): %_syn_simv: $(HEADERS) synth/%.vg testbench/%_tb.sv
	@$(call PRINT_COLOR, 5, compiling synth testbench for the $* module)
	$(VCS) +define+SYNTHESIS $^ $(LIB) -o $@
	@$(call PRINT_COLOR, 6, finished compiling $@ synth testbench)
# NOTE: LIB has to come after the other sources as it doesn't define a timescale, and must inherit it from a previous module

# this generates the <name>.syn targets that actually run the tesbench e.g. 'make rob_syn'
$(TESTED_MODULES:=.syn): %.syn: %_syn_simv | output
	@$(call PRINT_COLOR, 5, running synth testbench for the $* module)
	./$< | tee output/$(@F).out
	@$(call PRINT_COLOR, 6, finished running $* synth testbench)
	@$(call PRINT_COLOR, 2, output is in output/$(@F).out)
.PHONY: %.syn

# test all modules in one command
test_all_modules: $(TESTED_MODULES:=.sim)
test_all_modules_synth: $(TESTED_MODULES:=.syn)
.PHONY: test_all_modules test_all_modules_synth

# verdi rules:
# 'make <name>.verdi' or 'make <name>.syn.verdi'
$(TESTED_MODULES:=.verdi): %.verdi: %_simv novas.rc verdi_dir
	./$< -gui=verdi
$(TESTED_MODULES:=.syn.verdi): %.syn.verdi: %_syn_simv novas.rc verdi_dir
	./$< -gui=verdi
.PHONY: %.verdi %.syn.verdi


# dve rules:
$(TESTED_MODULES:=.dve): %.dve: $(HEADERS) %.sv testbench/%_tb.sv
	$(VCS) $^ -o dve -R -gui -debug_acccess+all -kdb
.PHONY: %.dve

$(TESTED_MODULES:=.syn.dve): %.syn.dve: %_syn_simv
	$(eval MODULE := $(patsubst %.syn.dve,%,$@))
	$(VCS) $(HEADERS) $(LIB) testbench/$(MODULE)_tb.sv synth/$(MODULE).vg -o dve -R -gui -debug_acccess+all -kdb +define+SYNTHESIS
.PHONY: %.syn.dve


# quick useful rules:
# view synthesis slack
slack:
	$(GREP) "slack" synth/*.rep
# check if testbenches passed or failed (must $display @@@Passed or @@@Failed in your testbenches)
testbench_passed:
	$(GREP) "@@@Passed|@@@Failed" output/*.sim.out output/*.syn.out
.PHONY: slack testbench_passed

# NOTE: we're able to write these filenames without directories due to the VPATH declaration above
# Make will automatically expand these to their actual paths when used in recipes
TESTBENCH = $(wildcard testbench/*.sv)

# you could simplify this line with $(wildcard verilog/*.sv) - but the manual way is more explicit
SIMFILES = $(wildcard verilog/*.sv)

simv: $(HEADERS) $(TESTBENCH) $(SIMFILES)
	@$(call PRINT_COLOR, 5, compiling $@)
	@$(call PRINT_COLOR, 3, NOTE: if this is slow to startup: run '"module load vcs verdi"')
	$(VCS) $^ -o simv
	@$(call PRINT_COLOR, 6, finished compiling $@)

# NOTE: ^ is an automatic variable, and is replaced by the list of all of the prerequisites
# ^, <, @, *, etc are also automatic variables that are used in this makefile
# see: https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html

SYNFILES = $(wildcard synth/*.vg)

syn_simv: $(HEADERS) $(TESTBENCH) $(SYNFILES)
	@$(call PRINT_COLOR, 5, compiling $@)
	$(VCS) $^ $(LIB) -o syn_simv
	@$(call PRINT_COLOR, 6, finished compiling $@)
# NOTE: LIB has to come after the other sources as it doesn't define a timescale, and must inherit it from a previous module




##############################
# ---- Memory Generation ----
##############################
memgen:
	cd memory; ./memgen.sh



##############################
# ---- Build Directories ----
##############################

# some targets in this makefile are built in the output/ directory for organization
# this rule creates the output directory if it doesn't exist yet
# the entire directory is deleted by 'make nuke', so be careful with that
# NOTE: add "| output" at the end of make rules that put things into output
# it creates 'ordered' dependencies that are built first, and in order
# because you can't put files into output/ if it doesn't exist
output:
ifeq ($(wildcard output/.),) # whether output/ exists
	mkdir output
endif

##################
# ---- Verdi ----
##################

# this creates a directory that verdi will use if it doesn't exist yet
verdi_dir:
	if [[ ! -d /tmp/$${USER}470 ]] ; then mkdir /tmp/$${USER}470 ; fi
.PHONY: verdi_dir

novas.rc: initialnovas.rc
	sed s/UNIQNAME/$$USER/ initialnovas.rc > novas.rc

# these targets use the legacy program.mem system and load the program in SOURCE below
verdi: simv novas.rc verdi_dir $(SOURCE)
	./simv -gui=verdi
verdi_syn: syn_simv novas.rc verdi_dir $(SOURCE)
	./syn_simv -gui=verdi
.PHONY: verdi verdi_syn


####################
# ---- Cleanup ----
####################

# cleans most build files, but notably does not remove .mem or synthesis files (does remove syn_simv)
# clean does most common cleanup, nuke cleans everything
# other clean_* commands clean only certain files

# removes executables and per-run output files
clean: clean_exe clean_run_files
	@$(call PRINT_COLOR, 6, NOTE: clean is split into multiple commands that you can call separately: clean_exe and clean_run_files)

# removes all extra synthesis files and the entire output directory
# use cautiously, this can cause hours of recompiling
nuke: clean clean_output_dir clean_synth clean_power clean_results clean_reports
	@$(call PRINT_COLOR, 6, NOTE: nuke is split into multiple commands that you can call separately: clean_output_dir and clean_synth)
	@$(call PRINT_COLOR, 6, you can also call clean_programs to just delete the .mem and .dump files)

clean_exe:
	@$(call PRINT_COLOR, 3, removing compiled executable files)
	rm -rf *simv *.daidir csrc *.key   # created by simv/syn_simv/vis_simv
	rm -rf vcdplus.vpd vc_hdrs.h       # created by simv/syn_simv/vis_simv
	rm -rf verdi* novas* *fsdb*        # verdi files
	rm -rf dve* inter.vpd DVEfiles     # old DVE debugger

clean_run_files:
	@$(call PRINT_COLOR, 3, removing per-run outputs)
	rm -rf output/*.out output/*.wb output/*.ppln
	rm -rf *.elf *.dump *.mem debug_bin # legacy program.mem compilation files
	rm -rf *.out                        # legacy execution outputs

clean_synth:
	@$(call PRINT_COLOR, 1, removing synthesis files)
	rm -rf *.vcd *.log
	cd synth && rm -rf *.vg *_svsim.sv *.res *.rep *.ddc *.chk *.syn *.out *.db *.svf *.mr *.pvl command.log *.sdc *_dclib
	cd synth/reports && rm -rf *.rpt
	cd synth/results && rm -rf *.ddc *.sdc *.sdf *.spef *.svsim *.v
	cd synth && rm -rf alib-52

clean_reports:
	@$(call PRINT_COLOR, 1, removing reports files)
	rm -rf *.vcd
	cd reports && rm -rf *.vg *_svsim.sv *.res *.rep *.ddc *.chk *.syn *.out *.db *.svf *.mr *.pvl command.log *.sdc *.rpt

clean_results:
	@$(call PRINT_COLOR, 1, removing results files)
	rm -rf *.vcd
	cd results && rm -rf *.vg *_svsim.sv *.res *.rep *.ddc *.chk *.syn *.out *.db *.svf *.mr *.pvl command.log *.sdc

clean_power:
	@$(call PRINT_COLOR, 1, removing power analysis files)
	cd power && rm -rf *.rpt *.txt *.log *.fsdb

clean_output_dir:
	@$(call PRINT_COLOR, 1, removing entire output directory)
	rm -rf output/

.PHONY: clean nuke clean_%

# :)
