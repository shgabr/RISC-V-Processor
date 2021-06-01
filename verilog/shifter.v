/******************************************************************* 
*
* Module: shifter.v
* Project: Risc-V processor pipelined 
* Author: Sherif Gabr - sherif.gabr@aucegypt.edu
* Author: Mina Ashraf - mina146@aucegypt.edu
* Description:
*   - shift values depending type by shamt amount 
*   - "signed" is used in declaration to signify signed value (must be used for SRA)
*
**********************************************************************/

`timescale 1ns / 1ps
module shifter (
 input signed [31:0] a,
 input [4:0] shamt, 
 input [1:0] type, 
 output reg signed [31:0] r);

        always@(*) begin

            case (type)
                2'b00 :   r = a >> shamt;       //srl
                2'b01 :   r = a << shamt;       //sll
                2'b10 :   r = a >>> shamt;      //sra
                default:  r = a;
            endcase

        end


endmodule 
    
