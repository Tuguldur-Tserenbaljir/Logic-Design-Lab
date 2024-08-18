`timescale 1ns / 1ps

module Sliding_Window_Sequence_Detector_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg in = 1'b0;
wire dec;


Sliding_Window_Sequence_Detector SWSD(
    .clk(clk),
    .rst_n(rst_n),
    .in(in),
    .dec(dec)
    );
    
parameter cyc = 5;
always #(cyc) clk = ~clk;

initial begin
    @(negedge clk) rst_n = 1'b0;
    @(negedge clk) rst_n = 1'b1;
    //Given Waveform
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    //Sequence dec == 1;
  
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    
    @(negedge clk) rst_n = 1'b0;
    @(negedge clk) rst_n = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    
    #10 $finish;
end
endmodule
