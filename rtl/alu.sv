module alu_unit_interface #(
    parameter ALU_WIDTH = 8
    parameter ALU_OPS = 8,
    parameter A_REG_MAP = ,
    parameter B_REG_MAP = 17
)    (
        sysclk, 
        A_bus, B_bus, 
        alu_op, alu_en,
        reg_src,
        cc_greater,
        cc_equal, 
        alu_result);

    input logic sysclk, alu_en;
    input logic [$clog2(ALU_OPS)-1:0] alu_op;
    input logic [ALU_WIDTH-1:0] A_bus, B_bus;

    output logic cc_greater, cc_equal;
    output logic [ALU_WIDTH-1:0] alu_result;

    logic [ALU_WIDTH-1:0] A_reg, B_reg;

    assign A_reg_en = (alu_en == 1'b1 && reg_src == A_REG_MAP);
    assign B_reg_en = (alu_en == 1'b1 && reg_src == B_REG_MAP);

    always @(posedge clk) begin
        if(A_reg_en) begin
            A_reg <= A_bus;
        end
        if(B_reg_en) begin
            B_reg <= B_bus;
        end
    end

    logic carry_in;
    assign carry_in = 1'b0;
    //ALU module
    alu_unit alu_module(.A(A_reg), .B(B_reg), .carry_in(carry_in), 
                    .alu_op(alu_op), .alu_result(alu_result), 
                    .greater(cc_greater), .equal(cc_equal));
endmodule

module alu_unit #(
    parameter ALU_WIDTH = 8,
    parameter ALU_OPS = 8
) (
    A,
    B,
    carry_in,
    alu_op,
    alu_result,
    greater,
    equal
);
    input logic [ALU_WIDTH-1:0] A,B;
    input logic [$clog2(ALU_OPS)-1:0] alu_op;
    output logic [ALU_WIDTH-1:0] alu_result;
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
            4'b0000: alu_result = {ALU_WIDTH{1'b0}};
            4'b0001: alu_result = A+B;
            4'b0010: alu_result = A-B;
            4'b0011: alu_result = A|B;
            4'b0100: alu_result = A&B;
            4'b0101: alu_result = ~A;
            4'b0110: alu_result = A<<B;
            4'b0111: alu_result = A>>B;
            4'b1000: alu_result = A>>>B;
            default: alu_result = {ALU_WIDTH{1'b0}};
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