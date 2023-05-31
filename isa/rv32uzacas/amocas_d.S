# See LICENSE for license details.

#*****************************************************************************
# amocas_d.S
#-----------------------------------------------------------------------------
#
# Test amocas.d instruction for RV32.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN
        
# Successful compare. Expect swap.
TEST_CASE(2, a4, 0x80000000,            \
          li a0, 0x80000000;            \
	  li a1, 0x70000000;            \
          li a2, 0xfffff800;            \
          li a3, 0xfffff700;            \
          li a4, 0x80000000;            \
          li a5, 0x70000000;            \
          la a6, amo_operand;           \
          sw a0, 0(a6);                 \
          sw a1, 4(a6);                 \
          amocas.d a4, a2, 0(a6);       \
        )
TEST_CASE(3, a5, 0x70000000)
TEST_CASE(4, a7, 0xfffff800, lw a7, 0(a6))
TEST_CASE(5, a7, 0xfffff700, lw a7, 4(a6))

#Failed compare. No swap.
TEST_CASE(6, a4, 0x80000000,            \
          li a0, 0x80000000;            \
	  li a1, 0x70000000;            \
          li a2, 0xfffff800;            \
          li a3, 0xfffff700;            \
          li a4, 0x80000000;            \
          li a5, 0x60000000;            \
          la a6, amo_operand;           \
          sw a0, 0(a6);                 \
          sw a1, 4(a6);                 \
          amocas.d a4, a2, 0(a6);       \
        )
TEST_CASE(7, a5, 0x70000000)
TEST_CASE(8, a7, 0x80000000, lw a7, 0(a6))
TEST_CASE(9, a7, 0x70000000, lw a7, 4(a6))

# Zero RS2 means zero.
TEST_CASE(10, a4, 0x80000000,           \
          li x1, 0x1;                   \
          li a0, 0x80000000;            \
	  li a1, 0x70000000;            \
          li a4, 0x80000000;            \
          li a5, 0x70000000;            \
          la a6, amo_operand;                   \
          sw a0, 0(a6);                         \
          sw a1, 4(a6);                         \
          amocas.d a4, zero, 0(a6);             \
        )
TEST_CASE(11, a5, 0x70000000)
TEST_CASE(12, a7, 0, lw a7, 0(a6))
TEST_CASE(13, a7, 0, lw a7, 4(a6))                

# Zero RD means zero
TEST_CASE(14, x1, 1,           			\
          li x1, 1                  ;           \
          li a2, 0xfffff800;            \
          li a3, 0xfffff700;            \
          la a6, amo_operand;                   \
          sw x0, 0(a6);                       \
          sw x0, 4(a6);                       \
          amocas.d zero, a2, 0(a6);             \
        )
TEST_CASE(16, a7, 0xfffff800, lw a7, 0(a6))
TEST_CASE(17, a7, 0xfffff700, lw a7, 4(a6))

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
