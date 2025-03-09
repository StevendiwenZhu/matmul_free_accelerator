


# Define top design (default target)
TOP_DESIGN ?= pipeline

# Default power target
power: $(TOP_DESIGN).power

%.power:
	@echo "Running power analysis for module: $*"
	@echo "!!!! REMEMBER TO SET CORRECT START AND END TIMES IN envset.tcl FILE !!!!"
	@pt_shell -f pp.tcl -x "set TOP_DESIGN $*" | tee pp_$*.log

# Phony targets
.PHONY: clean

clean:
	rm -f *.log.*
	rm -f *.fsdb.*
	rm -f *.tset.tcl
	rm -f *.swp
	rm -f *.log
	rm -f *.rpt
	rm -f *.fsdb

# Help target
help:
	@echo "Available targets:"
	@echo "  power              : Run power analysis for $(TOP_DESIGN)"
	@echo "  <module>.power     : Run power analysis for <module>"
	@echo "  clean              : Remove generated files"
	@echo "  help               : Show this help message"

# Make help the default target
.DEFAULT_GOAL := help

# ORIGINAL:

# pp:
# 	pt_shell -f pp.tcl  | tee pp.log
# clean:
# 	rm -f *.log.*
# 	rm -f *.fsdb.*
# 	rm -f *.tset.tcl
# 	rm -f *.swp
# 	rm -f *.log
# 	#rm -f *.rpt
# 	rm -f *.fsdb
