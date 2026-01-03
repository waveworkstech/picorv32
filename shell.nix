{ pkgs ? import <nixpkgs> {} }:

# ======================================
# PicoRV32 Nix Development Shell
# ======================================
# Provides:
#   - Verilog simulation/synthesis (Icarus, Verilator, Yosys, NextPNR)
#   - Formal verification (Z3, Boolector, Yices)
#   - Python3 for firmware scripts
#   - RISC-V toolchain from $HOME/riscv32
# ======================================

let
  # -------------------------------
  # Location of your home-installed RISC-V toolchain
  # -------------------------------
  riscvInstallPrefix = "${builtins.getEnv "HOME"}/riscv32_src/riscv32imc";
  toolchainPrefix = "${riscvInstallPrefix}/bin/riscv32-unknown-elf-";

in pkgs.mkShell {
  # -------------------------------
  # Packages in the shell
  # -------------------------------
  buildInputs = [
    # General tools
    pkgs.python3
    pkgs.git
    pkgs.gnumake

    # Simulation / Synthesis
    pkgs.verilog
    pkgs.verilator
    pkgs.yosys
    pkgs.symbiyosys
    pkgs.nextpnr
    pkgs.icestorm
    pkgs.arachne-pnr

    # Formal / SMT solvers
    pkgs.z3
    pkgs.boolector
    pkgs.yices

    # Libraries required for building GCC
    pkgs.gmp
    pkgs.mpfr
    pkgs.libmpc

  # Host libraries for GDB/GCC build
  pkgs.expat
  ];

  # -------------------------------
  # Environment variables & shell hooks
  # -------------------------------
  shellHook = ''
    # RISC-V toolchain
    export TOOLCHAIN_PREFIX=${toolchainPrefix}

    if command -v "$TOOLCHAIN_PREFIX"gcc >/dev/null 2>&1; then
    echo "=========================================="
    echo "Using RISC-V toolchain:"
    which "$TOOLCHAIN_PREFIX"gcc
    else
    echo "=========================================="
    echo "⚠️  RISC-V toolchain not found!"
    echo "Firmware compilation will not work."
    echo "Make sure it is installed at $HOME/riscv32"
    fi

    # Libraries for building GCC
    export GMP_DIR=${pkgs.gmp}
    export MPFR_DIR=${pkgs.mpfr}
    export MPC_DIR=${pkgs.libmpc}

    # Simulation tools
    echo "Icarus Verilog: $(which iverilog)"
    echo "Verilator: $(which verilator)"
    echo "=========================================="
    echo "PicoRV32 Nix environment ready"
  '';
}
