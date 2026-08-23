module logic_unit(
    input [7:0] a, b,
    input [2:0] logic_op,
    output reg [7:0] data_out
);

    wire [7:0] and_out, nand_out, or_out, nor_out, xor_out, xnor_out, not_out;

    assign and_out = a & b;
    assign nand_out = ~(a & b);
    assign or_out = a | b;
    assign nor_out = ~(a | b);
    assign xor_out = a ^ b;
    assign xnor_out = ~(a ^ b);
    assign not_out = ~a;

    always @(*) begin
        case (logic_op)
            3'b000: data_out = and_out;
            3'b001: data_out = nand_out;
            3'b010: data_out = or_out;
            3'b011: data_out = nor_out;
            3'b100: data_out = xor_out;
            3'b101: data_out = xnor_out;
            3'b110: data_out = not_out;
            default: data_out = 8'b0;
        endcase
    end
endmodule