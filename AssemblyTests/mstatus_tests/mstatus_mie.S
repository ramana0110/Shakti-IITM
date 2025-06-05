#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

MMODE_CSR_PRINTS
csrr x6, mtvec  //saving address stored in mtvec
la x5, interrupt_handler
csrw mtvec, x5 
li x5, MSTATUS_MIE
csrs mstatus, x5
csrr x5, mie
li x5, 2  //bitmask for MSIP
csrs mie, x5
csrs mip, x5 //triggering MSIP
MMODE_CSR_PRINTS

nop
nop
nop


interrupt_handler:
MMODE_CSR_PRINTS
csrr x5, mstatus  //MIE should be set to 0 after control goes to the interrupt handler
li x7, MSTATUS_MIE  
and x5,x5, x7  
bnez t0, fail  //should be 0 when MIE is disabled
csrw mtvec, t1
MMODE_CSR_PRINTS
RVTEST_PASS

fail:
csrw mtvec, t1
RVTEST_FAIL


RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
