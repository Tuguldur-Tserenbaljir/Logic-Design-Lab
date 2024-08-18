`timescale 1ns / 1ps

module Toggle_Flip_Flop(clk, q, t, rst_n);
    input clk;
    input t;
    input rst_n;
    output q;
    
    wire nott,notq;
    wire w1,w2;
    wire XOROut, Din;
    
    //XOR
    not not1(nott, t);
    not not2(notq, q);
    
    and and1(w1, t, notq);
    and and2(w2, nott, q);

    or OutXOR(XOROut, w1, w2);
    //XOR Finish
    and beforeD (Din, XOROut, rst_n);

    D_Flip_Flop D(clk, Din, q);
    
endmodule

module D_Flip_Flop(clk, d, q);
    input clk;
    input d;
    output q;
    
    wire w1;
    wire not_clk;
    
    not not1(not_clk, clk);
    
    D_Latch Master(not_clk, d, w1);
    D_Latch Slave(clk, w1, q);

endmodule

module D_Latch(e, d, q, qbar);
    input e;
    input d;
    output q, qbar;
    
    wire w1,w2;
    wire notd;
    
    not not1(notd, d);
    
    nand nand1(w1, d, e);
    nand nand2(w2, notd,e);
    
    nand nand3(q, w1, qbar);
    nand nand4(qbar, w2, q);

endmodule