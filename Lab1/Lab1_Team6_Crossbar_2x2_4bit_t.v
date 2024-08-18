`timescale 1ns / 1ps

module Crossbar_2x2_4bit_t;
    reg[3:0]
    in1 = 4'b0,
    in2 = 4'b0;
    reg
    control = 1'b0;
    wire[3:0] out1, out2;
    
    Crossbar_2x2_4bit SCB(
        .control(control),
        .in1(in1),
        .in2(in2),        
        .out1(out1),
        .out2(out2)
    );
    
    initial begin
        repeat (2) begin
            #1 control = control + 1'b1;
            repeat (2 ** 4) begin
                #1 in1 = in1 + 4'b1;
                repeat (2 ** 4) begin
                    #1 in2 = in2 + 4'b1;
                end
            end
        end
        #1 $finish;
    end
endmodule
