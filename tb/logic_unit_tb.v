module logic_unit_tb;
    reg [7:0] a,b;
    reg [2:0] logic_op;
    wire [7:0] data_out;
    integer i;
    integer i2;
    integer errors;
    reg [7:0] expected;

    logic_unit DUT (.a(a), .b(b), .logic_op(logic_op), .data_out(data_out));

    initial begin
        errors = 0;

        // Dump waveforms
        $dumpfile("logic_unit_tb.vcd");
        $dumpvars(0, logic_unit_tb);

        for (i = 0; i < 100; i = i + 1) begin
            for (i2 = 0; i2 < 7; i2 = i2 + 1) begin
                test_case($random, $random, i2);
            end
        end

        if (errors == 0) begin
            $display("ALL TESTS PASSED");
        end
        else begin
            $display("%0d TESTS FAILED", errors);
        end

        $finish;
    end

    task test_case (input [7:0] ta, input [7:0] tb, input [2:0] tlogic_op);
        begin
            a = ta;
            b = tb;
            logic_op = tlogic_op;
            #10;

            case (logic_op)
                3'b000: expected = a & b;
                3'b001: expected = ~(a & b);
                3'b010: expected = a | b;
                3'b011: expected = ~(a | b);
                3'b100: expected = a ^ b;
                3'b101: expected = ~(a ^ b);
                3'b110: expected = ~a;
                default: expected = 8'b0;
            endcase

            if (data_out !== expected) begin
                $display("FAIL: a=%b b=%b | expected=%b | output %b", 
                    a, b, expected, data_out);
                errors = errors + 1; 
            end
        end
    endtask
endmodule