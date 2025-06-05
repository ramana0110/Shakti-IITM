#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

.align 2
.option norvc

csrr t1, mtvec  // saving the previous value of the mtvec reg
la t0, exception_handler 
csrw mtvec, t0 
li t0, MSTATUS_MPP  // loading the mpp bit mask to t0
csrc mstatus, t0   // clearing the mpp bits of mstatus (user mode)
la t0, user_mode
csrw mepc, t0
mret  // switches to user mode
csrw mtvec, t1
RVTEST_FAIL

exception_handler:
csrw mtvec, t1  // Illegal instruction (Trying to access mtvec in user mode)
RVTEST_PASS

user_mode:
csrw mepc,t0


RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
