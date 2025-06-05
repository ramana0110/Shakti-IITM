#include "test_macros.h"
#include "riscv_test.h"
RVTEST_RV64M
RVTEST_CODE_BEGIN

.align 2
.option norvc

#Machine mode 
MMODE_CSR_PRINTS 
csrr x6, mtvec
la x5, exception_handler
csrw mtvec, x5
li x5, MSTATUS_MPP  // loading the mpp bit mask to t0
csrc mstatus, x5   // clearing the mpp bits of mstatus 
li x5, 0x800  // bit to be set for supervisor mode
csrs mstatus, x5
li x5, MSTATUS_TVM //Storing the TVM bit position in t0
csrc mstatus, x5 //Clear the TVM bit (Allows reading satp)
la x5, TVM_0
csrw mepc, x5
MMODE_CSR_PRINTS
mret  // switches to supervisor mode
csrw mtvec, x6 //restoring mtvec
RVTEST_FAIL

#Supervisor mode
TVM_0:
csrr x29, sstatus
csrr x5, satp //Reading satp when TVM = 0 (Should read)
ecall
csrw mtvec, x6 //restoring mtvec
RVTEST_FAIL

#Supervisor mode
TVM_1:
csrr x29, sstatus
csrr x5, satp //Reading satp when TVM = 1 (Throws an exception)
csrw mtvec, x6 //restoring mtvec
RVTEST_FAIL

#Machine mode
exception_handler:
MMODE_CSR_PRINTS
li x5, MSTATUS_MPP  // loading the mpp bit mask to t0
csrc mstatus, x5   // clearing the mpp bits of mstatus 
li x5, 0x800  // bit to be set for supervisor mode
csrs mstatus, x5
li x5, MSTATUS_TVM //Storing the TVM bit position in t0
csrs mstatus, x5 //Set the TVM bit (Doesn't allow reading satp)
la x5, TVM_1
csrw mepc, x5
la x5, correct_exception
csrw mtvec, x5
MMODE_CSR_PRINTS
mret

correct_exception:
MMODE_CSR_PRINTS
csrw mtvec, x6 //restoring mtvec
RVTEST_PASS

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END