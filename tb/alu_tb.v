module alu_tb;
    reg [7:0] a, b;
    reg [4:0] opcode;
    reg [2:0] shift_amount;
    wire overflow_flag, carry_flag, zero_flag, negative_flag;
    wire [7:0] result;
    reg [7:0] expected;
    integer i;
    integer errors;

    alu DUT (
    .a(a),
    .b(b), 
    .opcode(opcode), 
    .shift_amount(shift_amount),
    .result(result));

    // ALU operation codes
    localparam ALU_ADD  = 5'd0;   // Add
    localparam ALU_INC  = 5'd1;   // Increment
    localparam ALU_SUB  = 5'd2;   // Subtract
    localparam ALU_DEC  = 5'd3;   // Decrement
    localparam ALU_NEG  = 5'd4;   // Two's complement
    localparam ALU_AND  = 5'd5;   // AND
    localparam ALU_NAND = 5'd6;   // NAND (AND + NOT)
    localparam ALU_OR   = 5'd7;   // OR
    localparam ALU_NOR  = 5'd8;   // NOR (OR + NOT)
    localparam ALU_XOR  = 5'd9;   // XOR
    localparam ALU_XNOR = 5'd10;  // XNOR (NOT + XOR)
    localparam ALU_NOT  = 5'd11;  // NOT
    localparam ALU_MOV  = 5'd12;  // Passthrough
    localparam ALU_LSL  = 5'd13;  // Logical shift left
    localparam ALU_LSR  = 5'd14;  // Logical shift right
    localparam ALU_ASR  = 5'd15;  // Arithmetic shift right
    localparam ALU_ROL  = 5'd16;  // Rotate left
    localparam ALU_ROR  = 5'd17;  // Rotate right
    localparam ALU_GT   = 5'd18;  // Greater than (bool)
    localparam ALU_GE   = 5'd19;  // Greater than or equal (bool)
    localparam ALU_LT   = 5'd20;  // Less than (bool)
    localparam ALU_LE   = 5'd21;  // Less than or equal (bool)
    localparam ALU_EQ   = 5'd22;  // Equals (bool)
    localparam ALU_NE   = 5'd23;  // Not equal (bool)

    initial begin
        errors = 0;

        // Dump waveforms
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, adder_8bit_tb);

        // Random testing
        for (i = 0; i < 100; i = i + 1) begin
            for (op = 0; op < 24; op = op + 1) begin
                test_case($random, $random, op, $random);
            end
        end

        if (errors == 0) begin
            $display("ALL TESTS PASSED");
        end
        else begin
            $display("%0d TESTS FAILED", errors);
        end

        $finish
    end

    task test_case(
        input [7:0] ta, 
        input [7:0] tb, 
        input [4:0] topcode, 
        input [2:0] tshift_amount);
        begin
            a = ta;
            b = tb;
            opcode = topcode;
            shift_amount = tshift_amount;
            
            expected = 0;

            case (opcode)
                ALU_ADD:  expected = (a + b);
                ALU_INC:  expected = (a + 1);
                ALU_SUB:  expected = (a - b);
                ALU_DEC:  expected = (a - 1);
                ALU_NEG:  expected = ~a;
                ALU_AND:  expected = (a & b);
                ALU_NAND: expected = ~(a & b);
                ALU_OR:   expected = (a | b);
                ALU_NOR:  expected = ~(a | b);
                ALU_XOR:  expected = (a ^ b);
                ALU_XNOR: expected = ~(a ^ b);
                ALU_NOT:  expected = ~a;
                ALU_MOV:  expected = a;
                ALU_LSL:  expected = (a << shift_amount);
                ALU_LSR:  expected = (a >> shift_amount);
                ALU_ASR:  expected = $signed(a) >>> shift_amount;
                ALU_ROL:  expected = (a << shift_amount) | (a >> (8 - shift_amount));
                ALU_ROR:  expected = (a >> shift_amount) | (a << (8 - shift_amount));
                ALU_GT:   expected = (a > b);
                ALU_GE:   expected = (a >= b);
                ALU_LT:   expected = (a < b);
                ALU_LE:   expected = (a <= b);
                ALU_EQ:   expected = (a == b);
                ALU_NE:   expected = (a != b);
                default:  expected = 8'b0;
            endcase

            if (result != expected) begin
                errors = errors + 1;
            end
        end
    endtask
endmodule