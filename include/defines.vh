/*CPU States*/
`define CPU_STATES          10
`define FETCH_MINST         4'd1
`define DECODE              4'd2
`define EXECUTE1            4'd3
`define EXECUTE2            4'd4 
//No. of micro registers
`define MREG_COUNT          'd16
/*Micro-registers Mapping*/
`define A_REG_MAP           5'd0
`define B_REG_MAP           5'd1
`define ALU_RESULT_MAP      5'd2
`define CC_GREATER_MAP      5'd3
`define CC_EQUAL_MAP        5'd4
`define REG_SEL_MAP         5'd5
`define REG_WR_DATA_MAP     5'd6
`define REG_RD_DATA_MAP     5'd7
`define IMM_MAP             5'd8
`define REG_SRC_MAP         5'd9
`define REG_DST_MAP         5'd10
`define BRANCH_TARGET_MAP   5'd11
`define M_PC_MAP            5'd12
`define RS1_MAP             5'd13 
`define RS2_MAP             5'd14
`define RD_MAP              5'd15

`define INST_WIDTH         32
//No of micro-instructions
`define MINST_COUNT         8
`define MINST_TYPE_WIDTH    3
`define MINST_WIDTH         44
/*Register Widths*/
//PC Register Width
`define PC_WIDTH            8
//Micro-PC 
`define MPC_WIDTH           8 
//Branch target   
`define BRANCH_ADDR_WIDTH   8
//Immediate value
`define IMM_WIDTH           8
//Shared write bus 
`define WRITE_WIDTH         8
//
`define ADDR_WIDTH          5
//
`define DATA_WIDTH          8
//Register file depth
`define REG_FILE_DEPTH      4
`define DATA_WIDTH          8
//log2(REG_FILE_DEPTH)
`define REG_SPEC_WIDTH      2 
`define REG_FILE_READ       1'b0
`define REG_FILE_WRITE      1'b1 
//No of ALU operations
`define ALU_OPS             8
//ALU width
`define ALU_WIDTH           8
//parameter MEM_ADR  13
//parameter MEM_DATA  14
//parameter LD_DATA  15
`define BUS_ARGS            10