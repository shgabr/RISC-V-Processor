`include "defines.v"
`timescale 1ns / 1ps
module branch_controls (
    input [6:0] opcode, 
    input [2:0] funct3, 
    input cf, zf, vf, sf, ef,
    output reg [1:0] pc_selection);

always@(*) begin
    case(opcode)
        `OPCODE_JAL:  //jal
            pc_selection = 2'b10;       //result adder branch
        `OPCODE_JALR:
            pc_selection = 2'b01;       //ALU result jalr (pc = rs1 + immed << 1) 
        `OPCODE_Branch:
            begin 
                case(funct3)
                    `BR_BEQ: pc_selection = zf ? 2'b10 : 2'b00;  //BEQ 
                    
                    `BR_BNE: pc_selection = zf ? 2'b00 : 2'b10;  //BNE (branch if ~zf)

                    `BR_BLT: pc_selection = (sf != vf) ? 2'b10 : 2'b00;  //BLT

                    `BR_BGE: pc_selection = (sf == vf) ? 2'b10 : 2'b00;  //BGE

                    `BR_BLTU: pc_selection = cf ? 2'b00 : 2'b10;  //BLTU (branch if ~cf)

                    `BR_BGEU: pc_selection = cf ? 2'b10 : 2'b00;  //BGEU
                    
                    default: pc_selection = 2'b00;
                endcase
            end

        `OPCODE_SYSTEM:     //ECALL & EBREAK
            pc_selection = (ef) ? 2'b11 : 2'b00;

        default: pc_selection = 2'b00;
    
    endcase

end
endmodule 