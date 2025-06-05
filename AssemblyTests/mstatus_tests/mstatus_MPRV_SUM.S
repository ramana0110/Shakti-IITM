#include "riscv_test.h"
#include "test_macros.h"

#if (DRAM_BASE >> 30 << 30) != DRAM_BASE
# error This test requires DRAM_BASE be SV39 superpage-aligned
#endif 

RVTEST_RV64M
RVTEST_CODE_BEGIN

MMODE_CSR_PRINTS
li x28, (SATP_MODE & ~(SATP_MODE<<1)) * SATP_MODE_SV39  //This is to set SATP mode in the satp register
la x5, page_table_1
srl x5, x5, RISCV_PGSHIFT  //To shift the address of the page table right number of bits for the satp register
or x5, x5, x28
csrr x6, satp
csrw satp, x5
sfence.vma 

li x5, ((MSTATUS_MPP & ~(MSTATUS_MPP<<1)) * PRV_S) | MSTATUS_MPRV  //Setting the MPRV bit
csrs mstatus, x5
MMODE_CSR_PRINTS
li TESTNUM, 2
li x6, 1
sw x6, dummy - DRAM_BASE, x28  //Trying to access from VM (Should fail since it's a user table)

li x5, ((MSTATUS_MPP & ~(MSTATUS_MPP<<1)) * PRV_S) | MSTATUS_SUM   //Setting the SUM bit  
csrs mstatus, x5
MMODE_CSR_PRINTS

lw x5, dummy - DRAM_BASE  //Should be able to access it since SUM bit is set
bnez t0, fail

li TESTNUM, 3
li x6, 25
sw x6, dummy - DRAM_BASE, x28 //Storing a word in memory 
lw x5, dummy - DRAM_BASE  //Reading the stored word
bne x5, x6, fail //Comparing them
RVTEST_PASS

  .align 2
  .global mtvec_handler
mtvec_handler:
  MMODE_CSR_PRINTS
  csrr x5, mcause
  add x5, x5, -CAUSE_STORE_PAGE_FAULT
  bnez x5, fail //Checking whether the exception is caused by accessing a page
  li x6, 2
  bne TESTNUM, x6, 1f
  lw x5, page_table_1
  and x6, x5, PTE_D  //Checking whether the page table has been changed (Shouldn't have changed)
  bnez x6, fail
skip:
  csrr x5, mepc
  add x5, x5, 4  //Moving to the next instruction
  csrw mepc, x5
  MMODE_CSR_PRINTS
  mret

1:
  # The implementation doesn't appear to set D bits in HW.
  # Make sure the D bit really is clear.
  MMODE_CSR_PRINTS
  lw x5, page_table_1
  and x6, x5, PTE_D
  bnez x6, fail
  # Set the D bit.
  or x5, x5, PTE_D
  sw x5, page_table_1, x6
  sfence.vma
  mret


fail:
RVTEST_FAIL


RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

.align 12
page_table_1: .dword (DRAM_BASE/RISCV_PGSIZE << PTE_PPN_SHIFT) | PTE_V | PTE_U | PTE_R | PTE_W | PTE_X | PTE_A  
dummy: .dword 0

RVTEST_DATA_END
