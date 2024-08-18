`timescale 1ns/1ps

module Greatest_Common_Divisor_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg start = 1'b0;
reg [15:0] a = 15'd0;
reg [15:0] b = 15'd0;
wire [15:0] gcd;
wire done;

Greatest_Common_Divisor GCD(
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .a(a),
    .b(b),
    .done(done),
    .gcd(gcd)
    );

parameter cyc = 2;
always #(cyc) clk = ~clk;

initial begin 
    @(negedge clk) rst_n = 1'b0;
    @(negedge clk) rst_n = 1'b1;
    @(negedge clk) begin
        start = 1'b1;
        a = 16'd9;
        b = 16'd3;
    end
    @(negedge clk) begin
        a = 16'd5;
        b = 16'd2;
    end

    #50 $finish;
end
endmodule