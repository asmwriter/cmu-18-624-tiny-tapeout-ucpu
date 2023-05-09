`include "defines.vh"

module tb_topcpu;
    reg sys_clk, sys_reset;
    localparam INST_MEM_SIZE = 1024;
    localparam M_INST_MEM_SIZE = 160;
    parameter M_INST_ADDR_WIDTH = 9;
    /*Declare Instruction and micro-instruction memory*/
    reg [`INST_WIDTH-1:0] inst_mem [INST_MEM_SIZE-1:0];
    reg [`MINST_WIDTH-1:0]  m_inst_mem [M_INST_MEM_SIZE-1:0];

    reg [`PC_WIDTH-1:0] instr_add_reg;

    reg [M_INST_ADDR_WIDTH-1:0] m_instr_add_reg;
	
    
    
    top_cpu mcpu(.*);

    reg instr_in, m_instr_in;
    wire inst_addr_stream, m_inst_addr_stream;


    initial begin
        $readmemb("tb/tests/mov/imem.txt", inst_mem); 
        $readmemb("tb/tests/mov/micro_rom.txt", m_inst_mem); 
        // $display("inst_mem[0] = %b", inst_mem[0]); 
        // $display("m_inst_mem[0] = %b", m_inst_mem[128]); 
        instr_add_reg = {`PC_WIDTH{1'b0}};
        m_instr_add_reg = {M_INST_ADDR_WIDTH{1'b0}};
        sys_clk = 1'b0;  
        sys_reset = 1'b1;
    
        #10
        sys_clk = 1'b1;
        #10  
        sys_clk = 1'b0;  
        sys_reset = 1'b0;
    
        $display("***************************************");
        $display("Receiving instruction address from CPU");
        $display("CPU_STATE = %h",mcpu.cpu_state);
        for(int i = 0; i<`PC_WIDTH;i++) begin
            $display("cpu_state = %h",mcpu.cpu_state);
            $display("current_bit_index = %h",mcpu.inst_to_bit.current_bit_index);
            $display("inst_addr_stream = %b",inst_addr_stream);
            instr_add_reg <= {instr_add_reg[`PC_WIDTH-2:0], inst_addr_stream};
            #10
            sys_clk = 1'b1;
            #10  
            sys_clk = 1'b0;  
        end 
        $display("Completed receiving instruction address from CPU, CPU_STATE = %h",mcpu.cpu_state);
        $display("instr_add_reg = %h",instr_add_reg);
        $display("Instruction at address: %h = %h", instr_add_reg, inst_mem[instr_add_reg]);
        
        $display("***************************************");
        $display("Sending instruction to CPU(%0.d cycles, msb first) ",`INST_WIDTH);
        $display("CPU_STATE = %h",mcpu.cpu_state);
        for(int i = 0; i<`INST_WIDTH;i++) begin
        $display("CPU_STATE = %h",mcpu.cpu_state);
            instr_in = inst_mem[instr_add_reg][`INST_WIDTH-1-i];
            #10
            $display(" i = %0.d, instr_in bit = %b",i, instr_in);
            #10
            sys_clk = 1'b1;
            #10  
            sys_clk = 1'b0;  
        end 
        $display("Completed sending instruction address from CPU, CPU_STATE = %h",mcpu.cpu_state);
        $display("CPU Instruction register contents: %h",mcpu.instr_reg);
        $display("***************************************");
        $display("Decoding instruction in CPU and populating decode registers ");
        $display("CPU_STATE = %h",mcpu.cpu_state);
        #10
        sys_clk = 1'b1;
        #10  
        sys_clk = 1'b0;
        $display("Finished Decoding instruction in CPU and populating decode registers, CPU_STATE = %h",mcpu.cpu_state);
        $display("is_imm_active_id = %b, is_imm_active = %b", mcpu.is_imm_active_id, mcpu.is_imm_active);
        $display("inst type = %b", mcpu.inst_type);
        $display("reg_src_1_id = %b", mcpu.reg_src_1_id);
        $display("reg_src_1 = %b", mcpu.reg_src_1);
        $display("reg_src_2_id = %b", mcpu.reg_src_2_id);
        $display("reg_src_2  = %b", mcpu.reg_src_2);
        $display("reg_dst_id = %b", mcpu.reg_dst_id);
        $display("reg_dst = %b", mcpu.reg_dst);
        $display("imm_id = %b", mcpu.imm_id);
        $display("imm = %b", mcpu.imm);
        $display("branch_target_id  = %b", mcpu.branch_target_id);
        $display("branch_target = %b", mcpu.branch_target);
        $display("***************************************");
        for(int i = 0; mcpu.m_pc < 32 ; i++) begin
            $display("____________________ i=%h________________",i);  
            $display("micro-PC = %h", mcpu.m_pc);
            if(mcpu.cpu_state == `SEND_MPC) begin
                $display("Receiving micro-instruction address from CPU, cpu_state=%h",mcpu.cpu_state);
                $display("micro-PC = %h", mcpu.m_pc);
                $display("CPU_STATE = %h",mcpu.cpu_state);
                $display("micro-instruction starting address = %h", mcpu.m_inst_addr_offset);
                for(int i = 0; i<M_INST_ADDR_WIDTH;i++) begin
                    $display("cpu_state = %h",mcpu.cpu_state);
                    $display("current_bit_index = %h",mcpu.m_inst_to_bit.current_bit_index);
                    $display("mpc_offset = %h",mcpu.mpc_offset);
                    $display("m_inst_addr = %h",mcpu.m_inst_to_bit.m_inst_addr);
                    $display("m_inst_addr_stream = %b",m_inst_addr_stream);
                    m_instr_add_reg <= {m_instr_add_reg[`M_INST_ADDR_WIDTH-2:0], m_inst_addr_stream};
                    #10
                    sys_clk = 1'b1;
                    #10  
                    sys_clk = 1'b0;  
                end 
                $display("Completed receiving micro-instruction address from CPU, CPU_STATE = %h",mcpu.cpu_state);
                $display("m_instr_add_reg = %h",m_instr_add_reg);
                $display("Micro-Instruction at address: %h = %h", m_instr_add_reg, m_inst_mem[m_instr_add_reg]);
                $display("***************************************");
            end
            if(mcpu.cpu_state == `FETCH_MINST) begin
                $display("Sending microinstruction to CPU, CPU_STATE = %h",mcpu.cpu_state);
                $display("mcpu.m_instr_reg_en = %b",mcpu.m_instr_reg_en);
                // $display("micro-pc:%h", mcpu.m_pc);
                // $display("next micro-pc:%h", mcpu.next_m_pc);
                for(int i = 0; i<`MINST_WIDTH;i++) begin
                $display("CPU_STATE = %h",mcpu.cpu_state);
                    m_instr_in = m_inst_mem[m_instr_add_reg][`MINST_WIDTH-1-i];
                    #10
                    $display(" i = %0.d, m_instr_in bit = %b",`MINST_WIDTH-1-i, m_instr_in);
                    #10
                    sys_clk = 1'b1;
                    #10  
                    sys_clk = 1'b0;  
                end 
                // $display("micro-pc:%h", mcpu.m_pc);
                // $display("next micro-pc:%h", mcpu.next_m_pc);
                $display("Completed Sending microinstruction to CPU, CPU_STATE = %h",mcpu.cpu_state);
                $display("CPU Micro-Instruction register contents: %h",mcpu.m_instr_reg);
                $display("***************************************");
            end
            if(mcpu.cpu_state == `DECODE_MINST) begin
                $display("Decoding micro-instruction in CPU and populating micro-decode registers ");
                $display("CPU_STATE = %h",mcpu.cpu_state);
                $display("load_m_pc_en:%h", mcpu.load_m_pc_en);
                $display("micro-pc:%h", mcpu.m_pc);
                $display("next micro-pc:%h", mcpu.next_m_pc);
                #10
                if(mcpu.load_m_pc_en == 1'b1) begin
                    $display("micro-pc:%h", mcpu.m_pc);
                end
                sys_clk = 1'b1;
                #10  
                sys_clk = 1'b0;
                $display("Decode signals");
                $display("reg_src = %b", mcpu.reg_src_md);
                $display("reg_dst = %b", mcpu.reg_dst_md);
                $display("m_imm_md = %b", mcpu.m_imm_md);
                $display("mbranch_target_md  = %b", mcpu.mbranch_target_md);
                $display("is_m_imm_active_md = %b", mcpu.is_m_imm_active_md);
                $display("alu_en_A_md = %b", mcpu.alu_en_A_md);
                $display("alu_en_B_md = %b", mcpu.alu_en_B_md);
                $display("alu_op_md = %b", mcpu.alu_op_md);
                $display("reg_file_en_md = %b", mcpu.reg_file_en_md);
                $display("reg_file_rw_md = %b", mcpu.reg_file_rw_md);
                $display("is_branch_md = %b", mcpu.is_branch_md);
                $display("Decode registers");
                $display("reg_src = %b", mcpu.reg_src);
                $display("reg_dst = %b", mcpu.reg_dst);
                $display("m_imm = %b", mcpu.m_imm);
                $display("mbranch_target  = %b", mcpu.mbranch_target);
                $display("is_m_imm_active = %b", mcpu.is_m_imm_active);
                $display("alu_en_A = %b", mcpu.alu_en_A);
                $display("alu_en_B = %b", mcpu.alu_en_B);
                $display("alu_op = %b", mcpu.alu_op);
                $display("reg_file_en = %b", mcpu.reg_file_en);
                $display("reg_file_rw = %b", mcpu.reg_file_rw);
                $display("is_branch = %b", mcpu.is_branch);
                $display("minstr_type = %b", mcpu.minstr_type);
                $display("is_current_micro_inst_nop = %b", mcpu.is_current_micro_inst_nop);
                if(mcpu.load_m_pc_en == 1'b1) begin
                    $display("Updated micro-pc:%h", mcpu.m_pc);
                end
                $display("Finished Decoding micro-instruction in CPU and populating micro-decode registers, CPU_STATE = %h",mcpu.cpu_state);
                $display("***************************************");
            end
            if(mcpu.cpu_state == `EXECUTE1) begin
                $display("In EXECUTE-1 state of Micro-instruction in CPU, CPU_STATE = %h",mcpu.cpu_state);
                $display("minstr_type = %h",mcpu.minstr_type);
                $display("micro-pc:%h", mcpu.m_pc);
                $display("load_m_pc_en:%h", mcpu.load_m_pc_en);
                $display("should_branch:%h", mcpu.should_branch);
                if(mcpu.should_branch == 1'b1) begin
                    $display("reg_dst = %h",mcpu.reg_src_dst_cmp_branch.reg_dst);
                    $display("reg_dst_content = %h",mcpu.reg_src_dst_cmp_branch.reg_dst_content);
                    $display("mbranch_target = %h",mcpu.mbranch_target);
                end
                $display("shared_write_bus = %d",mcpu.shared_write_bus);
                // $display("reg_file_interface.reg_sel_in=%h",mcpu.reg_file_interface.reg_sel_in);
                // $display("reg_file_interface.reg_dst=%h",mcpu.reg_file_interface.reg_dst);
                #10
                if(mcpu.reg_file_en == 1'b1) begin
                    $display("reg_sel_in:%h", mcpu.reg_file_interface.reg_sel_in);
                    $display("reg_wr_data_in = %h",mcpu.reg_file_interface.reg_wr_data_in);
                    $display("reg_rd_data_out = %h",mcpu.reg_file_interface.reg_rd_data_out);
                end
                
                sys_clk = 1'b1;
                #10  
                sys_clk = 1'b0;
                if(mcpu.should_branch == 1'b1) begin
                    $display("Updated micro-pc:%h", mcpu.m_pc);
                    $display("mbranch_target = %h",mcpu.mbranch_target);
                end
                if(mcpu.reg_file_en == 1'b1) begin
                    $display("Updated reg_file_en:%h", mcpu.reg_file_interface.reg_file_en);
                    $display("Updated reg_dst:%h", mcpu.reg_file_interface.reg_dst);
                    $display("Updated reg_sel_in:%h", mcpu.reg_file_interface.reg_sel_in);
                    $display("Updated reg_wr_data_in = %h",mcpu.reg_file_interface.reg_wr_data_in);
                    $display("Updated reg_rd_data_out = %h",mcpu.reg_file_interface.reg_rd_data_out);
                end
                $display("Completed EXECUTE-1 for Micro-instruction in CPU, CPU_STATE = %h",mcpu.cpu_state);
                $display("***************************************");
            end
            if(mcpu.cpu_state == `EXECUTE2) begin
                $display("In EXECUTE-2 state of Micro-instruction in CPU, CPU_STATE = %h",mcpu.cpu_state);
                #10
                $display("Current micro-pc:%h", mcpu.m_pc);
                $display("Current load_m_pc_en:%h", mcpu.load_m_pc_en);
                $display("next_m_pc:%h", mcpu.next_m_pc);
                sys_clk = 1'b1;
                #10  
                sys_clk = 1'b0;  
                $display("Updated micro-pc:%h", mcpu.m_pc);
                $display("reg_file_interface.reg_sel_in=%h",mcpu.reg_file_interface.reg_sel_in);
                $display("reg_file_interface.reg_rd_data=%h",mcpu.reg_file_interface.reg_rd_data_out);
                $display("reg_file_interface.reg_wr_data_in=%h",mcpu.reg_file_interface.reg_wr_data_in);
                $display("Completed EXECUTE-2 for Micro-instruction in CPU, CPU_STATE = %h",mcpu.cpu_state);
                $display("***************************************");
            end
        end
    end
endmodule