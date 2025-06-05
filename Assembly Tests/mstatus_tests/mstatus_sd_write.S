#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

MMODE_CSR_PRINTS
li x5, MSTATUS64_SD
csrw mstatus, x5   //Trying to write SD bit which is read-only
csrr x6, mstatus
MMODE_CSR_PRINTS
and x5, x6, x5   //Should be 0 since SD is read-only
beqz x5, pass
RVTEST_FAIL

pass:
RVTEST_PASS

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
