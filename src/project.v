//------Digital Temperature Monitor Template-----
/*
 * Copyright (c) 2025 Silicon University, Odisha, India
 */
//`timescale 1ns / 1ps
//Put your DEFINES here

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

//--------------Declaration of intenal signal to ports--------------
// Although the inputs can directly be used in the code,
// always good to internally assign them to a more readable port.  
//Internal signal-to-port assignment
  assign sel_ob_LSB  = ui_in[1];       //DIP switch-2: if ui_in[0]=0: 1-> LSB, 0-> MSB
  

// IMPLEMENT CODE HERE

 endmodule
