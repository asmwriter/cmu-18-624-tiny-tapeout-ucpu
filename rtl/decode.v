`include "defines.vh"
/*
    Instruction format
    Branch
     __________
    |27:31|1:26|
    |__________|   

    Register 3 operand
     _______________________________
    |27:31|26|22:25|18:21|14:17|13:0|
    |_______________________________|  

    Immediate 3 operand
     _________________________
    |27:31|26|22:25|18:21|0:17|
    |_________________________| 
*/
module instruction_decoder(
    instr_in,
    is_imm_active,
    reg_dst, 
    reg_src_1, 
    reg_src_2, 
    imm, 
    branch_target,


    );
    input  logic [31:0]  instr_in;
    output logic [3:0] reg_src_1, reg_src_2, reg_dst;
    output logic [10:0] imm;
    output logic [9:0] branch_target;
    output logic is_imm_active;
    
    assign reg_dst = instr_in[25:22];
    assign reg_src_1 = instr_in[21:18];
    assign reg_src_2 = instr_in[17:14];

endmodule

/*
    Micro-instruction format
     _________________________________
    |43:41|40:36|35:31|30:20|19:10|9:0|
    |_________________________________| 
    Fields:
    43:41 - Micro-instruction type
    40:36 - Source register
    35:31 - Destination register
    30:20 - Immediate value (consider only 27:20)
    19:10 - Branch target micro PC ( consider only 10:17 )
    9:0   - Bus arguments
        
*/
module micro_inst_decoder (
    minstr_in, 
    reg_src_md, 
    reg_dst_md, 
    imm_md, 
    branch_target, 
    is_imm_active_md,
    reg_file_en_md,
    reg_file_rw_md,
    alu_en_md, 
    alu_op_md,
    // mem_en_md,
    // mem_rw_md,
    is_branch_md
    );
    localparam REG_SPEC_WIDTH = $clog2(`MREG_COUNT);
    localparam MINST_TYPE_WIDTH = $clog2(`MINST_COUNT);

    //Input micro-instruction
    input  logic [`MINST_WIDTH-1:0] minstr_in;

    //Microinstruction source and destination register mapping
    output logic [`REG_SPEC_WIDTH-1:0] reg_src_md, reg_dst_md;
    //Immediate value
    output logic [`IMM_WIDTH-1:0] imm_md;
    //Branch target value
    output logic [`BRANCH_ADDR_WIDTH-1:0] branch_target;
    
    /*Output control signals*/ 
    output logic alu_en_md;
    output logic [$clog2(`ALU_OPS)-1:0] alu_op_md;
    output logic is_imm_active_md;
    output logic reg_file_en_md, reg_file_rw_md;
    //output logic mem_en_md, mem_rw_md; 
    output logic is_branch_md;   

    /*Micro instruction type*/
    logic [`MINST_TYPE_WIDTH-1:0] minstr_type;

    /*Args Field in the instruction*/
    logic [`BUS_ARGS-1:0] m_args;

    /*Extract the fields*/
    assign minstr_type = minstr_in[43:41];
    assign reg_src_md = minstr_in[40:36];
    assign reg_dst_md = minstr_in[35:31];
    assign imm_md = minstr_in[27:20];
    assign branch_target = minstr_in[17:10];
    assign m_args = minstr_in[9:0];
    
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
    //ALU Enable
    assign alu_en_md = m_args[0];
    //ALU operation
    assign alu_op_md = m_args[3:1];
    /*Determine if immediate bit is active*/
    assign is_imm_active_md = (minstr_type == 3'b001) || 
                              (minstr_type == 3'b010) || 
                              (minstr_type == 3'b011);
    //Reg file enable and reg file read/write signal
    assign reg_file_en_md = m_args[4];
    assign reg_file_rw_md = m_args[5];
    //Data memory enable read/write signal
    // assign mem_en_md = m_args[6];
    // assign mem_rw_md = m_args[7];
    //Is branch signal
    assign is_branch_md = (minstr_type == 3'b100) || (minstr_type == 3'b011);
endmodule