`timescale 1ns / 1ps
/******************************************************************* 
*
* Module: forwarding_unit.v
* Project: Risc-V processor pipelined 
* Author: Sherif Gabr - sherif.gabr@aucegypt.edu
* Author: Mina Ashraf - mina146@aucegypt.edu
* Description:
*   - handles forwarding from later phases to prior stages to avoid stalls
**********************************************************************/

module forwarding_unit(
        input [4:0] rs1, rs2,
        input [4:0] rd,
        input RegWrite,
        output forwardA, forwardB
        );
        assign forwardA = (rd != 0 && rs1 == rd && RegWrite);
        assign forwardB = (rd != 0 && rs2 == rd && RegWrite);

endmodule 