`timescale 1ns/1ps

module Decode_And_Execute(rs, rt, sel, out1, out2);
    input [3:0] rs, rt;
    input [2:0] sel;
    output [3:0] out1;
    output [6:0] out2;
    wire [3:0] rd;

    wire [3:0] case0,case1,case2,case3,case4,case5,case6,case7;
    wire [3:0] w1;
    
     ASSIGN_GATE nuwebfrw1(out1[3], 1'b1);
     ASSIGN_GATE nuwebfrw2(out1[2], 1'b1);
     ASSIGN_GATE nuwebfrw3(out1[1], 1'b1);
     ASSIGN_GATE nuwebfrw4(out1[0], 1'b0);

    //SUB
    COMPLEMENT C1(rt, w1);  
    ADD Sub(rs, w1, case0);
    
    //RCA_4bit
    ADD A1(rs, rt, case1);
    
    //BITWISE OR
    BIT_OR OR1(rs, rt, case2);
    
    //BITWISE AND
    BIT_AND AND1(rs, rt, case3);
    
    
    //RIGHT SHIFT
    shift R0(rt[1], case4[0]);
    shift R1(rt[2], case4[1]);
    shift R2(rt[3], case4[2]);
    shift R3(rt[3], case4[3]);
    
    //LEFT SHIFT
    shift L0(rs[3], case5[0]);
    shift L1(rs[0], case5[1]);
    shift L2(rs[1], case5[2]);
    shift L3(rs[2], case5[3]);
    
    //EQ and GT
    COMPARATOR Comp(rs, rt, case7, case6);
   
    //MUX
    MUX_8X1_4bit M1(case0,case1,case2,case3,case4,case5,case6,case7,sel, rd);
    
    Conv4to7bit(rd,out2);
endmodule


module Conv4to7bit(rd,out);
    input [3:0] rd;
    output [7-1:0] out;

    wire notrd0,notrd1,notrd2,notrd3;
    NOT_GATE notd0(notrd0,rd[0]);
    NOT_GATE notd1(notrd1,rd[1]);
    NOT_GATE notd2(notrd2,rd[2]);
    NOT_GATE notd3(notrd3,rd[3]);
    
    wire and0000,and0001,and0010,and0011,and0100,and0101,and0110,and0111,and1000,and1001,and1010,and1011,and1100,and1101,and1110,and1111;
    AND_4bit A4bit1(notrd3,notrd2,notrd1,notrd0,and0000);
    AND_4bit A4bit2(notrd3,notrd2,notrd1,rd[0],and0001);
    AND_4bit A4bit3(notrd3,notrd2,rd[1],notrd0,and0010);
    AND_4bit A4bit4(notrd3,notrd2,rd[1],rd[0],and0011);
    AND_4bit A4bit5(notrd3,rd[2],notrd1,notrd0,and0100);
    AND_4bit A4bit6(notrd3,rd[2],notrd1,rd[0],and0101);
    AND_4bit A4bit7(notrd3,rd[2],rd[1],notrd0,and0110);
    AND_4bit A4bit8(notrd3,rd[2],rd[1],rd[0],and0111);
    AND_4bit A4bit9(rd[3],notrd2,notrd1,notrd0,and1000);
    AND_4bit A4bit10(rd[3],notrd2,notrd1,rd[0],and1001);
    AND_4bit A4bit11(rd[3],notrd2,rd[1],notrd0,and1010);
    AND_4bit A4bit12(rd[3],notrd2,rd[1],rd[0],and1011);
    AND_4bit A4bit13(rd[3],rd[2],notrd1,notrd0,and1100);
    AND_4bit A4bit14(rd[3],rd[2],notrd1,rd[0],and1101);
    AND_4bit A4bit15(rd[3],rd[2],rd[1],notrd0,and1110);
    AND_4bit A4bit16(rd[3],rd[2],rd[1],rd[0],and1111);

    OR_4bit O4bit1(and0001,and0100,and1011,and1101,out[6]);
    OR_6bit OR6bit1(and0101,and0110,and1011,and1100,and1110,and1111,out[5]);
    OR_4bit O4bit2(and0010,and1100,and1110,and1111,out[4]);
    OR_4bit O4bit3(and0001,and0100,and0111,and1111,out[3]);
    OR_6bit O6bit2(and0001,and0011,and0100,and0101,and0111,and1001,out[2]);
    OR_6bit O6bit3(and0001,and0010,and0011,and0111,and1010,and1101,out[1]);
    OR_4bit O4bit4(and0000,and0001,and0111,and1100,out[0]);
endmodule

module AND_4bit(a,b,c,d,out);
    input a,b,c,d;
    output out;
    wire w1;

    nand NAND4bit1 (w1,a,b,c,d);
    nand NAND4bit2(out,w1);
endmodule

module OR_4bit(a,b,c,d,out);
    input a,b,c,d;
    output out;
    
    wire w1,w2;
    OR_GATE OR_4bit1(w1,a,b);
    OR_GATE OR_4bit2(w2,c,d);

    OR_GATE OR_4bit3(out,w1,w2);

endmodule

module OR_5bit(a,b,c,d,e,out);
    input a,b,c,d,e;
    output out;
    
    wire w1,w2,w3;
    OR_GATE OR_5bit1(w1,a,b);
    OR_GATE OR_5bit2(w2,c,d);
    OR_GATE OR_5bit3(w3,w1,w2);

    OR_GATE OR_5bit4(out,w3,e);

endmodule

module OR_6bit(a,b,c,d,e,f,out);
    input a,b,c,d,e,f;
    output out;
    
    wire w1,w2,w3,w4;
    OR_GATE OR_6bit1(w1,a,b);
    OR_GATE OR_6bit2(w2,c,d);
    OR_GATE OR_6bit3(w3,w1,w2);
    OR_GATE OR_6bit4(w4,e,f);

    OR_GATE OR_6bit5(out,w3,w4);
endmodule

module shift (in, out);
    input in;
    output out;
    
    wire w;
    
    NOT_GATE SH0(w, in);
    NOT_GATE SH1(out, w);
    
endmodule

module MUX_2x1_4bit(a, b, sel, out);
    input [3:0] a, b;
    input sel;
    output [3:0] out;
    
    wire not_sel;
    
    wire w0, w1, w2, w3,w4, w5, w6, w7;
    
    NOT_GATE N(not_sel, sel);
    
    AND_GATE A0(w0, a[0], not_sel);
    AND_GATE A1(w1, a[1], not_sel);
    AND_GATE A2(w2, a[2], not_sel);
    AND_GATE A3(w3, a[3], not_sel);
    
    AND_GATE B0(w4, b[0], sel);
    AND_GATE B1(w5, b[1], sel);
    AND_GATE B2(w6, b[2], sel);
    AND_GATE B3(w7, b[3], sel);
    
    OR_GATE O0(out[0], w0, w4);
    OR_GATE O1(out[1], w1, w5);
    OR_GATE O2(out[2], w2, w6);
    OR_GATE O3(out[3], w3, w7);

endmodule 

module MUX_8X1_4bit (case0,case1,case2,case3,case4,case5,case6,case7,sel,out);
    input [3:0] case0,case1,case2,case3,case4,case5,case6,case7;
    input [2:0] sel;
    output [3:0] out;
    
    wire [3:0] w1,w2,w3,w4,w12,w34;
    
    MUX_2x1_4bit u1(case0, case1, sel[0], w1);
    MUX_2x1_4bit u2(case2, case3, sel[0], w2);
    MUX_2x1_4bit u3(case4, case5, sel[0], w3);
    MUX_2x1_4bit u4(case6, case7, sel[0], w4);
    
    MUX_2x1_4bit u5(w1, w2, sel[1], w12);
    MUX_2x1_4bit u6(w3, w4, sel[1], w34);
    
    MUX_2x1_4bit u7(w12, w34, sel[2], out);
    
endmodule

module COMPARATOR(a, b, eq, gt);
    input [3:0] a, b;
    output [3:0] eq, gt;
    
    wire E_confirm, G_confirm;
    
    //eq
    wire XNOR_0, XNOR_1, XNOR_2, XNOR3;
    wire XNOR_23, XNOR_012;
 
    wire BB_0, BB_1, BB_2, BB_3;
    wire GT_AB_0, GT_AB_1;
    wire GT_AB_2, GT_AB_3;
    wire GT_AB_01, GT_AB_012, GT_AB_0123;
    wire ACC01, ACC012;
    
    
    
    XNOR_GATE X0(XNOR_0, a[0], b[0]);
    XNOR_GATE X1(XNOR_1, a[1], b[1]);
    XNOR_GATE X2(XNOR_2, a[2], b[2]);
    XNOR_GATE X3(XNOR_3, a[3], b[3]);
    
    
    AND_GATE EQ01(XNOR_23, XNOR_2, XNOR_3);
    AND_GATE EQ012(XNOR_123, XNOR_1, XNOR_23);
    AND_GATE EQ0123(E_confirm, XNOR_0, XNOR_123);
    
    //gt
    
    
    NOT_GATE N0(BB_0, a[0]);
    NOT_GATE N1(BB_1, a[1]);
    NOT_GATE N2(BB_2, a[2]);
    NOT_GATE N3(BB_3, a[3]);
    
    
    AND_GATE A0(GT_AB_0, b[0], BB_0);
    AND_GATE A1(GT_AB_1, b[1], BB_1);
    AND_GATE A2(GT_AB_2, b[2], BB_2);
    AND_GATE A3(GT_AB_3, b[3], BB_3);
    
    AND_GATE GT1(GT_AB_01, GT_AB_2, XNOR_3);
    AND_GATE GT2(GT_AB_012, GT_AB_1, XNOR_23);
    AND_GATE GT3(GT_AB_0123, GT_AB_0, XNOR_123);
    
    
    OR_GATE O0(ACC01, GT_AB_3, GT_AB_01);
    OR_GATE O1(ACC012, ACC01, GT_AB_012);
    OR_GATE O2(G_confirm, ACC012, GT_AB_0123);
    
    //Value
    shift E_Value0(E_confirm, eq[0]);
    shift E_Value1(1'b1, eq[1]);
    shift E_Value2(1'b1, eq[2]);
    shift E_Value3(1'b1, eq[3]);
    
    shift G_Value0(G_confirm, gt[0]);
    shift G_Value1(1'b1, gt[1]);
    shift G_Value2(1'b0, gt[2]);
    shift G_Value3(1'b1, gt[3]);
    
endmodule

module BIT_AND (a, b, out);
    input [3:0] a, b;
    output [3:0] out;
    
    AND_GATE A0(out[0], a[0], b[0]);
    AND_GATE A1(out[1], a[1], b[1]);
    AND_GATE A2(out[2], a[2], b[2]);
    AND_GATE A3(out[3], a[3], b[3]);
    
endmodule

module BIT_OR(a, b, out);
    input [3:0] a, b;
    output [3:0] out;
    
    OR_GATE O0(out[0], a[0], b[0]);
    OR_GATE O1(out[1], a[1], b[1]);
    OR_GATE O2(out[2], a[2], b[2]);
    OR_GATE O3(out[3], a[3], b[3]);
    
endmodule

module COMPLEMENT(in, out);
    input [3:0] in;
    output [3:0] out;
    
    wire [3:0] f;
    
    NOT_GATE N0(f[0], in[0]);
    NOT_GATE N1(f[1], in[1]);
    NOT_GATE N2(f[2], in[2]);
    NOT_GATE N3(f[3], in[3]);
    
    ADD COMP1(f, 4'b0001, out);
    
endmodule

module ADD(a, b, s);
    input [3:0] a, b;
    output [3:0] s;
    
    wire f0, f1, f2, f3;
    
    Full_Adder C0(a[0], b[0], 1'b0, f0, s[0]);
    Full_Adder C1(a[1], b[1], f0, f1, s[1]);
    Full_Adder C2(a[2], b[2], f1, f2, s[2]);
    Full_Adder C3(a[3], b[3], f2, f3, s[3]);
    
endmodule

module Full_Adder(a, b, cin, out, sum);
    input a, b, cin;
    output out, sum;
    
    wire XOR_AB, AND_AB, AND_CX;
    
    XOR_GATE FA1(XOR_AB, a, b);
    XOR_GATE FA2(sum, XOR_AB, cin);
   
    AND_GATE A1(AND_AB, a, b);
    AND_GATE A2(AND_CX, XOR_AB, cin);
    
    OR_GATE O(out, AND_AB, AND_CX);   
    
endmodule

module ASSIGN_GATE(out, in);

input in;
output out;
wire w1;
NOT_GATE no1(w1, in);
NOT_GATE no2(out, w1);

endmodule

module AND_GATE(out, a, b);
    input a, b;
    output out;
    
    wire not_b;
    
    NOT_GATE A1(not_b, b);
    
    Universal_Gate A2(out, a, not_b);
    
endmodule

module OR_GATE(out, a, b);
    input a, b;
    output out;
    
    wire a_bar, w1;
    
    NOT_GATE OR1(a_bar, a);
    NOT_GATE OR2(out, w1);
    
    Universal_Gate OR3(w1, a_bar, b);
    
endmodule

module NOT_GATE(out, a);
    input a;
    output out;
    
    Universal_Gate N(out, 1'b1, a);
    
endmodule

module XOR_GATE (out, a, b);
    input a, b;
    output out;
    
    wire a_bar, b_bar;
    wire and1, and2;
    
    NOT_GATE NOT1(a_bar, a);
    NOT_GATE NOT2(b_bar, b);
    
    AND_GATE NOT3(and1, a, b_bar);
    AND_GATE NOT4(and2, a_bar, b);
    
    OR_GATE NOT5(out, and1, and2);
        
endmodule

module XNOR_GATE(out, a, b);
    input a, b;
    output out;
    
    wire w1;

    XOR_GATE XNOR1(w1, a, b);
    
    NOT_GATE XNOR2(out, w1);
    
endmodule

module Universal_Gate(out, a, b);
    input a, b;
    output out;
    
    wire not_b;
    
    not N(not_b, b);
    
    and A(out, a, not_b);

endmodule