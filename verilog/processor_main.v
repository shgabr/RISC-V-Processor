`timescale 1ns / 1ps

/******************************************************************* 
*
* Module: processor_main.v
* Project: Risc-V processor pipelined 
* Author: Sherif Gabr - sherif.gabr@aucegypt.edu
* Author: Mina Ashraf - mina146@aucegypt.edu
* Description:
*  - A compilation of all the modules in a pipeline arrangement 
*    that ensures correct execution of all instructions.
*  
**********************************************************************/

module processor_main(
    input clk, reset, 
    input [1:0] ledSel, 
    input [3:0] ssdSel,
    output reg [7:0] leds, 
    output reg [12:0] ssd
    );

    reg clk_slow;
    always @(posedge clk or posedge reset) begin
        if (reset) clk_slow = 0;
        else 
        clk_slow = clk_slow + 1;
    end



    /*******    IF   ********/
    wire [31:0] pc, pc_next,  pc_adder_branch, pc_add4;
    wire pc_cout;
    wire [31:0] instruction;
    wire [8:0] memory_address;  
    wire [31:0] data_out;


    /*******    IF/ID   ********/
    wire [95:0] input_if_id;
    wire [31:0] output_if_id_inst, output_if_id_pc, output_if_id_pc_add4;
    wire [31:0] immgenOut;
    wire controls_zero_sel; 
    wire [9:0] controls, new_controls;
    wire [31:0] read_data_1, read_data_2;


    /*******    ID/EX   ********/
    wire [195:0] input_id_ex;
    wire [9:0] output_id_ex_controls;
    wire [31:0] output_id_ex_pc, output_id_ex_pc_add4, output_id_ex_read_data_1, output_id_ex_read_data_2, output_id_ex_read_data_2_forward, output_id_ex_immgenOut;
    wire [3:0] output_id_ex_aluControl;
    wire [4:0] output_id_ex_destReg;
    wire [6:0] output_id_ex_opCode;
    wire [4:0] output_id_ex_rs1, output_id_ex_rs2;
    wire [3:0] alu_selection;
    wire [31:0] ALU1stInput, ALUPre2ndInput, ALU2ndInput;
    wire [31:0] ALUresult;
    wire cf, zf, vf, sf;
    wire [4:0] shamt;


    /*******    EX/MEM   ********/
    wire [184:0] input_ex_mem;
    wire [5:0] output_ex_mem_controls;
    wire [31:0] output_ex_mem_pc, output_ex_mem_pc_addbranch, output_ex_mem_pc_add4, output_ex_mem_alu_result, output_ex_mem_read_data_2;
    wire output_ex_mem_cf, output_ex_mem_zf, output_ex_mem_vf, output_ex_mem_sf;
    wire [4:0] output_ex_mem_destReg;
    wire [6:0] output_ex_mem_opCode;
    wire [2:0] output_ex_mem_funct3;
    wire [1:0] pc_selection;
    wire forwardA, forwardB;


    /*******    MEM/WB   ********/
    wire [135:0] input_mem_wb;
    wire [4:0] output_mem_wb_destReg;
    wire [2:0] output_mem_wb_controls;
    wire [31:0] output_mem_wb_alu_result, output_mem_wb_data_out, output_mem_wb_pc_add4, output_mem_wb_pc_addbranch;

    wire [31:0] write_data;     //output of MUX (selection between ALU output & read data memory)
    
    wire load;


    /*** IF STAGE ***/
        n_bit_register PC (pc_next, clk_slow,reset, load, pc);
        adder PC_add4 (pc, 4, 0, pc_add4, pc_cout);
        
        assign memory_address = clk_slow ? pc[8:0] : output_ex_mem_alu_result [8:0];
        Memory mem (clk, clk_slow, output_ex_mem_controls[4], output_ex_mem_controls[3], memory_address, output_ex_mem_read_data_2, output_ex_mem_funct3, data_out, instruction);

    /*** ID STAGE ***/
    assign input_if_id = {pc, instruction, pc_add4};
    n_bit_register #(96) IF_ID_reg(input_if_id, clk, reset, 1, {output_if_id_pc, output_if_id_inst, output_if_id_pc_add4});
            
        hazard_control_unit hcu (pc_selection, controls_zero_sel);

        cu controlUnit (output_if_id_inst, controls);    
        // Halt     = controls[9];
        // MemRead  = controls[8];
        // MemWrite = controls[7];
        // [1:0] ToReg  = controls[6:5];
        // [1:0] ALUOP  = controls[4:3];
        // ALUSrc1  = controls[2];
        // ALUSrc2  = controls[1];
        // RegWrite = controls[0];

        assign load = ~controls[9];
        NBit_MUX2x1 #(10) new_controls_mux (10'b0, controls, controls_zero_sel, new_controls); 

        reg_file registerfile (write_data, output_if_id_inst[19:15], output_if_id_inst[24:20], output_mem_wb_destReg, output_mem_wb_controls[0], ~clk, reset, read_data_1, read_data_2);
        rv32_ImmGen immediategen (output_if_id_inst, immgenOut);


    /*** EX STAGE ***/
    assign input_id_ex = {output_if_id_inst[24:20], output_if_id_inst[19:15], new_controls, output_if_id_pc, read_data_1, read_data_2, immgenOut, output_if_id_inst[30], output_if_id_inst[14:12], output_if_id_inst[11:7], output_if_id_inst[6:0], output_if_id_pc_add4};
    n_bit_register #(196) ID_EX_reg (input_id_ex, clk, reset, 1, 
    {output_id_ex_rs2, output_id_ex_rs1,output_id_ex_controls, output_id_ex_pc,output_id_ex_read_data_1, output_id_ex_read_data_2, output_id_ex_immgenOut, output_id_ex_aluControl, output_id_ex_destReg, output_id_ex_opCode, output_id_ex_pc_add4});
    
        wire [31:0] fake_inst_alu = {1'b0, output_id_ex_aluControl[3], 15'b0, output_id_ex_aluControl[2:0], 5'b0, output_id_ex_opCode}; 
        alu_cu ALUCntrl (fake_inst_alu, output_id_ex_controls[4:3], alu_selection);
                                                                                                                                                                                 

        forwarding_unit fu (output_id_ex_rs1, output_id_ex_rs2, output_mem_wb_destReg, output_mem_wb_controls[0], forwardA, forwardB);
        NBit_MUX2x1 fowardMUXA (write_data, output_id_ex_read_data_1, forwardA, ALU1stInput); 
        NBit_MUX2x1 fowardMUXB (write_data, output_id_ex_read_data_2, forwardB, ALUPre2ndInput);
        
        NBit_MUX2x1 alu2input (output_id_ex_immgenOut, ALUPre2ndInput, output_id_ex_controls[1], ALU2ndInput);
         assign output_id_ex_read_data_2_forward = ALUPre2ndInput;


        assign shamt = (output_id_ex_opCode[5]==1) ? ALU2ndInput : output_id_ex_rs2;
        prv32_ALU ALU (ALU1stInput, ALU2ndInput, shamt, ALUresult, cf, zf, vf, sf, alu_selection); 

        adder PC_addImm (output_id_ex_pc, output_id_ex_immgenOut, 0, pc_adder_branch, pc_cout);

   
    
    /*** MEM STAGE ***/
    assign input_ex_mem = {output_id_ex_controls[9:5], output_id_ex_controls[0],pc_adder_branch,ALUresult,cf,zf,vf,sf,output_id_ex_read_data_2_forward, output_id_ex_aluControl[2:0], output_id_ex_destReg, output_id_ex_opCode, output_id_ex_pc_add4, output_id_ex_pc};
    n_bit_register #(185) EX_MEM_reg (input_ex_mem, clk, reset, 1,
     {output_ex_mem_controls, output_ex_mem_pc_addbranch, output_ex_mem_alu_result, output_ex_mem_cf, output_ex_mem_zf, output_ex_mem_vf, output_ex_mem_sf, output_ex_mem_read_data_2, output_ex_mem_funct3, output_ex_mem_destReg, output_ex_mem_opCode, output_ex_mem_pc_add4, output_ex_mem_pc});
        //output_ex_mem_controls -> Halt 5, MemRead 4 , MemWrite 3 , ToReg 2 1, RegWrite 0
        
        wire output_ex_mem_ef = output_ex_mem_controls[5];
        branch_controls brcontrols (output_ex_mem_opCode, output_ex_mem_funct3, output_ex_mem_cf, output_ex_mem_zf, output_ex_mem_vf, output_ex_mem_sf, output_ex_mem_ef, pc_selection);
        
        mux_4x1 pcmux (pc_add4, output_ex_mem_alu_result, output_ex_mem_pc_addbranch, output_ex_mem_pc, pc_selection, pc_next);


    /*** WB STAGE***/        
    assign input_mem_wb = {output_ex_mem_controls[2:0], output_ex_mem_alu_result, data_out, output_ex_mem_destReg, output_ex_mem_pc_add4, output_ex_mem_pc_addbranch};
    n_bit_register #(136) MEM_WB_reg (input_mem_wb, clk, reset, 1, {output_mem_wb_controls, output_mem_wb_alu_result, output_mem_wb_data_out, output_mem_wb_destReg, output_mem_wb_pc_add4, output_mem_wb_pc_addbranch});     
        // output_mem_wb_controls --> ToReg 2 1, RegWrite 0
        
        mux_4x1 wbmux (output_mem_wb_pc_add4, output_mem_wb_alu_result, output_mem_wb_data_out, output_mem_wb_pc_addbranch, output_mem_wb_controls[2:1], write_data);   

    
    always @(*) begin
        
        case (ledSel)
            2'b00: leds = {controls[8:3], controls[1:0]};
            2'b01: leds = {controls[4:3], cf, zf, vf, sf, pc_selection};
            2'b10: leds = {load, controls[9], forwardA, forwardB, alu_selection};
            2'b11: leds = ALUresult[7:0];         
        endcase
        
        case (ssdSel)
            4'b0000: ssd = pc;
            4'b0001: ssd = pc_add4;
            4'b0010: ssd = pc_adder_branch;
            4'b0011: ssd = pc_next;
            4'b0100: ssd = read_data_1;
            4'b0101: ssd = read_data_2;
            4'b0110: ssd = write_data;
            4'b0111: ssd = immgenOut;
            4'b1000: ssd = pc_selection;
            4'b1001: ssd = ALU2ndInput;
            4'b1010: ssd = ALUresult;
            4'b1011: ssd = data_out;
            4'b1100: ssd = ALU1stInput;
            4'b1101: ssd = ALUPre2ndInput;
            default: ssd = instruction;
        endcase
       end
  
endmodule