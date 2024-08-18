`timescale 1ns/1ps

module Content_Addressable_Memory(clk, wen, ren, din, addr, dout, hit);
input clk;
input wen, ren;
input [7:0] din;
input [3:0] addr;
output [3:0] dout;
output hit;

parameter n = 16, m = 8;
reg [m-1:0] CAM [n-1:0];
reg [n-1:0] compare;

reg[3:0]dout;
reg hit;
wire matchreg;
wire match;

wire [3:0]prioaddressreg;
wire [3:0] prioaddress;
assign prioaddress = prioaddressreg;
assign match = matchreg;

always @(posedge clk) begin
    dout <= 4'b0;
    hit <= 1'b0;
if (ren == 1'b1) begin // Ren = 1 or Ren Wen = 1
    if(match) begin
        dout <= prioaddress;
        hit <= 1'b1;
    end
    else begin
        dout <= 4'b0;
        hit <= 1'b0;
    end
end
else begin
    if(wen == 1'b1) begin // Wen = 1
        CAM[addr] <= din;
        dout <= 4'b0;
        hit <= 1'b0;
    end
    else begin // Ren = 0 , Wen = 0
        dout <= 4'b0;
        hit <= 1'b0;  
            end
        end
    end

always @(*)begin
    if (din == CAM[0])begin
        compare[0] = 1'b1;
    end
    else begin
        compare[0] = 1'b0;
    end
    if (din == CAM[1])begin
        compare[1] = 1'b1;
    end
    else begin
        compare[1] = 1'b0;
    end
    if (din == CAM[2])begin
        compare[2] = 1'b1;
    end
    else begin
        compare[2] = 1'b0;
    end
    if (din == CAM[3])begin
        compare[3] = 1'b1;
    end
    else begin
        compare[3] = 1'b0;
    end
    if (din == CAM[4])begin
        compare[4] = 1'b1;
    end
    else begin
        compare[4] = 1'b0;
    end
    if (din == CAM[5])begin
        compare[5] = 1'b1;
    end
    else begin
        compare[5] = 1'b0;
    end
    if (din == CAM[6])begin
        compare[6] = 1'b1;
    end
    else begin
        compare[6] = 1'b0;
    end
    if (din == CAM[7])begin
        compare[7] = 1'b1;
    end
    else begin
        compare[7] = 1'b0;
    end
    if (din == CAM[8])begin
        compare[8] = 1'b1;
    end
    else begin
        compare[8] = 1'b0;
    end
    if (din == CAM[9])begin
        compare[9] = 1'b1;
    end
    else begin
        compare[9] = 1'b0;
    end
    if (din == CAM[10])begin
        compare[10] = 1'b1;
    end
    else begin
        compare[10] = 1'b0;
    end
    if (din == CAM[11])begin
        compare[11] = 1'b1;
    end
    else begin
        compare[11] = 1'b0;
    end
    if (din == CAM[12])begin
        compare[12] = 1'b1;
    end
    else begin
        compare[12] = 1'b0;
    end
    if (din == CAM[13])begin
        compare[13] = 1'b1;
    end
    else begin
        compare[13] = 1'b0;
    end
    if (din == CAM[14])begin
        compare[14] = 1'b1;
    end
    else begin
        compare[14] = 1'b0;
    end
    if (din == CAM[15])begin
        compare[15] = 1'b1;
    end
    else begin
        compare[15] = 1'b0;
    end
end

PriorityEncoder AddrOut(
    .out(prioaddressreg),
    .in(compare),
    .matching(matchreg)
);

endmodule

module PriorityEncoder(in, out, matching);
parameter n = 16;
input [n-1:0] in;
output reg [3:0] out;
output reg matching;


always @(*)begin
    matching = 1'b1;
    if(in[0] == 1'b1) out = 4'b0000 ;
    else if(in[1] == 1'b1) out = 4'b0001;
    else if(in[2] == 1'b1) out = 4'b0010;
    else if(in[3] == 1'b1) out = 4'b0011;
    else if(in[4] == 1'b1) out = 4'b0100;
    else if(in[5] == 1'b1) out = 4'b0101;
    else if(in[6] == 1'b1) out = 4'b0110;
    else if(in[7] == 1'b1) out = 4'b0111;
    else if(in[8] == 1'b1) out = 4'b1000;
    else if(in[9] == 1'b1) out = 4'b1001;
    else if(in[10] == 1'b1) out = 4'b1010;
    else if(in[11] == 1'b1) out = 4'b1011;
    else if(in[12] == 1'b1) out = 4'b1100;
    else if(in[13] == 1'b1) out = 4'b1101;
    else if(in[14] == 1'b1) out = 4'b1110;
    else if(in[15] == 1'b1) out = 4'b1111;
    else begin
    out = 4'bxxxx;
    matching = 1'b0;
    end
end

endmodule