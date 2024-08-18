`timescale 1ns/1ps

module Traffic_Light_Controller_t;
    reg clk;
    reg rst_n;
    reg lr_has_car;
    wire [2:0] hw_light;
    wire [2:0] lr_light;
    
    
    Traffic_Light_Controller TLC(
        .clk(clk),
        .rst_n(rst_n),
        .lr_has_car(lr_has_car),
        .hw_light(hw_light),
        .lr_light(lr_light)
    );
    
    
    parameter cyc = 2;   
    always #(cyc/2) clk = ~clk;
    
    
    initial begin
        clk = 1'b1;
        #cyc rst_n = 1'b0;
        #cyc rst_n = 1'b1;
        lr_has_car = 1'b0;
        
        repeat(20)begin
            @(negedge clk);
        end
        
        #(cyc * 200 ) lr_has_car = 1'b1;
        #(cyc * 100)lr_has_car = 1'b0;
        
        #(cyc * 80 ) lr_has_car = 1'b1;
        #(cyc * 200 ) lr_has_car = 1'b0;


        # (cyc * 5) $finish();

    end

endmodule