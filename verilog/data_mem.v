/******************************************************************* 
*
* Module: data_mem.v
* Project: Risc-V processor pipelined 
* Author: Sherif Gabr - sherif.gabr@aucegypt.edu
* Author: Mina Ashraf - mina146@aucegypt.edu
* Description:
*   - single ported memory for both instructions and data.
*   - its size was supposed to be 4kb, but for quick synthesis it was minimzied 
*     to 1kb only.
*   - testing files are commeneted, uncomment and simulate for faster testing process.
**********************************************************************/

`include "defines.v"
`timescale 1ns / 1ps
module Memory (
    input clk, clk_slow,
    input MemRead, input MemWrite,
    input [8:0] addr,           //address is now 9 BITS to represent 512 
    input [31:0] data_in, 
    input [2:0] funct3, 
    output reg [31:0] data_out, inst_out
    );
 
    reg [7:0] mem [0:128];      //8*128 = 1024 byte
    //reg [7:0] mem [0:512];    //uncomment this line for enlarging the memory back 

   
    
    wire msbb, msbh, msbw;
    assign msbb = mem[addr][7];         //most significant bit of byte
    assign msbh = mem[addr+1][7];       //most significant bit of half-word (2 bytes)

    initial begin
        {mem[0], mem[1], mem[2], mem[3]} = 32'h00000033; //initial NOP for correct operation

//      Testing Cases
//        $readmemh("ALUOperations1.mem",mem, 4);
//        $readmemh("ALUOperations2.mem",mem, 4);
//        $readmemh("ALUOperations3.mem",mem, 4);
//        $readmemh("BranchesBEQ.mem",mem, 4);
//        $readmemh("BranchesBNE.mem",mem, 4);
//        $readmemh("BranchesBLT.mem",mem, 4);
//        $readmemh("BranchesBGE.mem",mem, 4);
//        $readmemh("BranchesBLTU.mem",mem, 4);
//        $readmemh("BranchesBGEU.mem",mem, 4);
//        $readmemh("FENCE_EBREAK_ECALL.mem",mem, 4);
//        $readmemh("JAL_JALR.mem",mem, 4);
//        $readmemh("LUI_AUIPC.mem",mem, 4);
        
//        $readmemh("loading_storing.mem",mem, 4);
//        mem [100] = 8'b10011000;
//        mem [101] = 8'b11101111;
//        mem [102] = 8'b11001101;
//        mem [103] = 8'b10101011;
          
//          $readmemh("FPGA_test.mem",mem, 4); 
              
           
    end 
    
    ///////Fetching Instructions////////// 
    always@(*)
    begin
        if(clk_slow)
            inst_out = {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]};
        else inst_out = 32'h33; //NOP  
    end

    /////////Loading//////////
    always@(*)
    begin
        if(MemRead == 1) begin
            case(funct3)
                `F3_LB:     data_out = {{24{msbb}}, mem[addr]};                               //LB
                `F3_LH:     data_out = {{16{msbh}}, mem[addr+1], mem[addr]};                  //LH
                `F3_LW:     data_out = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};    //LW
                `F3_LBU:    data_out = {24'b0, mem[addr]};                                    //LBU
                `F3_LHU:    data_out = {16'b0, mem[addr+1], mem[addr]};                       //LHU
                default:    data_out = 32'b0;
            endcase
        end 
        else data_out = 32'b0;
    end


    /////////Storing//////////
    always @(posedge clk) begin
        if (MemWrite==1) begin
            case (funct3)
                `F3_SB: mem[addr] = data_in[7:0]; //SB 
                `F3_SH: begin   //SH
                        mem[addr]   = data_in[7:0];
                        mem[addr+1] = data_in[15:7];    
                end
                `F3_SW: begin   //SW
                        mem[addr]   = data_in[7:0];
                        mem[addr+1] = data_in[15:8];  
                        mem[addr+2] = data_in[23:16];
                        mem[addr+3] = data_in[31:24];   
                end
                
            endcase  
        end
    end

endmodule
