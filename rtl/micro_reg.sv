`include "defines.vh"
/*
    Micro-instruction format: 
     _________________________________
    |43:41|40:36|35:31|30:20|19:10|9:0|
    |_________________________________| 
*/

module mdecode_reg (
    sys_clk, 
    sys_reset,
    /*Decode fields*/
    is_imm_active_md,
    reg_dst_md, 
    reg_src_md, 
    imm_md, 
    branch_target_md, 
    /*Flags*/
    alu_en_md,
    alu_op_md,
    reg_file_en_md,
    reg_file_rw_md,
    is_branch_md,

    reg_src,
    reg_dst,
    imm,
    branch_target,
    is_imm_active,
    alu_en,
    alu_op,
    reg_file_en,
    reg_file_rw,
    is_branch,
);
    /*Fields from decoder unit*/
    input  sys_clk, sys_reset;
    input  [3:0] reg_src_md, reg_dst_md;
    input  [10:0] imm_md;
    input  [9:0] branch_target_md;
    /*Control signals and bus args*/
    input  is_imm_active_md;
    input  alu_en_md;
    input  [$clog2(`ALU_OPS)-1:0] alu_op_md;
    input  reg_file_en_md, reg_file_rw_md;
    input  is_branch_md;

    /*Declare registers*/
    output reg [3:0] reg_src, reg_dst;
    output reg [10:0] imm;
    output reg [9:0] branch_target;

    /*Registered control signals*/
    output reg is_imm_active;

    /*Registered args*/
    output reg alu_en;
    output reg [$clog2(`ALU_OPS)-1:0] alu_op;
    output reg reg_file_en, reg_file_rw;
    //output wire mem_en, mem_rw;
    output reg is_branch;

    /*Register all fields, control signals and args*/
    /*Yet to implement sys_reset*/
    always @(posedge sys_clk) begin
        if(sys_reset) begin
            reg_src <= 0;
            reg_dst <= 0;
            imm <= 0;
            branch_target <= 0;
            is_imm_active <= 0;
            alu_en <= 0;
            alu_op <= 0;
            reg_file_en <= 0;
            reg_file_rw <= 0;
            is_branch <= 0;
        end
        else begin
            reg_src <= reg_src_md;
            reg_dst <= reg_dst_md;
            imm <= imm_md;
            branch_target <= branch_target_md;
            is_imm_active <= is_imm_active_md;
            alu_en <= alu_en_md;
            alu_op <= alu_op_md;
            reg_file_en <= reg_file_en_md;
            reg_file_rw <= reg_file_rw_md;
            is_branch <= is_branch_md;
        end
    end

endmodule

module micro_reg_file (
    //sys clk
    input sys_clk,
    //System reset
    input sys_reset,
    //cpu_state
    input [$clog2(`CPU_STATES)-1:0] cpu_state,
    /* Register file enable signal */
    input reg_file_en, 
    /* Register filecR/W signal */
    input reg_file_rw, 
    /* Reg file register select  */
    input [`REG_SPEC_WIDTH-1:0] reg_sel,
    input [`DATA_WIDTH-1:0] reg_wr_data,
    output [`DATA_WIDTH-1:0] reg_rd_data
);

    /*Registered reg file addr select*/
    reg [`REG_SPEC_WIDTH-1:0] reg_sel_in;

    /*Registered reg file write data*/
    reg [`DATA_WIDTH-1:0] reg_wr_data_in;

    /*Registered reg file read data*/
    reg [`DATA_WIDTH-1:0] reg_rd_data_out;

    /*Declare register file*/
    reg [`DATA_WIDTH-1:0] mreg_file[`REG_FILE_DEPTH-1:0];

    /*reg_rd_data output*/
    assign reg_rd_data = reg_rd_data_out;
    
    /*Register file writes are synchronous*/
    always @(posedge sys_clk) begin
        if(sys_reset) begin
            reg_sel_in <= {`REG_SPEC_WIDTH{1'b0}};
            reg_wr_data_in <= {`DATA_WIDTH{1'b0}};
            reg_rd_data_out <= {`DATA_WIDTH{1'b0}};
        end
        else begin
            if(reg_file_en) begin
                if(cpu_state == `EXECUTE1) begin
                    reg_sel_in <= reg_sel;
                    if(reg_file_rw == `REG_FILE_WRITE) begin
                        reg_wr_data_in <= reg_wr_data; 
                    end
                end
                else if(cpu_state == `EXECUTE2) begin
                    if(reg_file_rw == `REG_FILE_READ) begin
                        reg_rd_data_out <= mreg_file[reg_sel_in];
                    end
                    else if(reg_file_rw == `REG_FILE_WRITE) begin
                        mreg_file[reg_sel_in] <= reg_wr_data_in;
                    end
                end
            end
        end
    end
endmodule