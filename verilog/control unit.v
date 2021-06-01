/******************************************************************* 
*
* Module: control_unit.v
* Project: Risc-V processor pipelined 
* Author: Sherif Gabr - sherif.gabr@aucegypt.edu
* Author: Mina Ashraf - mina146@aucegypt.edu
* Description:
*   - checks the instruction opcode and generate the control wires that 
*     control what the instruction can do.
*
**********************************************************************/

`timescale 1ns / 1ps
`include "defines.v"

 /* Control =          
     Halt       1bit    (signed or unsigned)
     MemRead    1bit    (read from memory)
     MemWrite   1bit    (write to memory)
     ToReg      2bits   (write to register)
     ALUOP      2bits   (Alu operation)   
     ALUSrc1    1bit    (First MUX selection to ALU)    
     ALUSrc2    1bit    (Second MUX selection to ALU)    
     RegWrite   1bit    (Write to register file)
     __________________________________________________
                10 bits
*/



module cu(
    input [31:0] instruction, 
    output reg [9:0] controls);

    always @(*) begin
        casez (instruction[`IR_opcode])
        
            `OPCODE_Arith_R:       //R-format Operations
                controls = 10'b0_0_0_01_10_0_0_1;
                
            `OPCODE_Load:       //Load Instructions
                controls = 10'b0_1_0_10_00_0_1_1;
        
            `OPCODE_Store:       //Store Instructions
                controls = 10'b0_0_1_00_00_0_1_0;

            `OPCODE_Branch:       //Branch Instructions
                controls = 10'b0_0_0_00_01_0_0_0;     
            
            `OPCODE_LUI:       //lui
                controls = 10'b0_0_0_01_11_0_1_1;

            `OPCODE_AUIPC:       //auipc
                controls = 10'b0_0_0_11_00_1_1_1;  

            `OPCODE_JAL:       //jal
                controls = 10'b0_0_0_00_00_1_1_1;

            `OPCODE_JALR:       //jalr 
                controls = 10'b0_0_0_00_00_0_1_1;

            `OPCODE_Arith_I:       //I type
                controls = 10'b0_0_0_01_10_0_1_1;
                   
            `OPCODE_FENCE:      //FENCE
                controls = 10'b0_0_0_00_00_0_0_0;

            `OPCODE_SYSTEM:     //ECALL & EBREAK
                controls = (instruction[20]) ? 10'b0_0_0_00_00_0_0_0  : 10'b1_0_0_00_00_0_0_0;
            
            default: 
                controls = 10'd0_0_0_00_00_0_0_0;

        endcase
    end
endmodule
