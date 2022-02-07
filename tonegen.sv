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

    logic [31:0] count, count_next; // Counter that controls spkr
    logic [31:0] T_cycles; // Keeps track of how many cycles after which the speaker should toggle
    logic spkr_next; // next value of speaker
    logic write_detect; // detects if write was pressed, for a quasi-edge detect
    logic speaker_active, speaker_active_next; // detects if speaker should be running

    always_comb begin : logic_combo 
        //Count only if speaker is active, loop back to 0 if it reaches the max count
        if( (count == T_cycles - 1) || (T_cycles == 0) || (write_detect==0 && write == 1) ) count_next = 0;
        else count_next = count+1;
            
        //Toggle speaker when speaker is supposed to be active
        if (speaker_active) spkr_next = (count == (T_cycles - 1)) ? ~spkr : spkr; 
        else spkr_next = 0;

        //Make speaker active on quasi edge detector of write
        if (write_detect==0 && write == 1) speaker_active_next = 1;
        else speaker_active_next = (T_cycles == 0) ? 0 : speaker_active;
    end : logic_combo

    //Clock and reset flipflop
    always_ff @(posedge clk, posedge reset) begin : clk_ff
        if(reset) begin
            spkr <= 0; //Turn speaker off
            speaker_active <= 0;
            T_cycles <= 0; //Speaker frequency = 0
            count <= 0; // Reset counter
        end else begin
            if(write) T_cycles <= (writedata > 0) ? fclk / (writedata * 2) : 0; // If 0, then speaker off, else frequency needed for sound
            speaker_active <= speaker_active_next;
            count <= count_next; // Increments if T_cycles > 0
            spkr <= spkr_next; // Toggling speaker
            write_detect <= write; // Take in frequency
        end
    end : clk_ff
endmodule;

