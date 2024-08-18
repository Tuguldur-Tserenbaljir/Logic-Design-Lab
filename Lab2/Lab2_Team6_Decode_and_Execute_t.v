`timescale 1ns / 1ps

module Decode_and_Execute_t;
    reg [3:0] rs, rt;
    reg [2:0] sel;
    wire [3:0] rd;
    
    Decode_And_Execute DE(
        .rs(rs),
        .rt(rt),
        .sel(sel),
        .rd(rd)
    );
    
    initial begin
        sel = 3'd0;
        rs = 4'd0;
        rt = 4'd0;
        repeat(2 ** 4) begin
            repeat(2 ** 4) begin
                repeat(2 ** 3) begin
                    #1 sel = sel + 1'b1;
                end
                rt = rt + 1'b1;
            end
            rs = rs + 1'b1;
        end
        #1 $finish;
    end

endmodule
