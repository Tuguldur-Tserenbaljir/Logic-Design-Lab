module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
input clk, rst_n;
input enable;
input flip;
input [4-1:0] max;
input [4-1:0] min;
output direction;
output [4-1:0] out;

// Init
reg dir = 1'b1, next_dir;
reg [4-1:0] count = 4'b0000, next_count;

// LOGIC
/* 
if flip == 1, then the counter will flip direction
if flip == 0, then the counter will not flip direction
if reach max / min , change direction, 
*/
// Sequential (Latch)
always @(posedge clk) begin
    if(rst_n == 1'b0) begin
        count <= min;
        dir <= 1'b1;
    end 
    else begin
        count <= next_count;
        dir <= next_dir;
    end
end

//Combination (Logic Circuit)
    always@(*)begin
        if(enable == 1'b1 && max > min)begin
            if(count <= max && count >= min)begin
                //DEBUG DONE
                if(flip == 1'b1 & count != max & count != min & dir == 1'b1) begin 
                    next_dir = 1'b0;
                    next_count = count - 1'b1;
                end
                else if (flip == 1'b1 & count != max & count != min & dir == 1'b0)begin
                    next_dir = 1'b1;
                    next_count = count + 1'b1;
                end 
                // DEBUG DONE
                else begin 
                    if (dir == 1'b1)begin
                        if (count == max) begin
                            next_dir = 1'b0;
                            next_count = count - 1'b1;
                        end
                        else begin
                            next_count = count + 1'b1;
                            next_dir = dir;
                        end
                    end
                    // DEBUG DONE
                    else begin
                        if (count == min) begin
                            next_dir = 1'b1;
                            next_count = count + 1'b1;
                        end
                        else begin
                            next_count = count - 1'b1;
                            next_dir = dir;
                        end
                    end
                    // DEBUG DONE
                end
            end
            else begin
                next_count = count;
                next_dir = dir;
            end
        end
        else begin
            next_count = count;
            next_dir = dir;
        end
    end

// Output
assign direction = dir;
assign out = count;

endmodule