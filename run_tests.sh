#!/bin/bash
# ============================================================================
#  PicoRV32 Test Runner
# ----------------------------------------------------------------------------
#  Author      : Farag Elsayed
#  Date        : 2026-01-03
# ----------------------------------------------------------------------------
#  Description :
#  Executes the PicoRV32 test suite. Includes environment verification to 
#  ensure Nix tools and RISC-V toolchains are present before execution.
# ============================================================================

set -e  # Exit immediately if any command fails

echo "============================================================"
echo "      PicoRV32 Stress Test Suite - Environment Check"
echo "============================================================"

# 1. Verify Simulation Tools Existence
# These should be provided by the Nix shell defined in shell.nix
MISSING_TOOLS=0
for tool in iverilog verilator vvp; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "❌ Error: Required tool '$tool' not found in PATH."
        MISSING_TOOLS=1
    else
        echo "✅ Found $tool: $(which $tool)"
    fi
done

if [ $MISSING_TOOLS -ne 0 ]; then
    echo "Hint: Ensure you have loaded the environment via 'nix-shell' or you have tools installed locally."
    exit 1
fi

# 2. Verify RISC-V Toolchain
# Uses the prefix defined in the Makefile or shell hook
PREFIX="${TOOLCHAIN_PREFIX:-riscv32-unknown-elf-}"
echo "Using Toolchain Prefix: $PREFIX"

if ! command -v "${PREFIX}gcc" >/dev/null 2>&1; then
    echo "❌ Error: RISC-V compiler '${PREFIX}gcc' not found."
    echo "   Ensure you installed RISCV Toolchain correctly"
    exit 1
else
    echo "✅ Found RISC-V Toolchain: $(which "${PREFIX}gcc")"
fi

echo "Environment verification complete. Starting tests..."
echo ""

# ---------------------------------------------------------
# 1. Basic & Self-Contained Tests
# ---------------------------------------------------------
echo "------------------------------------------------------------"
echo "Test 1: EZ Test (test_ez)"
echo "Summary: Verifies basic CPU bring-up and simple instruction fetch."
echo "------------------------------------------------------------"
make test_ez
echo "   [PASSED] test_ez"
echo ""

# ---------------------------------------------------------
# 2. Main Firmware Tests
# ---------------------------------------------------------
echo "------------------------------------------------------------"
echo "Test 2: Main Firmware Test (Icarus Verilog)"
echo "Summary: Runs full suite including ISA tests and stress tests."
echo "------------------------------------------------------------"
make test TOOLCHAIN_PREFIX="$PREFIX"
echo "   [PASSED] make test (Icarus)"
echo ""

echo "------------------------------------------------------------"
echo "Test 3: Main Firmware Test (Verilator)"
echo "Summary: Validates compatibility with Verilator."
echo "------------------------------------------------------------"
make test_verilator
echo "   [PASSED] make test_verilator"
echo ""

# ---------------------------------------------------------
# 3. Bus Interface Tests (AXI only)
# ---------------------------------------------------------
echo "------------------------------------------------------------"
echo "Test 4: AXI4-Lite Interface Tests"
echo "Summary: Checks memory read/write correctness over AXI."
echo "------------------------------------------------------------"
make test_axi TOOLCHAIN_PREFIX="$PREFIX"
echo "   [PASSED] AXI4-Lite Tests"
echo ""

# ---------------------------------------------------------
# 4. Benchmarks (DISABLED for RV32E)
# ---------------------------------------------------------
# echo "------------------------------------------------------------"
# echo "Test 5: Dhrystone Benchmark"
# echo "Summary: Executes standard integer performance benchmark."
# echo "------------------------------------------------------------"
# cd dhrystone
# make test TOOLCHAIN_PREFIX="$PREFIX"
# cd ..
# echo "   [PASSED] Dhrystone Benchmark"
# echo ""

# ---------------------------------------------------------
# 5. Language Runtime Tests (DISABLED for RV32E)
# ---------------------------------------------------------
# echo "------------------------------------------------------------"
# echo "Test 6: C++ Runtime Demo"
# echo "Summary: Verifies STL, virtual functions, and C++ runtime."
# echo "------------------------------------------------------------"
# cd scripts/cxxdemo
# make test RISCV_TOOLS_PREFIX="$PREFIX"
# cd ../..
# echo "   [PASSED] C++ Runtime Demo"
# echo ""

echo "============================================================"
echo "SUCCESS: All environment checks and tests passed!"
echo "============================================================"