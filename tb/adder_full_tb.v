module adder_full_tb;
    reg a, b, cin;
    wire sum, cout;
    reg expected_sum, expected_cout;
    integer i;
    integer errors;

    adder_full DUT (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    initial begin
        errors = 0;

        for (i = 0; i < 8; i = i + 1) begin
            {a, b, cin} = i;
            #10;

            expected_sum = a ^ b ^ cin;
            expected_cout = (a & b) | (cin & (a ^ b));

            if (sum !== expected_sum || cout !== expected_cout) begin
                $display("FAIL: a=%b b=%b cin=%b | sum=%b (exp %b) cout=%b (exp %b)", 
                a, b, cin, sum, expected_sum, cout, expected_cout);
                errors = errors + 1;
            end
            /*
            else begin
                $display("PASS: a=%b b=%b cin=%b | sum=%b cout=%b", a, b, cin, sum, cout);
            end
            */
        end

        if (errors == 0) begin
            $display("ALL TESTS PASSED");
        end
        else begin
            $display("%0d TESTS FAILED", errors);
        end

        $finish;
    end
endmodule