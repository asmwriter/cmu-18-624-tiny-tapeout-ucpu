/*Yet to implement*/
/*
module read_bus #(
    
) (
    
);
    
endmodule
*/

module write_bus #(
    parameter WRITE_BUS_WIDTH = 12,
    parameter ADDR_WIDTH = 5,
    parameter ALU_WIDTH = 8,
    parameter ALU_OPS = 8,
    parameter A_REG_MAP = 0,
    parameter B_REG_MAP = 1,
    parameter ALU_RESULT_MAP = 2,
    parameter CC_GREATER_MAP = 3,
    parameter CC_EQUAL_MAP = 4,
    parameter REG_SEL_MAP = 5,
    parameter REG_WR_DATA_MAP = 6,
    parameter REG_RD_DATA_MAP = 7,
    parameter IMM_MAP = 8,
    parameter REG_SRC_MAP = 9,
    parameter REG_DST_MAP = 10,
    parameter BRANCH_TARGET_MAP = 11,
    parameter M_PC_MAP = 12,
    parameter BRANCH_ADDR_WIDTH = 10,
    parameter IMM_WIDTH = 11,
    //parameter MEM_ADR = 13,
    //parameter MEM_DATA = 14,
    //parameter LD_DATA = 15
) (
    //source register
    reg_src,
    //bus args
    is_imm_active,
    reg_file_en,
    reg_file_rw,
    alu_en,
    alu_op,
    is_branch,
    //producer - micro-decode registers 
    imm, 
    m_pc,
    branch_target,    
    //producer - ALU operations
    alu_result,
    cc_greater,
    cc_equal,
    //producer - register file
    reg_rd_data
);
    //source register
    input logic [ADDR_WIDTH-1:0] reg_src;
    //bus args
    input logic is_imm_active, reg_file_en, reg_file_rw, alu_en, is_branch;
    input logic [$clog2(ALU_OPS)-1:0] alu_op;

    //producer - micro-decode registers 
    input logic [PC_WIDTH-1:0] m_pc;
    input logic [IMM_WIDTH-1:0] imm;
    input logic [BRANCH_ADDR_WIDTH-1:0] branch_target; 

    /*
    Micro Registers which are producers
    - m_pc 
    - imm
    - branch_target

    Data path registers which are producers
    - alu_result
    - reg_rd_data
    - cc_greater
    - cc_equal
    - ld_data (to be implemented) 
    */
    output logic [WRITE_WIDTH-1:0] write_bus_out;
    always @(*) begin
        case (reg_src)
            IMM_MAP: write_bus_out = imm; 
            M_PC_MAP: write_bus_out = m_pc;
            BRANCH_TARGET_MAP: write_bus_out = branch_target;
            ALU_RESULT_MAP: write_bus_out = alu_result;
            CC_GREATER_MAP: write_bus_out = cc_greater;
            CC_EQUAL_MAP: write_bus_out = cc_equal;
            REG_RD_DATA_MAP: write_bus_out = reg_rd_data;
        endcase
    end
endmodule