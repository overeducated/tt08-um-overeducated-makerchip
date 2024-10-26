// ////////////////////////////////////////////////////////////////////////
// @BEGIN Header
// ////////////////////////////////////////////////////////////////////////

`ifndef _tt09_kwr_lfsr__header_
`define _tt09_kwr_lfsr__header_

// ////////////////////////////////////////////////////////////////////////
// ////////////////////////////////////////////////////////////////////////

// ////////////////////////////////////
// Copyright (c) 2024 Kevin W. Rudd
// SPDX-License-Identifier: Apache-2.0
// ////////////////////////////////////

`default_nettype    none

// ////////////////////////////////////////////////////////////////////////
// ////////////////////////////////////////////////////////////////////////

`endif // _tt09_kwr_lfsr__header_

// ////////////////////////////////////////////////////////////////////////
// @END Header
// ////////////////////////////////////////////////////////////////////////


// ////////////////////////////////////////////////////////////////////////
// @BEGIN Modules
// ////////////////////////////////////////////////////////////////////////

`ifndef _tt09_kwr_lfsr__modules_
`define _tt09_kwr_lfsr__modules_

// ////////////////////////////////////////////////////////////////////////
// ////////////////////////////////////////////////////////////////////////

module generate_mask_fibonacci_2_taps
(
    input  wire [5:0]    lfsr_length,

    output reg  [63:0]   mask_value,
    output reg           mask_valid
);

    always @(*)
    begin
        case (lfsr_length)
               6'd00 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000000; mask_valid  = 0; end
               6'd01 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000000; mask_valid  = 0; end
               6'd02 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000011; mask_valid  = 1; end
               6'd03 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000110; mask_valid  = 1; end
               6'd04 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000001100; mask_valid  = 1; end
               6'd05 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000010100; mask_valid  = 1; end
               6'd06 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000110000; mask_valid  = 1; end
               6'd07 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000001100000; mask_valid  = 1; end
               6'd08 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000000; mask_valid  = 0; end
               6'd09 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000100010000; mask_valid  = 1; end
               6'd10 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000001001000000; mask_valid  = 1; end
               6'd11 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000010100000000; mask_valid  = 1; end
               6'd12 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000000; mask_valid  = 0; end
               6'd13 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000000; mask_valid  = 0; end
               6'd14 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000000; mask_valid  = 0; end
               6'd15 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000110000000000000; mask_valid  = 1; end
               6'd16 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000000; mask_valid  = 0; end
               6'd17 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000010010000000000000; mask_valid  = 1; end
               6'd18 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000100000010000000000; mask_valid  = 1; end
               6'd19 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000000; mask_valid  = 0; end
               6'd20 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000010010000000000000000; mask_valid  = 1; end
               6'd21 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000101000000000000000000; mask_valid  = 1; end
               6'd22 : begin mask_value  <= 64'b0000000000000000000000000000000000000000001100000000000000000000; mask_valid  = 1; end
               6'd23 : begin mask_value  <= 64'b0000000000000000000000000000000000000000010000100000000000000000; mask_valid  = 1; end
               6'd24 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000000; mask_valid  = 0; end
               6'd25 : begin mask_value  <= 64'b0000000000000000000000000000000000000001001000000000000000000000; mask_valid  = 1; end
               6'd26 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000000; mask_valid  = 0; end
               6'd27 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000000; mask_valid  = 0; end
               6'd28 : begin mask_value  <= 64'b0000000000000000000000000000000000001001000000000000000000000000; mask_valid  = 1; end
               6'd29 : begin mask_value  <= 64'b0000000000000000000000000000000000010100000000000000000000000000; mask_valid  = 1; end
               6'd30 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000000; mask_valid  = 0; end
               6'd31 : begin mask_value  <= 64'b0000000000000000000000000000000001001000000000000000000000000000; mask_valid  = 1; end
               6'd32 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000000; mask_valid  = 0; end
               6'd33 : begin mask_value  <= 64'b0000000000000000000000000000000100000000000010000000000000000000; mask_valid  = 1; end
             default : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000000; mask_valid  = 0; end
        endcase
    end // always

endmodule // generate_mask_fibonacci_

// ////////////////////////////////////////////////////////////////////////

module generate_mask_fibonacci_4_taps
(
    input  wire [5:0]    lfsr_length,

    output reg  [63:0]   mask_value,
    output reg           mask_valid
);

    always @(*)
    begin
        case (lfsr_length)
               6'd00 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000000; mask_valid  = 0; end
               6'd01 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000000; mask_valid  = 0; end
               6'd02 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000000; mask_valid  = 0; end
               6'd03 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000000; mask_valid  = 0; end
               6'd04 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000000; mask_valid  = 0; end
               6'd05 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000011110; mask_valid  = 1; end
               6'd06 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000110110; mask_valid  = 1; end
               6'd07 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000001111000; mask_valid  = 1; end
               6'd08 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000010111000; mask_valid  = 1; end
               6'd09 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000110110000; mask_valid  = 1; end
               6'd10 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000001101100000; mask_valid  = 1; end
               6'd11 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000011101000000; mask_valid  = 1; end
               6'd12 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000110010100000; mask_valid  = 1; end
               6'd13 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000001101100000000; mask_valid  = 1; end
               6'd14 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000011010100000000; mask_valid  = 1; end
               6'd15 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000111010000000000; mask_valid  = 1; end
               6'd16 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000001011010000000000; mask_valid  = 1; end
               6'd17 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000011110000000000000; mask_valid  = 1; end
               6'd18 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000111001000000000000; mask_valid  = 1; end
               6'd19 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000001110010000000000000; mask_valid  = 1; end
               6'd20 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000011001010000000000000; mask_valid  = 1; end
               6'd21 : begin mask_value  <= 64'b0000000000000000000000000000000000000000000111001000000000000000; mask_valid  = 1; end
               6'd22 : begin mask_value  <= 64'b0000000000000000000000000000000000000000001001110000000000000000; mask_valid  = 1; end
               6'd23 : begin mask_value  <= 64'b0000000000000000000000000000000000000000011010100000000000000000; mask_valid  = 1; end
               6'd24 : begin mask_value  <= 64'b0000000000000000000000000000000000000000110110000000000000000000; mask_valid  = 1; end
               6'd25 : begin mask_value  <= 64'b0000000000000000000000000000000000000001111000000000000000000000; mask_valid  = 1; end
               6'd26 : begin mask_value  <= 64'b0000000000000000000000000000000000000011100010000000000000000000; mask_valid  = 1; end
               6'd27 : begin mask_value  <= 64'b0000000000000000000000000000000000000111001000000000000000000000; mask_valid  = 1; end
               6'd28 : begin mask_value  <= 64'b0000000000000000000000000000000000001100101000000000000000000000; mask_valid  = 1; end
               6'd29 : begin mask_value  <= 64'b0000000000000000000000000000000000011101000000000000000000000000; mask_valid  = 1; end
               6'd30 : begin mask_value  <= 64'b0000000000000000000000000000000000110010100000000000000000000000; mask_valid  = 1; end
               6'd31 : begin mask_value  <= 64'b0000000000000000000000000000000001111000000000000000000000000000; mask_valid  = 1; end
               6'd32 : begin mask_value  <= 64'b0000000000000000000000000000000010100011000000000000000000000000; mask_valid  = 1; end
               6'd33 : begin mask_value  <= 64'b0000000000000000000000000000000110010100000000000000000000000000; mask_valid  = 1; end
             default : begin mask_value  <= 64'b0000000000000000000000000000000000000000000000000000000000000000; mask_valid  = 0; end
        endcase
    end // always

endmodule // generate_mask_fibonacci_

// ////////////////////////////////////////////////////////////////////////

module lfsr_fibonacci
(
    input  wire           clk,
    input  wire           rst_n,
    input  wire  [5:0]    lfsr_length,
    input  wire           lfsr_n_taps,

    output reg  [63:0]    lfsr_value,
    output reg            lfsr_valid
);

    wire        [63:0]    mask_value_2_taps;
    wire                  mask_valid_2_taps;

    generate_mask_fibonacci_2_taps    gmf2t
    (
        .lfsr_length(lfsr_length),
        .mask_value(mask_value_2_taps),
        .mask_valid(mask_valid_2_taps)
    );

    wire        [63:0]    mask_value_4_taps;
    wire                  mask_valid_4_taps;

    generate_mask_fibonacci_4_taps    gmf4t
    (
        .lfsr_length(lfsr_length),
        .mask_value(mask_value_4_taps),
        .mask_valid(mask_valid_4_taps)
    );

    reg         [63:0]    mask_value;
    reg                   mask_valid;


    always @(*)
    begin
        if      (lfsr_n_taps)
          begin
            mask_value  <= mask_value_4_taps;
            mask_valid  <= mask_valid_4_taps;
          end
        else
          begin
            mask_value  <= mask_value_2_taps;
            mask_valid  <= mask_valid_2_taps;
          end
        // endif
    end // always

    always @(posedge clk or negedge rst_n)
    begin
        if      (~rst_n)
          begin
            // initialize current value/valid
            lfsr_value       <= 64'd1;
            lfsr_valid       <= 1;
          end
        else if (~mask_valid)
          begin
            // force current value/valid to invalid
            lfsr_value  <= 64'd0;
            lfsr_valid  <= 0;
          end
        else
          begin
            // shift the previous value and add in the computed (reduced) feedback value, set valid correctly (already verified mask is valid)
            lfsr_value       <= { lfsr_value[62:0], ^(lfsr_value & mask_value) };
            lfsr_valid       <= 1;
          end
        // endif

    end // always

endmodule // lfsr_fibonacci

// ////////////////////////////////////////////////////////////////////////
// ////////////////////////////////////////////////////////////////////////

`endif // _tt09_kwr_lfsr__modules_

// ////////////////////////////////////////////////////////////////////////
// @END Modules
// ////////////////////////////////////////////////////////////////////////


// ////////////////////////////////////////////////////////////////////////
// @BEGIN Logic
// ////////////////////////////////////////////////////////////////////////

`ifndef _tt09_kwr_lfsr__logic_
`define _tt09_kwr_lfsr__logic_

// ////////////////////////////////////////////////////////////////////////
// ////////////////////////////////////////////////////////////////////////

module tt_um__kwr_lfsr__top // top-level (and business) logic
(
    // parameters from tt09 top-module definition on nhttps://tinytapeout.com/hdl/important/, reformatted for consistency
    input  wire           clk,        // clock
    input  wire           rst_n,      // reset_n - low to reset
    input  wire           ena,        // will go high when the design is enabled
    input  wire  [7:0]    ui_in,      // Dedicated inputs
    input  wire  [7:0]    uio_in,     // IOs: Input path
    output reg   [7:0]    uo_out,     // Dedicated outputs
    output reg   [7:0]    uio_out,    // IOs: Output path
    output reg   [7:0]    uio_oe      // IOs: Enable path (active high: 0=input, 1=output)
);

    // All unused inputs must be used to prevent warnings
    reg                   _unused;

// ////////////////////////////////////////////////////////////////////////

    reg         [5:0]     lfsr_length;
    reg                   lfsr_n_taps;
    wire        [63:0]    lfsr_value;
    wire                  lfsr_valid;
    lfsr_fibonacci    lfsr
    (
        .clk(clk),
        .rst_n(rst_n),
        .lfsr_length(lfsr_length),
        .lfsr_n_taps(lfsr_n_taps),
        .lfsr_value(lfsr_value),
        .lfsr_valid(lfsr_valid)
    );

    reg                   hold;
    reg                   hold_on;

    reg                   step;
    reg                   step_on;
    always @(posedge clk, negedge rst_n)
    begin


    end // always
// ////////////////////////////////////////////////////////////////////////
    always @(*)
    begin
        // All output pins must be assigned. If not used, assign to 0.
        uo_out     = 0;
        uio_out    = 0;
        uio_oe     = 0;

        _unused    = &{ena, clk, rst_n, 1'b0};
    end

endmodule // tt_um__kwr_lfsr__top

// ////////////////////////////////////////////////////////////////////////
// ////////////////////////////////////////////////////////////////////////

`endif // _tt09_kwr_lfsr__logic_

// ////////////////////////////////////////////////////////////////////////
// @END Logic
// ////////////////////////////////////////////////////////////////////////


// ////////////////////////////////////////////////////////////////////////
// @BEGIN Test_LFSR
// ////////////////////////////////////////////////////////////////////////

`ifndef _tt09_kwr_lfsr__test_lfsr_
`define _tt09_kwr_lfsr__test_lfsr_

// ////////////////////////////////////////////////////////////////////////
// ////////////////////////////////////////////////////////////////////////

// ... test code goes here ....

module test_lfsr;
    reg                   clk;
    reg                   rst_n;
    reg          [5:0]    lfsr_length;
    reg                   lfsr_n_taps;

    wire        [63:0]    lfsr_value;
    wire                  lfsr_valid;

    lfsr_fibonacci    lfsr
    (
        .clk(clk),
        .rst_n(rst_n),
        .lfsr_length(lfsr_length),
        .lfsr_n_taps(lfsr_n_taps),
        .lfsr_value(lfsr_value),
        .lfsr_valid(lfsr_valid)
    );

    integer               cycle;

    initial
    begin
        cycle             = 0;
        $display("#### cycle = %d", cycle);
        clk               = 0;
        rst_n             = 1;
        $display("#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value = 0b%07b", cycle, clk, rst_n, lfsr_valid, lfsr_value & 127);

        lfsr_length       = 6'd7;
        lfsr_n_taps       = 0;

        #50;
        rst_n             = 0;
        $display("#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value = 0b%07b", cycle, clk, rst_n, lfsr_valid, lfsr_value & 127);
        #50;
        clk               = 1;
        $display("#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value = 0b%07b", cycle, clk, rst_n, lfsr_valid, lfsr_value & 127);

        #100;
        clk               = 0;
        $display("#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value = 0b%07b", cycle, clk, rst_n, lfsr_valid, lfsr_value & 127);

        #100;
        clk               = 1;
        $display("#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value = 0b%07b", cycle, clk, rst_n, lfsr_valid, lfsr_value & 127);

        #100;
        clk               = 0;
        $display("#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value = 0b%07b", cycle, clk, rst_n, lfsr_valid, lfsr_value & 127);

        #100;
        clk               = 1;
        $display("#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value = 0b%07b", cycle, clk, rst_n, lfsr_valid, lfsr_value & 127);

        #50;
        rst_n             = 1;
        $display("#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value = 0b%07b", cycle, clk, rst_n, lfsr_valid, lfsr_value & 127);
        #50;
        clk               = 0;
        $display("#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value = 0b%07b", cycle, clk, rst_n, lfsr_valid, lfsr_value & 127);

    end

    always
    begin
        cycle             = cycle + 1;

        if (cycle > 100)    $finish;

        #100;
        clk               = 1;
        $display("#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value = 0b%07b", cycle, clk, rst_n, lfsr_valid, lfsr_value & 127);

        #100;
        clk               = 0;
        $display("#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value = 0b%07b", cycle, clk, rst_n, lfsr_valid, lfsr_value & 127);
    end // always

endmodule // test_lfsr

// ////////////////////////////////////////////////////////////////////////
// ////////////////////////////////////////////////////////////////////////

`endif // _tt09_kwr_lfsr__test_lfsr_

// ////////////////////////////////////////////////////////////////////////
// @END Test_LFSR
// ////////////////////////////////////////////////////////////////////////
