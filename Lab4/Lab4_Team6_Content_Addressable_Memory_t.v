`timescale 1ns/1ps

module Content_Addresable_Memory_t;
    reg clk = 1'b0;
    reg wen, ren;
    reg [7:0] din;
    reg [3:0] addr;
    wire [3:0] dout;
    wire hit;
    
    parameter cyc = 10;
    
    Content_Addressable_Memory C(
        .clk(clk),
        .wen(wen),
        .ren(ren),
        .din(din),
        .addr(addr),
        .dout(dout),
        .hit(hit)
    );
    
    always #(cyc/2) clk = !clk;
    
    initial begin
        wen = 1'b0;
        ren = 1'b0;
        din = 1'b0;
        addr = 1'b0;
        
        @(negedge clk)begin
            wen = 1'b1;
            addr = 4'd1;
            din = 8'd4;
        end
        @(negedge clk)begin
            addr = 4'd7;
            din = 8'd8;
        end
        @(negedge clk)begin
            addr = 4'd15;
            din = 8'd35;
        end
        @(negedge clk)begin
            addr = 4'd9;
            din = 8'd8;
        end
        //
        @(negedge clk) begin
            wen = 1'b0;
            addr = 4'd0;
            din = 8'd0;
        end
        @(negedge clk);
        @(negedge clk);
        @(negedge clk)begin
            ren = 1'b1;
            din = 8'd4;
        end
        @(negedge clk) din = 8'd8;
        @(negedge clk) din = 8'd35;
        @(negedge clk) din = 8'd87;
        @(negedge clk) din = 8'd45;
        @(negedge clk) begin
            ren = 1'b0;
            wen = 1'b0;
            addr = 4'd0;
            din = 8'd0;
        end
        
        @(negedge clk) $finish;
        
    end

endmodule