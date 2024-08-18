`timescale 1ns/1ps

module Built_In_Self_Test(clk, rst_n, scan_en, scan_in, scan_out);
    input clk;
    input rst_n;
    input scan_en;
    output scan_in;
    output scan_out;
    

    Many_To_One_LFSR M(
        .clk(clk), 
        .rst_n(rst_n), 
        .out(scan_in)
    );
    
    Scan_Chain_Design SCD(
        .clk(clk),
        .rst_n(rst_n), 
        .scan_in(scan_in), 
        .scan_en(scan_en), 
        .scan_out(scan_out)
        );
    
endmodule

module Scan_Chain_Design(clk, rst_n, scan_in, scan_en, scan_out);
    input clk;
    input rst_n;
    input scan_in;
    input scan_en;
    output scan_out;

    wire [7:0] temp,p;
    
    assign scan_out = temp[0];
    SDFF S1(temp[7],scan_en,scan_in,p[7],rst_n,clk);
    SDFF S2(temp[6],scan_en,temp[7],p[6],rst_n,clk);
    SDFF S3(temp[5],scan_en,temp[6],p[5],rst_n,clk);
    SDFF S4(temp[4],scan_en,temp[5],p[4],rst_n,clk);
    SDFF S5(temp[3],scan_en,temp[4],p[3],rst_n,clk);
    SDFF S6(temp[2],scan_en,temp[3],p[2],rst_n,clk);
    SDFF S7(temp[1],scan_en,temp[2],p[1],rst_n,clk);
    SDFF S8(temp[0],scan_en,temp[1],p[0],rst_n,clk);

    Multiplier_4bit M(p,temp[7:4],temp[3:0]);

endmodule

module SDFF(DFF,scan_en,scan_in,data,rst_n,clk);
    input scan_en,scan_in,data,rst_n,clk;
    output reg DFF;

    always @(posedge clk)begin
        if(rst_n == 1'b0)begin
            DFF <= 1'b0;
        end else begin
            if(scan_en == 1'b1)begin
                DFF <= scan_in;
            end
            else begin
                DFF <= data;
            end
        end
    end
endmodule

module Multiplier_4bit(p ,a, b);
    input [3:0] a, b;
    output [7:0] p;

    assign p = a * b;
endmodule

module Many_To_One_LFSR(clk, rst_n, out);
input clk;
input rst_n;
output [8-1:0] out;

reg [7:0] DFF;
    
// Get most significant bit == 7
always @(posedge clk) begin
     if(rst_n == 1'b0) begin
         DFF[7:0] <= 8'b10111101;
     end else begin
         DFF[7:1] <= DFF[6:0];
         DFF[0] <= (DFF [1] ^ DFF[2]) ^ (DFF[3] ^ DFF[7]);
     end

end
    assign out = DFF[7];
endmodule