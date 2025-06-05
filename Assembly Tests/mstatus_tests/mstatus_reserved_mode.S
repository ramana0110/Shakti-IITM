#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

MMODE_CSR_PRINTS
csrr x6, mtvec  //saving address stored in mtvec
la x5, pass 
csrw mtvec, x5 
li x5, MSTATUS_MPP //clearing the bits specifying the privilege mode
csrc mstatus, x5
li x5, 0x1000  // setting mpp to 10 which is reserved 
csrs mstatus, x5
la x5, reserved_mode  
csrw mepc, x5
MMODE_CSR_PRINTS  
mret  //jumps to the reserved mode
csrw mtvec, x6
RVTEST_FAIL


pass:
MMODE_CSR_PRINTS
csrw mtvec, x6
RVTEST_PASS



reserved_mode:
ecall

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
