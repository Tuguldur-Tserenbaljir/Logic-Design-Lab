`timescale 1ns / 1ps

module Lab4_Team6_Mealy_Sequence_Detector_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg in = 1'b0;
wire dec;
wire [3:0] state;

Mealy_Sequence_Detector MSD(
    .clk(clk),
    .rst_n(rst_n),
    .in(in),
    .dec(dec),
    .state(state)
    );
    
parameter cyc = 5;
always #(cyc) clk = ~clk;

initial begin
    @(negedge clk) rst_n = 1'b0;
    @(negedge clk) rst_n = 1'b1;
    //Given Waveform
    @(posedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    //
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    //
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    //
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    
    #10 $finish;
end
endmodule
