`timescale 1ns/1ps

module Traffic_Light_Controller (clk, rst_n, lr_has_car, hw_light, lr_light);

input clk, rst_n;
input lr_has_car;

output reg [2:0] hw_light;
output reg [2:0] lr_light;

reg [2:0] next_state,state ;
reg [2:0] next_hw_light, next_lr_light;
reg [7:0] count, next_count;

parameter S0 = 3'b000; // hw green, lr red
parameter S1 = 3'b001; // hw yellow, lr red
parameter S2 = 3'b010; // hw red, lr red
parameter S3 = 3'b011; // hw red, lr green
parameter S4 = 3'b100; // hw red, lr yellow
parameter S5 = 3'b101; // hw red, lr red

// 100 - red
// 010 - yellow
// 001 - green
always @(posedge clk)begin
    if(!rst_n)begin
        //stay in default state
        state <= S0;
        hw_light <= 3'b001;
        lr_light <= 3'b100;
        count <= 0;
    end
    else begin
        state <= next_state;
        hw_light <= next_hw_light;
        lr_light <= next_lr_light;
        count <= next_count; 
    end
end

always @(*)begin
    next_state = state;
    next_hw_light = hw_light;
    next_lr_light = lr_light;
    next_count = count;
    
    case(state)
        S0:begin // hw green, lr red, atleast 70 clock
            if(count >=69  && lr_has_car == 1'b1)begin
                // cycle until there is car in local road
                next_count = 0;
                next_state = S1;
                next_hw_light = 3'b010;
            end else begin
            //still count until there is car in current state
                next_count = count + 1;
                next_state = S0;
                next_hw_light = 3'b001;
            end
        end
        S1:begin // hw yellow, lr red 25 clock
            // no need to calculate lr because still red
            if(count == 24)begin
                next_count = 0;
                next_state = S2;
                next_hw_light = 3'b100;
            end
            //not enough clock
            else begin
                next_count = count + 1;
                next_state = S1;
            end
        end
        S2:begin // hw red, lr red 1 cycle
        //setting lr to green for next state
            next_count = 0;
            next_lr_light = 3'b001;
            next_state = S3;
        end
        S3:begin // hw red, lr green 70 cycle
            if(count == 69)begin
                next_count = 0;
                next_state = S4;
                next_lr_light = 3'b010;
            end
            else begin
                next_count = count + 1;
                next_state = S3;
            end
        end
        S4:begin // hw red, lr yellow 25 cycle
            // no need for hw because it is still red
            if(count == 24)begin
                next_count = 0;
                next_state = S5;
                next_lr_light = 3'b100;
            end
            else begin
                next_count = count + 1;
                next_state = S4; 
            end
        end
        S5:begin // hw red, lr red 1 cycle
            // go back to initial state
            next_count = 0;
            next_hw_light = 3'b001;
            next_state = S0;
        end
        default: begin
            next_state = S0;
            next_count = 0;
        end  
    endcase
end

endmodule
