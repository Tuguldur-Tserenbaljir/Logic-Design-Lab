`timescale 1ns/1ps

module Exhausted_Testing(a, b, cin, error, done);
output [4-1:0] a, b;
output cin;
output error;
output done;


// input signal to the test instance.
reg [4-1:0] a = 4'b0000;
reg [4-1:0] b = 4'b0000;
reg cin = 1'b0;

// initial value for the done and error indicator: not done, no error
reg done = 1'b0;
reg error = 1'b0;

// output from the test instance.
wire [4-1:0] sum;
wire cout;

// Inidicator Correct
wire notcorrect;
wire[4-1:0]sum_correct;
wire cout_correct;

Ripple_Carry_Adder1 R1(
    .a (a), 
    .b (b), 
    .cin (cin),
    .cout_correct (cout_correct),
    .sum_correct (sum_correct)
    );
// instantiate the test instance. DONT CHANGE
Ripple_Carry_Adder rca(
    .a (a), 
    .b (b), 
    .cin (cin),
    .cout (cout),
    .sum (sum)
);

CHECK chk(
    .notcorrect(notcorrect),
    .cout_correct(cout_correct),
    .sum_correct(sum_correct),
    .sum(sum),
    .cout(cout)
);

initial begin
        repeat (2 ** 4) begin
            repeat (2 ** 4) begin
                repeat(2 ** 1) begin
                    cin = cin + 1'b1;
                    #1 error = notcorrect;
                    #4;
                end
                b = b + 1'b1;
            end
            a = a + 1'b1;
        end
        done = 1'b1;
        #5 done = 1'b0;
end

endmodule

module CHECK(notcorrect,cout_correct,sum_correct, sum, cout);
    input[3:0] sum , sum_correct;
    input cout, cout_correct;
    output notcorrect;
    
    wire w1,w2,w3,w4,w5;
    wire a1,a2,a3,a4;
    wire iscorrect;
    
    XNOR1 xnor1(sum_correct[0],sum[0],w1);
    XNOR1 xnor2(sum_correct[1],sum[1],w2);
    XNOR1 xnor3(sum_correct[2],sum[2],w3);
    XNOR1 xnor4(sum_correct[3],sum[3],w4);
    XNOR1 xnor5(cout,cout_correct,w5);
    
    AND1 and1(w1, w2, a1);
    AND1 and2(w3, w4, a2);
    AND1 and3(a1,a2, a3);
    AND1 and4(a3, w5, iscorrect);
    NOT1 not1(iscorrect, notcorrect);
endmodule

module Ripple_Carry_Adder1(a, b, cin, cout_correct, sum_correct);
    input [3:0] a, b;
    input cin;
    output cout_correct;
    output [3:0] sum_correct;
    
    wire c1,c2,c3,c4,c5,c6,c7;
    
    Full_Adder FADD0(a[0], b[0], cin, c1, sum_correct[0]);
    Full_Adder FADD1(a[1], b[1], c1, c2, sum_correct[1]);
    Full_Adder FADD2(a[2], b[2], c2, c3, sum_correct[2]);
    Full_Adder FADD3(a[3], b[3], c3, cout_correct, sum_correct[3]);

endmodule

//XNOR
module XNOR1(a, b, out);

input a, b;
output out;

wire w1, w2, w3, w4;

nand nand1(w1, a, b);
nand nand2(w2, a, w1);
nand nand3(w3, w1, b);
nand nand4(w4, w2, w3);
nand nand5(out, w4, w4);

endmodule

module Full_Adder1 (a, b, cin, cout, sum);
    input a, b, cin;
    output cout, sum;
    
    wire notc,notcout, w1;
    
    nand nand1(notcin, cin);
    nand nand2(notcout,cout);
    
    Majority1 M1(a, b, cin, cout);
    Majority1 M2(notcin, b, a, w1);
    Majority1 M3(notcout, cin, w1, sum);

endmodule

module Majority1(a, b, c, out);
    input a, b, c;
    output out;
    
    wire w1,w2,w3,w4;
    AND1 and1(a,b, w1);
    AND1 and2(a, c , w2);
    AND1 and3(b, c ,w3);
    
    OR1 or1(w1, w2, w4);
    OR1 or2(w4,w3, out);
    
endmodule

module AND1 (a, b , out);
    input a,b;
    output out;
    
    wire w1;
    
    nand nand1(w1, a, b);
    nand nand2(out, w1);
    
endmodule

module OR1 (a, b, out);
    input a,b;
    output out;
    
    wire w1,w2;
    
    nand nand1(w1, a);
    nand nand2(w2, b);
    nand nand3(out, w1, w2);
    
endmodule
module NOT1(a ,out);
    input a;
    output out;
    
    nand nand1 (out, a, a);

endmodule