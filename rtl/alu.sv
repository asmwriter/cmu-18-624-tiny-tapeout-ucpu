`include "defines.vh"

module alu_unit_interface (
        sys_clk, 
        sys_reset,
        cpu_state,
        A_bus, B_bus, 
        alu_en_A_reg, alu_en_B_reg,
        alu_op,
        cc_greater,
        cc_equal, 
        alu_result);

    input logic sys_clk, sys_reset;
    input logic alu_en_A_reg, alu_en_B_reg;
    input logic [$clog2(`CPU_STATES)-1:0] cpu_state;
    input logic [$clog2(`ALU_OPS)-1:0] alu_op;
    input logic [`ALU_WIDTH-1:0] A_bus, B_bus;

    logic alu_en;

    /*Registered ALU outputs*/
    output logic cc_greater, cc_equal;
    output logic [`ALU_WIDTH-1:0] alu_result;

    logic [`ALU_WIDTH-1:0] A_reg, B_reg;

    /*Control signals for loading from A_bus and B_bus*/
    logic A_reg_en, B_reg_en, alu_result_load;

    assign alu_en = alu_en_A_reg || alu_en_B_reg;
    // assign A_reg_en = (alu_en == 1'b1 && reg_src == A_REG_MAP && cpu_state == `EXECUTE1);
    // assign B_reg_en = (alu_en == 1'b1 && reg_src == B_REG_MAP && cpu_state == `EXECUTE1);
    assign alu_result_load = (alu_en && cpu_state == `EXECUTE2);

    logic [`ALU_WIDTH-1:0] alu_result_out;
    logic cc_greater_out, cc_equal_out;

    /*Control signal to load ALU micro-registers*/

    always @(posedge sys_clk) begin
        if(sys_reset) begin
            A_reg <= 0;
            B_reg <= 0;
            alu_result <= 0;
            cc_greater <= 0;
            cc_equal   <= 0;
        end
        else begin
            if(alu_en_A_reg && cpu_state == `EXECUTE1) begin
                A_reg <= A_bus;
            end
            if(alu_en_B_reg && cpu_state == `EXECUTE1) begin
                B_reg <= B_bus;
            end
            if(alu_en && cpu_state == `EXECUTE2) begin
                alu_result <= alu_result_out;
                cc_greater <= cc_greater_out;
                cc_equal   <= cc_equal_out;
            end
        end
    end

    /*carry in*/
    logic carry_in;
    assign carry_in = 1'b0;

    //ALU module
    alu_unit alu(.A(A_reg), .B(B_reg), .carry_in(carry_in), 
                    .alu_op(alu_op), .alu_result(alu_result_out), 
                    .greater(cc_greater_out), .equal(cc_equal_out));
endmodule

module alu_unit (
    A,
    B,
    carry_in,
    alu_op,
    alu_result,
    greater,
    equal
);
    input logic [`ALU_WIDTH-1:0] A,B;
    input logic carry_in;
    input logic [$clog2(`ALU_OPS)-1:0] alu_op;
    output logic [`ALU_WIDTH-1:0] alu_result;
    output logic greater, equal;

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
    always @(*) begin
        case (alu_op)
            4'b0000: alu_result = {`ALU_WIDTH{1'b0}};
            4'b0001: alu_result = A+B;
            4'b0010: alu_result = A-B;
            4'b0011: alu_result = A|B;
            4'b0100: alu_result = A&B;
            4'b0101: alu_result = ~A;
            4'b0110: alu_result = A<<B;
            4'b0111: alu_result = A>>B;
            4'b1000: alu_result = A>>>B;
            default: alu_result = {`ALU_WIDTH{1'b0}};
        endcase
    end
    always @(*) begin
        case (alu_op)
            4'b1001: begin
                greater = (A>B);
                equal = (A==B);
            end
            default: begin
                greater = 1'b0;
                equal = 1'b0;
            end
            
        endcase
    end
endmodule

