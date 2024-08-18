`timescale 1ns / 1ps

 module Toggle_Flip_Flop_t;
    reg
    clk = 1'b0,
    t = 1'b0, 
    rst_n = 1'b0; 
    wire q;
    
 
    
    Toggle_Flip_Flop TFF(
        .clk(clk),
        .t(t),
        .rst_n(rst_n),
        .q(q)
    );
    
    always#(1) clk = clk + 1'b1;
    always begin
        @(negedge clk) begin 
            #2 rst_n = rst_n + 1'b1;
            #2 t = t + 1'b1;
        end
    end
    
endmodule
