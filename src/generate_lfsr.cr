########################################################################
########################################################################
# module ???
########################################################################

    TOOL_DESCRIPTOR     = "LFSR generator"
    TOOL_DESCRIPTXX     = "              "              # there's probably a way to do something like " "*(TOOL_DESCRIPTOR.size) but …

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

    lfsr_init_value  = 1              # kwr::HACK--- initializing to a 1 value rather than something smarter (and contained in the table for generality?)

    NULL_2TAP  = [-1, -1]

    # **** this table uses 1-based taps, thus SIZE..1, not (SIZE-1)..0

    LFSR_2TAP  =  [
                      NULL_2TAP, #  0 # **** [0] represents the invalid entry (can't have an 2-tap LFSR with length 0!) ****
                      NULL_2TAP, #  1 # **** [0] represents the invalid entry (can't have an 2-tap LFSR with length 0!) ****
                      [ 2,  1],  #  2 # 4,
                      [ 3,  2],  #  3 # 8,
                      [ 4,  3],  #  4 # 16,
                      [ 5,  3],  #  5 # 32,
                      [ 6,  5],  #  6 # 64,
                      [ 7,  6],  #  7 # 128,
                      NULL_2TAP, #  8 # 256,
                      [ 9,  5],  #  9 # 512,
                      [10,  7],  # 10 # 1024,
                      [11,  9],  # 11 # 2048,
                      NULL_2TAP, # 12 # 4096,
                      NULL_2TAP, # 13 # 8192,
                      NULL_2TAP, # 14 # 16384,
                      [15, 14],  # 15 # 32768,
                      NULL_2TAP, # 16 # 65536,
                      [17, 14],  # 17 # 131072,
                      [18, 11],  # 18 # 262144,
                      NULL_2TAP, # 19 # 524288,
                      [20, 17],  # 20 # 1048576,
                      [21, 19],  # 21 # 2097152,
                      [22, 21],  # 22 # 4194304,
                      [23, 18],  # 23 # 8388608,
                      NULL_2TAP, # 24 # 16777216,
                      [25, 22],  # 25 # 33554432,
                      NULL_2TAP, # 26 # 67108864,
                      NULL_2TAP, # 27 # 134217728,
                      [28, 25],  # 28 # 268435456,
                      [29, 27],  # 29 # 536870912,
                      NULL_2TAP, # 30 # 1073741824,
                      [31, 28],  # 31 # 2147483648,
                      NULL_2TAP, # 32 # 4294967296,
                      [33, 20],  # 33 # 8589934592,
                      NULL_2TAP, # 34 # 17179869184,
                      [35, 33],  # 35 # 34359738368,
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

    # **** this table uses 1-based taps, thus SIZE..1, not (SIZE-1)..0

    LFSR_4TAP  =  [
                      NULL_4TAP,          #  0 # **** [0] represents the invalid entry (can't have an 4-tap LFSR with length 0!) ****
                      NULL_4TAP,          #  1 # **** [0] represents the invalid entry (can't have an 4-tap LFSR with length 1!) ****
                      NULL_4TAP,          #  2 # **** [0] represents the invalid entry (can't have an 4-tap LFSR with length 2!) ****
                      NULL_4TAP,          #  3 # **** [0] represents the invalid entry (can't have an 4-tap LFSR with length 3!) ****
                      NULL_4TAP,          #  4 #
                      [ 5,  4,  3,  2],   #  5 # 32,
                      [ 6,  5,  3,  2],   #  6 # 64,
                      [ 7,  6,  5,  4],   #  7 # 128,
                      [ 8,  6,  5,  4],   #  8 # 256,
                      [ 9,  8,  6,  5],   #  9 # 512,
                      [10,  9,  7,  6],   # 10 # 1024,
                      [11, 10,  9,  7],   # 11 # 2048,
                      [12, 11,  8,  6],   # 12 # 4096,
                      [13, 12, 10,  9],   # 13 # 8192,
                      [14, 13, 11,  9],   # 14 # 16384,
                      [15, 14, 13, 11],   # 15 # 32768,
                      [16, 14, 13, 11],   # 16 # 65536,
                      [17, 16, 15, 14],   # 17 # 131072,
                      [18, 17, 16, 13],   # 18 # 262144,
                      [19, 18, 17, 14],   # 19 # 524288,
                      [20, 19, 16, 14],   # 20 # 1048576,
                      [21, 20, 19, 16],   # 21 # 2097152,
                      [22, 19, 18, 17],   # 22 # 4194304,
                      [23, 22, 20, 18],   # 23 # 8388608,
                      [24, 23, 21, 20],   # 24 # 16777216,
                      [25, 24, 23, 22],   # 25 # 33554432,
                      [26, 25, 24, 20],   # 26 # 67108864,
                      [27, 26, 25, 22],   # 27 # 134217728,
                      [28, 27, 24, 22],   # 28 # 268435456,
                      [29, 28, 27, 25],   # 29 # 536870912,
                      [30, 29, 26, 24],   # 30 # 1073741824,
                      [31, 30, 29, 28],   # 31 # 2147483648,
                      [32, 30, 26, 25],   # 32 # 4294967296,
                      [33, 32, 29, 27],   # 33 # 8589934592,
                      [34, 31, 30, 26],   # 34 # 17179869184,
                      [35, 34, 28, 27],   # 35 # 34359738368,
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
        Test
    end # enum

    ##################
    ##################

    class Option_State
        include JSON::Serializable

        property  what
        property  language

        property  type
        property  lfsr_init_value
        property  lfsr_length_bound
        property  lfsr_length_max
        property  lfsr_length_size

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
        @lfsr_init_value    : Int32             # could be inadequate; instead, could be an array of non-zero bits which should be set using a generated sequence of (1 << a[i]) | ...
        @lfsr_length_bound  : Int32
        @lfsr_length_max    : Int32
        @lfsr_length_size   : Int32

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
            @lfsr_init_value    = 0
            @lfsr_length_bound  = 0
            @lfsr_length_max    = 0
            @lfsr_length_size   = 0

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

                  when "test"
                    @what  = Generate::Test

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

            # kwr::WARN!!!! this test only works for a two-tap configuration; it fails for a four-tap configuration (but is verified later during generation????)
            #if ((@lfsr_length_max < 2) || (@lfsr_length_max > @tap_table_max))
            if ((@lfsr_length_max < 2) || (@lfsr_length_bound < 2))
                puts "LFSR length maximum #{@lfsr_length_max} and bound #{@lfsr_length_bound} must be at least 2"
                exit -1
            end # if

            #########

            #if (@n_taps != @tap_table_n_taps)
            #    puts "LFSR taps #{@n_taps} must match tap-table taps #{@tap_table_n_taps}b LFSR"
            #    exit -1
            #end # if

            #########

            if (@lfsr_init_value == 0)
                puts "LFSR initial value #{@lfsr_init_value} must be specified (and be non-zero!)"
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

            #which_taps  = @tap_table[@lfsr_length_max]
            #if (which_taps == @tap_table_null)
            #    puts "There is no valid LSFR of length #{@lfsr_length_max} with #{@n_taps} taps"
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
                    puts "Don't know how to generate modules RTL for #{lang}"
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
                    puts "Don't know how to generate logic RTL for #{lang}"
                    exit -1
                end # case

              when Generate::Test
                case (lang)
                  when Language::Verilog
                    Verilog_Generator        .generate_test(gen_opts)

                  when Language::SystemVerilog
                    SystemVerilog_Generator  .generate_test(gen_opts)

                  when Language::VHDL
                    VHDL_Generator           .generate_test(gen_opts)

                  else
                    puts "Don't know how to generate test RTL for #{lang}"
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

            lfsr_length_bound  = gen_opts.lfsr_length_bound

            # kwr::QUERY??? should we instead cap it at the maximum size and warn the user?
            if (lfsr_length_bound > tap_table_max)
                puts "LFSR length #{lfsr_length_bound} is greater than the tap-table maximum length #{tap_table_max}"
                exit -1
            end

            case (gen_opts.type)
              when Type::Fibonacci
                lfsr_length_max   = gen_opts.lfsr_length_max
                lfsr_length_size  = gen_opts.lfsr_length_size

                puts "module generate_mask_fibonacci_#{n_taps}_taps"
                puts "("
                puts "    input       [#{lfsr_length_size - 1}:0]    lfsr_length,"

                puts ""

                puts "    output reg  [#{lfsr_length_max  - 1}:0]   mask_value,"
                puts "    output reg           mask_valid"
                puts ");"

                puts ""

                puts "    always @(*)"
                puts "    begin"
                puts "        case (lfsr_length)"

                in_lb   = 0
                in_ub   = imin(lfsr_length_max, lfsr_length_bound) - 1

                in_lb.upto(in_ub) \
                do | i |
                    if (i > tap_table_max)
                        puts "Unexpected invalid LFSR length #{i} > #{tap_table_max}"
                    end # if

                    taps  = tap_table[i]

                    if (taps != tap_table_null)
                        valid  = 1

                    else
                        taps   = [] of Int32                                         # no taps...
                        valid  = 0
                    end # if

                    # kwr::FIXME!!!! inefficient code…
                    # generate the mask inefficiently due to crystal strings behavior
                    # as this approach generates ~lfsr_length_max strings
                    # which could be done quicker by testing for index inclusion in the taps array
                    # but … this version seems to work … which is good enough for now!

                    mask  = "0" * lfsr_length_max

                    # **** the tables use 1-based taps, thus SIZE..1, not (SIZE-1)..0
                    taps.each { | t | mask  = mask.sub(lfsr_length_max - t, "1"); }

                    # kwr::HACK!!!! fixes layout for two digits…
                    if (i < 10)
                        puts "               #{lfsr_length_size}'d0#{i} : begin mask_value  <= #{lfsr_length_max}'b#{mask}; mask_valid  = #{valid}; end"
                    else
                        puts  "               #{lfsr_length_size}'d#{i} : begin mask_value  <= #{lfsr_length_max}'b#{mask}; mask_valid  = #{valid}; end"
                    end # if
                end # do

                out_lb  = in_ub + 1
                out_ub  = lfsr_length_bound - 1

                #mask    = "x" * lfsr_length_max                                                  # could we get hugely-better results with casex and "x"?
                mask    = "0" * lfsr_length_max

                out_lb.upto(out_ub) \
                do | i |
                    # kwr::HACK!!!! fixes layout for two digits…
                    if (i < 10)
                        puts "               #{lfsr_length_size}'d0#{i} : begin mask_value  <= #{lfsr_length_max}'b#{mask}; mask_valid  = 0; end"
                    else
                        puts "               #{lfsr_length_size}'d#{i} : begin mask_value  <= #{lfsr_length_max}'b#{mask}; mask_valid  = 0; end"
                    end # if
                end # do

                puts "             default : begin mask_value  <= #{lfsr_length_max}'b#{mask}; mask_valid  = 0; end"
                puts "        endcase"
# puts "$display(#{DQ}$$$$ n_taps=#{n_taps} lfsr_length=%d, mask_value=0b%064b mask_valid=0b%b#{DQ}, lfsr_length, mask_value, mask_valid);"
                puts "    end"
                puts "endmodule"

              # when Type::Galois
              #   # TBD....

              else
                puts "Feedback type #{gen_opts.type} unimplemented"
                exit -1
            end # case type
        end # def self.generate_modules_feedback_mask

        #########

        def self.generate_modules_shift_register(gen_opts)
            clock_symbol      = gen_opts.clock_symbol
            clock_polarity    = gen_opts.clock_polarity

            reset_symbol      = gen_opts.reset_symbol
            reset_polarity    = gen_opts.reset_polarity

            lfsr_length_max   = gen_opts.lfsr_length_max
            lfsr_length_size  = gen_opts.lfsr_length_size
            lfsr_init_value   = gen_opts.lfsr_init_value

            puts "module lfsr_fibonacci"
            puts "("
            puts "    input                 clk,"
            puts "    input                 rst_n,"

            puts "    input                 lfsr_hold,"
            puts "    input        [#{lfsr_length_size - 1}:0]    lfsr_length,"
            puts "    input                 lfsr_n_taps,"

            puts "    input       [#{lfsr_length_max  - 1}:0]    lfsr_value_prev,"
            puts "    input                 lfsr_valid_prev,"

            puts ""

            puts "    output reg  [#{lfsr_length_max - 1}:0]    lfsr_value,"
            puts "    output reg            lfsr_valid"
            puts ");"

            puts ""

            puts "    wire        [#{lfsr_length_max - 1}:0]    mask_value_2_taps;"
            puts "    wire                  mask_valid_2_taps;"

            puts ""

            puts "    generate_mask_fibonacci_2_taps    gmf2t"
            puts "    ("
            puts "        .lfsr_length(lfsr_length),"
            puts "        .mask_value(mask_value_2_taps),"
            puts "        .mask_valid(mask_valid_2_taps)"
            puts "    );"

            puts "    wire        [#{lfsr_length_max - 1}:0]    mask_value_4_taps;"
            puts "    wire                  mask_valid_4_taps;"

            puts ""

            puts "    generate_mask_fibonacci_4_taps    gmf4t"
            puts "    ("
            puts "        .lfsr_length(lfsr_length),"
            puts "        .mask_value(mask_value_4_taps),"
            puts "        .mask_valid(mask_valid_4_taps)"
            puts "    );"

            puts ""

            puts "    reg         [#{lfsr_length_max - 1}:0]    mask_value;"
            puts "    reg                   mask_valid;"

            puts ""

            puts "    always @(*)"
            puts "    begin"
            puts "        if      (lfsr_n_taps)"
            puts "          begin"
            puts "            mask_value  <= mask_value_4_taps;"
            puts "            mask_valid  <= mask_valid_4_taps;"
            puts "          end"
            puts "        else"
            puts "          begin"
            puts "            mask_value  <= mask_value_2_taps;"
            puts "            mask_valid  <= mask_valid_2_taps;"
            puts "          end"
            puts "        // endif"
# puts "$display(#{DQ}$$$$ lfsr_n_taps=0b%0b lfsr_length=%d, mask_value=0b%064b mask_valid=0b%b#{DQ}, lfsr_n_taps, lfsr_length, mask_value, mask_valid);"
            puts "    end"

            puts ""

            puts "    always @(#{polarity?(clock_polarity, pos: "posedge ", neg: "negedge ")}#{clock_symbol} or #{polarity?(reset_polarity, pos: "posedge ", neg: "negedge ")}#{reset_symbol})"
            puts "    begin"

            puts "        if      (lfsr_hold)"
            puts "          begin"
puts "$display(#{DQ}.... .... lfsr hold#{DQ});"
            puts "            lfsr_value  <= lfsr_value_prev;"
            puts "            lfsr_valid  <= lfsr_valid_prev;"
            puts "          end"

            puts "        else if (~mask_valid)"
                                # should lfsr_invalid_value but specified somewhere?
                                # or are all maximal-length lfsr 2^n - 1 with 0 being the only invalid & stable state?
            puts "          begin"
puts "$display(#{DQ}.... .... lfsr mask invalid#{DQ});"
            puts "            lfsr_value  <= #{lfsr_length_max}'d0;"
            puts "            lfsr_valid  <= 0;"
            puts "          end"

            puts "        else if (#{polarity?(reset_polarity, pos: "", neg: "~")}#{reset_symbol})"
                                # should lfsr_init_value be specified in the table (at the 0-length position?) as tap-dependent?
                                # or are all maximal-length lfsr 2^n - 1 with 0 being the only invalid & stable state?
            puts "          begin"
puts "$display(#{DQ}.... .... reset#{DQ});"
            puts "            lfsr_value  <= #{lfsr_length_max}'d#{lfsr_init_value};"
            puts "            lfsr_valid  <= 1;"
            puts "          end"

            puts "        else"
            puts "          begin"
puts "$display(#{DQ}.... .... cycle .... mask_value = 0b%07b#{DQ}, mask_value);"

            puts "            // shift the previous value and add in the computed (reduced) feedback value"
            puts "            lfsr_value  <= { lfsr_value_prev[#{lfsr_length_max - 2}:0], ^(lfsr_value_prev & mask_value) };"
            puts "            lfsr_valid  <= 1;"
            puts "          end"
            puts "        // endif"

            puts ""

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
            puts "`endif // _tt_kwr_lfsr__modules_"
            puts ""

            puts "// ////////////////////////////////////////////////////////////////////////"
            puts "// @END Modules\n"
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

            lfsr_length_max     = gen_opts.lfsr_length_max

            if (lfsr_length_max > 64)
                puts "Logic implementation assumes no more than 6 bits which limits LFSR length to 64b, provided #{lfsr_length_max}b"
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

            puts "    wire    [5:0]     lfsr_length_max;"
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
            puts "        uio_oe           = 8b1111_1111;"
            #puts "    end"
            puts ""
            #puts "    always (*)"
            #puts "    begin"
            # should there be a lsfr_load to latch length and type?
            puts "        lfsr_length_max  = ui_in[5:0];"       # should we latch this one?
            puts "        lfsr_type        = ui_in[6];"         # we don't care for the moment, but should we latch this one?
            puts "        lfsr_hold        = ui_in[7];"

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
            puts "`endif // _tt_kwr_lfsr__logic_"
            puts ""

            puts "// ////////////////////////////////////////////////////////////////////////"
            puts "// @END Logic\n"
            puts "// ////////////////////////////////////////////////////////////////////////"
        end # def generate_logic

        #########

        def self.generate_test(gen_opts) : Nil
            clock_symbol      = gen_opts.clock_symbol
            clock_polarity    = gen_opts.clock_polarity

            reset_symbol      = gen_opts.reset_symbol
            reset_polarity    = gen_opts.reset_polarity

            lfsr_length_max   = gen_opts.lfsr_length_max
            lfsr_length_size  = gen_opts.lfsr_length_size
            lfsr_init_value   = gen_opts.lfsr_init_value

            lfsr_length       = 7
            lfsr_value_prev   = 0x69        # “random” 7b value…
            lfsr_value_mask   = 2**lfsr_length - 1

            puts "// ////////////////////////////////////////////////////////////////////////"
            puts "// @BEGIN Test\n"
            puts "// ////////////////////////////////////////////////////////////////////////"

            puts ""
            puts "`ifndef _tt_kwr_lfsr__test_"
            puts "`define _tt_kwr_lfsr__test_"
            puts ""

            puts "// ////////////////////////////////////////////////////////////////////////"
            puts "// ////////////////////////////////////////////////////////////////////////"

            puts ""

            puts "// ... test code goes here ...."
            puts ""

            puts "module test;"

            puts "    reg                   clk;"
            puts "    reg                   rst_n;"

            puts "    reg                   lfsr_hold;"
            puts "    reg          [#{lfsr_length_size - 1}:0]    lfsr_length;"
            puts "    reg                   lfsr_n_taps;"

            puts "    reg         [#{lfsr_length_max  - 1}:0]    lfsr_value_prev;"

            puts ""

            puts "    wire        [#{lfsr_length_max - 1}:0]    lfsr_value;"
            puts "    wire                  lfsr_valid;"

            puts ""

            puts "    lfsr_fibonacci    lf"
            puts "    ("
            puts "        .clk(clk),"
            puts "        .rst_n(rst_n),"
            puts "        .lfsr_hold(lfsr_hold),"
            puts "        .lfsr_length(lfsr_length),"
            puts "        .lfsr_n_taps(lfsr_n_taps),"
            puts "        .lfsr_value_prev(lfsr_value_prev),"
            puts "        .lfsr_value(lfsr_value),"
            puts "        .lfsr_valid(lfsr_valid)"
            puts "    );"

            puts ""

            puts "    integer               cycle;"

            puts ""

            puts "    initial"
            puts "    begin"

            puts "        cycle             = 0;"
            puts "        $display(#{DQ}#### cycle = %d#{DQ}, cycle);"

            puts "        clk               = 0;"
            puts "        rst_n             = 1;"
            puts "        $display(#{DQ}#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value_prev = 0b%0#{lfsr_length}b, lfsr_value = 0b%0#{lfsr_length}b#{DQ}, cycle, clk, rst_n, lfsr_valid, lfsr_value_prev & #{lfsr_value_mask}, lfsr_value & #{lfsr_value_mask});"

            puts ""

            puts "        lfsr_hold         = 0;"
            puts "        lfsr_length       = #{lfsr_length_size}'d#{lfsr_length};"
            puts "        lfsr_n_taps       = 0;"
            puts "        lfsr_value_prev   = #{lfsr_length_max}'d#{lfsr_value_prev};"

            puts ""

            puts "        #50;"
            puts "        rst_n             = 0;"
            puts "        $display(#{DQ}#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value_prev = 0b%0#{lfsr_length}b, lfsr_value = 0b%0#{lfsr_length}b#{DQ}, cycle, clk, rst_n, lfsr_valid, lfsr_value_prev & #{lfsr_value_mask}, lfsr_value & #{lfsr_value_mask});"
            puts "        #50;"
            puts "        clk               = 1;"
            puts "        $display(#{DQ}#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value_prev = 0b%0#{lfsr_length}b, lfsr_value = 0b%0#{lfsr_length}b#{DQ}, cycle, clk, rst_n, lfsr_valid, lfsr_value_prev & #{lfsr_value_mask}, lfsr_value & #{lfsr_value_mask});"
            puts "        lfsr_value_prev   = lfsr_value;"

            puts ""

            puts "        #100;"
            puts "        clk               = 0;"
            puts "        $display(#{DQ}#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value_prev = 0b%0#{lfsr_length}b, lfsr_value = 0b%0#{lfsr_length}b#{DQ}, cycle, clk, rst_n, lfsr_valid, lfsr_value_prev & #{lfsr_value_mask}, lfsr_value & #{lfsr_value_mask});"

            puts ""

            puts "        #100;"
            puts "        clk               = 1;"
            puts "        $display(#{DQ}#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value_prev = 0b%0#{lfsr_length}b, lfsr_value = 0b%0#{lfsr_length}b#{DQ}, cycle, clk, rst_n, lfsr_valid, lfsr_value_prev & #{lfsr_value_mask}, lfsr_value & #{lfsr_value_mask});"
            puts "        lfsr_value_prev   = lfsr_value;"

            puts ""

            puts "        #100;"
            puts "        clk               = 0;"
            puts "        $display(#{DQ}#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value_prev = 0b%0#{lfsr_length}b, lfsr_value = 0b%0#{lfsr_length}b#{DQ}, cycle, clk, rst_n, lfsr_valid, lfsr_value_prev & #{lfsr_value_mask}, lfsr_value & #{lfsr_value_mask});"

            puts ""

            puts "        #100;"
            puts "        clk               = 1;"
            puts "        $display(#{DQ}#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value_prev = 0b%0#{lfsr_length}b, lfsr_value = 0b%0#{lfsr_length}b#{DQ}, cycle, clk, rst_n, lfsr_valid, lfsr_value_prev & #{lfsr_value_mask}, lfsr_value & #{lfsr_value_mask});"
            puts "        lfsr_value_prev   = lfsr_value;"

            puts ""

            puts "        #50;"
            puts "        rst_n             = 1;"
            puts "        $display(#{DQ}#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value_prev = 0b%0#{lfsr_length}b, lfsr_value = 0b%0#{lfsr_length}b#{DQ}, cycle, clk, rst_n, lfsr_valid, lfsr_value_prev & #{lfsr_value_mask}, lfsr_value & #{lfsr_value_mask});"
            puts "        #50;"
            puts "        clk               = 0;"
            puts "        $display(#{DQ}#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value_prev = 0b%0#{lfsr_length}b, lfsr_value = 0b%0#{lfsr_length}b#{DQ}, cycle, clk, rst_n, lfsr_valid, lfsr_value_prev & #{lfsr_value_mask}, lfsr_value & #{lfsr_value_mask});"

            puts ""

            puts "    end"

            puts ""

            puts "    always"
            puts "    begin"

            puts "        cycle             = cycle + 1;"

            puts ""

            puts "        if (cycle > 100)    $finish;"

            puts ""

            puts "        #100;"
            puts "        clk               = 1;"
            puts "        $display(#{DQ}#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value_prev = 0b%0#{lfsr_length}b, lfsr_value = 0b%0#{lfsr_length}b#{DQ}, cycle, clk, rst_n, lfsr_valid, lfsr_value_prev & #{lfsr_value_mask}, lfsr_value & #{lfsr_value_mask});"
            puts "        lfsr_value_prev   = lfsr_value;"

            puts ""

            puts "        #100;"
            puts "        clk               = 0;"
            puts "        $display(#{DQ}#### cycle = %d, clk = %d, rst_n = %d, lfsr_valid = %d, lfsr_value_prev = 0b%0#{lfsr_length}b, lfsr_value = 0b%0#{lfsr_length}b#{DQ}, cycle, clk, rst_n, lfsr_valid, lfsr_value_prev & #{lfsr_value_mask}, lfsr_value & #{lfsr_value_mask});"

            puts "    end"

            puts "endmodule"

            puts ""

            puts "// ////////////////////////////////////////////////////////////////////////"

            puts ""
            puts "`endif // _tt_kwr_lfsr__test_"
            puts ""

            puts "// ////////////////////////////////////////////////////////////////////////"
            puts "// @END Test\n"
            puts "// ////////////////////////////////////////////////////////////////////////"
        end # def self.generate_test    end # class Verilog_Generator
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

        #########

        def self.generate_test(gen_opts)
            puts "#{self.name}.generate_test(gen_opts) is not implemented"
            exit -1
        end # def self.generate_test
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
        end # def self.generate_logic

        #########

        def self.generate_test(gen_opts)
            puts "#{self.name}.generate_test(gen_opts) is not implemented"
            exit -1
        end # def self.generate_test
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
        parser.banner = "Welcome to the #{TOOL_DESCRIPTOR}!"

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
                options.lfsr_init_value    = itest
            end # if

            generated            = false
        end # parser.on "-L"

        #########

        parser.on "-n N", "--width=N", "Specify (maximum) LFSR width" \
        do | n |
            wtest  = n.to_i?

            if    (wtest.nil?)
                puts "LFSR maximum width must be a smallish integer (provided #{n})"
                exit -1

            else
                options.lfsr_length_bound  = wtest

                # there's certainly a trivial-enough mathematical approach
                #     width  = log2(wtest).ceil
                #     bound  = 1 << (width - 1)
                # but i don't wan't to figure out how to do it (and debug it) in crystal right now.

                if    (wtest <=  2)
                    options.lfsr_length_size   =  1
                    options.lfsr_length_max    =  2

                elsif (wtest <=  4)
                    options.lfsr_length_size   =  2
                    options.lfsr_length_max    =  4

                elsif (wtest <=  8)
                    options.lfsr_length_size   =  3
                    options.lfsr_length_max    =  8

                elsif (wtest <= 16)
                    options.lfsr_length_size   =  4
                    options.lfsr_length_max    = 16

                elsif (wtest <= 32)
                    options.lfsr_length_size   =  5
                    options.lfsr_length_max    = 32

                elsif (wtest <= 64)
                    options.lfsr_length_size   =  6
                    options.lfsr_length_max    = 64

                else
                    puts "LFSR (maximum) width #{wtest} is greater than 64 (exceeds 6 bits) which is not supported by the current RTL model"
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

    # puts "ARGV      => #{ARGV}"
    # puts "ARGV.size => #{ARGV.size}"

    if (ARGV.size == 0)
        puts "#{TOOL_DESCRIPTOR}: must specify generator options in command line"
        puts "#{TOOL_DESCRIPTXX}      e.g., crystal run --error-trace lfsr.cr -- -Hv -i1 -n34 -C +clk -R -rst_n -L lfsr -T fib --generate modules --generate logic --generate test"
        puts ""
        puts parser
        exit -1
    end

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
# end module ???
########################################################################
########################################################################
