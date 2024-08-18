`timescale 1ns / 1ps


module Crossbar_4x4_4bit_t;
    reg[3:0]
    in1 = 4'b0001,
    in2 = 4'b0010,
    in3 = 4'b0100,
    in4 = 4'b1000;
    
    reg [4:0]
    control  = 5'b0;
    
    wire [3:0] out1, out2, out3, out4;
    
    Crossbar_4x4_4bit CB4x41(
        .control(control),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4)
        );
        
    initial begin
        repeat (2 ** 5) begin
            #1 control = control + 5'b1;
            repeat(2 ** 4) begin
                #1 in1 = in1 + 4'b1;
                repeat(2 ** 4) begin
                    #1 in2 = in2 + 4'b1;
                    repeat(2 ** 4) begin
                        #1 in3 = in3 + 4'b1;
                        repeat(2 ** 4) begin
                            #1 in4 = in4 + 4'b1;
                        end
                    end
                end
            end
        end
        #1 $finish;
     end 
          
endmodule
