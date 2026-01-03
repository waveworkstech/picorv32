# PicoRV32 Testing Guide

This guide describes how to prepare the environment and run the test suite for the PicoRV32 CPU.

## 1. Initial Environment Setup

If you are setting up the environment for the first time, use the setup_riscv.sh script to install nix-portable and build the RISC-V toolchain.

### Steps:

Run the setup script:

```bash
chmod +x setup_riscv.sh
./setup_riscv.sh
```

**Actions:**
* Downloads nix-portable to ~/.nix-portable/.
* Enters a Nix shell containing Icarus Verilog, and Verilator.
* Downloads RISC-V GNU toolchain sources.
* Builds the rv32imc toolchain in your home directory.

### Manual Toolchain Build (Local Environment)

If you have iverilog and verilator installed locally and do not wish to use nix-shell, you can build the toolchain using the Makefile targets:

```bash
# Download RISC-V sources (default path: $HOME/riscv-sources)
make download-tools RISCV_RESOURCES=$HOME/riscv-sources

# Build the RISC-V toolchain (default path: $HOME/riscv32_src)
make build-riscv32imc-tools RISCV_GNU_TOOLCHAIN_INSTALL_DIR=$HOME/riscv32_src
```

---

## 2. Running the Test Suite

Use the run_tests.sh script to execute the comprehensive test suite. The script automatically verifies that either your Nix environment is active or the required tools are installed locally, and it ensures the RISC-V toolchain is correctly loaded before starting.

**Option A: Using the Nix Environment**

Enter the shell first to ensure all dependencies are available:

```bash
nix-portable nix-shell
chmod +x run_tests.sh
./run_tests.sh
```

**Option B: Using Local Tools**

If tools are already installed locally, ensure your TOOLCHAIN_PREFIX environment variable points to your local compiler (e.g., 'riscv32-unknown-elf-') and then run the tests:

```bash
# Default path: "$HOME/riscv32_src/riscv32imc", change based on your installation
export TOOLCHAIN_PREFIX=$HOME/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-
chmod +x run_tests.sh
./run_tests.sh
```

### Summary of Executed Tests:

The script provides status reports for the following verification areas:
* **EZ Test**: Basic CPU bring-up and simple instruction fetch.
* **Firmware Tests**: Full ISA verification suite using Icarus and Verilator.
* **AXI4-Lite Interface**: Verification of bus transactions and memory correctness.
* **Benchmarks**: Execution of standard Dhrystone v2.1 performance tests.
* **C++ Runtime**: Validation of constructors, virtual functions, and STL support.

---

## 3. Expected Output Logs

When running `run_tests.sh`, you should see a sequence of passes for each major test category, If a test fails, the script will exit immediately.

```
============================================================
      PicoRV32 Stress Test Suite - Environment Check
============================================================
✅ Found iverilog: /nix/store/i1wkp64lbwqqqcq46l2k3z3i6kzfslyq-iverilog-12.0/bin/iverilog
✅ Found verilator: /nix/store/x3misplq46qblb5kjz9xygsgs2l9b428-verilator-5.022/bin/verilator
✅ Found vvp: /nix/store/i1wkp64lbwqqqcq46l2k3z3i6kzfslyq-iverilog-12.0/bin/vvp
Using Toolchain Prefix: /home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-
✅ Found RISC-V Toolchain: /home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc
Environment verification complete. Starting tests...

------------------------------------------------------------
Test 1: EZ Test (test_ez)
Summary: Verifies basic CPU bring-up and simple instruction fetch.
------------------------------------------------------------
iverilog -o testbench_ez.vvp -DCOMPRESSED_ISA testbench_ez.v picorv32.v
chmod -x testbench_ez.vvp
vvp -N testbench_ez.vvp
ifetch 0x00000000: 0x3fc00093
ifetch 0x00000004: 0x0000a023
ifetch 0x00000008: 0x0000a103
write  0x000003fc: 0x00000000 (wstrb=1111)
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000000
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000001 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000001
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000002 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000002
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000003 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000003
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000004 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000004
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000005 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000005
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000006 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000006
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000007 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000007
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000008 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000008
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000009 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000009
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x0000000a (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x0000000a
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x0000000b (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x0000000b
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x0000000c (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x0000000c
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x0000000d (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x0000000d
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x0000000e (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x0000000e
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x0000000f (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x0000000f
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000010 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000010
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000011 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000011
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000012 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000012
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000013 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000013
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000014 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000014
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000015 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000015
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000016 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000016
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000017 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000017
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000018 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000018
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000019 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000019
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x0000001a (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x0000001a
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x0000001b (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x0000001b
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x0000001c (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x0000001c
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x0000001d (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x0000001d
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x0000001e (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x0000001e
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x0000001f (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x0000001f
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000020 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000020
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000021 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000021
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000022 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000022
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000023 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000023
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000024 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000024
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000025 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000025
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000026 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000026
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000027 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000027
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000028 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000028
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x00000029 (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x00000029
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x0000002a (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x0000002a
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x0000002b (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x0000002b
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
write  0x000003fc: 0x0000002c (wstrb=1111)
ifetch 0x00000008: 0x0000a103
ifetch 0x0000000c: 0x00110113
read   0x000003fc: 0x0000002c
ifetch 0x00000010: 0x0020a023
ifetch 0x00000014: 0xff5ff06f
testbench_ez.v:25: $finish called at 11000000 (1ps)
   [PASSED] test_ez

------------------------------------------------------------
Test 2: Main Firmware Test (Icarus Verilog)
Summary: Runs full suite including ISA tests and stress tests.
------------------------------------------------------------
iverilog -o testbench.vvp -DCOMPRESSED_ISA testbench.v picorv32.v
chmod -x testbench.vvp
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32emc -o firmware/start.o firmware/start.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32emc -Os --std=c99 -Werror -Wall -Wextra -Wshadow -Wundef -Wpointer-arith -Wcast-qual -Wcast-align -Wwrite-strings -Wredundant-decls -Wstrict-prototypes -Wmissing-prototypes -pedantic  -ffreestanding -nostdlib -o firmware/print.o firmware/print.c
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32emc -Os --std=c99 -Werror -Wall -Wextra -Wshadow -Wundef -Wpointer-arith -Wcast-qual -Wcast-align -Wwrite-strings -Wredundant-decls -Wstrict-prototypes -Wmissing-prototypes -pedantic  -ffreestanding -nostdlib -o firmware/multest.o firmware/multest.c
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32emc -Os --std=c99 -Werror -Wall -Wextra -Wshadow -Wundef -Wpointer-arith -Wcast-qual -Wcast-align -Wwrite-strings -Wredundant-decls -Wstrict-prototypes -Wmissing-prototypes -pedantic  -ffreestanding -nostdlib -o firmware/stress.o firmware/stress.c
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/add.o -DTEST_FUNC_NAME=add \
	-DTEST_FUNC_TXT='"add"' -DTEST_FUNC_RET=add_ret tests/add.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/addi.o -DTEST_FUNC_NAME=addi \
	-DTEST_FUNC_TXT='"addi"' -DTEST_FUNC_RET=addi_ret tests/addi.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/and.o -DTEST_FUNC_NAME=and \
	-DTEST_FUNC_TXT='"and"' -DTEST_FUNC_RET=and_ret tests/and.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/andi.o -DTEST_FUNC_NAME=andi \
	-DTEST_FUNC_TXT='"andi"' -DTEST_FUNC_RET=andi_ret tests/andi.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/auipc.o -DTEST_FUNC_NAME=auipc \
	-DTEST_FUNC_TXT='"auipc"' -DTEST_FUNC_RET=auipc_ret tests/auipc.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/beq.o -DTEST_FUNC_NAME=beq \
	-DTEST_FUNC_TXT='"beq"' -DTEST_FUNC_RET=beq_ret tests/beq.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/bge.o -DTEST_FUNC_NAME=bge \
	-DTEST_FUNC_TXT='"bge"' -DTEST_FUNC_RET=bge_ret tests/bge.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/bgeu.o -DTEST_FUNC_NAME=bgeu \
	-DTEST_FUNC_TXT='"bgeu"' -DTEST_FUNC_RET=bgeu_ret tests/bgeu.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/blt.o -DTEST_FUNC_NAME=blt \
	-DTEST_FUNC_TXT='"blt"' -DTEST_FUNC_RET=blt_ret tests/blt.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/bltu.o -DTEST_FUNC_NAME=bltu \
	-DTEST_FUNC_TXT='"bltu"' -DTEST_FUNC_RET=bltu_ret tests/bltu.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/bne.o -DTEST_FUNC_NAME=bne \
	-DTEST_FUNC_TXT='"bne"' -DTEST_FUNC_RET=bne_ret tests/bne.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/j.o -DTEST_FUNC_NAME=j \
	-DTEST_FUNC_TXT='"j"' -DTEST_FUNC_RET=j_ret tests/j.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/jal.o -DTEST_FUNC_NAME=jal \
	-DTEST_FUNC_TXT='"jal"' -DTEST_FUNC_RET=jal_ret tests/jal.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/jalr.o -DTEST_FUNC_NAME=jalr \
	-DTEST_FUNC_TXT='"jalr"' -DTEST_FUNC_RET=jalr_ret tests/jalr.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/lb.o -DTEST_FUNC_NAME=lb \
	-DTEST_FUNC_TXT='"lb"' -DTEST_FUNC_RET=lb_ret tests/lb.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/lbu.o -DTEST_FUNC_NAME=lbu \
	-DTEST_FUNC_TXT='"lbu"' -DTEST_FUNC_RET=lbu_ret tests/lbu.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/lh.o -DTEST_FUNC_NAME=lh \
	-DTEST_FUNC_TXT='"lh"' -DTEST_FUNC_RET=lh_ret tests/lh.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/lhu.o -DTEST_FUNC_NAME=lhu \
	-DTEST_FUNC_TXT='"lhu"' -DTEST_FUNC_RET=lhu_ret tests/lhu.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/lui.o -DTEST_FUNC_NAME=lui \
	-DTEST_FUNC_TXT='"lui"' -DTEST_FUNC_RET=lui_ret tests/lui.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/lw.o -DTEST_FUNC_NAME=lw \
	-DTEST_FUNC_TXT='"lw"' -DTEST_FUNC_RET=lw_ret tests/lw.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/mul.o -DTEST_FUNC_NAME=mul \
	-DTEST_FUNC_TXT='"mul"' -DTEST_FUNC_RET=mul_ret tests/mul.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/mulh.o -DTEST_FUNC_NAME=mulh \
	-DTEST_FUNC_TXT='"mulh"' -DTEST_FUNC_RET=mulh_ret tests/mulh.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/mulhsu.o -DTEST_FUNC_NAME=mulhsu \
	-DTEST_FUNC_TXT='"mulhsu"' -DTEST_FUNC_RET=mulhsu_ret tests/mulhsu.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/mulhu.o -DTEST_FUNC_NAME=mulhu \
	-DTEST_FUNC_TXT='"mulhu"' -DTEST_FUNC_RET=mulhu_ret tests/mulhu.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/or.o -DTEST_FUNC_NAME=or \
	-DTEST_FUNC_TXT='"or"' -DTEST_FUNC_RET=or_ret tests/or.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/ori.o -DTEST_FUNC_NAME=ori \
	-DTEST_FUNC_TXT='"ori"' -DTEST_FUNC_RET=ori_ret tests/ori.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32emc -o tests/rvc_test.o -DTEST_FUNC_NAME=rvc_test \
	-DTEST_FUNC_TXT='"rvc_test"' -DTEST_FUNC_RET=rvc_test_ret tests/rvc_test.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/sb.o -DTEST_FUNC_NAME=sb \
	-DTEST_FUNC_TXT='"sb"' -DTEST_FUNC_RET=sb_ret tests/sb.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/sh.o -DTEST_FUNC_NAME=sh \
	-DTEST_FUNC_TXT='"sh"' -DTEST_FUNC_RET=sh_ret tests/sh.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/simple.o -DTEST_FUNC_NAME=simple \
	-DTEST_FUNC_TXT='"simple"' -DTEST_FUNC_RET=simple_ret tests/simple.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/sll.o -DTEST_FUNC_NAME=sll \
	-DTEST_FUNC_TXT='"sll"' -DTEST_FUNC_RET=sll_ret tests/sll.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/slli.o -DTEST_FUNC_NAME=slli \
	-DTEST_FUNC_TXT='"slli"' -DTEST_FUNC_RET=slli_ret tests/slli.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/slt.o -DTEST_FUNC_NAME=slt \
	-DTEST_FUNC_TXT='"slt"' -DTEST_FUNC_RET=slt_ret tests/slt.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/slti.o -DTEST_FUNC_NAME=slti \
	-DTEST_FUNC_TXT='"slti"' -DTEST_FUNC_RET=slti_ret tests/slti.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/sra.o -DTEST_FUNC_NAME=sra \
	-DTEST_FUNC_TXT='"sra"' -DTEST_FUNC_RET=sra_ret tests/sra.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/srai.o -DTEST_FUNC_NAME=srai \
	-DTEST_FUNC_TXT='"srai"' -DTEST_FUNC_RET=srai_ret tests/srai.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/srl.o -DTEST_FUNC_NAME=srl \
	-DTEST_FUNC_TXT='"srl"' -DTEST_FUNC_RET=srl_ret tests/srl.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/srli.o -DTEST_FUNC_NAME=srli \
	-DTEST_FUNC_TXT='"srli"' -DTEST_FUNC_RET=srli_ret tests/srli.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/sub.o -DTEST_FUNC_NAME=sub \
	-DTEST_FUNC_TXT='"sub"' -DTEST_FUNC_RET=sub_ret tests/sub.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/sw.o -DTEST_FUNC_NAME=sw \
	-DTEST_FUNC_TXT='"sw"' -DTEST_FUNC_RET=sw_ret tests/sw.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/xor.o -DTEST_FUNC_NAME=xor \
	-DTEST_FUNC_TXT='"xor"' -DTEST_FUNC_RET=xor_ret tests/xor.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -c -mabi=ilp32e -march=rv32em -o tests/xori.o -DTEST_FUNC_NAME=xori \
	-DTEST_FUNC_TXT='"xori"' -DTEST_FUNC_RET=xori_ret tests/xori.S
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-gcc -Os -mabi=ilp32e -march=rv32emc -ffreestanding -nostdlib -o firmware/firmware.elf \
	-Wl,--build-id=none,-Bstatic,-T,firmware/sections.lds,-Map,firmware/firmware.map,--strip-debug \
	firmware/start.o firmware/irq.o firmware/print.o firmware/hello.o firmware/multest.o firmware/stress.o tests/add.o tests/addi.o tests/and.o tests/andi.o tests/auipc.o tests/beq.o tests/bge.o tests/bgeu.o tests/blt.o tests/bltu.o tests/bne.o tests/j.o tests/jal.o tests/jalr.o tests/lb.o tests/lbu.o tests/lh.o tests/lhu.o tests/lui.o tests/lw.o tests/mul.o tests/mulh.o tests/mulhsu.o tests/mulhu.o tests/or.o tests/ori.o tests/rvc_test.o tests/sb.o tests/sh.o tests/simple.o tests/sll.o tests/slli.o tests/slt.o tests/slti.o tests/sra.o tests/srai.o tests/srl.o tests/srli.o tests/sub.o tests/sw.o tests/xor.o tests/xori.o
chmod -x firmware/firmware.elf
/home/farag/riscv32_src/riscv32imc/bin/riscv32-unknown-elf-objcopy -O binary firmware/firmware.elf firmware/firmware.bin
chmod -x firmware/firmware.bin
python3 firmware/makehex.py firmware/firmware.bin 32768 > firmware/firmware.hex
vvp -N testbench.vvp
hello world
lui..OK
auipc..OK
j..OK
jal..OK
jalr..OK
beq..OK
bne..OK
blt..OK
bge..OK
bltu..OK
bgeu..OK
lb..OK
lh..OK
lw..OK
lbu..OK
lhu..OK
sb..OK
sh..OK
sw..OK
addi..OK
slti..OK
xori..OK
ori..OK
andi..OK
slli..OK
srli..OK
srai..OK
add..OK
sub..OK
sll..OK
slt..OK
xor..OK
srl..OK
sra..OK
or..OK
and..OK
rvc_test..OK
mulh..OK
mulhsu..OK
mulhu..OK
mul..OK
simple..OK
input     [FFFFFFFF] 80000000 [FFFFFFFF] FFFFFFFF
hard mul   80000000  00000000  80000000  7FFFFFFF
soft mul   80000000   OK (Low 32 verified)
input     [00000000] 00000000 [00000000] 00000000
hard mul   00000000  00000000  00000000  00000000
soft mul   00000000   OK (Low 32 verified)
input     [FFFFFFFF] 8B578493 [00000000] 00000000
hard mul   00000000  00000000  00000000  00000000
soft mul   00000000   OK (Low 32 verified)
input     [00000000] 6F038AFB [00000000] 00000000
hard mul   00000000  00000000  00000000  00000000
soft mul   00000000   OK (Low 32 verified)
input     [00000000] 1BFC9C22 [FFFFFFFF] 876B9BDE
hard mul   67CDFB7C  F2D15DD3  0ECDF9F5  0ECDF9F5
soft mul   67CDFB7C   OK (Low 32 verified)
input     [00000000] 76141B16 [00000000] 5BA2940D
hard mul   949A181E  2A4422A3  2A4422A3  2A4422A3
soft mul   949A181E   OK (Low 32 verified)
input     [00000000] 2D45231C [FFFFFFFF] ADFA166F
hard mul   C756A124  F17ECF19  1EC3F235  1EC3F235
soft mul   C756A124   OK (Low 32 verified)
input     [00000000] 09C7BF74 [00000000] 3B014C60
hard mul   73323B80  024115D2  024115D2  024115D2
soft mul   73323B80   OK (Low 32 verified)
input     [00000000] 4325E1E6 [00000000] 1C32932A
hard mul   0BDA21BC  076568B5  076568B5  076568B5
soft mul   0BDA21BC   OK (Low 32 verified)
input     [FFFFFFFF] 84A97421 [FFFFFFFF] EF8D27D7
hard mul   002E8EB7  07ECBD6D  8C96318E  7C235965
soft mul   002E8EB7   OK (Low 32 verified)
input     [00000000] 258BAFEC [00000000] 5EB6FD37
hard mul   D7A707B4  0DE4210A  0DE4210A  0DE4210A
soft mul   D7A707B4   OK (Low 32 verified)
input     [FFFFFFFF] A31BEA5F [00000000] 145CCB97
hard mul   FE749309  F89C8277  F89C8277  0CF94E0E
soft mul   FE749309   OK (Low 32 verified)
input     [00000000] 28E3CD00 [00000000] 793F5181
hard mul   21A74D00  135DC8F9  135DC8F9  135DC8F9
soft mul   21A74D00   OK (Low 32 verified)
input     [FFFFFFFF] F2E838C6 [00000000] 4BE0C5FE
hard mul   6558B274  FC1E89B3  FC1E89B3  47FF4FB1
soft mul   6558B274   OK (Low 32 verified)
input     [00000000] 38BAA671 [FFFFFFFF] E2E2B92B
hard mul   1B639DFB  F98C5E4E  324704BF  324704BF
soft mul   1B639DFB   OK (Low 32 verified)

--- STARTING STRESS TESTS ---
[1/5] Running Matrix Mul... PASS
[2/5] Running Bubble Sort... PASS
[3/5] Running Recursion... PASS
[4/5] Running CRC32... PASS
[5/5] Running GCD... PASS
--- ALL TESTS PASSED ---
DONE
TRAP after 225230 clock cycles
ALL TESTS PASSED.
testbench.v:274: $finish called at 2253400000 (1ps)
   [PASSED] make test (Icarus)

------------------------------------------------------------
Test 3: Main Firmware Test (Verilator)
Summary: Validates compatibility with Verilator.
------------------------------------------------------------
verilator --cc --exe -Wno-lint -trace --top-module picorv32_wrapper testbench.v picorv32.v testbench.cc \
		-DCOMPRESSED_ISA --Mdir testbench_verilator_dir
make -C testbench_verilator_dir -f Vpicorv32_wrapper.mk
make[1]: Entering directory '/home/farag/Team_mabrains/wadi/backflip/private/ww/picorv32/testbench_verilator_dir'
g++  -I.  -MMD -I/nix/store/x3misplq46qblb5kjz9xygsgs2l9b428-verilator-5.022/share/verilator/include -I/nix/store/x3misplq46qblb5kjz9xygsgs2l9b428-verilator-5.022/share/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -DVM_TRACE_FST=0 -DVM_TRACE_VCD=1 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-shadow -Wno-sign-compare -Wno-tautological-compare -Wno-uninitialized -Wno-unused-but-set-parameter -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable      -Os -c -o testbench.o ../testbench.cc
g++ -Os  -I.  -MMD -I/nix/store/x3misplq46qblb5kjz9xygsgs2l9b428-verilator-5.022/share/verilator/include -I/nix/store/x3misplq46qblb5kjz9xygsgs2l9b428-verilator-5.022/share/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -DVM_TRACE_FST=0 -DVM_TRACE_VCD=1 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-shadow -Wno-sign-compare -Wno-tautological-compare -Wno-uninitialized -Wno-unused-but-set-parameter -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable      -c -o verilated.o /nix/store/x3misplq46qblb5kjz9xygsgs2l9b428-verilator-5.022/share/verilator/include/verilated.cpp
g++ -Os  -I.  -MMD -I/nix/store/x3misplq46qblb5kjz9xygsgs2l9b428-verilator-5.022/share/verilator/include -I/nix/store/x3misplq46qblb5kjz9xygsgs2l9b428-verilator-5.022/share/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -DVM_TRACE_FST=0 -DVM_TRACE_VCD=1 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-shadow -Wno-sign-compare -Wno-tautological-compare -Wno-uninitialized -Wno-unused-but-set-parameter -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable      -c -o verilated_dpi.o /nix/store/x3misplq46qblb5kjz9xygsgs2l9b428-verilator-5.022/share/verilator/include/verilated_dpi.cpp
g++ -Os  -I.  -MMD -I/nix/store/x3misplq46qblb5kjz9xygsgs2l9b428-verilator-5.022/share/verilator/include -I/nix/store/x3misplq46qblb5kjz9xygsgs2l9b428-verilator-5.022/share/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -DVM_TRACE_FST=0 -DVM_TRACE_VCD=1 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-shadow -Wno-sign-compare -Wno-tautological-compare -Wno-uninitialized -Wno-unused-but-set-parameter -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable      -c -o verilated_vcd_c.o /nix/store/x3misplq46qblb5kjz9xygsgs2l9b428-verilator-5.022/share/verilator/include/verilated_vcd_c.cpp
g++ -Os  -I.  -MMD -I/nix/store/x3misplq46qblb5kjz9xygsgs2l9b428-verilator-5.022/share/verilator/include -I/nix/store/x3misplq46qblb5kjz9xygsgs2l9b428-verilator-5.022/share/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -DVM_TRACE_FST=0 -DVM_TRACE_VCD=1 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-shadow -Wno-sign-compare -Wno-tautological-compare -Wno-uninitialized -Wno-unused-but-set-parameter -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable      -c -o verilated_threads.o /nix/store/x3misplq46qblb5kjz9xygsgs2l9b428-verilator-5.022/share/verilator/include/verilated_threads.cpp
/nix/store/gd3shnza1i50zn8zs04fa729ribr88m9-python3-3.11.8/bin/python3 /nix/store/x3misplq46qblb5kjz9xygsgs2l9b428-verilator-5.022/share/verilator/bin/verilator_includer -DVL_INCLUDE_OPT=include Vpicorv32_wrapper.cpp Vpicorv32_wrapper___024root__DepSet_h3139ae09__0.cpp Vpicorv32_wrapper___024root__DepSet_h8446a20b__0.cpp Vpicorv32_wrapper_picorv32_wrapper__DepSet_haddc77af__0.cpp Vpicorv32_wrapper_axi4_memory__DepSet_h9e3ae459__0.cpp Vpicorv32_wrapper_axi4_memory__DepSet_h1d476bdb__0.cpp Vpicorv32_wrapper__Dpi.cpp Vpicorv32_wrapper__Trace__0.cpp Vpicorv32_wrapper__ConstPool_0.cpp Vpicorv32_wrapper___024root__Slow.cpp Vpicorv32_wrapper___024root__DepSet_h3139ae09__0__Slow.cpp Vpicorv32_wrapper___024root__DepSet_h8446a20b__0__Slow.cpp Vpicorv32_wrapper_picorv32_wrapper__Slow.cpp Vpicorv32_wrapper_picorv32_wrapper__DepSet_haddc77af__0__Slow.cpp Vpicorv32_wrapper_picorv32_wrapper__DepSet_hf129db65__0__Slow.cpp Vpicorv32_wrapper_axi4_memory__Slow.cpp Vpicorv32_wrapper_axi4_memory__DepSet_h1d476bdb__0__Slow.cpp Vpicorv32_wrapper__Syms.cpp Vpicorv32_wrapper__Trace__0__Slow.cpp Vpicorv32_wrapper__TraceDecls__0__Slow.cpp > Vpicorv32_wrapper__ALL.cpp
g++ -Os  -I.  -MMD -I/nix/store/x3misplq46qblb5kjz9xygsgs2l9b428-verilator-5.022/share/verilator/include -I/nix/store/x3misplq46qblb5kjz9xygsgs2l9b428-verilator-5.022/share/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -DVM_TRACE_FST=0 -DVM_TRACE_VCD=1 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-shadow -Wno-sign-compare -Wno-tautological-compare -Wno-uninitialized -Wno-unused-but-set-parameter -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable      -c -o Vpicorv32_wrapper__ALL.o Vpicorv32_wrapper__ALL.cpp
echo "" > Vpicorv32_wrapper__ALL.verilator_deplist.tmp
Archive ar -rcs Vpicorv32_wrapper__ALL.a Vpicorv32_wrapper__ALL.o
g++    testbench.o verilated.o verilated_dpi.o verilated_vcd_c.o verilated_threads.o Vpicorv32_wrapper__ALL.a    -pthread -lpthread -latomic   -o Vpicorv32_wrapper
rm Vpicorv32_wrapper__ALL.verilator_deplist.tmp
make[1]: Leaving directory '/home/farag/Team_mabrains/wadi/backflip/private/ww/picorv32/testbench_verilator_dir'
cp testbench_verilator_dir/Vpicorv32_wrapper testbench_verilator
./testbench_verilator
Built with Verilator 5.022 2024-02-24.
Recommended: Verilator 4.0 or later.
hello world
lui..OK
auipc..OK
j..OK
jal..OK
jalr..OK
beq..OK
bne..OK
blt..OK
bge..OK
bltu..OK
bgeu..OK
lb..OK
lh..OK
lw..OK
lbu..OK
lhu..OK
sb..OK
sh..OK
sw..OK
addi..OK
slti..OK
xori..OK
ori..OK
andi..OK
slli..OK
srli..OK
srai..OK
add..OK
sub..OK
sll..OK
slt..OK
xor..OK
srl..OK
sra..OK
or..OK
and..OK
rvc_test..OK
mulh..OK
mulhsu..OK
mulhu..OK
mul..OK
simple..OK
input     [FFFFFFFF] 80000000 [FFFFFFFF] FFFFFFFF
hard mul   80000000  00000000  80000000  7FFFFFFF
soft mul   80000000   OK (Low 32 verified)
input     [00000000] 00000000 [00000000] 00000000
hard mul   00000000  00000000  00000000  00000000
soft mul   00000000   OK (Low 32 verified)
input     [FFFFFFFF] 8B578493 [00000000] 00000000
hard mul   00000000  00000000  00000000  00000000
soft mul   00000000   OK (Low 32 verified)
input     [00000000] 6F038AFB [00000000] 00000000
hard mul   00000000  00000000  00000000  00000000
soft mul   00000000   OK (Low 32 verified)
input     [00000000] 1BFC9C22 [FFFFFFFF] 876B9BDE
hard mul   67CDFB7C  F2D15DD3  0ECDF9F5  0ECDF9F5
soft mul   67CDFB7C   OK (Low 32 verified)
input     [00000000] 76141B16 [00000000] 5BA2940D
hard mul   949A181E  2A4422A3  2A4422A3  2A4422A3
soft mul   949A181E   OK (Low 32 verified)
input     [00000000] 2D45231C [FFFFFFFF] ADFA166F
hard mul   C756A124  F17ECF19  1EC3F235  1EC3F235
soft mul   C756A124   OK (Low 32 verified)
input     [00000000] 09C7BF74 [00000000] 3B014C60
hard mul   73323B80  024115D2  024115D2  024115D2
soft mul   73323B80   OK (Low 32 verified)
input     [00000000] 4325E1E6 [00000000] 1C32932A
hard mul   0BDA21BC  076568B5  076568B5  076568B5
soft mul   0BDA21BC   OK (Low 32 verified)
input     [FFFFFFFF] 84A97421 [FFFFFFFF] EF8D27D7
hard mul   002E8EB7  07ECBD6D  8C96318E  7C235965
soft mul   002E8EB7   OK (Low 32 verified)
input     [00000000] 258BAFEC [00000000] 5EB6FD37
hard mul   D7A707B4  0DE4210A  0DE4210A  0DE4210A
soft mul   D7A707B4   OK (Low 32 verified)
input     [FFFFFFFF] A31BEA5F [00000000] 145CCB97
hard mul   FE749309  F89C8277  F89C8277  0CF94E0E
soft mul   FE749309   OK (Low 32 verified)
input     [00000000] 28E3CD00 [00000000] 793F5181
hard mul   21A74D00  135DC8F9  135DC8F9  135DC8F9
soft mul   21A74D00   OK (Low 32 verified)
input     [FFFFFFFF] F2E838C6 [00000000] 4BE0C5FE
hard mul   6558B274  FC1E89B3  FC1E89B3  47FF4FB1
soft mul   6558B274   OK (Low 32 verified)
input     [00000000] 38BAA671 [FFFFFFFF] E2E2B92B
hard mul   1B639DFB  F98C5E4E  324704BF  324704BF
soft mul   1B639DFB   OK (Low 32 verified)

--- STARTING STRESS TESTS ---
[1/5] Running Matrix Mul... PASS
[2/5] Running Bubble Sort... PASS
[3/5] Running Recursion... PASS
[4/5] Running CRC32... PASS
[5/5] Running GCD... PASS
--- ALL TESTS PASSED ---
DONE
TRAP after 225229 clock cycles
ALL TESTS PASSED.
- testbench.v:274: Verilog $finish
   [PASSED] make test_verilator

------------------------------------------------------------
Test 4: AXI4-Lite Interface Tests
Summary: Checks memory read/write correctness over AXI.
------------------------------------------------------------
vvp -N testbench.vvp +axi_test
hello world
lui..OK
auipc..OK
j..OK
jal..OK
jalr..OK
beq..OK
bne..OK
blt..OK
bge..OK
bltu..OK
bgeu..OK
lb..OK
lh..OK
lw..OK
lbu..OK
lhu..OK
sb..OK
sh..OK
sw..OK
addi..OK
slti..OK
xori..OK
ori..OK
andi..OK
slli..OK
srli..OK
srai..OK
add..OK
sub..OK
sll..OK
slt..OK
xor..OK
srl..OK
sra..OK
or..OK
and..OK
rvc_test..OK
mulh..OK
mulhsu..OK
mulhu..OK
mul..OK
simple..OK
input     [FFFFFFFF] 80000000 [FFFFFFFF] FFFFFFFF
hard mul   80000000  00000000  80000000  7FFFFFFF
soft mul   80000000   OK (Low 32 verified)
input     [00000000] 00000000 [00000000] 00000000
hard mul   00000000  00000000  00000000  00000000
soft mul   00000000   OK (Low 32 verified)
input     [FFFFFFFF] 8B578493 [00000000] 00000000
hard mul   00000000  00000000  00000000  00000000
soft mul   00000000   OK (Low 32 verified)
input     [00000000] 6F038AFB [00000000] 00000000
hard mul   00000000  00000000  00000000  00000000
soft mul   00000000   OK (Low 32 verified)
input     [00000000] 1BFC9C22 [FFFFFFFF] 876B9BDE
hard mul   67CDFB7C  F2D15DD3  0ECDF9F5  0ECDF9F5
soft mul   67CDFB7C   OK (Low 32 verified)
input     [00000000] 76141B16 [00000000] 5BA2940D
hard mul   949A181E  2A4422A3  2A4422A3  2A4422A3
soft mul   949A181E   OK (Low 32 verified)
input     [00000000] 2D45231C [FFFFFFFF] ADFA166F
hard mul   C756A124  F17ECF19  1EC3F235  1EC3F235
soft mul   C756A124   OK (Low 32 verified)
input     [00000000] 09C7BF74 [00000000] 3B014C60
hard mul   73323B80  024115D2  024115D2  024115D2
soft mul   73323B80   OK (Low 32 verified)
input     [00000000] 4325E1E6 [00000000] 1C32932A
hard mul   0BDA21BC  076568B5  076568B5  076568B5
soft mul   0BDA21BC   OK (Low 32 verified)
input     [FFFFFFFF] 84A97421 [FFFFFFFF] EF8D27D7
hard mul   002E8EB7  07ECBD6D  8C96318E  7C235965
soft mul   002E8EB7   OK (Low 32 verified)
input     [00000000] 258BAFEC [00000000] 5EB6FD37
hard mul   D7A707B4  0DE4210A  0DE4210A  0DE4210A
soft mul   D7A707B4   OK (Low 32 verified)
input     [FFFFFFFF] A31BEA5F [00000000] 145CCB97
hard mul   FE749309  F89C8277  F89C8277  0CF94E0E
soft mul   FE749309   OK (Low 32 verified)
input     [00000000] 28E3CD00 [00000000] 793F5181
hard mul   21A74D00  135DC8F9  135DC8F9  135DC8F9
soft mul   21A74D00   OK (Low 32 verified)
input     [FFFFFFFF] F2E838C6 [00000000] 4BE0C5FE
hard mul   6558B274  FC1E89B3  FC1E89B3  47FF4FB1
soft mul   6558B274   OK (Low 32 verified)
input     [00000000] 38BAA671 [FFFFFFFF] E2E2B92B
hard mul   1B639DFB  F98C5E4E  324704BF  324704BF
soft mul   1B639DFB   OK (Low 32 verified)

--- STARTING STRESS TESTS ---
[1/5] Running Matrix Mul... PASS
[2/5] Running Bubble Sort... PASS
[3/5] Running Recursion... PASS
[4/5] Running CRC32... PASS
[5/5] Running GCD... PASS
--- ALL TESTS PASSED ---
DONE
TRAP after 265818 clock cycles
ALL TESTS PASSED.
testbench.v:274: $finish called at 2659280000 (1ps)
   [PASSED] AXI4-Lite Tests

============================================================
SUCCESS: All environment checks and tests passed!
============================================================
```
