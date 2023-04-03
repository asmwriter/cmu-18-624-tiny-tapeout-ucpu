/*
    Micro-instruction format
     _________________________________
    |43:41|40:36|35:31|30:20|19:10|9:0|
    |_________________________________| 
*/
module microdecoder #(
    parameter MINST_COUNT = 8,
    parameter MREG_COUNT = 32,
    parameter BRANCH_ADDR_WIDTH = 10,
    parameter IMM_WIDTH = 11,
    parameter ALU_OPS = 8,
    parameter BUS_ARGS = 10
) (
    m_instruction, 
    reg_src_md, 
    reg_dst_md, 
    imm_md, 
    branch_target, 
    is_imm_active_md,
    reg_file_en_md,
    reg_file_rw_md,
    mem_en_md,
    mem_rw_md,
    is_branch_md
    )
    localparam REG_WIDTH = $clog2(MREG_COUNT);
    localparam MINST_TYPE_WIDTH = $clog2(MINST_COUNT);
    localparam MINST_WIDTH = BUS_ARGS + BRANCH_ADDR_WIDTH + IMM_WIDTH + REG_WIDTH + REG_WIDTH + MINST_TYPE_WIDTH;

    input  logic [MINST_WIDTH-1:0] m_instruction;
    output logic [REG_WIDTH-1:0] reg_src_md, reg_dst_md;
    output logic [IMM_WIDTH-1:0] imm_md;
    output logic [BRANCH_ADDR_WIDTH-1:0] branch_target;
    
    /*Output control signals*/
    output logic alu_en_md;
    output logic [$clog2(ALU_OPS)-1:0] alu_op_md;
    output logic is_imm_active_md;
    output logic reg_file_en_md, reg_file_rw_md;
    output logic mem_en_md, mem_rw_md; 
    output logic is_branch_md;   

    /*Micro instruction type*/
    logic [MINST_TYPE_WIDTH-1:0] m_inst_type;

    /*Args Field in the instruction*/
    logic [BUS_ARGS-1:0] m_args;

    /*Extract the fields*/
    assign m_inst_type = m_instruction[43:41];
    assign reg_src_md = m_instruction[40:36];
    assign reg_dst_md = m_instruction[35:31];
    assign imm_md = m_instruction[30:20];
    assign branch_target = m_instruction[19:10];
    assign m_args = m_instruction[9:0];

    /*ALU operation field*/
    /*
        alu_op_md
        0000 - nop
        0001 - add
        0010 - sub
        0011 - or
        0100 - and
        0101 - not
        0110 - lsl
        0111 - lsr
        1000 - asr
        1001 - cmp
    */
    assign alu_en_md = m_args[0];
    assign alu_op_md = m_args[4:1];
    /*Determine if imm_mdediate bit is active*/
    assign is_imm_active_md = (m_inst_type == 3'b001) || 
                              (m_inst_type == 3'b010) || 
                              (m_inst_type == 3'b011);
    assign reg_file_en_md = m_args[5];
    assign reg_file_rw_md = m_args[6];
    assign mem_en_md = m_args[7];
    assign mem_rw_md = m_args[8];
    assign is_branch_md = (m_inst_type == 3'b100) || (m_inst_type == 3'b011);
endmodule