#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

#Multiplication of 2 64 bit sign extended numbers which also produces a 64 bit result
li x11, 16
li x12, 25
mul x14, x11, x12 
li x11, 400
bne x11, x14, fail

#Multiplication of 2 64 bit sign extended numbers which produces a result greater than 64 bits
li x11, 0x2000000000A
li x12, 0x40000000000
mulh  x14, x11, x12 #Stores the higher 64 bits of the result
mul x12, x11, x12 #Stores the lower 64 bits of the result 
li x11, 0x80000
bne x11, x14, fail
li x11, 0x280000000000
bne x12, x11, fail

#Multiplication of a 64 bit sign extended number and a 64 bit unsigned number which produces a result greater than 64 bits
li x11, -5
li x12, 10
mulhsu x14, x11, x12
li x11, 0xFFFFFFFFFFFFFFFF #Since the answer is -50  the upper 32 bits would be F's
bne x11, x14, fail

#Multiplication of 2 64 bit unsigned numbers which produces a result greater than 64 bits
li x11, -5  #Unsigned value of -5 in 64 bits would be FFFFFFFFFFFFFFFB(0 extended would be considered as positive)
li x12, 10
mulhu x14, x11, x12
li x11, 9 
bne x11, x14, fail

#Multiplication of 2 64 bit numbers whose first 32 bits would be sign extended and stored as 64 bits
li x11, 0xFFFFFFFF #-1 in 32 bit sign extended
li x12, 0x2
mulw x14, x12, x11
li x11, 0xFFFFFFFFFFFFFFFE #-2 in 64 bit sign extended
bne x11, x14, fail


RVTEST_PASS

fail:
RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
