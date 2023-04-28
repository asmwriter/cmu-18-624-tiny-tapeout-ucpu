module tb_alu_unit;

    reg sys_clk, sys_reset;
    reg alu_en_A_reg, alu_en_B_reg;
    reg [$clog2(`CPU_STATES)-1:0] cpu_state;
    reg [$clog2(`ALU_OPS)-1:0] alu_op;
    reg [`ALU_WIDTH-1:0] A_bus, B_bus;

    wire cc_greater, cc_equal;
    wire [`ALU_WIDTH-1:0] alu_result;

    alu_unit_interface alu_unit(.*);

    initial begin
        //Assert Reset
        sys_clk = 1'b0;
        sys_reset = 1'b1;
        #20
        sys_clk = 1'b1;
        #20
        //De-assert Reset, Set A_reg
        sys_clk = 1'b0;
        sys_reset = 1'b0;
        alu_en_A_reg = 1'b1;
        alu_en_B_reg = 1'b0;
        A_bus = 8'h23;
        cpu_state = `EXECUTE1;
        alu_op = 3'b001;
        #20
        sys_clk = 1'b1;
        #20
        //Set B_reg
        sys_clk = 1'b0;
        $display("A_reg = %h", alu_unit.A_reg);
        alu_en_A_reg = 1'b0;
        alu_en_B_reg = 1'b1;
        cpu_state = `EXECUTE1;
        B_bus = 8'h45;
        #20
        sys_clk = 1'b1;
        #20
        sys_clk = 1'b0; 
        //Go to EXECUTE2 state to 
        //write out ALU result to ALU micro-register
        cpu_state = `EXECUTE2;
        #20
        sys_clk = 1'b1;
        #20
        sys_clk = 1'b0; 
        $display("alu_result = %h", alu_result);
        
    end



endmodule;