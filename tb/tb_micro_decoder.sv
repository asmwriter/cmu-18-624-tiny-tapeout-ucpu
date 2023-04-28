`include "defines.vh"

module tb_micro_inst_decoder;

    //Declarations
   //Input micro-instruction
    reg [`MINST_WIDTH-1:0] minstr_in;

    //Microinstruction source and destination register mapping
    wire  [`REG_SPEC_WIDTH-1:0] reg_src_md, reg_dst_md;
    //Immediate value
    wire  [`IMM_WIDTH-1:0] imm_md;
    //Branch target value
    wire  [`BRANCH_ADDR_WIDTH-1:0] branch_target;
    
    /*wire control signals*/
    wire  alu_en_md;
    wire  [$clog2(`ALU_OPS)-1:0] alu_op_md;
    wire  is_imm_active_md;
    wire  reg_file_en_md, reg_file_rw_md;
    wire  mem_en_md, mem_rw_md; 
    wire  is_branch_md; 

    reg sys_clk;  

    micro_inst_decoder uinst_decoder(.*);

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
    always #5 sys_clk = ~sys_clk;
    initial begin
        sys_clk = 1'b0;
        #5
        minstr_in <= {3'b00, 5'd13, 5'd5, 11'b0, 11'b0, 10'b0000100000};
        #5
        $display("minstr_in=%h", minstr_in);
        $finish;
    end



endmodule