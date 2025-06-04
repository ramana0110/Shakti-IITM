#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

csrr t1, mtvec  //saving address stored in mtvec
la t0, interrupt_handler
csrw mtvec, t0 
li t0, MSTATUS_MIE
csrs mstatus, t0
li t0, 2  //bitmask for MSIP
csrs mie, t0
csrs mip, t0 //triggering MSIP

nop
nop
nop
li x18,100
li x19,0
loop:
add x19,x19,1
csrr x20 ,mstatus
bne x18,x19,loop



interrupt_handler:
csrr t0, mstatus  //MIE should be set to 0 after control goes to the interrupt handler
li t2, MSTATUS_MIE  
and t0,t0, t2  
bnez t0, fail  //should be 0 when MIE is disabled
csrw mtvec, t1
RVTEST_PASS

fail:
csrw mtvec, t1
RVTEST_FAIL


RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
