#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

.align 2
.option norvc

#Machine mode to Supervisor mode
li t0, MSTATUS_MPP  // loading the mpp bit mask to t0
csrc mstatus, t0   // clearing the mpp bits of mstatus 
li t0, 0x800  // bit to be set for supervisor mode
csrs mstatus, t0
la t0, supervisor_mode
csrw mepc, t0
mret  // switches to supervisor mode
RVTEST_FAIL

#Supervisor mode to User mode
supervisor_mode:
li t0, SSTATUS_SPP // loading the spp bit mask to t0
csrc sstatus, t0   // clearing the spp bits of sstatus (user mode)
la t0, user_mode
csrw sepc, t0
sret
RVTEST_FAIL

user_mode:
RVTEST_PASS

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END