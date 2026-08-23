module shifter_tb;
    reg [7:0] data_in;
    reg [2:0] shift_amount, shift_op;
    wire [7:0] data_out;
    integer i;

    shifter DUT (.data_in(data_in), .shift_amount(shift_amount), .shift_op(shift_op), .data_out(data_out));

    initial begin
        // Dump waveforms
        $dumpfile("shifter_tb.vcd");
        $dumpvars(0, shifter_tb);

        // LSL (0), LSR (1), ROL (3), ROR (4)
        for (i = 0; i < 5; i = i + 1) begin

            if (i !== 2) begin
                test_case($random, 0, i);
                test_case($random, 1, i);
                test_case($random, 4, i);
                test_case($random, 7, i);
            end
            else begin // ASR (2) requires checking for sign being kept
                test_case($random | 8'b10000000, 0, i); // Force msb to 1
                test_case($random | 8'b10000000, 1, i);
                test_case($random | 8'b10000000, 4, i);
                test_case($random | 8'b10000000, 7, i);
                test_case($random & 8'b01111111, 0, i); // Force msb to 0
                test_case($random & 8'b01111111, 1, i);
                test_case($random & 8'b01111111, 4, i);
                test_case($random & 8'b01111111, 7, i);
            end
        end
        $finish;
    end

    task test_case(input [7:0] in, input [2:0] sa, input [2:0] op);
        begin
            data_in = in;
            shift_amount = sa;
            shift_op = op;
            #10;

            $display("OPERATION: %d | SHIFT AMOUNT: %d | INPUT: %b | OUTPUT: %b",
                shift_op, shift_amount, data_in, data_out [7:0]);
        end
    endtask

endmodule