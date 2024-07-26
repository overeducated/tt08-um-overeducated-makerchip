// ////////////////////////////////////////////////////////////////////////
// @BEGIN Modules
// ////////////////////////////////////////////////////////////////////////

`ifndef _tt_kwr_lfsr__modules_
`define _tt_kwr_lfsr__modules_

// ////////////////////////////////////////////////////////////////////////
// ////////////////////////////////////////////////////////////////////////

module generate_mask
(
    input   [5:0]    lfsr_length,
    output           mask_valid
    output  [33:0]   mask_value,
);

        case
               6d0 : mask  = begin 34b0000000000000000000000000000000000; valid = 0; end
               6d1 : mask  = begin 34b0000000000000000000000000000000000; valid = 0; end
               6d2 : mask  = begin 34b0000000000000000000000000000000110; valid = 1; end
               6d3 : mask  = begin 34b0000000000000000000000000000001100; valid = 1; end
               6d4 : mask  = begin 34b0000000000000000000000000000011000; valid = 1; end
               6d5 : mask  = begin 34b0000000000000000000000000000101000; valid = 1; end
               6d6 : mask  = begin 34b0000000000000000000000000001100000; valid = 1; end
               6d7 : mask  = begin 34b0000000000000000000000000011000000; valid = 1; end
               6d8 : mask  = begin 34b0000000000000000000000000000000000; valid = 0; end
               6d9 : mask  = begin 34b0000000000000000000000001000100000; valid = 1; end
               6d10 : mask  = begin 34b0000000000000000000000010010000000; valid = 1; end
               6d11 : mask  = begin 34b0000000000000000000000101000000000; valid = 1; end
               6d12 : mask  = begin 34b0000000000000000000000000000000000; valid = 0; end
               6d13 : mask  = begin 34b0000000000000000000000000000000000; valid = 0; end
               6d14 : mask  = begin 34b0000000000000000000000000000000000; valid = 0; end
               6d15 : mask  = begin 34b0000000000000000001100000000000000; valid = 1; end
               6d16 : mask  = begin 34b0000000000000000000000000000000000; valid = 0; end
               6d17 : mask  = begin 34b0000000000000000100100000000000000; valid = 1; end
               6d18 : mask  = begin 34b0000000000000001000000100000000000; valid = 1; end
               6d19 : mask  = begin 34b0000000000000000000000000000000000; valid = 0; end
               6d20 : mask  = begin 34b0000000000000100100000000000000000; valid = 1; end
               6d21 : mask  = begin 34b0000000000001010000000000000000000; valid = 1; end
               6d22 : mask  = begin 34b0000000000011000000000000000000000; valid = 1; end
               6d23 : mask  = begin 34b0000000000100001000000000000000000; valid = 1; end
               6d24 : mask  = begin 34b0000000000000000000000000000000000; valid = 0; end
               6d25 : mask  = begin 34b0000000010010000000000000000000000; valid = 1; end
               6d26 : mask  = begin 34b0000000000000000000000000000000000; valid = 0; end
               6d27 : mask  = begin 34b0000000000000000000000000000000000; valid = 0; end
               6d28 : mask  = begin 34b0000010010000000000000000000000000; valid = 1; end
               6d29 : mask  = begin 34b0000101000000000000000000000000000; valid = 1; end
               6d30 : mask  = begin 34b0000000000000000000000000000000000; valid = 0; end
               6d31 : mask  = begin 34b0010010000000000000000000000000000; valid = 1; end
               6d32 : mask  = begin 34b0000000000000000000000000000000000; valid = 0; end
               6d33 : mask  = begin 34b1000000000000100000000000000000000; valid = 1; end
               6d34 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d35 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d36 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d37 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d38 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d39 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d40 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d41 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d42 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d43 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d44 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d45 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d46 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d47 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d48 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d49 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d50 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d51 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d52 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d53 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d54 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d55 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d56 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d57 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d58 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d59 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d60 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d61 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d62 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d63 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
            default : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
        endcase
endmodule

// ////////////////////////////////////////////////////////////////////////

module generate_mask
(
    input   [5:0]    lfsr_length,
    output           mask_valid
    output  [33:0]   mask_value,
);

        case
               6d0 : mask  = begin 34b0000000000000000000000000000000000; valid = 0; end
               6d1 : mask  = begin 34b0000000000000000000000000000000000; valid = 0; end
               6d2 : mask  = begin 34b0000000000000000000000000000000000; valid = 0; end
               6d3 : mask  = begin 34b0000000000000000000000000000000000; valid = 0; end
               6d4 : mask  = begin 34b0000000000000000000000000000000000; valid = 0; end
               6d5 : mask  = begin 34b0000000000000000000000000000111100; valid = 1; end
               6d6 : mask  = begin 34b0000000000000000000000000001101100; valid = 1; end
               6d7 : mask  = begin 34b0000000000000000000000000011110000; valid = 1; end
               6d8 : mask  = begin 34b0000000000000000000000000101110000; valid = 1; end
               6d9 : mask  = begin 34b0000000000000000000000001101100000; valid = 1; end
               6d10 : mask  = begin 34b0000000000000000000000011011000000; valid = 1; end
               6d11 : mask  = begin 34b0000000000000000000000111010000000; valid = 1; end
               6d12 : mask  = begin 34b0000000000000000000001100101000000; valid = 1; end
               6d13 : mask  = begin 34b0000000000000000000011011000000000; valid = 1; end
               6d14 : mask  = begin 34b0000000000000000000110101000000000; valid = 1; end
               6d15 : mask  = begin 34b0000000000000000001110100000000000; valid = 1; end
               6d16 : mask  = begin 34b0000000000000000010110100000000000; valid = 1; end
               6d17 : mask  = begin 34b0000000000000000111100000000000000; valid = 1; end
               6d18 : mask  = begin 34b0000000000000001110010000000000000; valid = 1; end
               6d19 : mask  = begin 34b0000000000000011100100000000000000; valid = 1; end
               6d20 : mask  = begin 34b0000000000000110010100000000000000; valid = 1; end
               6d21 : mask  = begin 34b0000000000001110010000000000000000; valid = 1; end
               6d22 : mask  = begin 34b0000000000010011100000000000000000; valid = 1; end
               6d23 : mask  = begin 34b0000000000110101000000000000000000; valid = 1; end
               6d24 : mask  = begin 34b0000000001101100000000000000000000; valid = 1; end
               6d25 : mask  = begin 34b0000000011110000000000000000000000; valid = 1; end
               6d26 : mask  = begin 34b0000000111000100000000000000000000; valid = 1; end
               6d27 : mask  = begin 34b0000001110010000000000000000000000; valid = 1; end
               6d28 : mask  = begin 34b0000011001010000000000000000000000; valid = 1; end
               6d29 : mask  = begin 34b0000111010000000000000000000000000; valid = 1; end
               6d30 : mask  = begin 34b0001100101000000000000000000000000; valid = 1; end
               6d31 : mask  = begin 34b0011110000000000000000000000000000; valid = 1; end
               6d32 : mask  = begin 34b0101000110000000000000000000000000; valid = 1; end
               6d33 : mask  = begin 34b1100101000000000000000000000000000; valid = 1; end
               6d34 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d35 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d36 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d37 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d38 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d39 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d40 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d41 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d42 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d43 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d44 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d45 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d46 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d47 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d48 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d49 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d50 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d51 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d52 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d53 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d54 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d55 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d56 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d57 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d58 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d59 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d60 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d61 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d62 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
               6d63 : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
            default : begin mask  = 34b0000000000000000000000000000000000; valid  = 0; end
        endcase
endmodule

// ////////////////////////////////////////////////////////////////////////

module lfsr_fibonacci
(
    input             clk,
    input             rst_n,
    input             lfsr_hold,
    input             mask_valid,
    input   [33:0]    mask_value,
    output  [33:0]    lfsr_value
);

    reg     [33:0]    sr_value;

    always @(posedge clk)
    begin
        if      (not mask_valid)
            lfsr  <= 34d0;
        else if (rst_n)
            lfsr  <= 34d1;
        else if (lfsr_hold)
            // don't change lfsr state
        else
            sr_value  <= { sr_value[32:0], ^(sr_value & mask_value) };
        end

            lfsr_value  = sr_value
    end
endmodule

// ////////////////////////////////////////////////////////////////////////
// ////////////////////////////////////////////////////////////////////////

`endif _tt_kwr_lfsr__modules_

// ////////////////////////////////////////////////////////////////////////
// @END Logic
// ////////////////////////////////////////////////////////////////////////
