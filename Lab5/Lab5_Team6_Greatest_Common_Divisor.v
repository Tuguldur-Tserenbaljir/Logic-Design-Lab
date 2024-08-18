`timescale 1ns/1ps

module Greatest_Common_Divisor (clk, rst_n, start, a, b, done, gcd);
input clk, rst_n;
input start;
input [15:0] a;
input [15:0] b;

output  wire done;
output  wire [15:0] gcd;

reg [15:0] out_gcd; 
reg out_done;
reg [3-1:0]state,next_state;
reg [15:0] reg_a,reg_b;
reg [1:0]count,next_count = 0;  //clock cycle

parameter WAIT = 2'b00;
parameter CAL = 2'b01;
parameter FINISH = 2'b10;

assign gcd = out_gcd;
assign done = out_done;

always @(posedge clk or negedge rst_n)begin
    //reset the module to wait state
    if(rst_n == 1'b0)begin
        state <= WAIT;
    end
    else begin
        count <= next_count;
        state <= next_state;
    end
end

always @(*)begin
    case(state)
        WAIT: begin
            if(start == 1'b1)begin
                next_state <= CAL;
            end else begin
                next_state <= WAIT;
            end
        end
        CAL: begin
            if(reg_a != reg_b)begin
                next_state <= CAL;
            end
            else begin
                next_state <= FINISH;
            end
        end
        FINISH: begin
            if(count == 1)begin
                next_state <= WAIT;
            end else begin
                next_count <= count + 1;
                next_state <= FINISH;
            end
        end
    endcase
end

always @(posedge clk or negedge rst_n)begin
    
    if(!rst_n)begin
        out_gcd <=16'd0;
        out_done <= 1'b0;
    end 
    else begin
        case(state)
            WAIT: begin 
                //fetch and buffer the inputs
                if(start == 1'b1)begin
                    reg_a <= a;
                    reg_b <= b;
                end
                    out_done <= 1'b0;
            end
            
            CAL: begin
                // a == 0
                //swap values with b and output
                if(reg_a == 16'd0)begin
                    reg_a <= reg_b;
                // b==0 
                //swap values with a and output
                end else if(reg_b == 16'd0)begin
                    reg_b <= reg_a;
                end
                //when a is not equal to b get the sub in positive output
                //when a is equal to b it is passed into finish state
                else if(reg_a != reg_b)begin
                    if(reg_a > reg_b)begin
                        reg_a <= reg_a - reg_b;
                        reg_b <= reg_b;
                    end else begin
                        reg_b <= reg_b - reg_a;
                        reg_a <= reg_a;
                    end
                end
            end
            FINISH: begin
                    //wait for the done to have 2 cycle 
                    out_gcd <= reg_a;
                    out_done <= 1'b1;
                    next_count = count + 1;
                end
        endcase

    end
end

endmodule