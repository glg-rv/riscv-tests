# See LICENSE for license details.

#*****************************************************************************
# amocas_q.S
#-----------------------------------------------------------------------------
#
# Test amocas.q instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

# Successful compare. Expect swap.
TEST_CASE(2, a4, 0xffffffff80000000,            \
          li a0, 0xffffffff80000000;            \
	  li a1, 0xffffffff70000000;            \
          li a2, 0xfffffffffffff800;            \
          li a3, 0xfffffffffffff700;            \
          li a4, 0xffffffff80000000;            \
          li a5, 0xffffffff70000000;            \
          la a6, amo_operand;                   \
          sd a0, 0(a6);                         \
          sd a1, 8(a6);                         \
          amocas.q a4, a2, 0(a6);               \
        )
TEST_CASE(3, a5, 0xffffffff70000000)
TEST_CASE(4, a7, 0xfffffffffffff800, ld a7, 0(a6))
TEST_CASE(5, a7, 0xfffffffffffff700, ld a7, 8(a6))

#Failed compare. No swap.
TEST_CASE(6, a4, 0xffffffff80000000,            \
          li a0, 0xffffffff80000000;            \
	  li a1, 0xffffffff70000000;            \
          li a2, 0xfffffffffffff800;            \
          li a3, 0xfffffffffffff700;            \
          li a4, 0xffffffff80000000;            \
          li a5, 0xffffffff60000000;            \
          la a6, amo_operand;                   \
          sd a0, 0(a6);                         \
          sd a1, 8(a6);                         \
          amocas.q a4, a2, 0(a6);               \
        )
TEST_CASE(7, a5, 0xffffffff70000000)
TEST_CASE(8, a7, 0xffffffff80000000, ld a7, 0(a6))
TEST_CASE(9, a7, 0xffffffff70000000, ld a7, 8(a6))

# Zero RS2 means zero.
TEST_CASE(10, a4, 0xffffffff80000000,           \
          li x1, 1;                             \
          li a0, 0xffffffff80000000;            \
	  li a1, 0xffffffff70000000;            \
          li a4, 0xffffffff80000000;            \
          li a5, 0xffffffff70000000;            \
          la a6, amo_operand;                   \
          sd a0, 0(a6);                         \
          sd a1, 8(a6);                         \
          amocas.q a4, zero, 0(a6);             \
        )
TEST_CASE(11, a5, 0xffffffff70000000)
TEST_CASE(12, a7, 0, ld a7, 0(a6))
TEST_CASE(13, a7, 0, ld a7, 8(a6))

# Zero RD means zero
TEST_CASE(14, x1, 1,           			\
          li x1, 1                  ;           \
          li a2, 0xfffffffffffff800;            \
          li a3, 0xfffffffffffff700;            \
          la a6, amo_operand;                   \
          sd x0, 0(a6);                       \
          sd x0, 8(a6);                       \
          amocas.q zero, a2, 0(a6);             \
        )
TEST_CASE(16, a7, 0xfffffffffffff800, ld a7, 0(a6))
TEST_CASE(17, a7, 0xfffffffffffff700, ld a7, 8(a6))

TEST_PASSFAIL

RVTEST_CODE_END

        .data
RVTEST_DATA_BEGIN

        TEST_DATA

RVTEST_DATA_END

        .bss
        .align 3
amo_operand:
        .dword 0
        .dword 0
