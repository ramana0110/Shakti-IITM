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
li x5, MSTATUS_TSR //Storing the TSR bit position in t0
csrc mstatus, x5 //Clear the TSM bit (Allows reading satp)
la x5, TSR_0
csrw mepc, x5
mret  // switches to supervisor mode
csrw mtvec, t1 //restoring mtvec
MMODE_CSR_PRINTS 
RVTEST_FAIL

#Supervisor mode
TSR_0:
csrr x29, sstatus
csrr x29, stvec
csrr x29, sepc
la x5, sret_jump
csrw sepc, x5
sret 
csrw mtvec, x6//restoring mtvec
csrr x29, sstatus
csrr x29, stvec
csrr x29, sepc
RVTEST_FAIL

#Supervisor mode
TSR_1:
csrr x29, sstatus
csrr x29, stvec
csrr x29, sepc
sret
csrw mtvec, t1 //restoring mtvec
RVTEST_FAIL

#Supervisor mode
sret_jump:
csrr x29, sstatus
csrr x29, stvec
csrr x29, sepc
ecall

#Machine mode
exception_handler:
MMODE_CSR_PRINTS 
li x5, MSTATUS_MPP  // loading the mpp bit mask to t0
csrc mstatus, x5   // clearing the mpp bits of mstatus 
li x5, 0x800  // bit to be set for supervisor mode
csrs mstatus, x5
li x5, MSTATUS_TSR //Storing the TSR bit position in t0
csrs mstatus, x5 //Set the TSR bit (Doesn't allow reading satp)
la x5, TSR_1
csrw mepc, x5
la x5, correct_exception
csrw mtvec, x5
MMODE_CSR_PRINTS 
mret

correct_exception:
csrw mtvec, x6 //restoring mtvec
RVTEST_PASS

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
