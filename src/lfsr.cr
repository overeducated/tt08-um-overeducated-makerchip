########################################################################
########################################################################
# module
########################################################################

########################################################################
# example run command
#    % crystal run --error-trace lfsr.cr -- -Hv -i1 -n34 -C +clk -R -rst_n -L lfsr -T fib --generate modules --generate logic
########################################################################

    # language and library setup

    require "json"
    require "option_parser"

    ####################################
    # constants

    TT_INPUT            = "ai"
    TT_OUTPUT           = "ao"
    TT_INPUT_OUTPUT     = "aio"
    TT_INPUT_OUTPUT_EN  = "aio_en"

    # **** could validate that LFSR[i][0] == i... ****

    LFSR_INIT  = 0              # kwr::HACK--- using a 1 value rather than something smarter (and contained in the table for generality?)

    NULL_2TAP  = [-1, -1]

    LFSR_2TAP  =  [
                      NULL_2TAP, #  0 # **** [0] represents the invalid entry (can't have an LFSR with length 1!) ****
                      NULL_2TAP, #  1 #
                      [ 2,  1],  #  2 # 4, (This LFSR was tested and found to have period of 33554432 clock cycles)
                      [ 3,  2],  #  3 # 8, if reset = '1' then
                      [ 4,  3],  #  4 # 16, QR <= (others => '1');
                      [ 5,  3],  #  5 # 32, elsif rising_edge(clk) THEN
                      [ 6,  5],  #  6 # 64, QR(24) <= QR(23);
                      [ 7,  6],  #  7 # 128, QR(23) <= QR(22);
                      NULL_2TAP, #  8 # 256, QR(22) <= QR(21) XOR QR(24); -- tap 22
                      [ 9,  5],  #  9 # 512, QR(21) <= QR(20);
                      [10,  7],  # 10 # 1024, QR(20) <= QR(19);
                      [11,  9],  # 11 # 2048, QR(19) <= QR(18);
                      NULL_2TAP, # 12# 4096, QR(18) <= QR(17);
                      NULL_2TAP, # 13 # 8192, QR(17) <= QR(16);
                      NULL_2TAP, # 14 # 16384, QR(16) <= QR(15);
                      [15, 14],  # 15 # 32768, QR(15) <= QR(14);
                      NULL_2TAP, # 16 # 65536, QR(14) <= QR(13);
                      [17, 14],  # 17 # 131072, QR(13) <= QR(12);
                      [18, 11],  # 18 # 262144, QR(12) <= QR(11);
                      NULL_2TAP, # 19 # 524288, QR(11) <= QR(10);
                      [20, 17],  # 20 # 1048576, QR(10) <= QR(9);
                      [21, 19],  # 21 # 2097152, QR(9)  <= QR(8);
                      [22, 21],  # 22 # 4194304, QR(8)  <= QR(7);
                      [23, 18],  # 23 # 8388608, QR(7)  <= QR(6);
                      NULL_2TAP, # 24 # 16777216, QR(6)  <= QR(5);
                      [25, 22],  # 25 # 33554432, QR(5)  <= QR(4);
                      NULL_2TAP, # 26 # 67108864, QR(4)  <= QR(3);
                      NULL_2TAP, # 27 # 134217728, QR(3)  <= QR(2);
                      [28, 25],  # 28 # 268435456, QR(2)  <= QR(1);
                      [29, 27],  # 29 # 536870912, QR(1)  <= QR(0);
                      NULL_2TAP, # 30 # 1073741824, QR(0) <= QR(24); -- tap 24
                      [31, 28],  # 31 # 2147483648,
                      NULL_2TAP, # 32 # 4294967296, "if QR = ""000000000000000000000000"" then"
                      [33, 20],  # 33 # 8589934592, QR <= (others => '1');
                      NULL_2TAP, # 34 # 17179869184,        end if;
                      [35, 33],  # 35 # 34359738368,    end if;
                      [36, 25],  # 36 # 68719476736,
                      NULL_2TAP, # 37 # 137439000000,
                      NULL_2TAP, # 38 # 274878000000,
                      [39, 35],  # 39 # 549756000000,
                      NULL_2TAP, # 40 # 1099510000000,
                      [41, 38],  # 41 # 2199020000000,
                      NULL_2TAP, # 42 # 4398050000000,
                      NULL_2TAP, # 43 # 8796090000000,
                      NULL_2TAP, # 44 # 17592200000000,
                      NULL_2TAP, # 45 # 35184400000000,
                      NULL_2TAP, # 46 # 70368700000000,
                      [47, 42],  # 47 # 140737000000000,
                      NULL_2TAP, # 48 # 281475000000000,
                      [49, 40],  # 49 # 562950000000000,
                      NULL_2TAP, # 50 # 1.1259E+15,
                      NULL_2TAP, # 51 # 2.2518E+15,
                      [52, 49],  # 52 # 4.5036E+15,
                      NULL_2TAP, # 53 # 9.0072E+15,
                      NULL_2TAP, # 54 # 1.80144E+16,
                      [55, 31],  # 55 # 3.60288E+16,
                      NULL_2TAP, # 56 # 7.20576E+16,
                      [57, 50],  # 57 # 1.44115E+17,
                      [58, 39],  # 58 # 2.8823E+17,
                      NULL_2TAP, # 59 # 5.76461E+17,
                      [60, 59],  # 60 # 1.15292E+18,
                      NULL_2TAP, # 61 # 2.30584E+18,
                      NULL_2TAP, # 62 # 4.61169E+18,
                      [63, 62],  # 63 # 9.22337E+18,
                      NULL_2TAP, # 64 # 1.84467E+19,
                      [65, 47],  # 65 # 3.68935E+19,
                      NULL_2TAP, # 66 # 7.3787E+19,
                      NULL_2TAP, # 67 # 1.47574E+20,
                  ]

    TAPS_2TAP  = 2
    MAX_2TAP   = LFSR_2TAP.size - 1

    ##################

    NULL_4TAP  = [-1, -1, -1, -1]

    LFSR_4TAP  =  [
                      NULL_4TAP,          #  0 # **** [0] represents the invalid entry (can't have an LFSR with length 1!) ****
                      NULL_4TAP,          #  1 #
                      NULL_4TAP,          #  2 # 4, (This LFSR was tested and found to have period of 33554432 clock cycles)
                      NULL_4TAP,          #  3 # 8, if reset = '1' then
                      NULL_4TAP,          #  4 # 16, QR <= (others => '1');
                      [ 5,  4,  3,  2],   #  5 # 32, elsif rising_edge(clk) THEN
                      [ 6,  5,  3,  2],   #  6 # 64, QR(24) <= QR(23);
                      [ 7,  6,  5,  4],   #  7 # 128, QR(23) <= QR(22);
                      [ 8,  6,  5,  4],   #  8 # 256, QR(22) <= QR(21) XOR QR(24); -- tap 22
                      [ 9,  8,  6,  5],   #  9 # 512, QR(21) <= QR(20);
                      [10,  9,  7,  6],   # 10 # 1024, QR(20) <= QR(19);
                      [11, 10,  9,  7],   # 11 # 2048, QR(19) <= QR(18);
                      [12, 11,  8,  6],   # 12# 4096, QR(18) <= QR(17);
                      [13, 12, 10,  9],   # 13 # 8192, QR(17) <= QR(16);
                      [14, 13, 11,  9],   # 14 # 16384, QR(16) <= QR(15);
                      [15, 14, 13, 11],   # 15 # 32768, QR(15) <= QR(14);
                      [16, 14, 13, 11],   # 16 # 65536, QR(14) <= QR(13);
                      [17, 16, 15, 14],   # 17 # 131072, QR(13) <= QR(12);
                      [18, 17, 16, 13],   # 18 # 262144, QR(12) <= QR(11);
                      [19, 18, 17, 14],   # 19 # 524288, QR(11) <= QR(10);
                      [20, 19, 16, 14],   # 20 # 1048576, QR(10) <= QR(9);
                      [21, 20, 19, 16],   # 21 # 2097152, QR(9)  <= QR(8);
                      [22, 19, 18, 17],   # 22 # 4194304, QR(8)  <= QR(7);
                      [23, 22, 20, 18],   # 23 # 8388608, QR(7)  <= QR(6);
                      [24, 23, 21, 20],   # 24 # 16777216, QR(6)  <= QR(5);
                      [25, 24, 23, 22],   # 25 # 33554432, QR(5)  <= QR(4);
                      [26, 25, 24, 20],   # 26 # 67108864, QR(4)  <= QR(3);
                      [27, 26, 25, 22],   # 27 # 134217728, QR(3)  <= QR(2);
                      [28, 27, 24, 22],   # 28 # 268435456, QR(2)  <= QR(1);
                      [29, 28, 27, 25],   # 29 # 536870912, QR(1)  <= QR(0);
                      [30, 29, 26, 24],   # 30 # 1073741824, QR(0) <= QR(24); -- tap 24
                      [31, 30, 29, 28],   # 31 # 2147483648,
                      [32, 30, 26, 25],   # 32 # 4294967296, "if QR = ""000000000000000000000000"" then"
                      [33, 32, 29, 27],   # 33 # 8589934592, QR <= (others => '1');
                      [34, 31, 30, 26],   # 34 # 17179869184,        end if;
                      [35, 34, 28, 27],   # 35 # 34359738368,    end if;
                      [36, 35, 29, 28],   # 36 # 68719476736,
                      [37, 36, 33, 31],   # 37 # 137439000000,
                      [38, 37, 33, 32],   # 38 # 274878000000,
                      [39, 38, 35, 32],   # 39 # 549756000000,
                      [40, 37, 36, 35],   # 40 # 1099510000000,
                      [41, 40, 39, 38],   # 41 # 2199020000000,
                      [42, 40, 37, 35],   # 42 # 4398050000000,
                      [43, 42, 38, 37],   # 43 # 8796090000000,
                      [44, 42, 39, 38],   # 44 # 17592200000000,
                      [45, 44, 42, 41],   # 45 # 35184400000000,
                      [46, 40, 39, 38],   # 46 # 70368700000000,
                      [47, 46, 43, 42],   # 47 # 140737000000000,
                      [48, 44, 41, 39],   # 48 # 281475000000000,
                      [49, 45, 44, 43],   # 49 # 562950000000000,
                      [50, 48, 47, 46],   # 50 # 1.1259E+15,
                      [51, 50, 48, 45],   # 51 # 2.2518E+15,
                      [52, 51, 49, 46],   # 52 # 4.5036E+15,
                      [53, 52, 51, 47],   # 53 # 9.0072E+15,
                      [54, 51, 48, 46],   # 54 # 1.80144E+16,
                      [55, 54, 53, 49],   # 55 # 3.60288E+16,
                      [56, 54, 52, 49],   # 56 # 7.20576E+16,
                      [57, 55, 54, 52],   # 57 # 1.44115E+17,
                      [58, 57, 53, 52],   # 58 # 2.8823E+17,
                      [59, 57, 55, 52],   # 59 # 5.76461E+17,
                      [60, 58, 56, 55],   # 60 # 1.15292E+18,
                      [61, 60, 59, 56],   # 61 # 2.30584E+18,
                      [62, 59, 57, 56],   # 62 # 4.61169E+18,
                      [63, 62, 59, 58],   # 63 # 9.22337E+18,
                      [64, 63, 61, 60],   # 64 # 1.84467E+19,
                      [65, 64, 62, 61],   # 65 # 3.68935E+19,
                      [66, 60, 58, 57],   # 66 # 7.3787E+19,
                      [67, 66, 65, 62],   # 67 # 1.47574E+20,
                  ]

    TAPS_4TAP  = 4
    MAX_4TAP   = LFSR_4TAP.size - 1

    ##################

    DQ                 = '"'
    SQ                 = "'"
    DQED_SQ            = DQ + SQ + DQ           # there has to be a better way....
    SQED_DQ            = SQ + DQ + SQ           # there has to be a better way....

    ##################
    ##################

    enum    Language
        Unknown
        #
        Verilog
        VHDL
        SystemVerilog
    end # enum

    #########

    enum    Polarity
        Unknown
        #
        Positive
        Negative
    end # enum

    #########

    enum    Type
        Unknown
        #
        Fibonacci
        # Galois
    end # enum

    #########

    enum    Generate
        Unknown
        #
        # All
        Modules
        Logic
    end # enum

    ##################
    ##################

    class Option_State
        include JSON::Serializable

        property  what
        property  language

        property  type
        property  lfsr_length
        #property  lfsr_n_taps                    # shouldn't this one be obvious?
        property  lfsr_init
        property  lfsr_width
        property  lfsr_bound

        #property  tap_table
        #property  tap_table_null
        #property  tap_table_max
        #property  tap_table_n_taps

        property  lfsr_symbol
        property  clock_symbol
        property  reset_symbol

        property  clock_polarity
        property  reset_polarity

        #########

        @what               : Generate
        @language           : Language

        @type               : Type
        @lfsr_length        : Int32
        #@lfsr_n_taps        : Int32
        @lfsr_init          : Int32             # could be inadequate; instead, could be an array of non-zero bits which should be set using a generated sequence of (1 << a[i]) | ...
        @lfsr_width         : Int32
        @lfsr_bound         : Int32

        #@tap_table          : Array(Array(Int32))
        #@tap_table_null     : Array(Int32)
        #@tap_table_max      : Int32
        #@tap_table_n_taps   : Int32

        @lfsr_symbol        : String
        @clock_symbol       : String
        @reset_symbol       : String

        @clock_polarity     : Polarity
        @reset_polarity     : Polarity

        #########

        def initialize
            @what               = Generate::Unknown
            @language           = Language::Unknown

            @type               = Type::Unknown
            @lfsr_length        = 0
            #@lfsr_n_taps        = 0
            @lfsr_init          = 0             # kwr::GUESS--- likely invalid for all LFSR but should be smarter about it (and -1 is so signed...)
            @lfsr_width         = 0
            @lfsr_bound         = 0

            #@tap_table          = [] of Array(Int32)
            #@tap_table_null     = [] of Int32
            #@tap_table_max      = 0
            #@tap_table_n_taps   = 0

            @lfsr_symbol        = ""
            @clock_symbol       = ""
            @reset_symbol       = ""

            @clock_polarity     = Polarity::Unknown
            @reset_polarity     = Polarity::Unknown
        end # def

        ##################

        def to_generate(what : String)
            if (what == "")
                puts "Must specify what code to generate"
                exit -1
            else
                wtest  = what.downcase

                case (what)
                  when "modules"
                    @what  = Generate::Modules

                  when "logic"
                    @what  = Generate::Logic

                  else
                    puts "Don't know how to generate output for #{what}"
                    exit -1
                end # case
            end # if

            #########

            if (@language == Language::Unknown)
                puts "Must specify the language"
            end # if

            #########

            if (@type == Type::Unknown)
                puts "Must specify the LFSR type"
                exit -1
            end # if

            #########

            #if ((@lfsr_length < 2) || (@lfsr_length > @tap_table_max))
            if (@lfsr_length < 2)
                puts "LFSR length #{@lfsr_length} must be at least 2"
                exit -1
            end # if

            #########

            #if (@n_taps != @tap_table_n_taps)
            #    puts "LFSR taps #{@n_taps} must match tap-table taps #{@tap_table_n_taps}b LFSR"
            #    exit -1
            #end # if

            #########

            if (@lfsr_init == 0)
                puts "LFSR initial value #{@lfsr_init} must be specified (and be non-zero!)"
                exit -1
            end # if

            #########

            if ((what == Generate::Logic) && (@lfsr_symbol  == ""))
                puts "Must specify the LFSR symbol"
                exit -1
            end # if

            #########

            if (@clock_symbol == "")
                puts "Must specify the clock symbol"
                exit -1
            end # if

            #########

            if (@reset_symbol == "")
                puts "Must specify the reset symbol"
                exit -1
            end # if

            #########

            if (@clock_polarity == Polarity::Unknown)
                puts "Must specify the clock polarity"
                exit -1
            end # if

            #########

            if (@reset_polarity == Polarity::Unknown)
                puts "Must specify the reset polarity"
                exit -1
            end # if

            #########

            #which_taps  = @tap_table[@lfsr_length]
            #if (which_taps == @tap_table_null)
            #    puts "There is no valid LSFR of length #{@lfsr_length} with #{@n_taps} taps"
            #    exit -1
            #elsif (which_taps.size != @n_taps)
            #    puts "Mismatch between number of taps specified in the tap table #{which_taps.size} and the requested #{@n_taps}"
            #    exit -1
            #end # if

            #########

            return (self.dup)
        end # def create_generate
    end # class Option_State

    ########################################################################

    class HDL_Generator
        @@hdl_classes  = Hash(Language, self.class).new

        ##################

        # add subclass works fine so long as it is invoked
        # as HDL_Generator.add_subclass without specific typing;
        # what it doesn't do is to allow HDL_Generator subclasses to be used
        # or, so far, to allow indirect (dynamic-class) method invocation

        # for better or worse, each class now has its own class variables
        # and do not share the top-level declaring class's class variables.

        # for args, can use gt : Language but not gc : HDL_Generator...

        # currently we end up with gc : HDL_Generator.class rather than HDL_Generator as the type;
        # the former doesn't seem right (with what i understand at the moment) but does seem to work
        # while the latter doesn't work

        def self.add_subclass(gt : Language, gc : self.class) : Nil
            @@hdl_classes[gt]  = gc
        end

        ##################

        def self.generate(gen_opts) : Nil
            lang  = gen_opts.language
            gc    = @@hdl_classes[lang]

            if (gc.nil?)
                puts "No generator class available for language #{lang}"
                exit -1
            end # if

            what  = gen_opts.what

            #gc.generate_modules(gen_opts)

            #case (what)
            #  when Generate::Modules
            #    gc.generate_modules(gen_opts)

            #  when Generate::LFSR
            #    gc.generate_logic(gen_opts)

            #  else
            #    puts "Don't know how to generate a #{what}"
            #    exit -1
            #end # case

            case (what)
              when Generate::Modules
                case (lang)
                  when Language::Verilog
                    Verilog_Generator        .generate_modules(gen_opts)

                  when Language::SystemVerilog
                    SystemVerilog_Generator  .generate_modules(gen_opts)

                  when Language::VHDL
                    VHDL_Generator           .generate_modules(gen_opts)

                  else
                    puts "Don't know how to generate RTL for #{lang}"
                    exit -1
                end # case

              when Generate::Logic
                case (lang)
                  when Language::Verilog
                    Verilog_Generator        .generate_logic(gen_opts)

                  when Language::SystemVerilog
                    SystemVerilog_Generator  .generate_logic(gen_opts)

                  when Language::VHDL
                    VHDL_Generator           .generate_logic(gen_opts)

                  else
                    puts "Don't know how to generate RTL for #{lang}"
                    exit -1
                end # case

              else
                puts "Don't know how to generate a #{what}"
                exit -1
            end # case

        end # def self.generate
    end # class HDL_Generator

    ####################################

    class Verilog_Generator       < HDL_Generator
        HDL_Generator.add_subclass(Language::Verilog, self)

        #########

        def self.generate_modules_feedback_mask(gen_opts, n_taps)
            case n_taps
              when 2
                tap_table         = LFSR_2TAP
                tap_table_null    = NULL_2TAP
                tap_table_max     = MAX_2TAP
                tap_table_n_taps  = TAPS_2TAP

              when 4
                tap_table         = LFSR_4TAP
                tap_table_null    = NULL_4TAP
                tap_table_max     = MAX_4TAP
                tap_table_n_taps  = TAPS_4TAP

              else
                puts "LFSR taps must be 2 or 4 (provided #{n_taps})"
                exit -1
            end # case

            lfsr_length  = gen_opts.lfsr_length

            # kwr::QUERY??? should we instead cap it at the maximum size and warn the user?
            if (lfsr_length > tap_table_max)
                puts "LFSR length #{lfsr_length} greater than the tap-table maximum value #{tap_table_max}"
                exit -1
            end

            case (gen_opts.type)
              when Type::Fibonacci
                index_width   = gen_opts.lfsr_width
                lfsr_length   = gen_opts.lfsr_length
                lfsr_bound    = gen_opts.lfsr_bound

                puts "module generate_mask"
                puts "("
                puts "    input   [#{index_width - 1}:0]    lfsr_length,"
                puts "    output           mask_valid"
                puts "    output  [#{lfsr_length - 1}:0]   mask_value,"
                puts ");"
                puts ""
                #puts "    always @(*)"
                #puts "    begin"
                puts "        case"

                in_lb   = 0
                in_ub   = imin(lfsr_length - 1, lfsr_bound)

                out_lb  = in_ub + 1
                out_ub  = lfsr_bound - 1
                in_lb.upto(in_ub) \
                do | i |
                    if (i > tap_table_max)
                        puts "Unexpected invalid LFSR length #{lfsr_length} > #{lfsr_bound}"
                    end # if

                    taps  = tap_table[i]

                    if (taps != tap_table_null)
                        valid  = 1

                    else
                        taps   = [] of Int32                                         # no taps...
                        valid  = 0
                    end # if

                    mask  = "0" * lfsr_length

                    taps.each { | t | mask  = mask.sub((lfsr_length - 1) - t, "1"); }               # ugly, but i guess that's the breaks (faster to generate sequentially? i doubt it...)

                    puts "               #{index_width}d#{i} : mask  = begin #{lfsr_length}b#{mask}; valid = #{valid}; end"
                end # do

                #mask    = "x" * lfsr_length                                                  # could we get hugely-better results with casex and "x"?
                mask    = "0" * lfsr_length

                out_lb.upto(out_ub) \
                do | i |
                    puts "               #{index_width}d#{i} : begin mask  = #{lfsr_length}b#{mask}; valid  = 0; end"
                end # do

                puts "            default : begin mask  = #{lfsr_length}b#{mask}; valid  = 0; end"
                puts "        endcase"
                #puts "    end"
                puts "endmodule"

              # when Type::Galois
              #   # TBD....

              else
                puts "Feedback type #{gen_opts.type} unimplemented"
                exit -1
            end # case type
        end # def self.generate_module_feedback_mask

        #########

        def self.generate_modules_shift_register(gen_opts)
                clock_symbol    = gen_opts.clock_symbol
                clock_polarity  = gen_opts.clock_polarity

                reset_symbol    = gen_opts.reset_symbol
                reset_polarity  = gen_opts.reset_polarity

                lfsr_length     = gen_opts.lfsr_length
                lfsr_init       = gen_opts.lfsr_init

                puts "module lfsr_fibonacci"
                puts "("
                puts "    input             clk,"
                puts "    input             rst_n,"
                puts "    input             lfsr_hold,"
                puts "    input             mask_valid,"
                puts "    input   [#{lfsr_length - 1}:0]    mask_value,"
                puts "    output  [#{lfsr_length - 1}:0]    lfsr_value"
                puts ");"
                puts ""
                puts "    reg     [#{lfsr_length - 1}:0]    sr_value;"
                puts ""
                puts "    always @(#{polarity?(clock_polarity, pos: "posedge", neg: "negedge")} clk)"
                puts "    begin"
                puts "        if      (not mask_valid)"
                puts "            lfsr  <= #{lfsr_length}d0;"
                puts "        else if (rst_n)"
                                    # should lfsr_init be in the table as length-dependent?
                                    # or are all maximal-length lfsr 2^n - 1 with 0 being the only stable state?
                puts "            lfsr  <= #{lfsr_length}d#{lfsr_init};"
                puts "        else if (lfsr_hold)"
                puts "            // don't change lfsr state"
                puts "        else"
                puts "            sr_value  <= { sr_value[#{lfsr_length - 2}:0], ^(sr_value & mask_value) };"
                puts "        end"
                puts ""
                #puts "        always @(*)"
                #puts "        begin"
                puts "            lfsr_value  = sr_value"
                #puts "        end"
                puts "    end"
                puts "endmodule"
        end # def self.generate_module_shift_register

        ##################

        def self.generate_modules(gen_opts) : Nil
            puts "// ////////////////////////////////////////////////////////////////////////"
            puts "// @BEGIN Modules"
            puts "// ////////////////////////////////////////////////////////////////////////"

            puts ""
            puts "`ifndef _tt_kwr_lfsr__modules_"
            puts "`define _tt_kwr_lfsr__modules_"
            puts ""

            puts "// ////////////////////////////////////////////////////////////////////////"
            puts "// ////////////////////////////////////////////////////////////////////////"

            puts ""
            self.generate_modules_feedback_mask(gen_opts, 2)
            puts ""

            puts "// ////////////////////////////////////////////////////////////////////////"

            puts ""
            self.generate_modules_feedback_mask(gen_opts, 4)
            puts ""

            puts "// ////////////////////////////////////////////////////////////////////////"

            puts ""
            self.generate_modules_shift_register(gen_opts)
            puts ""

            puts "// ////////////////////////////////////////////////////////////////////////"
            puts "// ////////////////////////////////////////////////////////////////////////"

            puts ""
            puts "`endif _tt_kwr_lfsr__modules_"
            puts ""

            puts "// ////////////////////////////////////////////////////////////////////////"
            puts "// @END Logic\n"
            puts "// ////////////////////////////////////////////////////////////////////////"
        end # def self.generate_modules

        ##################

        #def self.generate_tt_logic(gen_opts) : Nil
        def self.generate_logic(gen_opts) : Nil
            clock_symbol    = gen_opts.clock_symbol
            clock_polarity  = gen_opts.clock_polarity

            reset_symbol    = gen_opts.reset_symbol
            reset_polarity  = gen_opts.reset_polarity

            if (clock_symbol == "clk")
                if (clock_polarity == Polarity::Negative)
                    puts "Clock signal name aliasing (#{clock_symbol}) with inconsistent polarity: TT framework assumes positive and generation provided negative"
                    exit -1
                end
            end

            if (reset_symbol == "rst_n")
                if (reset_polarity == Polarity::Positive)
                    puts "Reset signal name aliasing (#{reset_symbol}) with inconsistent polarity: TT framework assumes negative and generation provided positive"
                    exit -1
                end
            end

            lfsr_length     = gen_opts.lfsr_length

            if (lfsr_length > 64)
                puts "Logic implementation assumes no more than 6 bits which limits LFSR length to 64b, provided #{lfsr_length}"
                exit -1
            end

            # Tiny Tapeout pin values available:

            #     input  wire [7:0] ui_in,    // Dedicated inputs"
            #     output wire [7:0] uo_out,   // Dedicated outputs"
            #     input  wire [7:0] uio_in,   // IOs: Input path"
            #     output wire [7:0] uio_out,  // IOs: Output path"
            #     output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)"
            #     input  wire       ena,      // always 1 when the design is powered, so you can ignore it"
            #     input  wire       clk,      // clock"
            #     input  wire       rst_n     // reset_n - low to reset"

            puts "// ////////////////////////////////////////////////////////////////////////"
            puts "// @BEGIN Logic\n"
            puts "// ////////////////////////////////////////////////////////////////////////"

            puts ""
            puts "`ifndef _tt_kwr_lfsr__logic_"
            puts "`define _tt_kwr_lfsr__logic_"
            puts ""

            puts "// ////////////////////////////////////////////////////////////////////////"
            puts "// ////////////////////////////////////////////////////////////////////////"

            puts ""

            puts "    wire    [5:0]     lfsr_length;"
            puts "    wire              lfsr_type;"
            #puts "    wire              lfsr_hold;"
            puts ""
            puts "    wire              lfsr_valid;"
            puts "    wire    [15:0]    lfsr_value;"
            puts ""
            puts "    wire              mask_valid;"
            puts "    wire              mask_value;"

            puts ""
            #puts "    always (*)"
            #puts "    begin"
            puts "        uio_oe       = 8b1111_1111;"
            #puts "    end"
            puts ""
            #puts "    always (*)"
            #puts "    begin"
            # should there be a lsfr_load to latch length and type?
            puts "        lfsr_length  = ui_in[5:0];"       # should we latch this one?
            puts "        lfsr_type    = ui_in[6];"         # we don't care for the moment, but should we latch this one?
            puts "        lfsr_hold    = ui_in[7];"

            puts "        #{clock_symbol}  = #{polarity?(clock_polarity, pos: "",    neg: "!")}clk;"
            puts "        #{reset_symbol}  = #{polarity?(reset_polarity, pos: "not", neg: "")}rst_n;"
            #puts "    end"
            puts ""
            puts ""
            puts "mask_fibonacci    mask"
            puts "("
            puts "    .mask_length(lsfr_length),"
            puts "    .mask_valid(mask_valid)"
            puts "    .mask_value(mask_value),"
            puts ");"
            puts ""
            puts "lfsr_fibonacci    lfsr"
            puts "("
            puts "    .clk(#{clock_symbol}),"
            puts "    .rst_n(#{reset_symbol}),"
            puts "    .mask_valid(mask_valid),"
            puts "    .mask_value(mask_value),"
            puts "    .lfsr_value(lfsr_value)"
            puts ");"
            puts ""
            #puts "    always (*)"
            #puts "    begin"
            puts "        uio_out[7]                       = lfsr_valid;"
            puts "        { uio_out[6:0], uo_out[7:0] }    = lfsr_value[14:0]"
            #puts "    end"

            puts ""

            puts "// ////////////////////////////////////////////////////////////////////////"

            puts ""
            puts "`endif _tt_kwr_lfsr__logic_"
            puts ""

            puts "// ////////////////////////////////////////////////////////////////////////"
            puts "// @END Logic\n"
            puts "// ////////////////////////////////////////////////////////////////////////"

        end # def generate_logic
    end # class Verilog_Generator

    ####################################

    class SystemVerilog_Generator < Verilog_Generator
        HDL_Generator.add_subclass(Language::SystemVerilog, self)

        #########

        def self.generate_modules(gen_opts)
            puts "#{self.name}.generate_modules(gen_opts) is not implemented"
            exit -1
        end # def self.generate_modules

        #########

        def self.generate_logic(gen_opts)
            puts "#{self.name}.generate_logic(gen_opts) is not implemented"
            exit -1
        end # def self.generate_modules
    end # class SystemVerilog_Generator

    ####################################

    class VHDL_Generator          < HDL_Generator
        HDL_Generator.add_subclass(Language::VHDL, self)

        #########

        def self.generate_modules(gen_opts)
            puts "#{self.name}.generate_modules(gen_opts) is not implemented"
            exit -1
        end # def self.generate_modules

        #########

        def self.generate_logic(gen_opts)
            puts "#{self.name}.generate_logic(gen_opts) is not implemented"
            exit -1
        end # def self.generate_modules
    end # class HDL_Generator

    ########################################################################
    ########################################################################

    # helper functions (should be included elsewhere?)

    def split_symbol(symbol)
        if (symbol.size == 0)
            return {Polarity::Unknown, symbol }

        elsif (symbol[0] == '+')
            return { Polarity::Positive, symbol.lchop }

        elsif (symbol[0] == '-')
            return { Polarity::Negative, symbol.lchop }

        else
            return { Polarity::Unknown, symbol }
        end
    end # def split_symbol

    #########

    def polarity?(pol, *, pos="", neg="", unk=pos)
        case pol
          when Polarity::Positive
            return (pos)

          when Polarity::Negative
            return (neg)

          when Polarity::Unknown
            return (unk)

          else
            puts "polarity?: #{pol} is not a valid polarity"
            exit -1
        end # case
    end # def polarity?

    #########

    def imin(a, b)
        return ((a < b) ? a : b)
    end

    #########

    def imax(a, b)
        return ((a > b) ? a : b)
    end

    ########################################################################
    ########################################################################

    to_generate        = [] of Option_State
    options            = Option_State.new

    generated          = true

    ####################################

    parser  = OptionParser.new do | parser |
        parser.banner = "Welcome to the LFSR generator!"

        #########

        parser.on "-C CLOCK", "--clock=CLOCK", "Specify CLOCK symbol to be used in generated RTL" \
        do | clock |
            clock_polarity, clock_symbol  = split_symbol(clock)

            options.clock_polarity  = clock_polarity
            options.clock_symbol    = clock_symbol

            generated                     = false
        end # parser.on "-C"

        #########

        parser.on "-g WHAT", "--generate WHAT", "Generate mode" \
        do | what |
            to_generate.push(options.to_generate(what))

            generated  = true
        end # parser.on "-h"

        #########

        parser.on "-h", "--help", "Display help" \
        do
            puts parser
            exit
        end # parser.on "-h"

        #########

        parser.on "-H LANG", "--hdl=LANG", "Select HDL language LANG" \
        do | lang |
            ltest  = lang.downcase

            case (ltest)
              when "verilog", "v"
                options.language  = Language::Verilog

              when "vhdl"
                options.language  = Language::VHDL
                puts "VHDL is not yet supported"
                exit -1

              when "system verilog", "sv"
                options.language  = Language::SystemVerilog

              else
                puts "Unknown language #{lang}"
                exit -1
            end # case

            generated  = false
        end # parser.on "-H"

        #########

        parser.on "-L LFSR", "--lfsr=LFSR", "Specify LFSR symbol to be used in generated RTL" \
        do | lfsr |
            options.lfsr_symbol  = lfsr

            generated            = false
        end # parser.on "-L"

        #########

        parser.on "-i IVAL", "--init=IVAL", "Specify initial value to be used in generated RTL to initialize the LFSR" \
        do | ival |
            itest  = ival.to_i?

            if    (itest.nil?)
                puts "LFSR length must be a smallish integer (provided #{ival})"
                exit -1

            else
                options.lfsr_init    = itest
            end # if

            generated            = false
        end # parser.on "-L"

        #########

        parser.on "-n N", "--length=N", "Specify (maximum) LFSR length" \
        do | n |
            ltest  = n.to_i?

            if    (ltest.nil?)
                puts "LFSR length must be a smallish integer (provided #{n})"
                exit -1

            else
                options.lfsr_length  = ltest

                # there's certainly a trivial-enough mathematical approach
                #     width  = log2(ltest).ceil
                #     bound  = 1 << (width - 1)
                # but i don't wan't to figure out how to do it (and debug it) in crystal right now.

                if    (ltest <  2)
                    options.lfsr_width  =  1
                    options.lfsr_bound  =  2

                elsif (ltest <  4)
                    options.lfsr_width  =  2
                    options.lfsr_bound  =  4

                elsif (ltest <  8)
                    options.lfsr_width  =  3
                    options.lfsr_bound  =  8

                elsif (ltest < 16)
                    options.lfsr_width  =  4
                    options.lfsr_bound  = 16

                elsif (ltest < 32)
                    options.lfsr_width  =  5
                    options.lfsr_bound  = 32

                elsif (ltest < 64)
                    options.lfsr_width  =  6
                    options.lfsr_bound  = 64

                else
                    puts "Length #{ltest} is greater than 64 which is not supported by the current RTL model"
                end # if
            end # if

            generated  = false
        end # parser.on "-n"

        #########

        parser.on "-R RESET", "--reset=reset", "Specify RESET symbol to be used in generated RTL" \
        do | reset |
            reset_polarity, reset_symbol  = split_symbol(reset)

            options.reset_polarity  = reset_polarity
            options.reset_symbol    = reset_symbol

            generated  = false
        end # parser.on "-R"

        #########

        parser.on "-t T", "--taps=T", "Specify LSFR taps" \
        do | t |
            puts " taps option is deprecated and taps selected by input port"

            #ttest  = t.to_i?

            #case (ttest)
            #  when nil
            #    puts "LSFR taps must be a smallish integer (provided #{t})"
            #    exit -1

            #  when 2
            #    options.n_taps            = 2

            #    options.tap_table         = LFSR_2TAP
            #    options.tap_table_null    = NULL_2TAP
            #    options.tap_table_max     = MAX_2TAP
            #    options.tap_table_n_taps  = TAPS_2TAP

            #  when 4
            #    options.n_taps            = 4

            #    options.tap_table         = LFSR_4TAP
            #    options.tap_table_null    = NULL_4TAP
            #    options.tap_table_max     = MAX_4TAP
            #    options.tap_table_n_taps  = TAPS_4TAP

            #  else
            #    puts "LFSR taps must be 2 or 4 (provided #{t})"
            #    exit -1
            #end # case

            #generated  = false
        end # parser.on "-t"

        #########

        parser.on "-T TYPE", "--type=TYPE", "Select LFSR type to generate" \
        do | type |
            ttest  = type.downcase

            case (ttest)
              when "fibonacci", "fib", "f"
                options.type  = Type::Fibonacci

              when "galois",     "gal",  "g"
                # options.type  = Type::Galois
                puts "Galois is not yet supported"
                exit -1

              else
                puts "Unknown LFSR type #{type}"
                exit -1
            end # case

            generated  = false
        end # parser.on "-T"

        #########

        parser.on "-v", "--version", "Show version information" \
        do
            puts "    version 1.0"
            exit
        end # parser.on "-v"
    end # parser.on "-l …"

    ####################################

    parser.parse

    if (!generated)
        puts "Options have been specified without a subsequent generate directive"
        exit -1
    end # if

    ####################################

    first_generation  = true

    to_generate.each do | gen_opts |
        if (first_generation)
            first_generation  = false

        else
            puts ""
        end

        HDL_Generator.generate(gen_opts)
    end # do

########################################################################
# end module
########################################################################
########################################################################
