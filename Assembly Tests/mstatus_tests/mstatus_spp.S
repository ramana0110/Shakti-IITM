#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

.align 2
.option norvc
MMODE_CSR_PRINTS
#Machine mode to Supervisor mode
li x5, MSTATUS_MPP  // loading the mpp bit mask to t0
csrc mstatus, x5   // clearing the mpp bits of mstatus 
li x5, 0x800  // bit to be set for supervisor mode
csrs mstatus, x5
la x5, supervisor_mode
csrw mepc, x5
MMODE_CSR_PRINTS
mret  // switches to supervisor mode
RVTEST_FAIL

#Supervisor mode to User mode
supervisor_mode:
csrr x29, sstatus
csrr x29, stvec
csrr x29, sepc
li x5, SSTATUS_SPP // loading the spp bit mask to t0
csrc sstatus, x5   // clearing the spp bits of sstatus (user mode)
la x5, user_mode
csrw sepc, x5
csrr x29, sstatus
csrr x29, stvec
csrr x29, sepc
sret
RVTEST_FAIL

user_mode:
RVTEST_PASS

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END