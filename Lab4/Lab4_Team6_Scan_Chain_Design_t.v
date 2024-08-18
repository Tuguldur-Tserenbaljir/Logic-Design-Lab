`timescale 1ns/1ps

module Scan_Chain_Design_t;  
reg clk = 1'b1;
reg rst_n = 1'b0;
reg scan_in = 1'b0;
reg scan_en = 1'b0;
wire scan_out;

parameter cyc = 10;
always #(cyc/2) clk = ~clk;

Scan_Chain_Design SCD( 
    .clk(clk),
    .rst_n(rst_n),
    .scan_in(scan_in),
    .scan_en(scan_en),
    .scan_out(scan_out)
);

initial begin
    @(negedge clk)
    @(negedge clk) 
    rst_n = 1'b1;
    scan_en = 1'b1;
    scan_in = 1'b1; 
    @(negedge clk) scan_in=1'b1; 
    @(negedge clk) scan_in=1'b1; 
    @(negedge clk) scan_in=1'b1; 
    @(negedge clk) scan_in=1'b1; 
    @(negedge clk) scan_in=1'b1; 
    @(negedge clk) scan_in=1'b1; 
    @(negedge clk) scan_in=1'b1; 
    @(posedge clk) 
    #2
    scan_en=1'b0;
    #cyc
    scan_en=1'b1;
    // Output Multiplier Start Here
    #75
    $finish ;
end

endmodule