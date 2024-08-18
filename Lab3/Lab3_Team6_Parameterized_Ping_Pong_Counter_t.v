module Parameterized_Ping_Pong_Counter_t;
    reg clk, rst_n;
    reg enable;
    reg flip;
    reg [3:0] max;
    reg [3:0] min;
    wire direction;
    wire [3:0] out;
    
    parameter cyc = 10;
    Parameterized_Ping_Pong_Counter P(
        .clk(clk), 
        .rst_n(rst_n), 
        .enable(enable), 
        .flip(flip), 
        .max(max), 
        .min(min), 
        .direction(direction), 
        .out(out)
    );
    
    always#(cyc/2)clk = !clk;
    initial begin
        clk = 1'b1;
        rst_n = 1'b0;
        enable = 1'b0;
        flip = 1'b0;
        max = 1'b0;
        min = 1'b0;
        @(negedge clk) rst_n = 1'b1;
        @(negedge clk) enable = 1'b1;
        @(negedge clk)begin
            max = 4'd9;
            min = 4'b0;
        end
        ///
        #(cyc * 5)
        @(negedge clk) flip = 1'b1;
        @(negedge clk) flip = 1'b0;
        
        #(cyc * 10) enable = 1'b0;
        #(cyc * 5) enable = 1'b1;
        //
        #(cyc * 7)
        @(negedge clk) begin
            max = 4'd5;
            min = 4'd7;
        end
        
        #(cyc * 5)
        @(posedge clk) begin
            max = 4'd15;
            min = 4'd0;
        end
        
        #(cyc * 8) 
        @(negedge clk) max = 4'd4;
        @(negedge clk) flip = 1'b1;
        @(negedge clk) flip = 1'b0;
        #(cyc * 1) 
        @(negedge clk) flip = 1'b1;
        @(negedge clk) flip = 1'b0;
        #(cyc * 10) $finish;
    end
    
endmodule