`timescale 1ns / 1ps

module FIFO_t;
    reg clk = 1'b0, rst_n = 1'b0, ren = 1'b0, wen = 1'b0;
    reg[7:0] din = 1'b0;
    
    wire[7:0] dout;
    wire error;
    
    FIFO_8 V(
        .clk(clk),
        .rst_n(rst_n),
        .wen(wen),
        .ren(ren),
        .din(din),
        .dout(dout),
        .error(error)
    );
    
    always #1 clk = ~clk;
    
    initial begin
        @(negedge clk) rst_n = 1'b1; 
        
        @(negedge clk) wen = 1'b1;
        repeat(2 ** 4) begin
            #2 din = din + 1'b1;
        end 
        
        @(negedge clk) ren = 1'b1;
        
        #20 $finish;
    end

endmodule
