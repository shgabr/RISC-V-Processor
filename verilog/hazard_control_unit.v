/******************************************************************* 
*
* Module: hazard_control_unit.v
* Project: Risc-V processor pipelined 
* Author: Sherif Gabr - sherif.gabr@aucegypt.edu
* Author: Mina Ashraf - mina146@aucegypt.edu
* Description:
*   checks the pc_selection and if it is not zero, then we want to flush
*
**********************************************************************/
`timescale 1ns / 1ps
module hazard_control_unit (
        input [1:0] pc_selection,  
        output reg controls_zero); 

always@(*)
begin 
    case(pc_selection)

        2'b00: controls_zero = 0;
        2'b01: controls_zero = 1;
        2'b10: controls_zero = 1;
        2'b11: controls_zero = 1;
    
    endcase
end

endmodule 