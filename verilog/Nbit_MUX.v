`timescale 1ns / 1ps

/******************************************************************* 
*
* Module: NBit_MUX2x1.v
* Project: Risc-V processor pipelined 
* Author: Sherif Gabr - sherif.gabr@aucegypt.edu
* Author: Mina Ashraf - mina146@aucegypt.edu
* Description:
*   2x1 MUX that outputs A if selection line is 1 else it outputs B    
*
**********************************************************************/


module NBit_MUX2x1  #(parameter N = 32) (
    input [N-1:0]A, B,
    input S, 
    output[N-1:0]C
    );  
      
     assign  C = S?A:B;
      

endmodule


