#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

MMODE_CSR_PRINTS
csrr x5, mtvec  //saving address stored in mtvec
la x6, interrupt_handler
csrw mtvec, x6  //interrupt handler is stored in mtvec
li x7, MSTATUS_MPIE 
csrr x6, mstatus
and x7, x6, x7  //MPIE is set to 1
MMODE_CSR_PRINTS
ecall

interrupt_handler:
MMODE_CSR_PRINTS
li x28, MSTATUS_MPIE
csrr x6, mstatus
and x28, x6, x28 //MPIE should become 0
beq x28, x7, fail //MPIE shouldn't be equal
csrw mtvec, x5
MMODE_CSR_PRINTS
RVTEST_PASS

fail:
MMODE_CSR_PRINTS
csrw mtvec, x5
RVTEST_FAIL


RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
