#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

MMODE_CSR_PRINTS
li x5, MSTATUS_FS
csrw mstatus, x5  //Dirtying FS bits
li x5, MSTATUS64_SD
csrr x6, mstatus //Should set SD bit of the mstatus register
and x5, x5, x6
MMODE_CSR_PRINTS
bnez x5, pass

RVTEST_FAIL

pass:
RVTEST_PASS
RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
