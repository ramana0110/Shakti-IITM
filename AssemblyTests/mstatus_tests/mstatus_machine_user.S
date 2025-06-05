#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

MMODE_CSR_PRINTS
csrr x6, mtvec  //saving address stored in mtvec
la x5, test_pass_fail 
csrw mtvec, x5 
li x5, MSTATUS_MPP //clearing the bits specifying the privilege mode
csrc mstatus, x5
la x5, user_mode
csrw mepc, x5
MMODE_CSR_PRINTS
mret

test_pass_fail:
MMODE_CSR_PRINTS
csrw mtvec, x6
csrr x5, mstatus
li x7, MSTATUS_MPP
and x5, x5, x7  //Checking the MPP bits
beqz x5, pass
MMODE_CSR_PRINTS
j fail

pass:
RVTEST_PASS 

fail:
RVTEST_FAIL  

user_mode:
ecall  //Jumping to machine mode through ecall


RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
