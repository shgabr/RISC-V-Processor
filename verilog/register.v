`timescale 1ns / 1ps

/******************************************************************* 
*
* Module: n_bit_register.v
* Project: Risc-V processor pipelined 
* Author: Sherif Gabr - sherif.gabr@aucegypt.edu
* Author: Mina Ashraf - mina146@aucegypt.edu
* Description:
*   - register that can save a certain 
*
**********************************************************************/

module n_bit_register #(parameter N = 32) (
 input [N-1:0] D,
 input clk, rst, load,
 output [N-1:0] Q
);

    wire [N-1:0] d; 
    genvar i; 
    generate
        for(i = 0; i<N; i = i +1 )
        begin
            mux mx1(D[i],Q[i], load, d[i]);
            DFlipFlop df1(clk, rst, d[i], Q[i]);
        end
    endgenerate
        
endmodule

module mux (input a, b, s, output reg c); 
    wire m,n; 
    always@(*)
    begin 
         
        c = s?a:b;
    end
   
endmodule


module DFlipFlop (input clk, input rst, input D, output reg Q);
    
    always @ (posedge clk or posedge rst)
        if (rst) begin
        Q <= 1'b0;
        end else begin
        Q <= D;
        end
endmodule 
