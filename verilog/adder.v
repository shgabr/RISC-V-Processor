/******************************************************************* 
*
* Module: adder.v
* Project: Risc-V processor pipelined 
* Author: Sherif Gabr - sherif.gabr@aucegypt.edu
* Author: Mina Ashraf - mina146@aucegypt.edu
* Description:
*   a simple adder module using ripple carry adders
*
*
* 
**********************************************************************/ 

`timescale 1ns / 1ps
module adder #(parameter N=32) (input[N-1:0] x, [N-1:0] y, input cin, output [N-1:0]s, output cout);

wire [N:0]carry;

assign carry[0] = cin;


   generate 
       for (genvar j=0; j<N; j=j+1) begin
           rca1 rc(x[j], y[j], carry[j], s[j], carry[j+1]);
       end
   endgenerate 
   
   assign cout = carry[N];

endmodule



module rca1(input x, input y, input cin, output s, output cout);

   assign {cout,s} = x+y+cin;
   
endmodule 