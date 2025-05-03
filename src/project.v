//------Digital Temperature Monitor Template-----
/*
 * Copyright (c) 2025 Silicon University, Odisha, India
 */
//`timescale 1ns / 1ps
//Put your DEFINES here
`define RST_COUNT	5'd0
`define MAX_COUNT	5'd28
`define CS_LOW_COUNT    5'd4
`define CS_HIGH_COUNT   5'd20
`define SPI_LATCH_COUNT 5'd22
//
`define SPI_IDLE	2'b00
`define SPI_READ	2'b01
`define SPI_LATCH	2'b10

// DO NOT CHANGE THIS MODULE
module digital_temp_monitor_top (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock e.g. provide a 10 kHz clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  // The enables may not be auto checked. 
  assign uio_oe  = 8'b00111011;
  assign uio_out[7:6] = 2'b00;
  assign uio_out[2] = 1'b0;
//---------------------------------------

// Internal signals 
reg [4:0] count;
reg [1:0] spi_state;
reg [7:0] shift_reg;
reg [7:0] tempC_bin_latch;
wire CS, SIO; 
reg SCK;
wire [3:0] bcd_msb;
wire [3:0] bcd_lsb;
wire bcd_lsb_carry;
wire [3:0] bcd_data;

assign uio_out[0] = CS;              //CS-->chip select for LM70
assign uio_out[1] = SCK;             //SCK--> clock for LM70
assign SIO = uio_in[2];

//--------------Declaration of intenal signal to ports--------------
// Although the inputs can directly be used in the code,
// always good to internally assign them to a more readable port.  
//Internal signal-to-port assignment
  assign sel_ob_LSB  = ui_in[1];       //DIP switch-2: if ui_in[0]=0: 1-> LSB, 0-> MSB
  

// IMPLEMENT CODE HERE
//BCD Logic
//Temp/10 approx. 1/16 + 1/32
assign bcd_msb = (tempC_bin_latch + (tempC_bin_latch>>1))>>4;
//LSB = temp - 10*MSB = temp - (8*MSB + 2*MSB)
assign bcd_lsb = tempC_bin_latch - ((bcd_msb<<3) + (bcd_msb<<1)); 
// Capturing overflow bit
assign bcd_lsb_carry = bcd_lsb > 4'h9;
// MUX for LSB or MSB
assign bcd_data = sel_ob_LSB ? bcd_lsb : bcd_msb + bcd_lsb_carry;
 

//SHIFT REGISTER
//Converts input data (uio_in[2]) from serial to parallel.
always @(posedge SCK or negedge rst_n)
  if (~rst_n)
    shift_reg <= 8'h00;
  else
    begin
      shift_reg <= shift_reg<<1;
      shift_reg[0] <= SIO ;
    end

//SPI CLOCK SCK generator
 
  always @(negedge clk or negedge rst_n)
  if (~rst_n)
    SCK <= 1'b0;
  else if(CS)
    SCK <= 1'b0;
  else
    SCK <= ~SCK;

// Create CS 
assign CS = ~(spi_state == `SPI_READ);

//State machine to create IDLE,READ,LATCH states ot generate CS, SCK 
always @(posedge clk or negedge rst_n)
  if (~rst_n)
      begin	    
        spi_state <= `SPI_IDLE;
	tempC_bin_latch <= 8'h00;
      end
  else if ((count >= `CS_LOW_COUNT) && (count < `CS_HIGH_COUNT) )
      begin
        spi_state <= `SPI_READ;
      end
  else if (count == `SPI_LATCH_COUNT)
      begin	    
        spi_state <= `SPI_LATCH;
        tempC_bin_latch <= shift_reg<<1;
      end
  else 
      begin	    
        spi_state <= `SPI_IDLE;
      end


//5-b counter 
 always @(posedge clk or negedge rst_n)
   if (~rst_n)
       count <= `RST_COUNT;
   else if (count == `MAX_COUNT)
       count <= `RST_COUNT;
   else
       count <= count + 1'b1;

 endmodule
