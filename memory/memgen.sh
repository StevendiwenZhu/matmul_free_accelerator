# example memory compiler command
# FILENAME=SRAM_weight_sp
FILENAME=SRAM_ifmap_sp
# /afs/umich.edu/class/eecs598-002/SAED32/saed_mc_v3_0_1/saed_mc/bin/saed_mc src/${FILENAME}.config
saed_mc src/${FILENAME}.config
mkdir -p results
mv mc_work results/${FILENAME}
mv saed_mc.*.log results/${FILENAME}

# verilog model
mkdir -p verilog
cp -vf results/${FILENAME}/*.v verilog

# db model
mkdir -p db
cp -vf results/${FILENAME}/*.db db

# W matrix 64 x 64 - 2 bits
# X matrix 128 x 64 - int 8
# psum buffer 