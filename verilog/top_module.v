`timescale 1ns / 1ps

module top_module(
    input clk, uart_in, 
    output [3:0] Anode, 
    output[6:0] LED_out, 
    output [15:0] LEDs
    );
    
    wire [7:0] out;
    wire [12:0] sevenSD;
    wire [7:0] leds_data;
    
    UART_receiver_multiple_Keys uartKeys (clk, uart_in, out);
    
    processor_main processor (out[7], out[6], out[5:4], out[3:0], leds_data, sevenSD);
    
    Four_Digit_Seven_Segment_Driver_Optimized s7sd (clk, sevenSD, Anode, LED_out);
    
    assign LEDs = {out, leds_data};
   
    
endmodule

/*
Four_Digit_Seven_Segment_Driver_Optimized(
    input clk,
    input [12:0] num,
    output reg [3:0] Anode,
    output reg [6:0] LED_out 
    );
    
*/