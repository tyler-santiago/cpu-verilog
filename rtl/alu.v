module alu (
    input [7:0] a, b,
    input [4:0] opcode,
    input [2:0] shift_amount,
    output reg overflow_flag, carry_flag,
    output zero_flag, negative_flag,
    output [7:0] result
);
    wire cout_add, cout_inc, cout_sub, cout_dec, cout_neg;
    wire [255:0] mux_in;
    reg adder_cout;

    assign result = mux_in[opcode * 8 +: 8];

    // 0. ADD (Add)
    adder_8bit a8_add (.a(a), .b(b), .cin(1'b0), .sum(mux_in[7:0]), .cout(cout_add));

    // 1. INC (Increment)
    adder_8bit a8_inc (.a(a), .b(0), .cin(1'b1), .sum(mux_in[15:8]), .cout(cout_inc));

    // 2. SUB (Subtract)
    adder_8bit a8_sub (.a(a), .b(~b), .cin(1'b1), .sum(mux_in[23:16]), .cout(cout_sub));

    // 3. DEC (Decrement)
    adder_8bit a8_dec (.a(a), .b(~8'b00000001), .cin(1'b1), .sum(mux_in[31:24]), .cout(cout_dec));

    // 4. NEG (Two’s complement)
    adder_8bit a8_neg (.a(~a), .b(8'b0), .cin(1'b1), .sum(mux_in[39:32]), .cout(cout_neg));

    // 5. AND
    assign mux_in[47:40] = a & b;

    // 6. NAND
    assign mux_in[55:48] = ~(a & b);

    // 7. OR
    assign mux_in[63:56] = a | b;

    // 8. NOR
    assign mux_in[71:64] = ~(a | b);

    // 9. XOR
    assign mux_in[79:72] = a ^ b;

    // 10. XNOR
    assign mux_in[87:80] = ~(a ^ b);

    // 11. NOT
    assign mux_in[95:88] = ~a;

    // 12. MOV (Passthrough)
    assign mux_in[103:96] = a;

    // 13. LSL (Logical shift left)
    assign mux_in[111:104] = a << shift_amount;

    // 14. LSR (Logical shift right)
    assign mux_in[119:112] = a >> shift_amount;

    // 15. ASR (Arithmetic shift right)
    assign mux_in[127:120] = $signed(a) >>> shift_amount;

    // 16. ROL (Rotate left)
    assign mux_in[135:128] = (a << shift_amount) | (a >> (8 - shift_amount));

    // 17. ROR (Rotate right)
    assign mux_in[143:136] = (a >> shift_amount) | (a << (8 - shift_amount));

    // 18. GT (Greater than – returns bool)
    assign mux_in[151:144] = (a > b);

    // 19. GE (Greater than or equal to – returns bool)
    assign mux_in[159:152] = (a >= b);

    // 20. LT (Less than – returns bool)
    assign mux_in[167:160] = (a < b);

    // 21. LE (Less than or equal to – returns bool)
    assign mux_in[175:168] = (a <= b);

    // 22. EQ (Equals – returns bool)
    assign mux_in[183:176] = (a == b);

    // 23. NE (Not Equal – returns bool)
    assign mux_in[191:184] = (a != b);

    // Overflow flag
    always @(*) begin
        case (opcode)
            5'b00000, 5'b00001:
                overflow_flag = ((a[7] == b[7]) && (result[7] != a[7]));
            5'b00010, 5'b00011, 5'b00100:
                overflow_flag = ((a[7] != b[7]) && (result[7] != a[7]));
            default: overflow_flag = 1'b0;
        endcase
    end

    // Carry flag
    always @(*) begin
        case (opcode)
            5'b00000: adder_cout = cout_add;
            5'b00001: adder_cout = cout_inc;
            5'b00010: adder_cout = cout_sub;
            5'b00011: adder_cout = cout_dec;
            5'b00100: adder_cout = cout_neg;
            default: adder_cout = 0;
        endcase
    end

    always @(*) begin
        case (opcode)
            5'b00000, 5'b00001, 5'b00010, 5'b00011, 5'b00100:
                carry_flag = adder_cout;
            default: carry_flag = 1'b0;
        endcase
    end

    // Negative flag
    assign negative_flag = result[7];

    // Zero flag
    assign zero_flag = (result == 8'b0);

endmodule