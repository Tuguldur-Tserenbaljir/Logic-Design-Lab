`timescale 1ns / 1ps

module Dmux_1x4_4bit_t;
    reg [3:0] in;
    reg [1:0] s;
    wire [3:0] a, b, c, d;
    
    Dmux_1x4_4bit dmux1(
        .in(in),
        .sel(sel),
        .a(a),
        .b(b),
        .c(c),
        .d(d)
    );
    
    initial begin
        sel = 2'b0; //declare 00
        in = 4'b0; // declare 0000
        repeat (2 ** 2) begin // 2bit
            #1 sel = sel + 2'b1; // 1ns delay
            in = 4'b0; // declare in as 0000
            repeat (2 ** 4) begin //4bit
                #1 in = in + 4'b1; // 1ns delay, for loop for adding 0000, 0001,0010,0011 until 1111,overflow 0000
            end
        end
        #1 $finish; //1ns delay
    end
    
endmodule
