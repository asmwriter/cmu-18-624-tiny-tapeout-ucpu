
module tb_micro_reg_file_unit;

    reg sys_clk, sys_reset;
    reg [$clog2(`CPU_STATES)-1:0] cpu_state;
    reg reg_file_en, reg_file_rw;
    reg [`REG_SPEC_WIDTH-1:0] reg_sel;
    reg [`DATA_WIDTH-1:0] reg_wr_data;
    wire [`DATA_WIDTH-1:0] reg_rd_data;
    
    micro_reg_file reg_file_interface(.*);

    initial begin
        //Assert Reset
        sys_clk = 1'b0;
        sys_reset = 1'b1;
        #20
        sys_clk = 1'b1;
        #20
        //De-assert Reset, clock
        sys_clk = 1'b0;
        sys_reset = 1'b0;
        //Register write to Address 0
        reg_file_rw = `REG_FILE_WRITE;
        reg_file_en = 1;
        reg_sel = 0;
        reg_wr_data = 8'hA4;
        //Go to EXECUTE1 state
        cpu_state = `EXECUTE1;
        #20
        sys_clk = 1'b1;
        #20
        sys_clk = 1'b0;
        cpu_state = `EXECUTE2;
        #20
        sys_clk = 1'b1;
        #20
        sys_clk = 1'b0; 
        #20
        //Register write to Address 0
        reg_file_rw = `REG_FILE_READ;
        reg_file_en = 1'b1;
        reg_sel = 0;
        //Go to EXECUTE1 state
        cpu_state = `EXECUTE1;
        #20
        sys_clk = 1'b1;
        #20
        sys_clk = 1'b0;
        //Go to EXECUTE2 state to 
        cpu_state = `EXECUTE2;
        #20
        sys_clk = 1'b1;
        #20
        sys_clk = 1'b0;
        //write out ALU result to ALU micro-register
        $display("reg_rd_data at address: 0 = %h", reg_rd_data);
    end
endmodule;