`timescale 1ns / 1ps

module Round_Robin_Arbiter_t;
    reg clk;
    reg rst_n;
    reg [3:0] wen;
    reg [7:0] a, b, c, d;
    wire [7:0] dout;
    wire valid;
    
    parameter cyc = 10;
    
    Round_Robin_Arbiter R(
        .clk(clk),
        .rst_n(rst_n),
        .wen(wen),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .dout(dout),
        .valid(valid)
    );
    
    always#(cyc/2)clk = !clk;
        
    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        wen = 1'b0;
        a = 8'd87; b = 8'd56; c = 8'd9; d = 8'd13;
        
        @(posedge clk) begin
            rst_n = 1'b1;
            wen = 4'b1111;
            a = 8'd87; b = 8'd56; c = 8'd9; d = 8'd13;
        end
        
        @(posedge clk)begin
            wen = 4'b1000;
            a = 8'd0; b = 8'd0; c = 8'd0;
            d = 8'd85;
        end
        
        @(posedge clk)begin
            wen = 4'b0100;
            a = 8'd0; b = 8'd0; d = 8'd0;
            c = 8'd139;
        end
        
        @(posedge clk) wen = 4'b0000;
        
        #(cyc * 4)
        
        @(posedge clk)begin
            wen = 4'b0001;
            a = 8'd51;
            b = 8'd0; d = 8'd0;
            c = 8'd0;
        end
        
        @(posedge clk) wen = 4'b0000;
        
        wen = 1'b0;
        a = 8'd0; b = 8'd0; c = 8'd0; d = 8'd0;
        
        repeat (2**3) begin
            #(cyc*2)
            wen = wen + 1'b0;
            a = a + 1'b0;
            b = b + 1'b0;
            c = c + 1'b0;
            d = d + 1'b0;
        end
        
        #(cyc*4) $finish;
    end
    
endmodule
