`timescale 1ns/1ps

module Sliding_Window_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output dec;

//declaring variables for the parameter and output
reg [4-1:0] state;
reg [4-1:0] next_state;
reg decc;

parameter S0 = 4'b0000;
parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0011;
parameter S4 = 4'b0100;
parameter S5 = 4'b0101;
parameter S6 = 4'b0110;
parameter S7 = 4'b0111;
parameter S8 = 4'b1000;

assign dec = decc;

always @(*) begin
    case(state)
    S0: begin // IDLE
        if (in) begin
            next_state = S1;
            decc = 1'b0;
        end
        else begin
            next_state = S0;
            decc = 1'b0;
        end
    end
    S1: begin // 1
        if (in) begin
            next_state = S2;
            decc = 1'b0;
        end
        else begin
            next_state = S0;
            decc = 1'b0;
        end
    end
    S2: begin // 11
        if (in) begin
            next_state = S3;
            decc = 1'b0;
        end
        else begin
            next_state = S0;
            decc = 1'b0;
        end
    end
    S3: begin // 111
        if (in) begin
            next_state = S3;
            decc = 1'b0;
        end
        else begin
            next_state = S4;
            decc = 1'b0;
        end
    end
    S4: begin /// 1110
        if (in) begin
            next_state = S1;
            decc = 1'b0;
        end
        else begin
            next_state = S5;
            decc = 1'b0;
        end
    end
    S5: begin
        if (in) begin
            next_state = S6;
            decc = 1'b0;
        end
        else begin
            next_state = S0;
            decc = 1'b0;
        end
    end
    S6: begin
        if (in) begin
            next_state = S7;
            decc = 1'b0;
        end
        else begin
            next_state = S5;
            decc = 1'b0;
        end
    end
    S7: begin
        if (in) begin
            next_state = S8;
            decc = 1'b1;
        end
        else begin
            next_state = S0;
            decc = 1'b0;            
        end
    end
    S8: begin
        if (in) begin
            next_state = S3;
            decc = 1'b0;
        end
        else begin
            next_state = S4;
            decc = 1'b0;            
        end
    end
    endcase
end

always @(posedge clk) begin
    if (rst_n == 1'b0) begin
        decc <= 1'b0;
        state <= S0;
    end
    else begin
        state <= next_state;
    end
end
endmodule 