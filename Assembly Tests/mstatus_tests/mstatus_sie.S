#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

MMODE_CSR_PRINTS
csrr x6, mtvec  //saving address stored in mtvec
la x5, fail 
csrw mtvec, x5 
li x5, MSTATUS_MPP //clearing the bits specifying the privilege mode
csrc mstatus, x5
li x5, 0x800 
csrs mstatus, x5  //setting the bits to go to supervisor mode
li x5, MSTATUS_MIE
csrs mstatus, x5
li x5, MSTATUS_SIE 
csrs mstatus, x5 
li x5, 2
MMODE_CSR_PRINTS
csrr x29, mideleg
csrr x29, sstatus
csrr x29, sie
csrr x29, sip
csrw mideleg, x5 //delegating SSIP to supervisor mode
csrs sstatus, x5
csrs sie, x5  // enanbling SSIP 
csrs sip, x5  // triggering SSIP
la x5, supervisor_mode
csrw mepc, x5
// Shouldn't trigger an interrupt until mret (switching to supervisor mode) is called 
nop
nop
nop
nop
nop
nop
nop
la x5, pass
csrw mtvec, x5
MMODE_CSR_PRINTS
mret

pass:
csrw mtvec, t1
RVTEST_PASS

fail:
csrw mtvec, t1
RVTEST_FAIL

supervisor_mode:
csrw mtvec, t1
RVTEST_PASS


RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
