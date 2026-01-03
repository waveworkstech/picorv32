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
