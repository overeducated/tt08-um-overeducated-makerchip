\m5_TLV_version 1d: tl-x.org
\m5
   /**
   This template is for developing Tiny Tapeout designs using Makerchip.
   Verilog, SystemVerilog, and/or TL-Verilog can be used.
   Use of Tiny Tapeout Demo Boards (as virtualized in the VIZ tab) is supported.
   See the corresponding Git repository for build instructions.
   **/
   
   use(m5-1.0)  // See M5 docs in Makerchip IDE Learn menu.
   
   // ---SETTINGS---
   var(my_design, tt_um_overeducated_makerchip)  /// Change tt_um_example to tt_um_<your-github-username>_<name-of-your-project>. (See README.md.)
   var(debounce_inputs, 0)
                     /// Legal values:
                     ///   1: Provide synchronization and debouncing on all input signals.
                     ///   0: Don't provide synchronization and debouncing.
                     ///   m5_if_defined_as(MAKERCHIP, 1, 0, 1): Debounce unless in Makerchip.
   // --------------
   
   // If debouncing, your top module is wrapped within a debouncing module, so it has a different name.
   var(user_module_name, m5_if(m5_debounce_inputs, my_design, m5_my_design))
   var(debounce_cnt, m5_if_defined_as(MAKERCHIP, 1, 8'h03, 8'hff))
\SV
   // Include Tiny Tapeout Lab.
   m4_include_lib(['https:/']['/raw.githubusercontent.com/os-fpga/Virtual-FPGA-Lab/35e36bd144fddd75495d4cbc01c4fc50ac5bde6f/tlv_lib/tiny_tapeout_lib.tlv'])

\TLV my_design()
   
   // ============================================
   // If you are using TL-Verilog for your design,
   // your TL-Verilog logic goes here.
   // Optionally, provide \viz_js here (for TL-Verilog or Verilog logic).
   // Tiny Tapeout inputs can be referenced as, e.g. *ui_in.
   // (Connect Tiny Tapeout outputs at the end of this template.)
   // ============================================
   
   // ...

\SV


// ================================================
// A simple Makerchip Verilog test bench driving random stimulus.
// Modify the module contents to your needs.
// ================================================

module top(input logic clk, input logic reset, input logic [31:0] cyc_cnt, output logic passed, output logic failed);
   // Tiny tapeout I/O signals.
   logic [7:0] ui_in, uio_in, uo_out, uio_out, uio_oe;
//   logic [31:0] r;
//   always @(posedge clk) r = m5_if_defined_as(MAKERCHIP, 1, ['$urandom()'], ['0']);
//   assign ui_in = r[7:0];
//   assign uio_in = r[15:8];
//   logic ena = 1'b0;
//   logic rst_n = ! reset;
   
//   /*
//   // Or, to provide specific inputs at specific times...
//   // BE SURE TO COMMENT THE ASSIGNMENT OF INPUTS ABOVE.
//   // BE SURE TO DRIVE THESE ON THE B-PHASE OF THE CLOCK (ODD STEPS).
//   // Driving on the rising clock edge creates a race with the clock that has unpredictable simulation behavior.
//   initial begin
//      #1  // Drive inputs on the B-phase.
//         ui_in = 8'h0;
//      #10 // Step past reset.
//         ui_in = 8'hFF;
//      // ...etc.
//   end
//   */
   
   // Instantiate the Tiny Tapeout module.
   m5_user_module_name tt(.*);
   
//   assign passed = cyc_cnt > 100;
   assign passed = 1'b1; 
   assign failed = 1'b0;
endmodule

// Provide a wrapper module to debounce input signals if requested.
m5_if(m5_debounce_inputs, ['m5_tt_top(m5_my_design)'])
// The above macro expands to multiple lines. We enter a new \SV block to reset line tracking.
\SV


// The Tiny Tapeout module.
module m5_user_module_name (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

   wire reset = ! rst_n;
   
\TLV
   /* verilator lint_off UNOPTFLAT */
   // Connect Tiny Tapeout I/Os to Virtual FPGA Lab.
   m5+tt_connections()
   
   // Instantiate the Virtual FPGA Lab.
   m5+board(/top, /fpga, 7, $, , my_design)
   // Label the switch inputs [0..7] (1..8 on the physical switch panel) (bottom-to-top).
   m5+tt_input_labels_viz(['"UNUSED", "UNUSED", "UNUSED", "UNUSED", "UNUSED", "UNUSED", "UNUSED", "UNUSED"'])
   
\SV_plus


   // =========================================
   // If you are using (System)Verilog for your design,
   // your Verilog logic goes here.
   // =========================================

// kwr::SIGH,,, Makerchip projects are currently limited to this single source file plus any TL-Verilog libraries included via URL.
// `include "lfsr_modules.v"

   // ////////////////////////////////////////////////////////////////////////
   // ////////////////////////////////////////////////////////////////////////
   // kwr::INCLUDE<<< Modules
   // ------------------------------------------------------------------------
   // ------------------------------------------------------------------------

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
// @END Modules
// ////////////////////////////////////////////////////////////////////////

   // ------------------------------------------------------------------------
   // kwr::INCLUDE>>> Modules
   // ////////////////////////////////////////////////////////////////////////
   // ////////////////////////////////////////////////////////////////////////

// kwr::SIGH,,, Makerchip projects are currently limited to this single source file plus any TL-Verilog libraries included via URL.
// `include "lfsr_logic"

   // ////////////////////////////////////////////////////////////////////////
   // ////////////////////////////////////////////////////////////////////////
   // kwr::INCLUDE<<< Logic
   // ------------------------------------------------------------------------


   // ------------------------------------------------------------------------
   // kwr::INCLUDE>>> Logic
   // ////////////////////////////////////////////////////////////////////////
   // ////////////////////////////////////////////////////////////////////////


   // Connect Tiny Tapeout outputs.
   // Note that my_design will be under /fpga_pins/fpga.
   // Example *uo_out = /fpga_pins/fpga|my_pipe>>3$uo_out;
   assign *uo_out = 8'b0;
   assign *uio_out = 8'b0;
   assign *uio_oe = 8'b0;
   
   // List all unused inputs to prevent warnings
   wire _unused = &{ena, clk, rst_n, 1'b0};
endmodule
