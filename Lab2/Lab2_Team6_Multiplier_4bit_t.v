`timescale 1ns / 1ps

module Multiplier_4bit_t;
    reg [3:0] a, b;
    wire[7:0] p;

    Multiplier_4bit mult(
        .a(a),
        .b(b),
        .p(p)
    );
    
    initial begin
        a = 4'b0000;
        b = 4'b0000;
        repeat (2 ** 4) begin
            repeat (2 ** 4) begin
                #1 b = b + 1'b1;
            end
            a = a + 1'b1;
        end
        #1 $finish;
    end
endmodule
