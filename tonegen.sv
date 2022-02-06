/********
tonegen.sv

Written by Jimmy Bates (A01035957)

ELEX 7660-Digital System Design
Lab 4

Date created: February 5th 2022

Implements a tone generator

code for modelsim:
vsim work.tonegen_tb; add wave sim:*; run -all

*********/

module tonegen
    #( parameter logic [31:0] fclk)
    (   input logic [31:0] writedata, // Avalon MM bus, data
        input logic write, // write enable
        output logic spkr, // output for audio
        input logic reset, clk ) ; // active high reset and clock

