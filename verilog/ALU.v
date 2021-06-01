/******************************************************************* 
*
* Module: prv32_ALU.v
* Project: Risc-V processor pipelined 
* Author: Sherif Gabr - sherif.gabr@aucegypt.edu
* Author: Mina Ashraf - mina146@aucegypt.edu
* Description:
*   The ALU computes an operation on 2 inputs and the operation
*    is decided depending on the ALU selection
*   
**********************************************************************/


`include "defines.v"
`timescale 1ns / 1ps
module prv32_ALU(
	input   wire [31:0] a, b,
	input   wire [4:0]  shamt,
	output  reg  [31:0] r,
	output  wire        cf, zf, vf, sf,
	input   wire [3:0]  alufn
);

    wire [31:0] add, sub, op_b;
    wire cfa, cfs;
    
    assign op_b = (~b);
    
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b);  //carry-flag
    
    assign zf = (add == 0);                                     //zero-flag
    assign sf = add[31];                                        //sign-flag
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);            //overflow-flag
    
    wire[31:0] sh;
    shifter shifter0(.a(a), .shamt(shamt), .type(alufn[1:0]),  .r(sh));
    
    always @ * begin
        r = 0;
        (* parallel_case *)
        case (alufn)
            // arithmetic
            `ALU_ADD : r = add;     //add
            `ALU_SUB : r = add;     //subtract
            `ALU_PASS : r = b;       //propagate
            // logic
            `ALU_OR:  r = a | b;   //or
            `ALU_AND:  r = a & b;   //and
            `ALU_XOR:  r = a ^ b;   //xor
            // shift
            `ALU_SRL:  r=sh;        //srl        
            `ALU_SLL:  r=sh;        //sll
            `ALU_SRA:  r=sh;        //sra
            // slt & sltu
            `ALU_SLT:  r = {31'b0,(sf != vf)}; 
            `ALU_SLTU:  r = {31'b0,(~cf)};            	
        endcase
    end
endmodule