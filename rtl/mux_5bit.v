module mux_5bit (
    input [255:0] data_in,
    input [4:0] sel,
    output [7:0] data_out
);
    assign data_out = data_in[(sel * 8) +: 8];
endmodule