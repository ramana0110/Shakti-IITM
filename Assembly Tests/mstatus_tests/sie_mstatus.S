#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

csrr t1, mtvec  //saving address stored in mtvec
la t0, fail 
csrw mtvec, t0 
li t0, MSTATUS_MPP //clearing the bits specifying the privilege mode
csrc mstatus, t0
li t0, 0x800 
csrs mstatus, t0  //setting the bits to go to supervisor mode
li t0, MSTATUS_MIE
csrs mstatus, t0
li t0, MSTATUS_SIE 
csrs mstatus, t0 
li t0, 2
csrw mideleg, t0 //delegating SSIP to supervisor mode
csrs sstatus, t0
csrs sie, t0  // enanbling SSIP 
csrs sip, t0  // triggering SSIP
la t0, supervisor_mode
csrw mepc, t0
// Shouldn't trigger an interrupt until mret (switching to supervisor mode) is called 
nop
nop
nop
nop
nop
nop
nop
la t0, pass
csrw mtvec, t0
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
