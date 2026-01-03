// ============================================================================
//  PicoRV32 Stress Test Suite
// ----------------------------------------------------------------------------
//  Author      : Farag Elsayed
//  Date        : 2026-01-02
// ----------------------------------------------------------------------------
//  Description :
//  Comprehensive bare-metal stress tests for the RISC-V CPU.
// ============================================================================

#include "firmware.h"

// FAIL Macro: Writes error code to the Fail Address
#define FAIL(code)  { *((volatile uint32_t*)OUT_FAIL_ADDR) = (code); return; }

// ----------------------------------------------------------------------------
// SYSTEM HELPER: memcpy
// ----------------------------------------------------------------------------
void *memcpy(void *dest, const void *src, size_t n) {
    uint8_t *d = (uint8_t *)dest;
    const uint8_t *s = (const uint8_t *)src;
    while (n--) *d++ = *s++;
    return dest;
}
// ----------------------------------------------------------------------------
// Test 1: Matrix Multiplication (Marked static)
// ----------------------------------------------------------------------------
#define MAT_N 4
static void test_matrix_mul(void) {
    print_str("[1/5] Running Matrix Mul... ");
    
    // GCC will use our memcpy to initialize these from Flash to Stack
    int A[MAT_N][MAT_N] = {{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 1, 2, 3}, {4, 5, 6, 7}};
    int B[MAT_N][MAT_N] = {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}}; // Identity
    int C[MAT_N][MAT_N];

    for (int i = 0; i < MAT_N; i++) {
        for (int j = 0; j < MAT_N; j++) {
            C[i][j] = 0;
            for (int k = 0; k < MAT_N; k++) {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }

    for (int i = 0; i < MAT_N; i++) {
        for (int j = 0; j < MAT_N; j++) {
            if (C[i][j] != A[i][j]) {
                print_str("FAIL\n");
                FAIL(0xDEAD0001);
            }
        }
    }
    print_str("PASS\n");
}

// ----------------------------------------------------------------------------
// Test 2: Bubble Sort (Marked static)
// ----------------------------------------------------------------------------
static void test_sort(void) {
    print_str("[2/5] Running Bubble Sort... ");
    
    int arr[10] = {90, 10, 50, 80, 20, 70, 40, 60, 30, 0};
    int n = 10;
    int temp;

    for (int i = 0; i < n-1; i++) {
        for (int j = 0; j < n-i-1; j++) {
            if (arr[j] > arr[j+1]) {
                temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
        }
    }

    for (int i = 0; i < n; i++) {
        if (arr[i] != i * 10) {
            print_str("FAIL\n");
            FAIL(0xDEAD0002);
        }
    }
    print_str("PASS\n");
}

// ----------------------------------------------------------------------------
// Test 3: Recursive Fibonacci (Marked static)
// ----------------------------------------------------------------------------
static int fib(int n) {
    if (n <= 1) return n;
    return fib(n-1) + fib(n-2);
}

static void test_fibonacci(void) {
    print_str("[3/5] Running Recursion... ");
    
    int result = fib(10); // Should be 55
    
    if (result != 55) {
        print_str("FAIL\n");
        FAIL(0xDEAD0003);
    }
    print_str("PASS\n");
}

// ----------------------------------------------------------------------------
// Test 4: CRC32 (Marked static)
// ----------------------------------------------------------------------------
static uint32_t calc_crc32(const uint8_t *data, int len) {
    uint32_t crc = 0xFFFFFFFF;
    for (int i = 0; i < len; i++) {
        crc ^= data[i];
        for (int j = 0; j < 8; j++) {
            if (crc & 1)
                crc = (crc >> 1) ^ 0xEDB88320;
            else
                crc = (crc >> 1);
        }
    }
    return ~crc;
}

static void test_crc32(void) {
    print_str("[4/5] Running CRC32... ");
    
    uint8_t msg[] = "123456789";
    uint32_t expected = 0xCBF43926;
    uint32_t result = calc_crc32(msg, 9);

    if (result != expected) {
        print_str("FAIL\n");
        FAIL(0xDEAD0004);
    }
    print_str("PASS\n");
}

// ----------------------------------------------------------------------------
// Test 5: Euclidean GCD (Marked static)
// ----------------------------------------------------------------------------
static int gcd(int a, int b) {
    while (b != 0) {
        int temp = b;
        int remainder = a;
        while (remainder >= b) {
            remainder -= b;
        }
        b = remainder;
        a = temp;
    }
    return a;
}

static void test_gcd(void) {
    print_str("[5/5] Running GCD... ");

    if (gcd(48, 18) != 6) {
        print_str("FAIL 1\n"); FAIL(0xDEAD0005);
    }
    
    if (gcd(101, 103) != 1) {
        print_str("FAIL 2\n"); FAIL(0xDEAD0005);
    }

    print_str("PASS\n");
}

// ----------------------------------------------------------------------------
// Public Entry Point
// ----------------------------------------------------------------------------
void run_stress_test(void) {
    print_str("\n--- STARTING STRESS TESTS ---\n");
    test_matrix_mul();
    test_sort();
    test_fibonacci();
    test_crc32();
    test_gcd();
    print_str("--- ALL TESTS PASSED ---\n");
}