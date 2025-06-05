#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

#Simple division involving 2 64 bit numbers(signed)
li x11, 100
li x12, 5
div x14, x11, x12
li x11, 20
bne x11, x14, fail

#Division of 2 64 bit negative numbers
li x11, -20
li x12, -3
div x14, x11, x12
li x11, 6
bne x11, x14, fail

#Division of 2 unsigned 64 bit numbers
li x11, -20
li x12, -3
divu x14, x12, x11
li x11, 1
bne x11, x14, fail

#Division of 2 64 bit numbers where only the lower 32 bits (sign extended) are considered 
li x11, 0xFFFFFFFFFFFFFFF0 #-16
li x12, 0xFFFFFFFFFFFFFFFE #-2
divw x14, x11, x12
li x11, 8
bne x11, x14, fail

#Division of 2 64 bit numbers where only the lower 32 bits (unsigned) are considered
li x11, 0xFFFFFFFF00000010 
li x12, 0xFFFFFFFF00000002
divuw x14, x11, x12
li x11, 8
bne x11, x14, fail

RVTEST_PASS

fail:
RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END