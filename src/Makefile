all:		lfsr

clean:		generate_lfsr lfsr.v
	rm $^

generate_lfsr:	generate_lfsr.cr
	crystal build $<

LFSR_GEN_OPTS	= 	-Hv \
			-i1 \
			-n34 \
			-C +clk \
			-R -rst_n \
			-L lfsr \
			-T fib \
			--generate modules \
			--generate test

#			--generate logic \
@			--generate test

lfsr.v:		generate_lfsr
	./$< $(LFSR_GEN_OPTS) > $@

lfsr:		lfsr.v
	iverilog -v -o $@ $< >& $@.out