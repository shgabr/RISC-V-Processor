`define     IR_rs1          19:15
`define     IR_rs2          24:20
`define     IR_rd           11:7
`define     IR_opcode       6:0
`define     IR_funct3       14:12
`define     IR_funct7       31:25
`define     IR_shamt        24:20

`define     OPCODE_Branch   7'b11_000_11
`define     OPCODE_Load     7'b00_000_11
`define     OPCODE_Store    7'b01_000_11
`define     OPCODE_JALR     7'b11_001_11
`define     OPCODE_JAL      7'b11_011_11
`define     OPCODE_Arith_I  7'b00_100_11
`define     OPCODE_Arith_R  7'b01_100_11
`define     OPCODE_AUIPC    7'b00_101_11
`define     OPCODE_LUI      7'b01_101_11
`define     OPCODE_SYSTEM   7'b11_100_11
`define     OPCODE_FENCE    7'b00_011_11 
`define     OPCODE_Custom   7'b10_001_11

`define     F3_ADD          3'b000
`define     F3_SLL          3'b001
`define     F3_SLT          3'b010
`define     F3_SLTU         3'b011
`define     F3_XOR          3'b100
`define     F3_SRL          3'b101
`define     F3_OR           3'b110
`define     F3_AND          3'b111

`define     BR_BEQ          3'b000
`define     BR_BNE          3'b001
`define     BR_BLT          3'b100
`define     BR_BGE          3'b101
`define     BR_BLTU         3'b110
`define     BR_BGEU         3'b111

`define     F3_LB           3'b000
`define     F3_LH           3'b001
`define     F3_LW           3'b010
`define     F3_LBU          3'b100
`define     F3_LHU          3'b101

`define     F3_SB           3'b000
`define     F3_SH           3'b001
`define     F3_SW           3'b010

`define     OPCODE          IR[`IR_opcode]

`define     ALU_ADD         4'b00_00
`define     ALU_SUB         4'b00_01
`define     ALU_PASS        4'b00_11
`define     ALU_OR          4'b01_00
`define     ALU_AND         4'b01_01
`define     ALU_XOR         4'b01_11
`define     ALU_SRL         4'b10_00
`define     ALU_SRA         4'b10_10
`define     ALU_SLL         4'b10_01
`define     ALU_SLT         4'b11_01
`define     ALU_SLTU        4'b11_11

`define     SYS_EC_EB       3'b000

