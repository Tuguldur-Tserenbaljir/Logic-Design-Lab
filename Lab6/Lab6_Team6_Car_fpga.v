`timescale 1ns/1ps

parameter FRONT = 2'd0;
parameter LEFT  =2'd1;
parameter RIGHT  = 2'd2;
parameter STOP   = 2'd3;
 
module Top(
    input clk,
    input rst,
    input echo,
    input left_signal,
    input right_signal,
    input mid_signal,

    output trig,
    output reg left_motor,
    output reg [1:0]left,
    output reg right_motor,
    output reg [1:0]right
    );
    wire [1:0] state;
    wire [1:0] speed;
    wire rst_n_db, rst_n_op, stop;

    debounce db_0(.pb_debounced(db_rst_n), .pb(rst_n), .clk(clk)); // Done
    onepulse op_0(.pb_debounced(db_rst_n), .clock(clk), .pb_one_pulse(op_rst_n)); // Done

    assign left_motor = speed[0];
    assign right_motor = speed[1];

    motor A(
        .clk(clk),
        .rst(rst),
        .mode(state),
        .pwm(speed)
    );

    sonic_top B(
        .clk(clk), 
        .rst(rst), 
        .Echo(echo), 
        .Trig(trig),
        .stop(stop) // check distance output 1/0
    );
    
    tracker_sensor C(
        .clk(clk), 
        .reset(Rst_n), 
        .left_signal(~left_signal), 
        .right_signal(~right_signal),
        .mid_signal(~mid_signal), 
        .state(state)
       );

    always @(*) begin
        // [TO-DO] Use left and right to set your pwm
        //if(stop) {left, right} = ???;
        //else  {left, right} = ???;
        if(stop) begin
            left[0] = 1'b0;
            left[1] = 1'b0;
            right[0] = 1'b0;
            right[1] = 1'b0;
            left_motor = 1'b0;
            right_motor = 1'b0;
            
        end 
        else begin
            case(state)
                FRONT :  begin
                    left[0] = 1'b0;
                    left[1] = 1'b1;
                    right[0] = 1'b0;
                    right[1] = 1'b1;

                end
                LEFT: begin  
                    left[0] = 1'b1;
                    left[1] = 1'b0;
                    right[0] = 1'b0;
                    right[1] = 1'b1;

                end
                RIGHT: begin 
                    left[0] = 1'b0;
                    left[1] = 1'b1;
                    right[0] =1'b1;
                    right[1] = 1'b0;

                end
                STOP: begin
                    left[0] = 1'b0;
                    left[1] = 1'b0;
                    right[0] = 1'b0;
                    right[1] = 1'b0;
                end
                default : begin
                    left[0] = 1'b0;
                    left[1] = 1'b1;
                    right[0] = 1'b0;
                    right[1] = 1'b1;
                end

            endcase
        end
        
    end
endmodule

module debounce (pb_debounced, pb, clk);
	output pb_debounced; // signal of a pushbutton after being debounced
	input pb; // signal from a pushbutton
	input clk;

	reg [3:0] DFF;
	always @(posedge clk)begin
		DFF[3:1] <= DFF[2:0];
		DFF[0] <= pb;
	end
	assign pb_debounced = ((DFF == 4'b1111) ? 1'b1 : 1'b0);
endmodule
module onepulse (pb_debounced, clock, pb_one_pulse);
	input pb_debounced;
	input clock;
	output reg pb_one_pulse;
	reg pb_debounced_delay;
	always @(posedge clock) begin
		pb_one_pulse <= pb_debounced & (! pb_debounced_delay);
		pb_debounced_delay <= pb_debounced;
	end
endmodule


/*
    tracker_sensor.v
*/
module tracker_sensor(clk, reset, left_signal, right_signal, mid_signal, state);
    input clk;
    input reset;
    input left_signal, right_signal, mid_signal;
    output reg [1:0] state;

    // [TO-DO] Receive three signals and make your own policy.
    // Hint: You can use output state to change your action.
    
    always @(posedge clk, posedge reset)begin
        if(reset)begin
            state <= STOP;
        end 
        else begin
            if(left_signal == 1'b0 && mid_signal == 1'b0 && right_signal == 1'b1) begin
                state <= RIGHT;
            end
            if(left_signal == 1'b0 && mid_signal == 1'b1 && right_signal == 1'b0) begin
                state <= FRONT;
            end
            if(left_signal == 1'b0 && mid_signal == 1'b1 && right_signal == 1'b1) begin
                state <= RIGHT;
            end
            if(left_signal == 1'b1 && mid_signal == 1'b0 && right_signal == 1'b0) begin
                state <= LEFT;
            end
            if(left_signal == 1'b1 && mid_signal == 1'b0 && right_signal == 1'b1) begin
                state <= STOP;
            end
            if(left_signal == 1'b1 && mid_signal == 1'b1 && right_signal == 1'b0) begin
                state <= LEFT;
            end
            if(left_signal == 1'b1 && mid_signal == 1'b1 && right_signal == 1'b1) begin
                state <= STOP;
            end
        end
    end
                // FRONT   2'd0
                // LEFT    2'd1
                // RIGHT   2'd2
                // STOP    2'd3
endmodule

/*
    motor.v
*/
module motor(
    input clk,
    input rst,
    input [1:0]mode,
    output[9:0] duty,
    output  [1:0]pwm
);

    reg [9:0]next_left_motor, next_right_motor;
    reg [9:0]left_motor, right_motor;
    wire left_pwm, right_pwm;

    motor_pwm m0(clk, rst, left_motor, left_pwm);
    motor_pwm m1(clk, rst, right_motor, right_pwm);
    
    parameter SLOW = 10'd600;
    parameter FAST = 10'd750;
    parameter STOP = 10'd0;
    
    always@(posedge clk)begin
        if(rst)begin
            left_motor <= 10'd0;
            right_motor <= 10'd0;
        end else begin
            left_motor <= next_left_motor;
            right_motor <= next_right_motor;
        end
    end
    
    // [TO-DO] take the right speed for different situation
    assign pwm = {left_pwm, right_pwm};
    
    always @(*)begin
        case(mode)
            FRONT:begin
                next_left_motor = FAST;
                next_right_motor= FAST;    
            end
            LEFT:begin
                next_left_motor = SLOW;
                next_right_motor= FAST;
            end
            RIGHT:begin
                next_left_motor = FAST;
                next_right_motor= SLOW;
            end
            STOP:begin
                next_left_motor = STOP;
                next_right_motor= STOP;
            end
        endcase
    end

endmodule

module motor_pwm (
    input clk,
    input reset,
    input [9:0]duty,
	output pmod_1 //PWM
);
        
    PWM_gen pwm_0 ( 
        .clk(clk), 
        .reset(reset), 
        .freq(32'd25000),
        .duty(duty), 
        .PWM(pmod_1)
    );

endmodule

//generte PWM by input frequency & duty
module PWM_gen (
    input wire clk,
    input wire reset,
	input [31:0] freq,
    input [9:0] duty,
    output reg PWM
);
    wire [31:0] count_max = 32'd100_000_000 / freq;
    wire [31:0] count_duty = count_max * duty / 32'd1024;
    reg [31:0] count;
        
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count <= 32'b0;
            PWM <= 1'b0;
        end else if (count < count_max) begin
            count <= count + 32'd1;
            if(count < count_duty)
                PWM <= 1'b1;
            else
                PWM <= 1'b0;
        end else begin
            count <= 32'b0;
            PWM <= 1'b0;
        end
    end
endmodule

/*
    sonic.v
*/
module sonic_top(clk, rst, Echo, Trig, stop);
	input clk, rst, Echo;
	output Trig, stop;

	wire[19:0] dis;
	wire[19:0] d;
    wire clk1M;
	wire clk_2_17;

    div clk1(clk ,clk1M);
	TrigSignal u1(.clk(clk), .rst(rst), .trig(Trig));
	PosCounter u2(.clk(clk1M), .rst(rst), .echo(Echo), .distance_count(dis));

    assign stop = (dis <= 20'd4000 )?(1'b1):(1'b0);  
endmodule

module PosCounter(clk, rst, echo, distance_count); 
    input clk, rst, echo;
    output[19:0] distance_count;

    parameter S0 = 2'b00;
    parameter S1 = 2'b01; 
    parameter S2 = 2'b10;
    
    wire start, finish;
    reg[1:0] curr_state, next_state;
    reg echo_reg1, echo_reg2;
    reg [19:0] count, next_count, distance_register, next_distance;
    wire[19:0] distance_count; 

    always@(posedge clk) begin
        if(rst) begin
            echo_reg1 <= 1'b0;
            echo_reg2 <= 1'b0;
            count <= 20'b0;
            distance_register <= 20'b0;
            curr_state <= S0;
        end
        else begin
            echo_reg1 <= echo;   
            echo_reg2 <= echo_reg1; 
            count <= next_count;
            distance_register <= next_distance;
            curr_state <= next_state;
        end
    end

    always @(*) begin
        case(curr_state)
            S0: begin
                next_distance = distance_register;
                if (start) begin
                    next_state = S1;
                    next_count = count;
                end else begin
                    next_state = curr_state;
                    next_count = 20'b0;
                end 
            end
            S1: begin
                next_distance = distance_register;
                if (finish) begin
                    next_state = S2;
                    next_count = count;
                end else begin
                    next_state = curr_state;
                    next_count = (count > 20'd600_000) ? count : count + 1'b1;
                end 
            end
            S2: begin
                next_distance = count;
                next_count = 20'b0;
                next_state = S0;
            end
            default: begin
                next_distance = 20'b0;
                next_count = 20'b0;
                next_state = S0;
            end
        endcase
    end

    assign distance_count = distance_register * 20'd100 / 20'd58; 
    assign start = echo_reg1 & ~echo_reg2;  
    assign finish = ~echo_reg1 & echo_reg2; 
endmodule

module TrigSignal(clk, rst, trig);
    input clk, rst;
    output trig;

    reg trig, next_trig;
    reg[23:0] count, next_count;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            count <= 24'b0;
            trig <= 1'b0;
        end
        else begin
            count <= next_count;
            trig <= next_trig;
        end
    end

    always @(*) begin
        next_trig = trig;
        next_count = count + 1'b1;
        if(count == 24'd999)
            next_trig = 1'b0;
        else if(count == 24'd9999999) begin
            next_trig = 1'b1;
            next_count = 24'd0;
        end
    end
endmodule

module div(clk ,out_clk);
    input clk;
    output out_clk;
    reg out_clk;
    reg [6:0] cnt;
    
    always @(posedge clk) begin   
        if(cnt < 7'd50) begin
            cnt <= cnt + 1'b1;
            out_clk <= 1'b1;
        end 
        else if(cnt < 7'd100) begin
	        cnt <= cnt + 1'b1;
	        out_clk <= 1'b0;
        end
        else if(cnt == 7'd100) begin
            cnt <= 7'b0;
            out_clk <= 1'b1;
        end
        else begin 
            cnt <= 7'b0;
            out_clk <= 1'b1;
        end
    end
endmodule
