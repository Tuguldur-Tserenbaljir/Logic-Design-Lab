`timescale 1ns/1ps

module Crossbar_4x4_4bit(in1, in2, in3, in4, out1, out2, out3, out4, control);
    input [4-1:0] in1, in2, in3, in4;
    input [5-1:0] control;
    output [4-1:0] out1, out2, out3, out4;
    
    wire[3:0] w1,w2,w3,w4,w5,w6;
    
    Crossbar_2x2_4bit CB1(in1, in2, control[0], w1 ,w2);
    Crossbar_2x2_4bit CB2(in3, in4, control[3], w3, w4);
    
    Crossbar_2x2_4bit CB3(w2, w3, control[2], w5, w6);
    
    Crossbar_2x2_4bit CB4(w1, w5, control[1], out1, out2);
    Crossbar_2x2_4bit CB5(w6, w4, control [4], out3, out4);
    
endmodule

`timescale 1ns/1ps

module Crossbar_2x2_4bit(in1, in2, control, out1, out2);

    input [4-1:0] in1, in2;
    input control;
    output [4-1:0] out1, out2;
    
    wire notcontrol;
    wire [3:0] w1, w2, w3, w4;
    
    not not1(notcontrol, control);
    
    Dmux_1x2_4bit Dmux1(w1, w2, control, in1);
    Dmux_1x2_4bit Dmux2(w3, w4, notcontrol, in2);
    
    Mux_2x1_4bit Mux1( w1, w3, control, out1);
    Mux_2x1_4bit Mux2( w2, w4, notcontrol, out2);

endmodule

module Dmux_1x2_4bit(a,b,sel,in);
    input [3:0] in;
    input sel;
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

module Mux_2x1_4bit(a,b,s,out);
    input [3:0]a,b;
    input s;
    output [3:0]out;
    
    wire w3,w4,w5,w6,w7,w8,w9,w10;
    wire nots;
    
    //Check Screenshot File for Circuit
    
    not not1(nots,s);
    
   
    and and1(w3,a[0], nots);
    and and2(w4,b[0], s);
    or or1 (out[0],w3,w4);
    
    and and3(w5, a[1], nots);
    and and4(w6, b[1], s);
    or or2(out[1], w5, w6);
    
    and and5(w7, a[2], nots);
    and and6(w8, b[2], s);
    or or3(out[2], w7, w8);
    
    and and7(w9, a[3], nots);
    and and8(w10, b[3], s);
    or or4(out[3], w9, w10);
    
endmodule