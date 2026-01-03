
RISCV_GNU_TOOLCHAIN_GIT_REVISION = 411d134
# RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX = /opt/riscv32
RISCV_RESOURCES = $(HOME)/riscv-sources
RISCV_GNU_TOOLCHAIN_INSTALL_DIR = $(HOME)/riscv32_src
RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX = $(RISCV_GNU_TOOLCHAIN_INSTALL_DIR)/riscv32

# Give the user some easy overrides for local configuration quirks.
# If you change one of these and it breaks, then you get to keep both pieces.
SHELL = bash
PYTHON = python3
VERILATOR = verilator
ICARUS_SUFFIX =
IVERILOG = iverilog$(ICARUS_SUFFIX)
VVP = vvp$(ICARUS_SUFFIX)

TEST_OBJS = $(addsuffix .o,$(basename $(wildcard tests/*.S)))
FIRMWARE_OBJS = firmware/start.o firmware/irq.o firmware/print.o firmware/hello.o firmware/sieve.o firmware/multest.o firmware/stats.o
FIRMWARE_OBJS += firmware/stress.o
GCC_WARNS  = -Werror -Wall -Wextra -Wshadow -Wundef -Wpointer-arith -Wcast-qual -Wcast-align -Wwrite-strings
GCC_WARNS += -Wredundant-decls -Wstrict-prototypes -Wmissing-prototypes -pedantic # -Wconversion
TOOLCHAIN_PREFIX = $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)imc/bin/riscv32-unknown-elf-
COMPRESSED_ISA = C

GIT_ENV = true

test: testbench.vvp firmware/firmware.hex
	$(VVP) -N $<

test_vcd: testbench.vvp firmware/firmware.hex
	$(VVP) -N $< +vcd +trace +noerror

test_rvf: testbench_rvf.vvp firmware/firmware.hex
	$(VVP) -N $< +vcd +trace +noerror

test_wb: testbench_wb.vvp firmware/firmware.hex
	$(VVP) -N $<

test_wb_vcd: testbench_wb.vvp firmware/firmware.hex
	$(VVP) -N $< +vcd +trace +noerror

test_ez: testbench_ez.vvp
	$(VVP) -N $<

test_ez_vcd: testbench_ez.vvp
	$(VVP) -N $< +vcd

test_sp: testbench_sp.vvp firmware/firmware.hex
	$(VVP) -N $<

test_axi: testbench.vvp firmware/firmware.hex
	$(VVP) -N $< +axi_test

test_synth: testbench_synth.vvp firmware/firmware.hex
	$(VVP) -N $<

test_verilator: testbench_verilator firmware/firmware.hex
	./testbench_verilator

testbench.vvp: testbench.v picorv32.v
	$(IVERILOG) -o $@ $(subst C,-DCOMPRESSED_ISA,$(COMPRESSED_ISA)) $^
	chmod -x $@

testbench_rvf.vvp: testbench.v picorv32.v rvfimon.v
	$(IVERILOG) -o $@ -D RISCV_FORMAL $(subst C,-DCOMPRESSED_ISA,$(COMPRESSED_ISA)) $^
	chmod -x $@

testbench_wb.vvp: testbench_wb.v picorv32.v
	$(IVERILOG) -o $@ $(subst C,-DCOMPRESSED_ISA,$(COMPRESSED_ISA)) $^
	chmod -x $@

testbench_ez.vvp: testbench_ez.v picorv32.v
	$(IVERILOG) -o $@ $(subst C,-DCOMPRESSED_ISA,$(COMPRESSED_ISA)) $^
	chmod -x $@

testbench_sp.vvp: testbench.v picorv32.v
	$(IVERILOG) -o $@ $(subst C,-DCOMPRESSED_ISA,$(COMPRESSED_ISA)) -DSP_TEST $^
	chmod -x $@

testbench_synth.vvp: testbench.v synth.v
	$(IVERILOG) -o $@ -DSYNTH_TEST $^
	chmod -x $@

testbench_verilator: testbench.v picorv32.v testbench.cc
	$(VERILATOR) --cc --exe -Wno-lint -trace --top-module picorv32_wrapper testbench.v picorv32.v testbench.cc \
			$(subst C,-DCOMPRESSED_ISA,$(COMPRESSED_ISA)) --Mdir testbench_verilator_dir
	$(MAKE) -C testbench_verilator_dir -f Vpicorv32_wrapper.mk
	cp testbench_verilator_dir/Vpicorv32_wrapper testbench_verilator

check: check-yices

check-%: check.smt2
	yosys-smtbmc -s $(subst check-,,$@) -t 30 --dump-vcd check.vcd check.smt2
	yosys-smtbmc -s $(subst check-,,$@) -t 25 --dump-vcd check.vcd -i check.smt2

check.smt2: picorv32.v
	yosys -v2 -p 'read_verilog -formal picorv32.v' \
	          -p 'prep -top picorv32 -nordff' \
		  -p 'assertpmux -noinit; opt -fast; dffunmap' \
		  -p 'write_smt2 -wires check.smt2'

synth.v: picorv32.v scripts/yosys/synth_sim.ys
	yosys -qv3 -l synth.log scripts/yosys/synth_sim.ys

firmware/firmware.hex: firmware/firmware.bin firmware/makehex.py
	$(PYTHON) firmware/makehex.py $< 32768 > $@

firmware/firmware.bin: firmware/firmware.elf
	$(TOOLCHAIN_PREFIX)objcopy -O binary $< $@
	chmod -x $@

firmware/firmware.elf: $(FIRMWARE_OBJS) $(TEST_OBJS) firmware/sections.lds
	$(TOOLCHAIN_PREFIX)gcc -Os -mabi=ilp32 -march=rv32im$(subst C,c,$(COMPRESSED_ISA)) -ffreestanding -nostdlib -o $@ \
		-Wl,--build-id=none,-Bstatic,-T,firmware/sections.lds,-Map,firmware/firmware.map,--strip-debug \
		$(FIRMWARE_OBJS) $(TEST_OBJS) -lgcc
	chmod -x $@

firmware/start.o: firmware/start.S
	$(TOOLCHAIN_PREFIX)gcc -c -mabi=ilp32 -march=rv32im$(subst C,c,$(COMPRESSED_ISA)) -o $@ $<

firmware/%.o: firmware/%.c
	$(TOOLCHAIN_PREFIX)gcc -c -mabi=ilp32 -march=rv32i$(subst C,c,$(COMPRESSED_ISA)) -Os --std=c99 $(GCC_WARNS) -ffreestanding -nostdlib -o $@ $<

# Specific rule for RVC test to enable 'c' extension
tests/rvc_test.o: tests/rvc_test.S tests/riscv_test.h tests/test_macros.h
	$(TOOLCHAIN_PREFIX)gcc -c -mabi=ilp32 -march=rv32imc -o $@ -DTEST_FUNC_NAME=rvc_test \
		-DTEST_FUNC_TXT='"rvc_test"' -DTEST_FUNC_RET=rvc_test_ret $<

tests/%.o: tests/%.S tests/riscv_test.h tests/test_macros.h
	$(TOOLCHAIN_PREFIX)gcc -c -mabi=ilp32 -march=rv32im -o $@ -DTEST_FUNC_NAME=$(notdir $(basename $<)) \
		-DTEST_FUNC_TXT='"$(notdir $(basename $<))"' -DTEST_FUNC_RET=$(notdir $(basename $<))_ret $<

download-tools:
	mkdir -p $(RISCV_RESOURCES)
	@for REPO in riscv-gnu-toolchain riscv-binutils-gdb riscv-gcc riscv-glibc riscv-newlib; do \
		if [ ! -d "$(RISCV_RESOURCES)/$$REPO.git" ]; then \
			echo "Cloning $$REPO..."; \
			GIT_PACK_THREADS=1 git clone --bare https://github.com/riscv/$$REPO $(RISCV_RESOURCES)/$$REPO.git; \
		else \
			echo "Updating $$REPO..."; \
			(cd $(RISCV_RESOURCES)/$$REPO.git && git fetch); \
		fi; \
	done

define build_tools_template
build-$(1)-tools:
	@echo "Target installation directory: $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)$(subst riscv32,,$(1))"
	@read -p "Do you want to remove existing data and start fresh? Type YES to remove, anything else to keep: " reply; \
	if [ "$$reply" = "YES" ] || [ "$$reply" = "yes" ] || [ "$$reply" = "Yes" ]; then \
		echo "Removing existing data..."; \
		rm -rf $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)$(subst riscv32,,$(1)); \
		mkdir -p $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)$(subst riscv32,,$(1)); \
	else \
		echo "Keeping existing installation, continuing..."; \
		mkdir -p $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)$(subst riscv32,,$(1)); \
	fi
	$(MAKE) build-$(1)-tools-bh

build-$(1)-tools-bh:
	+set -ex; $(GIT_ENV); \
	if [ -d $(RISCV_RESOURCES)/riscv-gnu-toolchain.git ]; then reference_riscv_gnu_toolchain="--reference $(RISCV_RESOURCES)/riscv-gnu-toolchain.git"; else reference_riscv_gnu_toolchain=""; fi; \
	if [ -d $(RISCV_RESOURCES)/riscv-binutils-gdb.git ]; then reference_riscv_binutils_gdb="--reference $(RISCV_RESOURCES)/riscv-binutils-gdb.git"; else reference_riscv_binutils_gdb=""; fi; \
	if [ -d $(RISCV_RESOURCES)/riscv-gcc.git ]; then reference_riscv_gcc="--reference $(RISCV_RESOURCES)/riscv-gcc.git"; else reference_riscv_gcc=""; fi; \
	if [ -d $(RISCV_RESOURCES)/riscv-glibc.git ]; then reference_riscv_glibc="--reference $(RISCV_RESOURCES)/riscv-glibc.git"; else reference_riscv_glibc=""; fi; \
	if [ -d $(RISCV_RESOURCES)/riscv-newlib.git ]; then reference_riscv_newlib="--reference $(RISCV_RESOURCES)/riscv-newlib.git"; else reference_riscv_newlib=""; fi; \
	if [ ! -d riscv-gnu-toolchain-$(1) ]; then \
		rm -rf riscv-gnu-toolchain-$(1); \
		git clone $$$$reference_riscv_gnu_toolchain https://github.com/riscv/riscv-gnu-toolchain riscv-gnu-toolchain-$(1); \
	else \
		echo "riscv-gnu-toolchain-$(1) already exists, skipping clone"; \
	fi; \
	cd riscv-gnu-toolchain-$(1); git checkout $(RISCV_GNU_TOOLCHAIN_GIT_REVISION); \
	git submodule update --init $$$$reference_riscv_binutils_gdb riscv-binutils; \
	git submodule update --init $$$$reference_riscv_binutils_gdb riscv-gdb; \
	git submodule update --init $$$$reference_riscv_gcc riscv-gcc; \
	git submodule update --init $$$$reference_riscv_glibc riscv-glibc; \
	git submodule update --init $$$$reference_riscv_newlib riscv-newlib; \
	export CFLAGS="-O2 -g -Wno-format-security" CXXFLAGS="-O2 -g -Wno-format-security"; \
	export CFLAGS_FOR_TARGET="-O2 -g -Wno-format-security" CXXFLAGS_FOR_TARGET="-O2 -g -Wno-format-security"; \
	if [ ! -d build ]; then \
		mkdir build; cd build; \
	else \
		cd build; \
	fi; \
	../configure \
		--with-arch=$(2) \
		--prefix=$(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)$(subst riscv32,,$(1)); \
	make

.PHONY: build-$(1)-tools
endef

$(eval $(call build_tools_template,riscv32i,rv32i))
$(eval $(call build_tools_template,riscv32ic,rv32ic))
$(eval $(call build_tools_template,riscv32im,rv32im))
$(eval $(call build_tools_template,riscv32imc,rv32imc))

build-tools:
	@echo "This will remove all existing data from $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)i, $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)ic, $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)im, and $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)imc."
	@read -p "Type YES to continue: " reply && [[ "$$reply" == [Yy][Ee][Ss] || "$$reply" == [Yy] ]]
	bash -c "set -ex; rm -rf $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX){i,ic,im,imc}; mkdir -p $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX){i,ic,im,imc}; chown $${USER}: $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX){i,ic,im,imc}"
# +$(MAKE) build-riscv32i-tools-bh
# +$(MAKE) build-riscv32ic-tools-bh
# +$(MAKE) build-riscv32im-tools-bh
	+$(MAKE) build-riscv32imc-tools-bh

toc:
	gawk '/^-+$$/ { y=tolower(x); gsub("[^a-z0-9]+", "-", y); gsub("-$$", "", y); printf("- [%s](#%s)\n", x, y); } { x=$$0; }' README.md

clean:
	rm -rf riscv-gnu-toolchain-riscv32i riscv-gnu-toolchain-riscv32ic \
		riscv-gnu-toolchain-riscv32im riscv-gnu-toolchain-riscv32imc
	rm -vrf $(FIRMWARE_OBJS) $(TEST_OBJS) check.smt2 check.vcd synth.v synth.log \
		firmware/firmware.elf firmware/firmware.bin firmware/firmware.hex firmware/firmware.map \
		testbench.vvp testbench_sp.vvp testbench_synth.vvp testbench_ez.vvp \
		testbench_rvf.vvp testbench_wb.vvp testbench.vcd testbench.trace \
		testbench_verilator testbench_verilator_dir

.PHONY: test test_vcd test_sp test_axi test_wb test_wb_vcd test_ez test_ez_vcd test_synth download-tools build-tools toc clean
