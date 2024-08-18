`timescale 1ns/1ps

module Ripple_Carry_Adder_t;
    reg [7:0] a, b;
    reg cin;
    wire [7:0] sum;
    wire cout;
    
    Ripple_Carry_Adder RCA(
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .sum(sum)
    );
    
    initial begin
        cin = 1'b0;
        a = 8'b0;
        b = 8'b0;
        repeat (2 ** 8) begin
            repeat (2 ** 8) begin
                repeat (2) begin
                    #1 cin = cin + 1'b1;
                end
                b = b + 1'b1;
            end
            a = a+1'b1;
        end
        #1 $finish;
    end

endmodule
