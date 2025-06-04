#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN


csrr x5, mtvec  //saving address stored in mtvec
la x6, interrupt_handler
csrw mtvec, x6  //interrupt handler is stored in mtvec
li x7, MSTATUS_SPIE  
csrr x6, mstatus
and x7, x6, x7  //SPIE would be 0 by default
li x6, 0x800  // Setting MPP to supervisor mode to switch
csrs mstatus, x6
la x6, supervisor_mode
csrw mepc, x6
li x6, 0x2
csrw mideleg, x6 //delegating SSIP to supervisor mode
csrs sstatus, x6
mret


interrupt_handler:
li x28, MSTATUS_SPIE 
csrr x6, mstatus
and x28, x6, x28 //SPIE should be one
beq x28, x7, fail //SPIE shouldn't be equal
csrw mtvec, x5
RVTEST_PASS

supervisor_mode:
la x6, sv_interrupt_handler
csrw stvec, x6 
li x6, 0x2
csrs sie, x6 // enanbling SSIP 
csrs sip, x6  // triggering SSIP
nop
nop
nop
nop

sv_interrupt_handler:
ecall 

fail:
csrw mtvec, x5
RVTEST_FAIL


RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END