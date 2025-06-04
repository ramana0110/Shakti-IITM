#include "test_macros.h"
#include "riscv_test.h"
RVTEST_RV64M
RVTEST_CODE_BEGIN

.align 2
.option norvc

#Machine mode 
csrr t1, mtvec
la t0, exception_handler
csrw mtvec, t0
li t0, MSTATUS_MPP  // loading the mpp bit mask to t0
csrc mstatus, t0   // clearing the mpp bits of mstatus 
li t0, 0x800  // bit to be set for supervisor mode
csrs mstatus, t0
li t0, MSTATUS_TVM //Storing the TVM bit position in t0
csrc mstatus, t0 //Clear the TVM bit (Allows reading satp)
la t0, TVM_0
csrw mepc, t0
mret  // switches to supervisor mode
csrw mtvec, t1 //restoring mtvec
RVTEST_FAIL

#Supervisor mode
TVM_0:
csrr t0, satp //Reading satp when TVM = 0 (Should read)
ecall
csrw mtvec, t1 //restoring mtvec
RVTEST_FAIL

#Supervisor mode
TVM_1:
csrr t0, satp //Reading satp when TVM = 1 (Throws an exception)
csrw mtvec, t1 //restoring mtvec
RVTEST_FAIL

#Machine mode
exception_handler:
li t0, MSTATUS_MPP  // loading the mpp bit mask to t0
csrc mstatus, t0   // clearing the mpp bits of mstatus 
li t0, 0x800  // bit to be set for supervisor mode
csrs mstatus, t0
li t0, MSTATUS_TVM //Storing the TVM bit position in t0
csrs mstatus, t0 //Set the TVM bit (Doesn't allow reading satp)
la t0, TVM_1
csrw mepc, t0
la t0, correct_exception
csrw mtvec, t0
mret

correct_exception:
csrw mtvec, t1 //restoring mtvec
RVTEST_PASS

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END