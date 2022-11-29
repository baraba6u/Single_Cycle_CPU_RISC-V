all: simple_cpu

MODULES = modules/ALU.v \
					modules/ALU_control.v \
					modules/defines.v \
					modules/register_file.v \
					modules/control.v \
					modules/data_memory.v \
					modules/mux_2x1.v	\
					modules/mux_3x1.v	\
					modules/imm_generator.v \
					modules/adder.v \
					modules/branch_control.v

SOURCES = ./riscv_tb.v ./simple_cpu.v 

simple_cpu: $(MODULES) $(SOURCES)
	iverilog -I modules/ -s riscv_tb -o $@ $^

clean:
	rm -f simple_cpu *.vcd
