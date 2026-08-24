# cpu-verilog
A CPU written in Verilog

Testbenches only show failures to minimize terminal clutter. To show successes, uncomment the `else` statement at the bottom of the testbench.

## How to Run

In terminal:
```
cd cpu-verilog
```

### Testbench Compile Commands

**Full adder:**
```
iverilog -o sim.out rtl/adder_half.v rtl/adder_full.v tb/adder_full_tb.v
```

**8-bit adder:**
```
iverilog -o sim.out rtl/adder_half.v rtl/adder_full.v rtl/adder_8bit.v tb/adder_8bit_tb.v
```

**Shifter:**
```
iverilog -o sim.out rtl/shifter.v tb/shifter_tb.v
```

**Logic unit:**
```
iverilog -o sim.out rtl/logic_unit.v tb/logic_unit_tb.v
```

**5-bit mux:**
```
iverilog -o sim.out rtl/mux_5bit.v tb/mux_5bit_tb.v
```

### Run the Simulation

After compiling, run the respective testbench:
```
vvp sim.out
```