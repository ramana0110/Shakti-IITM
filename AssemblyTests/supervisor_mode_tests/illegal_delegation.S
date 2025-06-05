#include "test_macros.h"
#include "riscv_test.h"
RVTEST_RV64M
RVTEST_CODE_BEGIN

.align 2
.option norvc

#Machine mode to Supervisor mode

li t0, MSTATUS_MPP  // loading the mpp bit mask to t0
csrc mstatus, t0   // clearing the mpp bits of mstatus 
li t0, 0x800  // bit to be set for supervisor mode
csrs mstatus, t0
li t0, 0x4  
csrs medeleg, t0  //delegating illegal opcode exception to supervisor mode
la t0, supervisor_mode
csrw mepc, t0
mret  // switches to supervisor mode
RVTEST_FAIL


supervisor_mode:
la t0, exception_handler
csrw stvec, t0
.word 0xFFFF
RVTEST_FAIL

exception_handler:
RVTEST_PASS

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END