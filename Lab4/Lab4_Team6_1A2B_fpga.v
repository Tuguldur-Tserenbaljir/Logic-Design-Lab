`timescale 1ps/1ps

module top(clk,rst_n,start,enter,in,Anode,Cathode,LED); //Game
    input clk;
    input rst_n;
    input start;
    input enter;
    input [3:0] in;

output reg [3:0] Anode;
output reg [6:0] Cathode;
output [15:0] LED;
reg [15:0]display;
// from out3,out2,out1,out0 to LED

reg initialphase = 1'b1;
//reg guessingphase;

wire rst_n_debounce,start_debounce,enter_debounce;
wire rst_n_one, start_one, enter_one;
wire [2:0] Answer,Guess;
wire[3:0]random[3:0];
wire [1:0] LED_activating_counter;

reg [3:0] answer[3:0], guess[3:0];

reg [4:0]LED_BCD;
//reg [4:0] flick;
reg [19:0] refresh_counter;


//debounce(pb_debounced, pb, clk);
debounce rst_debounce(rst_n_debounce,rst_n,clk);
debounce s_debounce(start_debounce,start,clk);
debounce e_debounce(enter_debounce,enter,clk);


//onepulse(pb_debounced, clk, pb_one_pulse);
onepulse rst_one(rst_n_debounce, clk,rst_n_one);
onepulse s_one(start_debounce,clk,start_one);
onepulse e_one(enter_debounce,clk,enter_one);


//Compare(Guess,Answer, answer3,answer2,answer1,answer0,
// guess3,guess2,guess1,guess0);
Compare C1 (Guess,Answer,answer[3],answer[2],answer[1],answer[0],
            guess[3],guess[2],guess[1],guess[0]);


//LFSR(clk, rst_n, out3,out2,out1,out0);
LFSR L1(clk,random[3],random[2],random[1],random[0]);

always @(posedge clk) begin
    if(initialphase)
        refresh_counter <= 0;
    else 
        refresh_counter <= refresh_counter + 1;
end

always @(*) begin
    //output 1A2b;

        case(LED_activating_counter)
        2'b00: begin
            Anode = 4'b0111; 
            LED_BCD = LED[15:11];
             end
        2'b01: begin
            Anode  = 4'b1011; 
            LED_BCD = LED[10:8];
                end
        2'b10: begin
            Anode = 4'b1101; 
            LED_BCD = LED[7:4];
              end
        2'b11: begin
            Anode  = 4'b1110; 
             LED_BCD = LED[3:0];
               end   
        default:begin
             Anode = 4'b0111; 
            LED_BCD = LED[15:11];
            end
        endcase

    case(LED_BCD)
        4'b0000: Cathode = 7'b0000001; //0
        4'b0001: Cathode = 7'b1001111; //1
        4'b0010: Cathode = 7'b0010010; //2
        4'b0011: Cathode = 7'b0000110; //3
        4'b0100: Cathode = 7'b1001100; //4
        4'b0101: Cathode = 7'b0100100; //5
        4'b0110: Cathode = 7'b0100000; //6
        4'b0111: Cathode = 7'b0001111; //7
        4'b1000: Cathode = 7'b0000000; //8
        4'b1001: Cathode = 7'b0000100; //9
        4'b1010: Cathode = 7'b0001000; //A
        4'b1011: Cathode = 7'b1100000; //B
        4'b1100: Cathode = 7'b0110001; //C
        4'b1101: Cathode = 7'b1000010; //D
        4'b1110: Cathode = 7'b0110000; //E
        4'b1111: Cathode = 7'b0111000; //F
        default: Cathode = 7'b1111111;
    endcase
end

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

module LFSR(clk, rst_n, out3,out2,out1,out0);
input clk;
input rst_n;
output reg [4-1:0] out3,out2,out1,out0;
reg [15:0] DFF;
    
always @(posedge clk) begin
     if(rst_n == 1'b0) begin
         DFF[15:0] <= 'b1011110110111101;
    end 
    else begin
    DFF[15] <= (DFF[14] ^ DFF[13] ^ DFF[12] ^ DFF[10]);
    DFF[14] <= DFF[13];
    DFF[12] <= DFF[11];
    DFF[11] <= DFF[10];
    DFF[10] <= DFF[9];
    DFF[9] <= DFF[8];
    DFF[8] <= DFF[7];
    DFF[7] <= DFF[6];
    DFF[6] <= DFF[5];
    DFF[5] <= DFF[4];
    DFF[4] <= (DFF[3]^DFF[7]);
    DFF[3] <= (DFF[2]^DFF[7]);
    DFF[2] <= (DFF[1]^DFF[7]);
    DFF[1] <= DFF[0];
    DFF[0] <= DFF[15];
    end
    out3 <= DFF[15:12];
    out2 <= DFF[11:8];
    out1 <= DFF[7:4];
    out0 <= DFF[3:0];
end

endmodule

module Compare(Guess,Answer, answer3,answer2,answer1,answer0, guess3,guess2,guess1,guess0);
input [3:0] answer3,answer2,answer1,answer0, guess3,guess2,guess1,guess0;

output reg [2:0] Guess,Answer;
reg [3:0] A_Counter, B_Counter;

always @(*)begin
    if(answer3 == guess3)begin
        A_Counter[3] = 1'b1;
        B_Counter[3] = 1'b0;
    end
    else begin
        if(answer3 != guess2 || answer3 != guess1 || answer3 != guess0)begin
            A_Counter[3] = 1'b0;
            B_Counter[3] = 1'b0;
        end
        else begin
            A_Counter[3] = 1'b0;
            B_Counter[3] = 1'b1;
        end
    end


    if(answer2 == guess2)begin
        A_Counter[2] = 1'b1;
        B_Counter[2] = 1'b0;
    end
    else begin
        if(answer2 != guess3 || answer2 != guess1 || answer2 != guess0)begin
            A_Counter[2] = 1'b0;
            B_Counter[2] = 1'b0;
        end
        else begin
            A_Counter[2] = 1'b0;
            B_Counter[2] = 1'b1;
        end
    end


    if(answer1 == guess1)begin
        A_Counter[1] = 1'b1;
        B_Counter[1] = 1'b0;
    end
    else begin
        if(answer1 != guess3 || answer1 != guess2 || answer1 != guess0)begin
            A_Counter[1] = 1'b0;
            B_Counter[1] = 1'b0;
        end
        else begin
            A_Counter[1] = 1'b0;
            B_Counter[1] = 1'b1;
        end
    end


    if(answer0 == guess0)begin
        A_Counter[0] = 1'b1;
        B_Counter[0] = 1'b0;
    end
    else begin
        if(answer0 != guess3 || answer0 != guess2 || answer0 != guess1)begin
            A_Counter[0] = 1'b0;
            B_Counter[0] = 1'b0;
        end
        else begin
            A_Counter[0] = 1'b0;
            B_Counter[0] = 1'b1;
        end
    end

    Guess = A_Counter[3] + A_Counter[2] + A_Counter[1] + A_Counter[0] ;
    Answer = B_Counter[3] + B_Counter[2] + B_Counter[1] + B_Counter[0] ;


end
endmodule