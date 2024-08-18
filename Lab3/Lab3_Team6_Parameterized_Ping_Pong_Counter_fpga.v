`timescale 1ns / 1ps

module Parameterized_Ping_Pong_Counter_fpga(clk, rst_n, enable, flip, max, min, LEDOut, Anode);
input clk, rst_n;
input enable;
input flip;
input [4-1:0] max;
input [4-1:0] min;

output reg[7-1:0] LEDOut;
output reg [4-1:0] Anode;

reg [19:0] refresh_counter;
wire [1:0] LED_activating_counter;
reg dclk;
reg [3:0] LED_bcd;
reg [26:0] ClkCounter;

wire flip_db, reset_db;
wire flip_op, reset_op;

wire direction;
wire [3:0] out;

//Debounce and OnePulse for Flip and Reset
debounce debounce_flip (.pb_debounced(flip_db), .pb(flip), .clk(clk));
debounce debounce_reset (.pb_debounced(reset_db), .pb(rst_n), .clk(clk));
onepulse onepulse_flip (.pb_debounced(flip_db),.clk(dclk), .pb_one_pulse(flip_op));
onepulse onepulse_reset (.pb_debounced(reset_db),.clk(dclk), .pb_one_pulse(reset_op));

Parameterized_Ping_Pong_Counter PPPC(
    .clk(dclk), 
    .rst_n(~reset_op),
    .enable(enable),
    .flip(flip_op),
    .max(max),
    .min(min),
    .direction(direction),
    .out(out)
);

// Clock
always @(posedge clk) begin
    refresh_counter <= refresh_counter + 1;
    if (rst_n == 1'b0) begin
        counter <= 1'b0;
    end
    else begin
    ClkCounter = ClkCounter + 1'b1;
    dclk <= (counter % ( 2 ** 25))? 1'b0: 1'b1;
    end
end

assign LED_activating_counter = refresh_counter[19:18];

    always @(*)begin
        case(LED_activating_counter)
        2'b00: begin
            Anode = 4'b0111; 
            LED_bcd = out/10;
        end
        2'b01: begin
            Anode = 4'b1011; 
            LED_bcd = out%10;
        end
        2'b10: begin
            Anode = 4'b1101; 
            LED_bcd = {3'b111,direction};
        end
        2'b11: begin
            Anode = 4'b1110; 
            LED_bcd = {3'b111,direction};
        end
        endcase
    end 
    always @(*)begin
        case(LED_bcd)
        4'b0000: LEDOut = 7'b0000001; // 0    
        4'b0001: LEDOut = 7'b1001111; // 1 
        4'b0010: LEDOut = 7'b0010010; // 2 
        4'b0011: LEDOut = 7'b0000110; // 3 
        4'b0100: LEDOut = 7'b1001100; // 4 
        4'b0101: LEDOut = 7'b0100100; // 5 
        4'b0110: LEDOut = 7'b0100000; // 6 
        4'b0111: LEDOut = 7'b0001111; // 7 
        4'b1000: LEDOut = 7'b0000000; // 8     
        4'b1001: LEDOut = 7'b0000100; // 9
		4'b1110: LEDOut = 7'b1100011; // down
		4'b1111: LEDOut = 7'b0011101; // up
        default: LEDOut = 7'b1111111; // "dead"
        endcase
    end
endmodule


// PPPC Module
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

module onepulse(pb_debounced, clk, pb_one_pulse);
    input pb_debounced;
    input clk;
    output reg pb_one_pulse;
    reg pb_debounced_delay;

    always @(posedge clk) begin
        pb_one_pulse <= pb_debounced & (!pb_debounced_delay);
        pb_debounced_delay <= pb_debounced;
    end

endmodule

module debounce(pb_debounced, pb, clk);
    input pb, clk;
    output pb_debounced;
    
    reg [3:0] DFF;
    
    always @(posedge clk) begin
        DFF[3:1] <= DFF[2:0];
        DFF[0] <= pb;
    end
    
    assign pb_debounced = ((DFF == 4'b1111) ? 1'b1 : 1'b0);
    
endmodule
