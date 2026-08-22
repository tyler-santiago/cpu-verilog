# cpu-verilog
A CPU written in Verilog

Testbenches only show failures to minimize terminal clutter. To show successes, uncomment the else statement at the bottom of the testbench. 

HOW TO RUN

In terminal:
cd cpu-verilog

To compile full adder:
iverilog -o sim.out rtl/adder_half.v rtl/adder_full.v tb/adder_full_tb.v

To compile 8-bit adder:
iverilog -o sim.out rtl/adder_half.v rtl/adder_full.v rtl/adder_8bit.v tb/adder_8bit_tb.v

After compiling, to run the respective testbench:
vvp sim.out