<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The basic code is a fixed-length shift register.
The LFSR aspect (Fibonacci only at this point)
    determines the appropriate mask bits using the "lfsr_length" input
    which is then used to mask the shift-register value
and thus computes the lfsr input bit.

## How to test

Provide the desired length and watch the outputs change cycle by cycle.

## External hardware

Nothing beyond that required to set the length input and (optionally) using the hold input to pause the LFSR.
