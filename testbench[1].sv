`timescale 1ns/1ps

parameter  dw =2;
 parameter aw = 4;

module asynchronous_fifo_tb;
  reg wclk, wrst,wr;
  reg rclk,rrst, rd;
  
  wire [dw-1:0] data_out;
  wire full;
  wire empty;
  reg [dw-1:0] data_in;
  wire [aw:0] debug_w1_rgray;
  wire [aw:0] debug_w2_rgray;
  wire [aw:0] debug_r1_wgray;
  wire [aw:0] debug_r2_wgray;

  
 
  
 
      
 asynchronous_fifo #(.aw(aw),.dw(dw)) uut (.wclk(wclk),
                            .rclk(rclk),
                            .wrst(wrst),
                             .rrst(rrst),
                            .rd(rd),
                            .wr(wr),
                            .wfull(full),
                            .rempty(empty),
                            .wdata(data_in),
                                           .rdata(data_out),
                                           .debug_w1_rgray(debug_w1_rgray),
    .debug_w2_rgray(debug_w2_rgray),
    .debug_r1_wgray(debug_r1_wgray),
    .debug_r2_wgray(debug_r2_wgray)
                                           
                                          );
  

      
      
      always #10 wclk = ~wclk;
      always #35 rclk = ~rclk;
      
   // Apply reset
 
  initial begin
    wrst = 1'b1; // 
    rrst = 1'b1; // 
    
    // Write stimulus
    #10 wr = 1'b1; data_in = 2'b01; 
    #20 wr = 1'b0; 
    #30 wr = 1'b1; data_in = 2'b10; 
    #40 wr = 1'b0; 
    
    // Read stimulus
    #50 rd = 1'b1; 
   // #20 rd = 1'b0; 
   
 
   // #10 wr = 1'b1; data_in = 2'b11; 
    //#20 wr = 1'b0; 
    //#30 rd = 1'b1; 
    //#20 rd = 1'b0; 

    // Add more test cases as needed
    #100ns $finish; 
  end

  // Monitor the signals
  initial begin
    $monitor("Time: %d | data_in: %b | data_out: %b | full: %b | empty: %b", 
             $time, data_in, data_out, full, empty);
  end
      
      endmodule
