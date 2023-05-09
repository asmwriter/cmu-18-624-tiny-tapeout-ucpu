module tb_cpu_fsm;
    reg sys_clk, sys_reset;
    reg is_nop;
    wire [$clog2(`CPU_STATES)-1:0] cpu_state;

    cpu_fsm cpu_fsm_top(.*);

    initial begin
        sys_clk = 1'b0;
        sys_reset = 1'b1;
        #10
        sys_clk = 1'b1;
        #10
        sys_clk = 1'b0;
        sys_reset = 1'b0;
        $display("CPU state = %h, fsm_assist = %h, current_minst = %h", 
                cpu_state, cpu_fsm_top.fsm_assist, cpu_fsm_top.current_minst);
        for(int i = 0; i <1000; i++) begin
            #10
            sys_clk = 1'b1;
            $display("CPU state = %h, fsm_assist = %h, current_minst = %h", 
                cpu_state, cpu_fsm_top.fsm_assist, cpu_fsm_top.current_minst);
            #10
            sys_clk = 1'b0;
        end
    end

endmodule