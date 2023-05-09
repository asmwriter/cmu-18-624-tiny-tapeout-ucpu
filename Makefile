rtl_shared_bus:
	vcs -sverilog -R +lint=all -debug_access+all -top write_bus +incdir+include +lint=all rtl/shared_bus.sv 

rtl_decoder:
	vcs -sverilog -R +lint=all -debug_access+all -top micro_inst_decoder +incdir+include +lint=all rtl/decode.v 

rtl_alu_unit:
	vcs -sverilog -R +lint=all -debug_access+all -top alu_unit_interface +incdir+include +lint=all rtl/alu.sv 

rtl_micro_reg_unit:
	vcs -sverilog -R +lint=all -debug_access+all -top micro_reg_file +incdir+include +lint=all rtl/micro_reg.sv 

rtl_mdecode_reg:
	vcs -sverilog -R +lint=all -debug_access+all -top mdecode_reg +incdir+include +lint=all rtl/micro_reg.sv 

rtl_inst_reg:
	vcs -sverilog -R +lint=all -debug_access+all -top instr_reg +incdir+include +lint=all rtl/inst_mem.sv 

rtl_inst_mem:
	vcs -sverilog -R +lint=all -debug_access+all +incdir+include +lint=all rtl/inst_mem.sv 

rtl_cpu_fsm:
	vcs -sverilog -R +lint=all -debug_access+all -top cpu_fsm +incdir+include +lint=all rtl/mcpu.sv 

rtl_cpu_top:
	vcs -sverilog -R +lint=all -debug_access+all -top top_cpu +incdir+include +lint=all rtl/mcpu.sv rtl/inst_mem.sv rtl/decode.v rtl/micro_reg.sv rtl/shared_bus.sv rtl/alu.sv

tb_decoder_iv:
	vcs -sverilog -R +lint=all -debug_access+all -top tb_micro_inst_decoder +incdir+include +lint=all rtl/decode.v tb/tb_micro_decoder.sv rtl/micro_reg.sv 

tb_alu_iv:
	vcs -sverilog -R +lint=all -debug_access+all -top tb_alu_unit +incdir+include +lint=all +error+20 rtl/alu.sv tb/tb_alu.sv

tb_micro_reg:
	vcs -sverilog -R +lint=all -debug_access+all -top tb_micro_reg_file_unit +incdir+include +lint=all +error+20 rtl/micro_reg.sv tb/tb_micro_reg.sv

tb_instr_reg_interface:
	vcs -sverilog -R +lint=all -debug_access+all -top tb_instr_reg +incdir+include +lint=all +error+20 rtl/inst_mem.sv tb/tb_instr_mem.sv

tb_cpu_fsm:
	vcs -sverilog -R +lint=all -debug_access+all -top tb_cpu_fsm +incdir+include +lint=all rtl/mcpu.sv tb/tb_cpu_fsm_interface.sv 

tb_cpu_top:
	vcs -sverilog -R +lint=all -debug_access+all -top tb_topcpu +incdir+include +lint=all tb/tb_top_cpu.sv rtl/mcpu.sv rtl/inst_mem.sv rtl/decode.v rtl/micro_reg.sv rtl/shared_bus.sv rtl/alu.sv

clean:
	rm -rf simv.daidir/
	rm -rf simv
	rm -rf csrc
	rm -rf DVEfiles
	rm -f ucli.key
	rm -f inter.vpd
	rm -f .restartSimSession.tcl.old
	rm -f .__*
	rm -f *.vcd
	rm -f log
	rm -f *.out
	


all: clean 
