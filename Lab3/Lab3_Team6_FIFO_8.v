`timescale 1ns/1ps

module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [8-1:0] din;
output [8-1:0] dout;
output error;

reg [3:0] Count = 1'b0;
reg [7:0] FIFO[7:0];
reg [2:0] read_Counter = 1'b0; 
reg [2:0] write_Counter = 1'b0;

reg D_error = 1'b0;
reg [7:0] D_dout = 1'b0;

assign Empty = (Count==0)? 1'b1:1'b0; 
assign Full = (Count==8)? 1'b1:1'b0; 

always @(posedge clk)begin
    if(rst_n == 1'b0)begin
        FIFO[0] = 1'b0;
        FIFO[1] = 1'b0;
        FIFO[2] = 1'b0;
        FIFO[3] = 1'b0;
        FIFO[4] = 1'b0;
        FIFO[5] = 1'b0;
        FIFO[6] = 1'b0;
        FIFO[7] = 1'b0;
        
        read_Counter = 1'b0;
        write_Counter = 1'b0;
        
        D_dout <= 1'b0;
        D_error <= 1'b0;     
    end
     
    else if( ren == 1'b1) begin
        if(Count != 1'b0 && wen == 1'b1)
            D_dout = FIFO[read_Counter]; 
            read_Counter = read_Counter + 1'b1;
    end
     
    else if ( wen == 1'b1 ) begin
        if(Count < 4'b1000 && ren == 1'b0)
            FIFO [write_Counter] <= din; 
            write_Counter = write_Counter + 1'b1;
    end
     
    else if (ren == 1'b1 && wen == 1'b0) begin
        D_dout =  FIFO[1];
    end
        
    if(read_Counter > write_Counter)begin
        Count = read_Counter - write_Counter;
    end else if(write_Counter > read_Counter)begin
        Count = write_Counter - read_Counter;
    end

    if(Empty || Full)begin
        D_error = 1'b1;
    end else begin
        D_error = 1'b0;
    end
end
    assign dout = D_dout;
    assign error = D_error;
endmodule