module mdecode_reg #(
    parameter MINST_COUNT = 8,
    parameter MREG_COUNT = 32,
    parameter BRANCH_ADDR_WIDTH = 10,
    parameter IMM_WIDTH = 11,
    parameter ALU_OPS = 8,
    parameter BUS_ARGS = 10
) (
    sys_clk, 
    reg_src_md, 
    reg_dst_md, 
    imm_md, 
    branch_target, 
    is_imm_active_md,
    alu_en_md,
    alu_op_md,
    reg_file_en_md,
    reg_file_rw_md,
    mem_en_md,
    mem_rw_md,
    is_branch_md,
    sys_reset
);
    /*Fields from decoder unit*/
    input logic [3:0] reg_src_md, reg_dst_md;
    /*Control signals and bus args*/
    input logic [10:0] imm_md;
    input logic [9:0] branch_target_md;
    input logic is_imm_active_md;
    input logic alu_en_md;
    input logic [$clog2(ALU_OPS)-1:0] alu_op_md;
    input logic reg_file_en_md, reg_file_rw_md;
    input logic mem_en_md, mem_rw_md;
    input logic is_branch_md;

    /*Declare registers*/
    output logic [3:0] reg_src, reg_dst;
    output logic [10:0] imm;
    output logic [9:0] branch_target;
    /*Registered control signals*/
    output logic is_imm_active;
    /*Registered args*/
    output logic alu_en;
    output logic [$clog2(ALU_OPS)-1:0] alu_op;
    output logic reg_file_en, reg_file_rw;
    output logic mem_en, mem_rw;
    output logic is_branch;

    /*Register all fields, control signals and args*/
    /*Yet to implement sys_reset*/
    always @(posedge sys_clk) begin
        reg_src <= reg_src_md;
        reg_dst <= reg_dst_md;
        imm <= imm_md;
        branch_target <= branch_target_md;
        is_imm_active <= is_imm_active_md;
        alu_en <= alu_en_md;
        alu_op <= alu_op_md;
        reg_file_en <= reg_file_en_md;
        reg_file_rw <= reg_file_rw_md;
        mem_rw <= mem_rw_md;
        mem_en <= mem_en_md;
        is_branch <= is_branch_md;
    end

endmodule

module micro_reg_file #(
    parameter DEPTH = 16,
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
    parameter REG_FILE_READ = 1'b0,
    parameter REG_FILE_WRITE = 1'b1
) (
    input sys_clk,
    input reg_file_en, reg_file_rw, 
    input sys_reset,
    input [ADDR_WIDTH-1:0] reg_src_in,
    input [DATA_WIDTH-1:0] reg_wr_data_in,
    output [DATA_WIDTH-1:0] reg_rd_data_out
);

    logic [ADDR_WIDTH-1:0] reg_src,
    /*Declare register file*/
    logic [DATA_WIDTH-1:0] mreg_file[DEPTH];


    /*Register file reads are combinational*/
    assign reg_rd_data = (reg_file_en && reg_file_rw == REG_FILE_READ) ? mreg_file[reg_src] : {DATA_WIDTH{1'b0}};
    
    /*Register file writes are synchronous*/
    /*Yet to implement sys_reset*/
    always @(posedge sys_clk) begin
        if(reg_file_en && reg_file_rw == REG_FILE_READ) begin
            reg_src <= reg_src_in;
        end
        if(reg_file_en && reg_file_rw == REG_FILE_WRITE) begin
            mreg_file[reg_src] <= reg_wr_data;
        end
    end
endmodule