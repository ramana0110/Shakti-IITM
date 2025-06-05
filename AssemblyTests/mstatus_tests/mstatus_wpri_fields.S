#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

MMODE_CSR_PRINTS
li x5, 0x7FFFFFC0FF800005  //bit mask for all the wpri fields of mstatus
csrw mstatus, x5
csrr x6, mstatus
and x5, x6, x5  //this should result in 0 since the fields are write protected
beqz x5, pass
MMODE_CSR_PRINTS
RVTEST_FAIL

pass:
RVTEST_PASS

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
