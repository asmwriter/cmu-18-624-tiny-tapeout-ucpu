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


tb_decoder_iv:
	vcs -sverilog -R +lint=all -debug_access+all -top tb_micro_inst_decoder +incdir+include +lint=all rtl/decode.v tb/tb_micro_decoder.sv

tb_alu_iv:
	vcs -sverilog -R +lint=all -debug_access+all -top tb_alu_unit +incdir+include +lint=all rtl/alu.sv tb/tb_alu.sv


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
	rm *.out
	


all: clean 
