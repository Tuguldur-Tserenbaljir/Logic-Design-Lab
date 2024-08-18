`timescale 1ns/1ps

module Round_Robin_Arbiter(clk, rst_n, wen, a, b, c, d, dout, valid);
    input clk;
    input rst_n;
    input [3:0] wen;
    input [7:0] a, b, c, d;
    output reg [7:0] dout;
    output reg valid;
    
    reg [3:0] ren = 4'b0000, counter = 4'b0001;
    reg [7:0]D_dout;
    reg D_valid;
    
    wire [7:0] dout_a, dout_b, dout_c, dout_d;
    wire error_a, error_b, error_c, error_d;
    
    always @(posedge clk) begin
        ren = counter;
        if(rst_n == 1'b0)begin
            counter <= 4'b0001;
            ren <= 4'b0000;
        end
        else begin
            if(counter == 4'b1000) counter <= 4'b0001;
            else counter <= counter << 1;
        end
        
        dout <= D_dout;
        valid <= D_valid;
    end
    
    always @(*)begin
        if(ren == 4'b0000)begin
            D_dout = 1'b0;
            D_valid = 1'b0;
        end 
        else begin 
            if(ren[0] == 1'b1 && (wen[0] == 1'b1 || error__a == 1'b1))begin
                    D_dout = 1'b0;
                    D_valid = 1'b0;
            end else begin
                    D_dout = dout_a;
                    D_valid = 1'b1;
            end

            if(ren[0] == 1'b1 && (wen[0] == 1'b1 || error__b == 1'b1))begin
                    D_dout = 1'b0;
                    D_valid = 1'b0;
            end else begin
                    D_dout = dout_b;
                    D_valid = 1'b1;   
            end   

            if (ren[0] == 1'b1 && (wen[0] == 1'b1 || error__c == 1'b1))begin
                    D_dout = 1'b0;
                    D_valid = 1'b0;
            end else begin
                    D_dout = dout_c;
                    D_valid = 1'b1;
                end

            if(ren[0] == 1'b1 && (wen[0] == 1'b1 || error__d == 1'b1))begin
                    D_dout = 1'b0;
                    D_valid = 1'b0;
            end else begin
                    D_dout = dout_d;
                    D_valid = 1'b1;
            end
        end
    end        
    
    FIFO_8 A(clk, rst_n, wen[0], ren[0], a, dout_a, error__a);
    FIFO_8 B(clk, rst_n, wen[1], ren[1], b, dout_b, error__b);
    FIFO_8 C(clk, rst_n, wen[2], ren[2], c, dout_c, error__c);
    FIFO_8 D(clk, rst_n, wen[3], ren[3], d, dout_d, error__d);
    
endmodule
