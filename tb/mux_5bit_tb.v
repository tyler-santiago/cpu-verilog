module mux_5bit_tb;
    reg [255:0] test_data;
    reg [4:0] sel;
    wire [7:0] out;
    integer i;
    integer errors;

    mux_5bit DUT (.data_in(test_data), .sel(sel), .data_out(out));

    initial begin
        errors = 0;

        for (i = 0; i < 32; i = i + 1)
            test_data[(i * 8) +: 8] = i;

        for (i = 0; i < 32; i = i + 1) begin // Use i instead of sel to avoid infinite loop due to wraparound (overflow)
            sel = i[4:0];   // Assign the loop counter's value into sel each iteration
            #10;
            if (out !== sel) begin
                $display("FAIL: sel=%0d out=%0d (expected %0d)", sel, out, sel);
                errors = errors + 1;
            end
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TESTS FAILED", errors);

        $finish;
    end
endmodule