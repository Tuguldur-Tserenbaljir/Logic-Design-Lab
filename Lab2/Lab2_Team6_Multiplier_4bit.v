module Multiplier_4bit(a, b, p);
    input [4-1:0] a, b;
    output [8-1:0] p;
    // Check Circuit for Logic

    wire and1,and2,and3,and4,and5,and6,and7,and8,and9,and10,and11,and12;

    AND ANDG1(a[0], b[1], and1);
    AND ANDG2(a[1], b[0], and2);
    AND ANDG3(a[0], b[2], and3);
    AND ANDG4(a[1], b[1], and4);
    AND ANDG5(a[1], b[2], and5);
    AND ANDG6(a[0], b[3], and6);
    AND ANDG7(a[1], b[3], and7);
    AND ANDG8(a[2], b[0], and8);
    AND ANDG9(a[2], b[1], and9);
    AND ANDG10(a[2], b[2], and10);
    AND ANDG11(a[2], b[3], and11);
    AND ANDG12(a[2], b[3], and12);
    AND ANDG13(a[3], b[0], and13);
    AND ANDG14(a[3], b[1], and14);
    AND ANDG15(a[3], b[2], and15);
    AND ANDG16(a[3], b[3], and16);

    wire x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16;
    
    AND ANDG0(a[0], b[0], p[0]);
    //Level 1
    Half_Adder HA1(and2, and1, x1, p[1]);
    Full_Adder FA1(and4,and3,x1,x3,x2);
    Full_Adder FA2(and5,and6,x3,x5,x4);
    Half_Adder HA2(and7,x5,x7,x6);

    Half_Adder HA3(x2,and8,x15,p[2]);
    Full_Adder FA3(x4,and9,x15,x16,x14);
    Full_Adder FA4(x6,and10,x16,x17,x13);
    Full_Adder FA5(x7,and12,x17, x8,x9);

    Half_Adder HA4(x14, and13, x12, p[3]);
    Full_Adder FA6(x13, and14, x12, x11, p[4]);
    Full_Adder FA7(x9,and15,x11,x10,p[5]);
    Full_Adder FA8(x8,and16,x10,p[7],p[6]);
endmodule


module Half_Adder(a, b, cout, sum);
    input a, b;
    output cout, sum;

    wire w1,w2,w3;

    nand nand1(w1,a,b);
    nand nand2(w2,a,w1);
    nand nand3(w3,b,w1);

    nand SumOut(sum, w2, w3);
    nand CarryOut(cout, w1);

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