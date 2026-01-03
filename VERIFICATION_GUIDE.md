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
div..OK
divu..OK
rem..OK
remu..OK
simple..OK
 1st prime is 2.
 2nd prime is 3.
 3rd prime is 5.
 4th prime is 7.
 5th prime is 11.
 6th prime is 13.
 7th prime is 17.
 8th prime is 19.
 9th prime is 23.
10th prime is 29.
11th prime is 31.
12th prime is 37.
13th prime is 41.
14th prime is 43.
15th prime is 47.
16th prime is 53.
17th prime is 59.
18th prime is 61.
19th prime is 67.
20th prime is 71.
21st prime is 73.
22nd prime is 79.
23rd prime is 83.
24th prime is 89.
25th prime is 97.
26th prime is 101.
27th prime is 103.
28th prime is 107.
29th prime is 109.
30th prime is 113.
31st prime is 127.
checksum: 1772A48F OK
input     [FFFFFFFF] 80000000 [FFFFFFFF] FFFFFFFF
hard mul   80000000  00000000  80000000  7FFFFFFF
soft mul   80000000  00000000  80000000  7FFFFFFF   OK
hard div   80000000  00000000  00000000  80000000
soft div   80000000  00000000  00000000  80000000   OK
input     [00000000] 00000000 [00000000] 00000000
hard mul   00000000  00000000  00000000  00000000
soft mul   00000000  00000000  00000000  00000000   OK
hard div   FFFFFFFF  FFFFFFFF  00000000  00000000
soft div   FFFFFFFF  FFFFFFFF  00000000  00000000   OK
input     [FFFFFFFF] 8B578493 [00000000] 00000000
hard mul   00000000  00000000  00000000  00000000
soft mul   00000000  00000000  00000000  00000000   OK
hard div   FFFFFFFF  FFFFFFFF  8B578493  8B578493
soft div   FFFFFFFF  FFFFFFFF  8B578493  8B578493   OK
input     [00000000] 6F038AFB [00000000] 00000000
hard mul   00000000  00000000  00000000  00000000
soft mul   00000000  00000000  00000000  00000000   OK
hard div   FFFFFFFF  FFFFFFFF  6F038AFB  6F038AFB
soft div   FFFFFFFF  FFFFFFFF  6F038AFB  6F038AFB   OK
input     [00000000] 1BFC9C22 [FFFFFFFF] 876B9BDE
hard mul   67CDFB7C  F2D15DD3  0ECDF9F5  0ECDF9F5
soft mul   67CDFB7C  F2D15DD3  0ECDF9F5  0ECDF9F5   OK
hard div   00000000  00000000  1BFC9C22  1BFC9C22
soft div   00000000  00000000  1BFC9C22  1BFC9C22   OK
input     [00000000] 76141B16 [00000000] 5BA2940D
hard mul   949A181E  2A4422A3  2A4422A3  2A4422A3
soft mul   949A181E  2A4422A3  2A4422A3  2A4422A3   OK
hard div   00000001  00000001  1A718709  1A718709
soft div   00000001  00000001  1A718709  1A718709   OK
input     [00000000] 2D45231C [FFFFFFFF] ADFA166F
hard mul   C756A124  F17ECF19  1EC3F235  1EC3F235
soft mul   C756A124  F17ECF19  1EC3F235  1EC3F235   OK
hard div   00000000  00000000  2D45231C  2D45231C
soft div   00000000  00000000  2D45231C  2D45231C   OK
input     [00000000] 09C7BF74 [00000000] 3B014C60
hard mul   73323B80  024115D2  024115D2  024115D2
soft mul   73323B80  024115D2  024115D2  024115D2   OK
hard div   00000000  00000000  09C7BF74  09C7BF74
soft div   00000000  00000000  09C7BF74  09C7BF74   OK
input     [00000000] 4325E1E6 [00000000] 1C32932A
hard mul   0BDA21BC  076568B5  076568B5  076568B5
soft mul   0BDA21BC  076568B5  076568B5  076568B5   OK
hard div   00000002  00000002  0AC0BB92  0AC0BB92
soft div   00000002  00000002  0AC0BB92  0AC0BB92   OK
input     [FFFFFFFF] 84A97421 [FFFFFFFF] EF8D27D7
hard mul   002E8EB7  07ECBD6D  8C96318E  7C235965
soft mul   002E8EB7  07ECBD6D  8C96318E  7C235965   OK
hard div   00000007  00000000  F7CD5D40  84A97421
soft div   00000007  00000000  F7CD5D40  84A97421   OK
input     [00000000] 258BAFEC [00000000] 5EB6FD37
hard mul   D7A707B4  0DE4210A  0DE4210A  0DE4210A
soft mul   D7A707B4  0DE4210A  0DE4210A  0DE4210A   OK
hard div   00000000  00000000  258BAFEC  258BAFEC
soft div   00000000  00000000  258BAFEC  258BAFEC   OK
input     [FFFFFFFF] A31BEA5F [00000000] 145CCB97
hard mul   FE749309  F89C8277  F89C8277  0CF94E0E
soft mul   FE749309  F89C8277  F89C8277  0CF94E0E   OK
hard div   FFFFFFFC  00000008  F48F18BB  00358DA7
soft div   FFFFFFFC  00000008  F48F18BB  00358DA7   OK
input     [00000000] 28E3CD00 [00000000] 793F5181
hard mul   21A74D00  135DC8F9  135DC8F9  135DC8F9
soft mul   21A74D00  135DC8F9  135DC8F9  135DC8F9   OK
hard div   00000000  00000000  28E3CD00  28E3CD00
soft div   00000000  00000000  28E3CD00  28E3CD00   OK
input     [FFFFFFFF] F2E838C6 [00000000] 4BE0C5FE
hard mul   6558B274  FC1E89B3  FC1E89B3  47FF4FB1
soft mul   6558B274  FC1E89B3  FC1E89B3  47FF4FB1   OK
hard div   00000000  00000003  F2E838C6  0F45E6CC
soft div   00000000  00000003  F2E838C6  0F45E6CC   OK
input     [00000000] 38BAA671 [FFFFFFFF] E2E2B92B
hard mul   1B639DFB  F98C5E4E  324704BF  324704BF
soft mul   1B639DFB  F98C5E4E  324704BF  324704BF   OK
hard div   FFFFFFFF  00000000  1B9D5F9C  38BAA671
soft div   FFFFFFFF  00000000  1B9D5F9C  38BAA671   OK
Cycle counter ......... 434900
Instruction counter .... 90146
CPI: 4.82

--- STARTING STRESS TESTS ---
[1/5] Running Matrix Mul... PASS
[2/5] Running Bubble Sort... PASS
[3/5] Running Recursion... PASS
[4/5] Running CRC32... PASS
[5/5] Running GCD... PASS
--- ALL TESTS PASSED ---
DONE

------------------------------------------------------------
EBREAK instruction at 0x0000077C
pc  0000077F    x8  00012340    x16 00000000    x24 00000000
x1  0000074C    x9  00000004    x17 E2E2B92B    x25 00000000
x2  00020000    x10 20000000    x18 00000000    x26 00000000
x3  DEADBEEF    x11 075BCD15    x19 00003F60    x27 00000000
x4  DEADBEEF    x12 0000004F    x20 00000000    x28 00000020
x5  000010C0    x13 0000004E    x21 00000000    x29 00000001
x6  00000000    x14 00000045    x22 00000000    x30 00000000
x7  00000000    x15 0000000A    x23 00000000    x31 00000000
------------------------------------------------------------
Number of fast external IRQs counted: 58
Number of slow external IRQs counted: 7
Number of timer IRQs counted: 22
TRAP after 509265 clock cycles
ALL TESTS PASSED.
testbench.v:266: $finish called at 5093750000 (1ps)
   [PASSED] make test (Icarus)

------------------------------------------------------------
Test 3: Main Firmware Test (Verilator)
Summary: Validates compatibility with Verilator.
------------------------------------------------------------
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
div..OK
divu..OK
rem..OK
remu..OK
simple..OK
 1st prime is 2.
 2nd prime is 3.
 3rd prime is 5.
 4th prime is 7.
 5th prime is 11.
 6th prime is 13.
 7th prime is 17.
 8th prime is 19.
 9th prime is 23.
10th prime is 29.
11th prime is 31.
12th prime is 37.
13th prime is 41.
14th prime is 43.
15th prime is 47.
16th prime is 53.
17th prime is 59.
18th prime is 61.
19th prime is 67.
20th prime is 71.
21st prime is 73.
22nd prime is 79.
23rd prime is 83.
24th prime is 89.
25th prime is 97.
26th prime is 101.
27th prime is 103.
28th prime is 107.
29th prime is 109.
30th prime is 113.
31st prime is 127.
checksum: 1772A48F OK
input     [FFFFFFFF] 80000000 [FFFFFFFF] FFFFFFFF
hard mul   80000000  00000000  80000000  7FFFFFFF
soft mul   80000000  00000000  80000000  7FFFFFFF   OK
hard div   80000000  00000000  00000000  80000000
soft div   80000000  00000000  00000000  80000000   OK
input     [00000000] 00000000 [00000000] 00000000
hard mul   00000000  00000000  00000000  00000000
soft mul   00000000  00000000  00000000  00000000   OK
hard div   FFFFFFFF  FFFFFFFF  00000000  00000000
soft div   FFFFFFFF  FFFFFFFF  00000000  00000000   OK
input     [FFFFFFFF] 8B578493 [00000000] 00000000
hard mul   00000000  00000000  00000000  00000000
soft mul   00000000  00000000  00000000  00000000   OK
hard div   FFFFFFFF  FFFFFFFF  8B578493  8B578493
soft div   FFFFFFFF  FFFFFFFF  8B578493  8B578493   OK
input     [00000000] 6F038AFB [00000000] 00000000
hard mul   00000000  00000000  00000000  00000000
soft mul   00000000  00000000  00000000  00000000   OK
hard div   FFFFFFFF  FFFFFFFF  6F038AFB  6F038AFB
soft div   FFFFFFFF  FFFFFFFF  6F038AFB  6F038AFB   OK
input     [00000000] 1BFC9C22 [FFFFFFFF] 876B9BDE
hard mul   67CDFB7C  F2D15DD3  0ECDF9F5  0ECDF9F5
soft mul   67CDFB7C  F2D15DD3  0ECDF9F5  0ECDF9F5   OK
hard div   00000000  00000000  1BFC9C22  1BFC9C22
soft div   00000000  00000000  1BFC9C22  1BFC9C22   OK
input     [00000000] 76141B16 [00000000] 5BA2940D
hard mul   949A181E  2A4422A3  2A4422A3  2A4422A3
soft mul   949A181E  2A4422A3  2A4422A3  2A4422A3   OK
hard div   00000001  00000001  1A718709  1A718709
soft div   00000001  00000001  1A718709  1A718709   OK
input     [00000000] 2D45231C [FFFFFFFF] ADFA166F
hard mul   C756A124  F17ECF19  1EC3F235  1EC3F235
soft mul   C756A124  F17ECF19  1EC3F235  1EC3F235   OK
hard div   00000000  00000000  2D45231C  2D45231C
soft div   00000000  00000000  2D45231C  2D45231C   OK
input     [00000000] 09C7BF74 [00000000] 3B014C60
hard mul   73323B80  024115D2  024115D2  024115D2
soft mul   73323B80  024115D2  024115D2  024115D2   OK
hard div   00000000  00000000  09C7BF74  09C7BF74
soft div   00000000  00000000  09C7BF74  09C7BF74   OK
input     [00000000] 4325E1E6 [00000000] 1C32932A
hard mul   0BDA21BC  076568B5  076568B5  076568B5
soft mul   0BDA21BC  076568B5  076568B5  076568B5   OK
hard div   00000002  00000002  0AC0BB92  0AC0BB92
soft div   00000002  00000002  0AC0BB92  0AC0BB92   OK
input     [FFFFFFFF] 84A97421 [FFFFFFFF] EF8D27D7
hard mul   002E8EB7  07ECBD6D  8C96318E  7C235965
soft mul   002E8EB7  07ECBD6D  8C96318E  7C235965   OK
hard div   00000007  00000000  F7CD5D40  84A97421
soft div   00000007  00000000  F7CD5D40  84A97421   OK
input     [00000000] 258BAFEC [00000000] 5EB6FD37
hard mul   D7A707B4  0DE4210A  0DE4210A  0DE4210A
soft mul   D7A707B4  0DE4210A  0DE4210A  0DE4210A   OK
hard div   00000000  00000000  258BAFEC  258BAFEC
soft div   00000000  00000000  258BAFEC  258BAFEC   OK
input     [FFFFFFFF] A31BEA5F [00000000] 145CCB97
hard mul   FE749309  F89C8277  F89C8277  0CF94E0E
soft mul   FE749309  F89C8277  F89C8277  0CF94E0E   OK
hard div   FFFFFFFC  00000008  F48F18BB  00358DA7
soft div   FFFFFFFC  00000008  F48F18BB  00358DA7   OK
input     [00000000] 28E3CD00 [00000000] 793F5181
hard mul   21A74D00  135DC8F9  135DC8F9  135DC8F9
soft mul   21A74D00  135DC8F9  135DC8F9  135DC8F9   OK
hard div   00000000  00000000  28E3CD00  28E3CD00
soft div   00000000  00000000  28E3CD00  28E3CD00   OK
input     [FFFFFFFF] F2E838C6 [00000000] 4BE0C5FE
hard mul   6558B274  FC1E89B3  FC1E89B3  47FF4FB1
soft mul   6558B274  FC1E89B3  FC1E89B3  47FF4FB1   OK
hard div   00000000  00000003  F2E838C6  0F45E6CC
soft div   00000000  00000003  F2E838C6  0F45E6CC   OK
input     [00000000] 38BAA671 [FFFFFFFF] E2E2B92B
hard mul   1B639DFB  F98C5E4E  324704BF  324704BF
soft mul   1B639DFB  F98C5E4E  324704BF  324704BF   OK
hard div   FFFFFFFF  00000000  1B9D5F9C  38BAA671
soft div   FFFFFFFF  00000000  1B9D5F9C  38BAA671   OK
Cycle counter ......... 434900
Instruction counter .... 90146
CPI: 4.82

--- STARTING STRESS TESTS ---
[1/5] Running Matrix Mul... PASS
[2/5] Running Bubble Sort... PASS
[3/5] Running Recursion... PASS
[4/5] Running CRC32... PASS
[5/5] Running GCD... PASS
--- ALL TESTS PASSED ---
DONE

------------------------------------------------------------
EBREAK instruction at 0x0000077C
pc  0000077F    x8  00012340    x16 00000000    x24 00000000
x1  0000074C    x9  00000004    x17 E2E2B92B    x25 00000000
x2  00020000    x10 20000000    x18 00000000    x26 00000000
x3  DEADBEEF    x11 075BCD15    x19 00003F60    x27 00000000
x4  DEADBEEF    x12 0000004F    x20 00000000    x28 00000020
x5  000010C0    x13 0000004E    x21 00000000    x29 00000001
x6  00000000    x14 00000045    x22 00000000    x30 00000000
x7  00000000    x15 0000000A    x23 00000000    x31 00000000
------------------------------------------------------------
Number of fast external IRQs counted: 58
Number of slow external IRQs counted: 7
Number of timer IRQs counted: 22
TRAP after 509264 clock cycles
ALL TESTS PASSED.
- testbench.v:266: Verilog $finish
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
div..OK
divu..OK
rem..OK
remu..OK
simple..OK
 1st prime is 2.
 2nd prime is 3.
 3rd prime is 5.
 4th prime is 7.
 5th prime is 11.
 6th prime is 13.
 7th prime is 17.
 8th prime is 19.
 9th prime is 23.
10th prime is 29.
11th prime is 31.
12th prime is 37.
13th prime is 41.
14th prime is 43.
15th prime is 47.
16th prime is 53.
17th prime is 59.
18th prime is 61.
19th prime is 67.
20th prime is 71.
21st prime is 73.
22nd prime is 79.
23rd prime is 83.
24th prime is 89.
25th prime is 97.
26th prime is 101.
27th prime is 103.
28th prime is 107.
29th prime is 109.
30th prime is 113.
31st prime is 127.
checksum: 1772A48F OK
input     [FFFFFFFF] 80000000 [FFFFFFFF] FFFFFFFF
hard mul   80000000  00000000  80000000  7FFFFFFF
soft mul   80000000  00000000  80000000  7FFFFFFF   OK
hard div   80000000  00000000  00000000  80000000
soft div   80000000  00000000  00000000  80000000   OK
input     [00000000] 00000000 [00000000] 00000000
hard mul   00000000  00000000  00000000  00000000
soft mul   00000000  00000000  00000000  00000000   OK
hard div   FFFFFFFF  FFFFFFFF  00000000  00000000
soft div   FFFFFFFF  FFFFFFFF  00000000  00000000   OK
input     [FFFFFFFF] 8B578493 [00000000] 00000000
hard mul   00000000  00000000  00000000  00000000
soft mul   00000000  00000000  00000000  00000000   OK
hard div   FFFFFFFF  FFFFFFFF  8B578493  8B578493
soft div   FFFFFFFF  FFFFFFFF  8B578493  8B578493   OK
input     [00000000] 6F038AFB [00000000] 00000000
hard mul   00000000  00000000  00000000  00000000
soft mul   00000000  00000000  00000000  00000000   OK
hard div   FFFFFFFF  FFFFFFFF  6F038AFB  6F038AFB
soft div   FFFFFFFF  FFFFFFFF  6F038AFB  6F038AFB   OK
input     [00000000] 1BFC9C22 [FFFFFFFF] 876B9BDE
hard mul   67CDFB7C  F2D15DD3  0ECDF9F5  0ECDF9F5
soft mul   67CDFB7C  F2D15DD3  0ECDF9F5  0ECDF9F5   OK
hard div   00000000  00000000  1BFC9C22  1BFC9C22
soft div   00000000  00000000  1BFC9C22  1BFC9C22   OK
input     [00000000] 76141B16 [00000000] 5BA2940D
hard mul   949A181E  2A4422A3  2A4422A3  2A4422A3
soft mul   949A181E  2A4422A3  2A4422A3  2A4422A3   OK
hard div   00000001  00000001  1A718709  1A718709
soft div   00000001  00000001  1A718709  1A718709   OK
input     [00000000] 2D45231C [FFFFFFFF] ADFA166F
hard mul   C756A124  F17ECF19  1EC3F235  1EC3F235
soft mul   C756A124  F17ECF19  1EC3F235  1EC3F235   OK
hard div   00000000  00000000  2D45231C  2D45231C
soft div   00000000  00000000  2D45231C  2D45231C   OK
input     [00000000] 09C7BF74 [00000000] 3B014C60
hard mul   73323B80  024115D2  024115D2  024115D2
soft mul   73323B80  024115D2  024115D2  024115D2   OK
hard div   00000000  00000000  09C7BF74  09C7BF74
soft div   00000000  00000000  09C7BF74  09C7BF74   OK
input     [00000000] 4325E1E6 [00000000] 1C32932A
hard mul   0BDA21BC  076568B5  076568B5  076568B5
soft mul   0BDA21BC  076568B5  076568B5  076568B5   OK
hard div   00000002  00000002  0AC0BB92  0AC0BB92
soft div   00000002  00000002  0AC0BB92  0AC0BB92   OK
input     [FFFFFFFF] 84A97421 [FFFFFFFF] EF8D27D7
hard mul   002E8EB7  07ECBD6D  8C96318E  7C235965
soft mul   002E8EB7  07ECBD6D  8C96318E  7C235965   OK
hard div   00000007  00000000  F7CD5D40  84A97421
soft div   00000007  00000000  F7CD5D40  84A97421   OK
input     [00000000] 258BAFEC [00000000] 5EB6FD37
hard mul   D7A707B4  0DE4210A  0DE4210A  0DE4210A
soft mul   D7A707B4  0DE4210A  0DE4210A  0DE4210A   OK
hard div   00000000  00000000  258BAFEC  258BAFEC
soft div   00000000  00000000  258BAFEC  258BAFEC   OK
input     [FFFFFFFF] A31BEA5F [00000000] 145CCB97
hard mul   FE749309  F89C8277  F89C8277  0CF94E0E
soft mul   FE749309  F89C8277  F89C8277  0CF94E0E   OK
hard div   FFFFFFFC  00000008  F48F18BB  00358DA7
soft div   FFFFFFFC  00000008  F48F18BB  00358DA7   OK
input     [00000000] 28E3CD00 [00000000] 793F5181
hard mul   21A74D00  135DC8F9  135DC8F9  135DC8F9
soft mul   21A74D00  135DC8F9  135DC8F9  135DC8F9   OK
hard div   00000000  00000000  28E3CD00  28E3CD00
soft div   00000000  00000000  28E3CD00  28E3CD00   OK
input     [FFFFFFFF] F2E838C6 [00000000] 4BE0C5FE
hard mul   6558B274  FC1E89B3  FC1E89B3  47FF4FB1
soft mul   6558B274  FC1E89B3  FC1E89B3  47FF4FB1   OK
hard div   00000000  00000003  F2E838C6  0F45E6CC
soft div   00000000  00000003  F2E838C6  0F45E6CC   OK
input     [00000000] 38BAA671 [FFFFFFFF] E2E2B92B
hard mul   1B639DFB  F98C5E4E  324704BF  324704BF
soft mul   1B639DFB  F98C5E4E  324704BF  324704BF   OK
hard div   FFFFFFFF  00000000  1B9D5F9C  38BAA671
soft div   FFFFFFFF  00000000  1B9D5F9C  38BAA671   OK
Cycle counter ......... 597057
Instruction counter .... 94286
CPI: 6.33

--- STARTING STRESS TESTS ---
[1/5] Running Matrix Mul... PASS
[2/5] Running Bubble Sort... PASS
[3/5] Running Recursion... PASS
[4/5] Running CRC32... PASS
[5/5] Running GCD... PASS
--- ALL TESTS PASSED ---
DONE

------------------------------------------------------------
EBREAK instruction at 0x0000077C
pc  0000077F    x8  00012340    x16 00000000    x24 00000000
x1  0000074C    x9  00000004    x17 E2E2B92B    x25 00000000
x2  00020000    x10 20000000    x18 00000000    x26 00000000
x3  DEADBEEF    x11 075BCD15    x19 00003F60    x27 00000000
x4  DEADBEEF    x12 0000004F    x20 00000000    x28 00000020
x5  000010C0    x13 0000004E    x21 00000000    x29 00000001
x6  00000000    x14 00000045    x22 00000000    x30 00000000
x7  00000000    x15 0000000A    x23 00000000    x31 00000000
------------------------------------------------------------
Number of fast external IRQs counted: 80
Number of slow external IRQs counted: 10
Number of timer IRQs counted: 35
TRAP after 699785 clock cycles
ALL TESTS PASSED.
testbench.v:266: $finish called at 6998950000 (1ps)
   [PASSED] AXI4-Lite Tests

------------------------------------------------------------
Test 5: Dhrystone Benchmark
Summary: Executes standard integer performance benchmark.
------------------------------------------------------------
vvp -N testbench.vvp
VCD info: dumpfile testbench.vcd opened for output.
TRAP
testbench.v:112: $finish called at 1490000 (1ps)
   [PASSED] Dhrystone Benchmark

------------------------------------------------------------
Test 6: C++ Runtime Demo
Summary: Verifies STL, virtual functions, and C++ runtime.
------------------------------------------------------------
vvp -N testbench.vvp
TRAP
testbench.v:111: $finish called at 149670000 (1ps)
   [PASSED] C++ Runtime Demo

============================================================
SUCCESS: All environment checks and tests passed!
============================================================

```
