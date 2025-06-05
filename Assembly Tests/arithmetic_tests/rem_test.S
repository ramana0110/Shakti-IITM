#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

#Simple division involving 2 64 bit numbers
li x11, 100
li x12, 5
rem x14, x11, x12
li x11, 0
bne x11, x14, fail

#Division of 2 64 bit negative numbers
li x11, -20
li x12, -3
rem x14, x11, x12
li x11, -2
bne x11, x14, fail

#Division of a 64 bit negative number by a 64 bit positive number
li x11, -20
li x12, 3
rem x14, x11, x12
li x11, -2
bne x11, x14, fail

#Division of a 64 bit positive number by a 64 bit negaitve number
li x11, 20
li x12, -3
rem x14, x11, x12
li x11, 2
bne x11, x14, fail

#Division of 2 unsigned 64 bit numbers
li x11, -20
li x12, -3
remu x14, x12, x11
li x11, 17
bne x11, x14, fail

#Division of 2 64 bit numbers where only the lower 32 bits (sign extended) are considered 
li x11, 0xFFFFFFFFFFFFFFEF #-17
li x12, 0xFFFFFFFFFFFFFFFD #-3
remw x14, x11, x12
li x11, -2
bne x11, x14, fail

#Division of 2 64 bit numbers where only the lower 32 bits (unsigned) are considered
li x11, 0xFFFFFFFF00000011 
li x12, 0xFFFFFFFF00000002
remuw x14, x11, x12
li x11, 1
bne x11, x14, fail

RVTEST_PASS

fail:
RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END