#include "test_macros.h"
#include "riscv_test.h"
RVTEST_RV64M
RVTEST_CODE_BEGIN

.align 2
.option norvc

#Machine mode to Supervisor mode
csrr t1, mtvec
la t0, exception_handler
csrw mtvec, t0
li t0, MSTATUS_MPP  // loading the mpp bit mask to t0
csrc mstatus, t0   // clearing the mpp bits of mstatus 
li t0, 0x800  // bit to be set for supervisor mode
csrs mstatus, t0
la t0, supervisor_mode
csrw mepc, t0
mret  // switches to supervisor mode
csrw mtvec, t1 //restoring mtvec
RVTEST_FAIL


supervisor_mode:
li t0, SSTATUS_SPP // loading the spp bit mask to t0
csrc mstatus, t0   // trying to clear mstatus in suprervisor (user mode)
csrw mtvec, t1 //restoring mtvec
RVTEST_FAIL

exception_handler:
csrw mtvec, t1 //restoring mtvec
RVTEST_PASS

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END