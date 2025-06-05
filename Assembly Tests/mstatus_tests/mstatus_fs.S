#include "riscv_test.h"
#include "test_macros.h"

#define RVTEST_RV64MF                                                   \
  .macro init;                                                          \
  RVTEST_ENABLE_MACHINE;                                                \
  RVTEST_FP_ENABLE;                                                     \
  .endm

RVTEST_RV64MF
RVTEST_CODE_BEGIN

MMODE_CSR_PRINTS
TEST_FP_OP2_S( 2,  fadd.s, 0, 3.5, 2.5, 1.0 );  //Trying a FP operation
csrr x5, mstatus  // This should set the FS bits to dirty
li x6, MSTATUS_FS  
and x5, x5, x6
MMODE_CSR_PRINTS
beq x6, x5, pass
RVTEST_FAIL

pass:
RVTEST_PASS

fail:
RVTEST_FAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END