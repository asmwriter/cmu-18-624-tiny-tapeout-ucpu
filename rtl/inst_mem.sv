module m_inst_fetch #(
    parameter MINST_WIDTH = 44,
    parameter DEPTH = 1024,
    parameter PC_WIDTH = 10,
    parameter M_INST_MODES = 2,
    parameter M_INST_LOAD_MODE = 1
    parameter M_INST_FETCH_MODE = 1
) (
    sys_clk,
    mode, 
    m_pc,
    m_inst_load,
    m_inst,
);
    input logic sys_clk;
    input logic [M_INST_MODES-1:0] mode;
    input logic [PC_WIDTH-1:0] m_pc;
    output logic [MINST_WIDTH-1:0] m_inst
    /*Declare instruction memory file*/
    logic [MINST_WIDTH-1:0] m_inst_mem[DEPTH];

    assign m_inst = (mode == FETCH) ? m_inst_mem[m_pc] : {MINST_WIDTH{1'b0}};

    /*Only used for loading instruction memory*/
    always @(posedge sys_clk) begin
        if(mode == M_INST_LOAD_MODE) begin
            m_inst_mem[m_pc] <= m_inst_load;
        end
    end
endmodule

module m_pc_reg #(
    parameter PC_WIDTH = 10;
) (
    sys_clk,
    next_m_pc_en
    next_m_pc,
    m_pc
);
    input logic [PC_WIDTH-1:0] next_m_pc;
    output logic [PC_WIDTH-1:0] m_pc;
    assign next_m_pc_en = 1'b1;
    always @(posedge sys_clk) begin
        if(next_m_pc_en) begin
            next_m_pc <= m_pc;
        end
    end
endmodule
