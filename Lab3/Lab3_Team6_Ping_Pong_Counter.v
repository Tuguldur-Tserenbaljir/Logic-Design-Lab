`timescale 1ns/1ps

module Ping_Pong_Counter (clk, rst_n, enable, direction, out);
input clk, rst_n;
input enable;
output direction;
output [4-1:0] out;

// Init
reg dir = 1'b1, next_dir;
reg [4-1:0] count = 4'b0000, next_count;

// Sequential (Latch)
always @(posedge clk) begin
    if(rst_n == 1'b0) begin
        count <= 4'b0000;
        dir <= 1'b1;
    end 
    else begin
        count <= next_count;
        dir <= next_dir;
    end
end

// Combinational (Logic gate)
always @(*) begin
    if (enable == 1'b1) begin 
        if (dir == 1'b1) begin
            if (count == 4'd15) begin
                next_dir = 1'b0; 
                next_count = 4'd14;
            end 
            else begin
                next_dir = dir;
                next_count = count + 1'b1;
            end
        end 
        else begin
            if (count == 4'd0) begin
                next_dir = 1'b1; 
                next_count = 4'd1;
            end else begin
                next_dir = dir;
                next_count = count - 1'b1;
            end
        end
    end 
    else begin
        next_dir = dir;
        next_count = count;
    end
end

// Output
assign direction = dir;
assign out = count;

endmodule