`timescale 1ns / 1ps

module Ping_Pong_Counter_t;
    reg clk = 1'b0, rst_n = 1'b0, enable = 1'b0;
    wire direction;
    wire[3:0] out;

    Ping_Pong_Counter pingpong(
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .direction(direction),
        .out(out)
    );
    
always #1 clk = !clk;
    
    initial begin
        @(negedge clk)rst_n = 1'b1;
        @(negedge clk)enable = 1'b1;
        #200 $finish;
    end
    
endmodule
