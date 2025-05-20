#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

.align 2
.option norvc

csrr t1, mtvec //storing the previous value of mtvec in a register
la t0, exception_handler
csrw mtvec, t0
.word 0xFFFF // this is an illegal opcode 
csrw mtvec, t1
RVTEST_FAIL

exception_handler:
csrw mtvec, t1 //restoring mtvec
RVTEST_PASS


RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
