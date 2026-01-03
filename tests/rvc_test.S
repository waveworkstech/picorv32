// ============================================================================
//  PicoRV32 Stress Test Suite
// ----------------------------------------------------------------------------
//  Author      : Farag Elsayed
//  Date        : 2026-01-02
// ----------------------------------------------------------------------------
//  Description :
//  Dedicated Compressed (RVC) Test to verify the CPU's 'C' extension.
//  
//  NOTE: This file is inherited and adapted from the official RISC-V Test 
//  Suite (riscv-tests/isa/rv64uc/rvc.S). It has been modified to run 
//  within the PicoRV32 bare-metal environment (RV32IMC).
// ============================================================================

#define TEST_FUNC_NAME rvc_test
#define TEST_FUNC_TXT "rvc_test"
#define TEST_FUNC_RET rvc_test_ret

#include "riscv_test.h"

// -----------------------------------------------------------------------------
// MACRO: RVC_TEST_CASE
// Arguments:
//   n: Test Number
//   r: Register to test
//   v: Expected Value
//   code: Instruction sequence to execute
// -----------------------------------------------------------------------------
#define RVC_TEST_CASE(n, r, v, code...) \
    li TESTNUM, n; \
    .option push; \
    .option rvc; \
    code; \
    .option pop; \
    li x29, v; \
    bne r, x29, fail;

RVTEST_CODE_BEGIN

    // ----------------------------------------------------------------
    // Test 2: Fetch across page boundary
    // ----------------------------------------------------------------
    li TESTNUM, 2
    li a1, 666
    j 1f
    .align 3
data_boundary: 
    .word 0x98765432
    .word 0xfedcba98
    .align 12
    .skip 4094
1: 
    addi a1, a1, 1
    li x29, 667
    bne a1, x29, fail

    // ----------------------------------------------------------------
    // Test 3-5: Stack Pointer Adjustments (c.addi4spn, c.addi16sp)
    // ----------------------------------------------------------------
    li sp, 0x1234
    RVC_TEST_CASE(3, a0, 0x1234 + 1020, c.addi4spn a0, sp, 1020)
    RVC_TEST_CASE(4, sp, 0x1234 + 496,  c.addi16sp sp, 496)
    RVC_TEST_CASE(5, sp, 0x1234 + 496 - 512, c.addi16sp sp, -512)

    // ----------------------------------------------------------------
    // Test 6: Loads and Stores (c.lw, c.sw)
    // ----------------------------------------------------------------
    la a1, data_block
    RVC_TEST_CASE(6, a2, 0xfffffedc, \
        c.lw a0, 12(a1); \
        addi a0, a0, 1; \
        c.sw a0, 12(a1); \
        c.lw a2, 12(a1) \
    )

    // ----------------------------------------------------------------
    // Test 8-9: Immediates (c.addi, c.li)
    // ----------------------------------------------------------------
    RVC_TEST_CASE(8, a0, -15, ori a0, x0, 1; c.addi a0, -16)
    RVC_TEST_CASE(9, a5, -16, ori a5, x0, 1; c.li a5, -16)

    // ----------------------------------------------------------------
    // Test 11-12: UI/Shift (c.lui, c.srai, c.srli)
    // ----------------------------------------------------------------
    // 32-bit specific logic
    RVC_TEST_CASE(11, s0, 0xffffffe1, c.lui s0, 0xfffe1; c.srai s0, 12)
    RVC_TEST_CASE(12, s0, 0x000fffe1, c.lui s0, 0xfffe1; c.srli s0, 12)

    // ----------------------------------------------------------------
    // Test 14-21: Logical Ops (c.andi, c.sub, c.xor, c.or, c.and, c.slli)
    // ----------------------------------------------------------------
    RVC_TEST_CASE(14, s0, ~0x11, c.li s0, -2; c.andi s0, ~0x10)
    RVC_TEST_CASE(15, s1, 14, li s1, 20; li a0, 6; c.sub s1, a0)
    RVC_TEST_CASE(16, s1, 18, li s1, 20; li a0, 6; c.xor s1, a0)
    RVC_TEST_CASE(17, s1, 22, li s1, 20; li a0, 6; c.or s1, a0)
    RVC_TEST_CASE(18, s1,  4, li s1, 20; li a0, 6; c.and s1, a0)
    RVC_TEST_CASE(21, s0, 0x12340, li s0, 0x1234; c.slli s0, 4)

    // ----------------------------------------------------------------
    // Test 30: Jumps (c.j)
    // ----------------------------------------------------------------
    RVC_TEST_CASE(30, ra, 0, \
        li ra, 0; \
        c.j 1f; \
        c.j 2f; \
      1:c.j 1f; \
      2:j fail; \
      1: \
    )

    // ----------------------------------------------------------------
    // Test 31-34: Branches (c.beqz, c.bnez)
    // ----------------------------------------------------------------
    RVC_TEST_CASE(31, x0, 0, \
        li a0, 0; \
        c.beqz a0, 1f; \
        c.j 2f; \
      1:c.j 1f; \
      2:j fail; \
      1: \
    )

    RVC_TEST_CASE(32, x0, 0, \
        li a0, 1; \
        c.bnez a0, 1f; \
        c.j 2f; \
      1:c.j 1f; \
      2:j fail; \
      1: \
    )

    RVC_TEST_CASE(33, x0, 0, \
        li a0, 1; \
        c.beqz a0, 1f; \
        c.j 2f; \
      1:c.j fail; \
      2: \
    )

    RVC_TEST_CASE(34, x0, 0, \
        li a0, 0; \
        c.bnez a0, 1f; \
        c.j 2f; \
      1:c.j fail; \
      2: \
    )

    // ----------------------------------------------------------------
    // Test 35-37: Jump Register (c.jr, c.jalr, c.jal)
    // ----------------------------------------------------------------
    RVC_TEST_CASE(35, ra, 0, \
        la t0, 1f; \
        li ra, 0; \
        c.jr t0; \
        c.j 2f; \
      1:c.j 1f; \
      2:j fail; \
      1: \
    )

    RVC_TEST_CASE(36, ra, -2, \
        la t0, 1f; \
        li ra, 0; \
        c.jalr t0; \
        c.j 2f; \
      1:c.j 1f; \
      2:j fail; \
      1:sub ra, ra, t0 \
    )

    // RV32 Only: c.jal
    RVC_TEST_CASE(37, ra, -2, \
        la t0, 1f; \
        li ra, 0; \
        c.jal 1f; \
        c.j 2f; \
      1:c.j 1f; \
      2:j fail; \
      1:sub ra, ra, t0 \
    )

    // ----------------------------------------------------------------
    // Test 40: Stack Pointer Loads (c.lwsp, c.swsp)
    // ----------------------------------------------------------------
    la sp, data_block
    RVC_TEST_CASE(40, a2, 0xfffffedd, \
        c.lwsp a0, 12(sp); \
        addi a0, a0, 1; \
        c.swsp a0, 12(sp); \
        c.lwsp a2, 12(sp) \
    )

    // ----------------------------------------------------------------
    // Test 42: Move (c.mv)
    // ----------------------------------------------------------------
    RVC_TEST_CASE(42, t0, 0x246, li a0, 0x123; c.mv t0, a0; c.add t0, a0)

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

    .data
    .align 4
data_block:
    .word 0xabcdef01
    .word 0x12345678
    .word 0xdeadbeef
    .word 0xfffffedb  // Initial value for test 6/40 (offset logic)
    .word 0x00000000
