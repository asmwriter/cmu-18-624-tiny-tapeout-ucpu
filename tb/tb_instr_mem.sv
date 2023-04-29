module tb_instr_reg;
    reg sys_clk, sys_reset;
    reg instr_in;
    wire [`INST_WIDTH-1:0] instr_reg;
    
    reg [`INST_WIDTH-1:0] instr_in_bits;

    instr_reg_interface instr_reg_inst(.*);

    initial begin
        sys_clk = 1'b0;
        sys_reset = 1'b1;
        #20
        sys_clk = 1'b1;
        #20
        sys_clk = 1'b0;
        sys_reset = 1'b0;
        //Instruction bits
        instr_in_bits = 32'hABCD1234;
        
        for(int i=31; i>=0;i--) begin
            instr_in = instr_in_bits[i];
            #20 
            sys_clk = 1'b1;
            #20
            sys_clk = 1'b0;
        end
        
        $display("instr_reg = %h", instr_reg);
        
    end

endmodule
