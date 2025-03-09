# MatMul-Free Transformer Accelerator

## Formatting Notes
* Note that in the power analysis, the convention for finding the module path is testbench/module_name0.

## Setup

To setup the environment, run the command below to load the PDK:
```bash
source setup.sh
```
## Software
All code related to software are contained in the `software` directory. Use `pip install -r software/requirements.txt` to install all the nessesary dependencies. 

Importantly, `arch_vis.ipynb` contains code and visualization for the architecture of our software refernece model. `matmul_fre_attn_ref.ipynb` contains code to train the software reference from scratch, as well as running inference and estimating latency. 

Note that due to cuda optimizations written by the original authors of the paper, it is required to run the code on a machine with a Nvidia GPU.

## Simulation

```bash
make module_name.sim
```

## Synthesis

```bash
make module_name.syn
```

Remember to run `source setup.sh` so the PDKs are properly loaded (very important)!

Note that currently the clock periods in testbench and in synth constraints are set in different places. Please make sure that the clock period in constraints.tcl and in sys_defs.svh are the same.

## Power Analysis

Power analysis is performed on Synopsys PTPX. VCD signals are dumped in post-synthesis simulation from the testbench. The power analysis script assumes that the instance name is named module_name0 in the testbench, where the module_name should be replaced by the actual module name. The power analysis script takes switching activity annotated by the .vcd file following the naming convention module_name_tb.vcd. Please see existing testbenches that saves switching activity as vcd as an example. Otherwise the power analysis scripts will not work.

```bash
cd power
make module_name.power
```
Power reports and logs will be generated in the same folder.

NOTE: Make sure to adjust the START_TIME and END_TIME in the power analysis tcl file (envset.tcl) and set the appropriate time to start and end the power analysis.

Sometimes an error with the Library Compiler path may occur. Make sure to set the correct environment variable (something like this on CAEN):
```bash
export LC_HOME=/usr/caen/bin/lc_shell
```

## Memory Generation


`make memgen`

Memory generation scripts are located in `/memory`. Change the config files to change the parameters of the generated SRAMs.

## Generators

Python scripts in `/generators` are used to generate the verilog LUTs for operations such as exp and sigmoid. These are performed with piece-wise linear approximations (PWL). The scripts will generate SystemVerilog files in `/verilog`. Example:
```bash
cd generators
python pwl_exp.py
```

# README from EECS598 PDK

To use this PDK, run the following line in your shell:
module load eecs598-002/f23

template.zip contains an example project folder structure. You can use this structure with the provided scripts as a starting point.

Please read Makefile for how to structure your folders and how to run synthesis and memory compilation.
It is strongly recommended to read through scripts/synth.tcl and scripts/constraints.tcl line by line and understand them. 
You can always modify these files for better performance / special needs.

Memory compiler user manual directory: /afs/umich.edu/class/eecs598-002/SAED32/saed_mc_v3_0_1/saed_mc/doc/
Standard cells library documents directory: /afs/umich.edu/class/eecs598-002/SAED32/SAED32_EDK/lib/stdcell_rvt/doc

Contact the GSI (office hour or slack general channel) if your group needs help.

Update: I forgot the change the unit of max_transition and the following two lines in *constraints.tcl*. It has been corrected. Please line 1~3 in your constraint.tcl as well.

