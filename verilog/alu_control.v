/******************************************************************* 
*
* Module: alu_control.v
* Project: Risc-V processor pipelined 
* Author: Sherif Gabr - sherif.gabr@aucegypt.edu
* Author: Mina Ashraf - mina146@aucegypt.edu
* Description:
*   The ALU control unit that generates the ALU selection lines that
*   will decide which function to be perfomed by the ALU 
*   
*   it checks bit #31, and the funct3 bits, and the opcode, and it 
*   generates the suitable 4-bit selection line for them.
**********************************************************************/

`timescale 1ns / 1ps
`include "defines.v"

module alu_cu( 
  input [31:0] instr, 
  input [1:0] aluOP, 
  output reg [3:0] alu_selection );

    wire [10:0] controlW;
    
    assign controlW = {instr[30],instr[14:12],instr[6:0]};

    always @(*) begin
        case (aluOP)
        2'b00 : alu_selection = `ALU_ADD;      //add        (load, store, jalr)
        
        2'b01 : alu_selection = `ALU_SUB;      //subtract   (branching)

        2'b11 : alu_selection = `ALU_PASS;      //propagate  (LUI)

        2'b10 :                                //check opcode, funct3, & funct7
          begin
            case (controlW)
              11'b0_000_0010011, 11'b1_000_0010011 : alu_selection = `ALU_ADD;   //add   (ADDI)
              11'b0_010_0010011, 11'b1_010_0010011 : alu_selection = `ALU_SLT;   //slt   (SLTI)
              11'b0_011_0010011, 11'b1_011_0010011 : alu_selection = `ALU_SLTU;  //sltu  (SLTIU)
              11'b0_100_0010011, 11'b1_100_0010011 : alu_selection = `ALU_XOR;   //xor   (XORI)
              11'b0_110_0010011, 11'b1_110_0010011 : alu_selection = `ALU_OR;    //or    (ORI)
              11'b0_111_0010011, 11'b1_111_0010011 : alu_selection = `ALU_AND;   //and   (ANDI)
              11'b0_001_0010011 : alu_selection = `ALU_SLL;   //sll   (SLLI)
              11'b0_101_0010011 : alu_selection = `ALU_SRL;   //srl   (SRLI)
              11'b1_101_0010011 : alu_selection = `ALU_SRA;   //sra   (SRAI)
              
              11'b0_000_0110011 : alu_selection = `ALU_ADD;   //add   (ADD)
              11'b1_000_0110011 : alu_selection = `ALU_SUB;   //sub   (SUB)
              11'b0_001_0110011 : alu_selection = `ALU_SLL;   //sll   (SLL)
              11'b0_010_0110011 : alu_selection = `ALU_SLT;   //slt   (SLT)
              11'b0_011_0110011 : alu_selection = `ALU_SLTU;  //sltu  (SLTU)
              11'b0_100_0110011 : alu_selection = `ALU_XOR ;  //xor   (XOR)
              11'b0_101_0110011 : alu_selection = `ALU_SRL;   //srl   (SRL)
              11'b1_101_0110011 : alu_selection = `ALU_SRA;   //sra   (SRA)
              11'b0_110_0110011 : alu_selection = `ALU_OR;    //or    (OR)
              11'b0_111_0110011 : alu_selection = `ALU_AND;   //and   (AND)
              
              default: alu_selection = `ALU_PASS;

            endcase
          end

        default: alu_selection = 4'b00_00;   
      endcase  
      
    end
    
endmodule
