**************************************************************************************
16-BIT MULTICYCLE RISC PROCESSOR
**************************************************************************************

To initialze the values of all 16 registrs (R0 to R15) to 0000H each, the rst signal 
needs to be made high momentarily (given a posedge). The values of these before and
after the execution can be checked using the data file "reg_file.dat".

______________________________________________________________________________________

To initalize the 64k locations of the data memory, write the values in a byte 
organized (8-bits in one line) and in little endian format (lower 8-bits of data in 
even address) in the data file "data_mem.dat". Some values have been poplulated in the 
file.

______________________________________________________________________________________
 
Instructions can be provided by populating the data file "ins_mem.dat" in a byte 
organized way(8-bits in one line), in little endian format (lower 8-bits of data in 
even address) and consecutively (without skipping memory locations). Sample values 
are provided in the file already.

______________________________________________________________________________________

In case the user wants to start the execution from a particular address, pass that 
value through PC_init (in the testbench) and give a posedge to rst.

______________________________________________________________________________________

In case of an invalid instruction, the error messages are displayed in the 
log file/terminal and the execution is terminated immediately.

______________________________________________________________________________________