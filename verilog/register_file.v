`timescale 1ns / 1ps

/******************************************************************* 
*
* Module: reg_file.v
* Project: Risc-V processor pipelined 
* Author: Sherif Gabr - sherif.gabr@aucegypt.edu
* Author: Mina Ashraf - mina146@aucegypt.edu
* Description:
*   - an array of registers 
*
**********************************************************************/

module reg_file #(parameter N=32) (
    input [N-1:0] write_data, 
    input [4:0] reg_read1, reg_read2, reg_write1, 
    input write_enable, clk, reset, 
    output  [N-1:0] read_data_1, read_data_2);

wire [N-1:0] Q [0:N-1];
reg [N-1:0] load;

always @(*) begin
    load = 0;
    if (write_enable == 1 && reg_write1 != 0) begin
            load = 0;
            load [reg_write1] = 1'b1;
    end
end

generate
    for (genvar i=0; i<N; i=i+1)begin:regs   
         n_bit_register rgstr (write_data ,clk, reset, load[i], Q[i]);
         end
endgenerate
    
assign read_data_1 = Q[reg_read1];
assign read_data_2 = Q[reg_read2];
    
    
endmodule
