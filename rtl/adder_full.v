module adder_full (
    input a, b, cin, 
    output sum, cout
);
    wire s1, c1, c2;

    adder_half ah1 (.a(a), .b(b), .sum(s1), .cout(c1));
    adder_half ah2 (.a(s1), .b(cin), .sum(sum), .cout(c2));

    assign cout = c1 | c2;
endmodule