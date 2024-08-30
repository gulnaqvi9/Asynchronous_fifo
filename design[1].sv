// Code your design here
// Code your testbench here
// or browse Examples
//`timescale 1ns/1ps
module asynchronous_fifo  #(parameter dw = 2,parameter aw = 4)( input wire wclk, wrst,wr,rclk,rrst,rd,
                                                               input wire [dw-1:0] wdata,
                                                                output reg wfull,
                                                               output wire [dw-1:0] rdata,
                                                                output reg rempty,
                                                              output wire [aw:0] debug_w1_rgray, // Expose internal signal
  output wire [aw:0] debug_w2_rgray, 
  output wire [aw:0] debug_r1_wgray,
  output wire [aw:0] debug_r2_wgray 
);

// Internal signals
reg [aw:0] w1_rgray, w2_rgray, r1_wgray, r2_wgray;

// Connect internal signals to debug ports
assign debug_w1_rgray = w1_rgray;
assign debug_w2_rgray = w2_rgray;
assign debug_r1_wgray = r1_wgray;
assign debug_r2_wgray = r2_wgray;
  
  parameter  depth = 2^aw;
  
//  input wire wclk,wrst,wr,rclk,rrst,rd;
 // input wire [dw-1:0] wdata;
  //output reg wfull;
  //output wire [dw-1:0] rdata;
  //output reg rempty;
  //reg [aw:0] wgray, wbin, w1_rgay, w2_rgray, rgray, rbin, r1_wgray, r2_wgray;
  
  wire[aw-1:0] waddr,raddr;
  wire wfull_next, rempty_next;
  
  reg [aw:0] wgray, wbin, rgray, rbin;
  
  wire [aw:0] wgraynext,wbinnext;
  wire [aw:0] rgraynext,rbinnext;
  
  reg [dw-1:0] mem [0:depth-1];
  
  
  initial begin
    w2_rgray = 0;
    w1_rgray = 0;
  end
  
  always@(posedge wclk or negedge wrst)
    begin
      if(!wrst)
      {w2_rgray, w1_rgray} <= 0;
      else
      {w2_rgray, w1_rgray} <= {w1_rgray, rgray};
    end
  
  assign wbinnext = wbin + {{(aw){1'b0}},((wr) && (~wfull))};
  assign wgraynext = (wbinnext >> 1) ^ wbinnext;
  
  assign waddr = wbin[aw-1:0];
  
  
  initial begin
    wbin = 0;
    wgray = 0;
  end
  
  always@(posedge wclk or negedge wrst)
    begin
    if(~wrst)
    {wbin, wgray} <=0;
  else
  {wbin, wgray} <= {wbinnext, wgraynext};
  
    end
  
  assign wfull_next = (wgraynext == {~w2_rgray[aw:aw-1],w2_rgray[aw-2:0]});
                       
                       
                       
initial wfull = 0;
                       always@(posedge wclk or negedge wrst)
                         begin
                           if(~wrst)
                             wfull <= 0;
                           else
                             wfull <= wfull_next;
                         end
                       
                       always@(posedge wclk)
                         if((wr) && (~wfull))
                           mem[waddr] <= wdata;
                       
                       
                       
                       initial{r2_wgray, r1_wgray} = 0;
                       always@(posedge rclk or negedge rrst)
                         begin
                         if(~rrst)
                         {r2_wgray, r1_wgray} <= 0;
                           else
                           {r2_wgray, r1_wgray} <= {r1_wgray, wgray};
                           end
                       
                       assign rbinnext = rbin + {{(aw){1'b0}}, ((rd) && (~rempty)) };
                       assign rgraynext = (rbinnext >>1)^ rbinnext;
                       
                       
                       initial {rbin, rgray} = 0;
                       always@(posedge rclk or negedge rrst)
                         begin
                           if(~rrst)
                           {rbin, rgray} <= 0;
                           else
                           {rbin, rgray} <= {rbinnext, rgraynext};
                         end
                       
                       assign raddr = rbin[aw-1:0];
                       
                       assign rempty_next = (rgraynext == r2_wgray);
                       
                       initial rempty = 1;
                       always@(posedge rclk or negedge rrst)
                         begin
                           if(~rrst)
                             rempty <= 1'b1;
                           else
                             rempty <= rempty_next;
                         end
                       
                       assign rdata = mem[raddr];
endmodule
