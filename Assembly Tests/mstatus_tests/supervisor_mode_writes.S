#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

csrr x6, mtvec  //saving address stored in mtvec
la x5, mtvec_handler 
csrw mtvec, x5 
li x5, MSTATUS_MPP //clearing the bits specifying the privilege mode
csrc mstatus, x5
li x5, 0x800
csrs mstatus, x5 //setting mpp to switch to supervisor mode
la x5, supervisor_mode
csrw mepc, x5
mret

mtvec_handler:
beqz x5, fail 
la x5, loop1  
slli x28, x28, 1  //left shifting to progress with bits
addi x27, x27, -1
beqz x27, pass //if all the 64 fields are checked it would jump to pass
csrw mepc, x5
mret

pass:
csrw mtvec, x6
RVTEST_PASS

fail:
csrw mtvec, x6
RVTEST_FAIL

supervisor_mode:
li x27, 64  //since mstatus has 64 fields
li x28, 1  
loop1:
    csrs mstatus, x28  //setting each bit of mstatus register
    li x5, 0 //if exception is not triggered
    ecall
    

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
