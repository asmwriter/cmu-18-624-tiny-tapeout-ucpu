module shared_bus #(
    parameters
) (
    ports
);
    
endmodule


module read_bus #(
    
) (
    
);
    
endmodule

module write_bus #(
    
) (
    imm, 
    alu_result,
    m_pc,
    reg_src,
    reg_dst,
    branch_target

);
    /*
    Bus args
    - is_imm_active
    - reg_file_en
    - reg_file_rw
    - alu_en
    - alu_op
    - is_branch

    Micro Registers
    - m_pc 
    - reg_dst
    - reg_src
    - imm
    - branch_target
    - alu_result
    - reg_rd_data
    - cc_greater
    - cc_equal
    - m_data_val (to be implemented)
    - m_mem_addr (to be implemented)
    - 
    */

    always @(*) begin
        if(imm == 1'b1) begin
        
        end
        else begin

        end
    end
endmodule