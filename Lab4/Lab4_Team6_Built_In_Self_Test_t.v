`timescale 1ns/1ps

module Built_In_Self_Test_t;
    reg clk;
    reg rst_n;
    reg scan_en;
    wire scan_in;
    wire scan_out;
    
    parameter cyc = 10;
    always#(cyc/2)clk = !clk;
    
    Built_In_Self_Test BIST(
    .clk(clk), 
    .rst_n(rst_n), 
    .scan_en(scan_en), 
    .scan_in(scan_in), 
    .scan_out(scan_out)
    );
    initial begin
        clk = 1'b1;
        rst_n = 1'b0;
        scan_en = 1'd0;
        #(cyc)
        @(negedge clk) begin
            rst_n = 1'd1;
            scan_en = 1'd1;
        end
        
        //1011 x 1101 
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(posedge clk) scan_en = 1'b0;
        @(posedge clk) scan_en = 1'b1;     
        
        // Scan_Out Start
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        
        //Scan In Again
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(posedge clk) scan_en = 1'b0;
        @(posedge clk) scan_en = 1'b1;     
        //Scan_Out Again
        #100 $finish;
    end
endmodule
