`timescale 1ns/1ps
 
module Ripple_Carry_Adder(a, b, cin, cout, sum);
    input [8-1:0] a, b;
    input cin;
    output cout;
    output [8-1:0] sum;
    
    wire c1,c2,c3,c4,c5,c6,c7;
    
    Full_Adder FADD0(a[0], b[0], cin, c1, sum[0]);
    Full_Adder FADD1(a[1], b[1], c1, c2, sum[1]);
    Full_Adder FADD2(a[2], b[2], c2, c3, sum[2]);
    Full_Adder FADD3(a[3], b[3], c3, c4, sum[3]);
    Full_Adder FADD4(a[4], b[4], c4, c5, sum[4]);
    Full_Adder FADD5(a[5], b[5], c5, c6, sum[5]);
    Full_Adder FADD6(a[6], b[6], c6, c7, sum[6]);
    Full_Adder FADD7(a[7], b[7], c7, cout, sum[7]);
 
endmodule
 
module Full_Adder (a, b, cin, cout, sum);
    input a, b, cin;
    output cout, sum;
    
    wire notc,notcout, w1;
    
    nand nand1(notcin, cin);
    nand nand2(notcout,cout);
    
    Majority M1(a, b, cin, cout);
    Majority M2(notcin, b, a, w1);
    Majority M3(notcout, cin, w1, sum);
 
endmodule
 
module Majority(a, b, c, out);
    input a, b, c;
    output out;
    
    wire w1,w2,w3,w4;
    AND and1(a,b, w1);
    AND and2(a, c , w2);
    AND and3(b, c ,w3);
    
    OR or1(w1, w2, w4);
    OR or2(w4,w3, out);
    
endmodule
 
module AND (a, b , out);
    input a,b;
    output out;
    
    wire w1;
    
    nand nand1(w1, a, b);
    nand nand2(out, w1);
    
endmodule
 
module OR (a, b, out);
    input a,b;
    output out;
    
    wire w1,w2;
    
    nand nand1(w1, a);
    nand nand2(w2, b);
    nand nand3(out, w1, w2);
    
endmodule
