`timescale 1ns/1ps

module Dmux_1x4_4bit(in, a, b, c, d, sel);
    
    input [4-1:0] in;
    input [2-1:0] sel;
    output [4-1:0] a, b, c, d;
     
    wire [3:0] w1,w2;
    
    Dmux_1x2_4bit DMUX1(w1, w2, sel[1], in);
    Dmux_1x2_4bit DMUX2(a, b, sel[0], w1);
    Dmux_1x2_4bit DMUX3(c, d, sel[0], w2);
    
endmodule

module Dmux_1x2_4bit(a,b,sel,in);
    input [3:0] in;
    input  sel;
    output [3:0] a, b;
    
    wire notsel;
    
    not not1(notsel, sel);
    
    // 4bit outputs
    and and1(a[0], notsel, in[0]);
    and and2(b[0], sel, in[0]);
    
    and and3(a[1], notsel, in[1]);
    and and4(b[1], sel, in[1]);
    
    and and5(a[2], notsel, in[2]);
    and and6(b[2], sel, in[2]);
    
    and and7(a[3], notsel, in[3]);
    and and8(b[3], sel, in[3]);

endmodule