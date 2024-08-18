`timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit(a, b, c0, s, c8);
    input [7:0] a, b;
    input c0;
    output [7:0] s;
    output c8;
    
    wire c1, c2, c3, c4, c5, c6, c7;
    wire P0, P1, P2, P3, P4, P5, P6, P7;
    wire G0, G1, G2, G3, G4, G5, G6, G7;
    wire PG0123, PG4567;
    wire GG0123, GG4567; 
    
    
    Prop_and_Gen CLA0(P0, G0, s[0], a[0], b[0], c0);
    Prop_and_Gen CLA1(P1, G1, s[1], a[1], b[1], c1);
    Prop_and_Gen CLA2(P2, G2, s[2], a[2], b[2], c2);
    Prop_and_Gen CLA3(P3, G3, s[3], a[3], b[3], c3);
    Prop_and_Gen CLA4(P4, G4, s[4], a[4], b[4], c4);
    Prop_and_Gen CLA5(P5, G5, s[5], a[5], b[5], c5);
    Prop_and_Gen CLA6(P6, G6, s[6], a[6], b[6], c6);
    Prop_and_Gen CLA7(P7, G7, s[7], a[7], b[7], c7);
    
    CLA_4bit CLA_0123(P0, G0,P1, G1,P2, G2,P3, G3,c0,c1, c2, c3,PG0123, GG0123);
    CLA_4bit CLA_4567(P4, G4,P5, G5,P6, G6,P7, G7,c4,c5, c6, c7,PG4567, GG4567);
    
    CLA_2bit CLA_ALL(PG0123, GG0123,PG4567, GG4567,c0, c4, c8);
    
endmodule

module Prop_and_Gen(P, G, out, a, b, cin);
    input a, b, cin;
    output P, G, out;
    
    wire w1;
    
    NAND_XOR Prop(P, a, b);
    
    NAND_AND Gen(G, a, b);
    
    NAND_XOR PG1(w1, a, b);
    NAND_XOR PG2(out, w1, cin);

endmodule

module CLA_4bit(P0,G0,P1,G1,P2,G2,P3,G3,cin,CA,CB,CC,PG,GG);
    input P0,G0,P1,G1,P2,G2,P3,G3;
    input cin;
    output CA, CB, CC;
    output PG, GG;
    
    wire P0cin;
    wire P1G0, P1P0cin;
    wire P2G1, P2P1G0, P2P1P0cin;
    wire P3G2, P3P2G1, P3P2P1G0;
    
    //CA
    NAND_AND CA1(P0cin, P0, cin);
    
    NAND_OR CA2(CA, P0cin, G0);
    
    //CB
    NAND_AND CB1(P1G0, P1, G0);
    
    NAND_AND_3bit CB2(P1P0cin, P1, P0, cin);
    
    NAND_OR_3bit CB3(CB, G1, P1G0, P1P0cin);
    
    //CC
    NAND_AND CC1(P2G1, P2, G1);
    
    NAND_AND_3bit CC2(P2P1G0, P2, P1, G0);
    
    NAND_AND_4bit CC3(P2P1P0cin, P2, P1, P0, cin);
    
    NAND_OR_4bit CC4(CC, G2, P2G1, P2P1G0, P2P1P0cin);
    
    //Prop and Gen Carry
    NAND_AND PGC1(P3G2, P3, G2);
    
    NAND_AND_3bit PGC2(P3P2G1, P3, P2, G1);
    
    NAND_AND_4bit PGC3(P3P2P1G0, P3, P2, P1, G0);
    
    //PG
    NAND_AND_4bit PG1(PG, P0, P1, P2, P3);
    
    //GG
    NAND_OR_4bit GG1(GG, G3, P3G2, P3P2G1, P3P2P1G0);

endmodule

module CLA_2bit(P0,G0,P1,G1,cin,carry,cout);
    input P0, G0,P1, G1,cin;
    output carry, cout;
    
    wire P0_cin, P1_G0, P1P0_cin;
    
    NAND_AND CLA1(P0_cin, P0, cin);
    
    NAND_OR CL2(carry, P0_cin, G0);
    
    NAND_AND CLA3(P1_G0, P1, G0);
    
    NAND_AND_3bit CLA4(P1P0_cin, P1, P0, cin);
    
    NAND_OR_3bit CLA5(cout, G1, P1_G0, P1P0_cin);

endmodule

module NAND_AND(out,a,b);
input a,b;
output out;
wire w1;
nand N1(w,a,b);
nand N2(out,w,w);
endmodule

module NAND_AND_3bit(out,a,b,c);
input a,b,c;
output out;
wire nand1;
NAND_AND A1(nand1,a,b);
NAND_AND A2(out,nand1,c);
endmodule

module NAND_AND_4bit(out,a,b,c,d);
input a,b,c,d;
output out;
wire nand1;
NAND_AND_3bit A1(nand1,a,b,c);
NAND_AND A2(out,nand1,d);
endmodule

module NAND_AND_5bit(out,a,b,c,d,e);
input a,b,c,d,e;
output out;
wire nand1;
NAND_AND_4bit A1(nand1,a,b,c,d);
NAND_AND A2(out,nand1,e);
endmodule

module NAND_OR(out,a,b);
input a,b;
output out;
wire w1,w2;
nand O1(w1,a,a);
nand O2(w2,b,b);
nand O3(out,w1,w2);
endmodule

module NAND_OR_3bit(out,a,b,c);
input a,b,c;
output out;
wire w1;
NAND_OR O1(w1,a,b);
NAND_OR O2(out,w1,c);
endmodule

module NAND_OR_4bit(out,a,b,c,d);
input a,b,c,d;
output out;
wire w1;
NAND_OR_3bit O1(w1,a,b,c);
NAND_OR O2(out,w1,d);
endmodule

module NAND_OR_5bit(out,a,b,c,d,e);
input a,b,c,d,e;
output out;
wire w1;
NAND_OR_4bit O1(w1,a,b,c,d);
NAND_OR O2(out,w1,e);
endmodule

module NAND_XOR(out,a,b);
input a,b;
output out;
wire w1,w2;
nand X1(w1,a,b);
NAND_OR X2(w2,a,b);
NAND_AND X3(out,w1,w2);
endmodule