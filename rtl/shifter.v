module shifter (
    input [7:0] data_in,
    input [2:0] shift_amount,
    input [2:0] shift_op,
    output reg [7:0] data_out
);

    wire [7:0] result_lsl, result_lsr, result_asr, result_rol, result_ror;

    assign result_lsl = data_in << shift_amount; // LSL (Logical shift left)
    assign result_lsr = data_in >> shift_amount; // LSR (Logical shift right)
    assign result_asr = $signed(data_in) >>> shift_amount; // ASR (Arithmetic shift right)
    assign result_rol = (data_in << shift_amount) | (data_in >> (8 - shift_amount)); // ROL (Rotate left)
    assign result_ror = (data_in >> shift_amount) | (data_in << (8 - shift_amount)); // ROR (Rotate right)

    // Output MUX
    always @(*) begin
        case (shift_op)
            3'b000: data_out = result_lsl;
            3'b001: data_out = result_lsr;
            3'b010: data_out = result_asr;
            3'b011: data_out = result_rol;
            3'b100: data_out = result_ror;
            default: data_out = 8'b0;
        endcase
    end
endmodule