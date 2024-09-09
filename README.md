Divider RTL Verilog Module
Overview
This repository contains a Verilog implementation of a divider module designed to perform both integer and fractional division. The module, dividor_rtl, is parameterized to handle inputs of varying bit-widths and provides outputs for both the integer and fractional parts of the result.

Features
Parameterizable Bit-Width: Supports different bit-widths for inputs and outputs through the SIZE parameter.
Finite State Machine (FSM): Implements an FSM to handle different stages of division, including managing invalid inputs, zero values, and calculating fractional results.
Comprehensive State Handling: Manages division across multiple states, including IDLE, READY, INVALID, ZERO, REAL, FRACTION, and RESULT.
Module Definition
Parameters
SIZE: Specifies the bit-width of the inputs (a, b) and output (m). For instance, setting SIZE=4 will handle 4-bit wide inputs and outputs.
Inputs
clk: Clock signal for synchronization.
rst: Reset signal to initialize the module.
start: Signal to start the division process.
a: Dividend input value.
b: Divisor input value.
Outputs
m: Integer part of the result.
f: Fractional part of the result, represented as a 10-bit value.
Functionality
Initialization:

On reset, the module initializes all registers and state variables to their default values.
State Transitions:

The module transitions between various states using an FSM:
IDLE: Waits for the start signal.
READY: Prepares for division, checks for edge cases.
INVALID: Handles cases where the divisor is zero.
ZERO: Handles cases where the dividend is zero.
REAL: Performs integer division.
FRACTION: Calculates the fractional part of the result if needed.
RESULT: Outputs the final result.
Division Process:

READY State: Initializes the necessary registers and handles edge cases (e.g., zero divisor or zero dividend).
REAL State: Subtracts the divisor from the dividend until the remainder is less than the divisor, counting the number of subtractions for the integer part.
FRACTION State: If the divisor is smaller than the dividend, calculates the fractional part by multiplying the remainder by 10 and repeating the division.
RESULT State: Assembles and outputs the integer and fractional results.
Example Usage
To use the divider module in a Verilog design:

Instantiate the Module:

verilog
Copy code
dividor_rtl #(8) my_divider (
    .clk(clk),
    .rst(rst),
    .start(start),
    .a(dividend),
    .b(divisor),
    .m(result_integer),
    .f(result_fraction)
);
dividend: 8-bit input value representing the dividend.
divisor: 8-bit input value representing the divisor.
result_integer: 8-bit output for the integer part of the result.
result_fraction: 10-bit output for the fractional part of the result.
Connect to Testbench:

In a testbench, apply stimulus to the clk, rst, start, a, and b inputs and observe the outputs m and f to verify functionality.

Files
dividor_rtl.v: Verilog source code for the divider module.
Simulation and Testing
Testbench: A sample testbench file can be created to verify the functionality of the dividor_rtl module by applying various input values and checking the results.
Simulation Tools: This module can be simulated using tools such as ModelSim, QuestaSim, or any other Verilog-compatible simulator.
