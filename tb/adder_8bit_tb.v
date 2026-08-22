module adder_8bit_tb;
    reg [7:0] a, b;
    reg cin;
    wire [7:0]sum;
    wire cout;
    reg [8:0] expected;
    integer i;
    integer errors;

    adder_8bit DUT (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    initial begin
        errors = 0;

        // dump waveforms
        $dumpfile("adder_8bit_tb.vcd");
        $dumpvars(0, adder_8bit_tb);

        // 1. Directed edge cases
        test_case(8'h00, 8'h00, 1'b0);   // 0 + 0
        test_case(8'hFF, 8'h00, 1'b0);   // max + 0
        test_case(8'hFF, 8'h01, 1'b0);   // overflow case
        test_case(8'hFF, 8'hFF, 1'b1);   // max + max + carry-in
        test_case(8'h80, 8'h80, 1'b0);   // MSB-only overflow case

        // 2. Randomized testing
        for (i = 0; i < 1000; i = i + 1) begin
            test_case($random, $random, $random);
        end

        if (errors == 0) begin
            $display("ALL TESTS PASSED");
        end
        else begin
            $display("%0d TESTS FAILED", errors);
        end

        $finish;
    end

    task test_case(input [7:0] ta, input [7:0] tb, input tcin);
        begin
            a = ta;
            b = tb;
            cin = tcin;
            #10;

            expected = a + b + cin;

            if ({cout, sum} !== expected) begin
                $display("FAIL: a=%d b=%d cin=%b | sum=%d (exp %d) cout=%b (exp %b)", 
                    a, b, cin, sum, expected[7:0], cout, expected[8]);
                errors = errors + 1; 
            end
            /*
            else begin
                $display("PASS: a=%d b=%d cin=%b | sum=%d cout=%b", 
                    a, b, cin, sum, cout);
            end
            */
        end
    endtask
endmodule