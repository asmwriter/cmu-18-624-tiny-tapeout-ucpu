module data_mem_interface #(
    parameter DEPTH = 16,
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 5,
    parameter REG_FILE_READ = 1'b0,
    parameter REG_FILE_WRITE = 1'b1,
    //Control unit states
    parameter CONTROL_STATES = 3,
    parameter DECODE = 0,
    parameter EXECUTE1 = 1,
    parameter EXECUTE2 = 2
) (
    input sys_clk,
    input [$clog2(CONTROL_STATES)-1:0] control_state,
    input reg_file_en, reg_file_rw, 
    input sys_reset,
    input [ADDR_WIDTH-1:0] reg_sel,
    input [DATA_WIDTH-1:0] reg_wr_data,
    output [DATA_WIDTH-1:0] reg_rd_data
);

    /*Registered reg file addr select*/
    logic [ADDR_WIDTH-1:0] reg_sel_in;

    /*Registered reg file write data*/
    logic [DATA_WIDTH-1:0] reg_wr_data_in;

    /*Registered reg file read data*/
    logic [DATA_WIDTH-1:0] reg_rd_data_out;

    /*Declare register file*/
    logic [DATA_WIDTH-1:0] mreg_file[DEPTH];

    /*reg_rd_data output*/
    assign reg_rd_data = reg_rd_data_out;
    
    /*Register file writes are synchronous*/
    /*Yet to implement sys_reset*/
    always @(posedge sys_clk) begin
        if(reg_file_en) begin
            if(control_state == EXECUTE1) begin
                reg_sel_in <= reg_sel;
            end
            if(reg_file_rw == REG_FILE_READ && control_state == EXECUTE2) begin
                reg_rd_data_out <= mreg_file[reg_sel_in];
            end
            else begin
                if(reg_file_rw == REG_FILE_WRITE && control_state == EXECUTE1) begin
                    reg_wr_data_in <= reg_wr_data; 
                end
                if(reg_file_rw == REG_FILE_WRITE && control_state == EXECUTE2) begin
                    mreg_file[reg_src] <= reg_wr_data_in;
                end
            end
        end
    end
endmodule