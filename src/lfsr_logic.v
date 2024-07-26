// ////////////////////////////////////////////////////////////////////////
// @BEGIN Logic
// ////////////////////////////////////////////////////////////////////////

`ifndef _tt_kwr_lfsr__logic_
`define _tt_kwr_lfsr__logic_

// ////////////////////////////////////////////////////////////////////////
// ////////////////////////////////////////////////////////////////////////

    wire    [5:0]     lfsr_length;
    wire              lfsr_type;

    wire              lfsr_valid;
    wire    [15:0]    lfsr_value;

    wire              mask_valid;
    wire              mask_value;

        uio_oe       = 8b1111_1111;

        lfsr_length  = ui_in[5:0];
        lfsr_type    = ui_in[6];
        lfsr_hold    = ui_in[7];
        clk  = clk;
        rst_n  = rst_n;


mask_fibonacci    mask
(
    .mask_length(lsfr_length),
    .mask_valid(mask_valid)
    .mask_value(mask_value),
);

lfsr_fibonacci    lfsr
(
    .clk(clk),
    .rst_n(rst_n),
    .mask_valid(mask_valid),
    .mask_value(mask_value),
    .lfsr_value(lfsr_value)
);

        uio_out[7]                       = lfsr_valid;
        { uio_out[6:0], uo_out[7:0] }    = lfsr_value[14:0]

// ////////////////////////////////////////////////////////////////////////

`endif _tt_kwr_lfsr__logic_

// ////////////////////////////////////////////////////////////////////////
// @END Logic
// ////////////////////////////////////////////////////////////////////////
