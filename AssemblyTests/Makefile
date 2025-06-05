# Makefile for compiling and running RISC-V test on Spike

ifndef TEST
$(error TEST is not set. Please run: export TEST=/path/to/test_file.S)
endif

# Variables (override TEST on the command line)
# TEST      ?= test.S
FILENAME  := $(basename $(notdir $(TEST)))
TEST_HOME := $(CURDIR)
OUT_DIR   := $(TEST_HOME)/work/$(FILENAME)

# Tools
GCC       := riscv64-unknown-elf-gcc
OBJDUMP   := riscv64-unknown-elf-objdump
SPIKE     := spike
TIMEOUT   := timeout --foreground 3s

# Compiler/linker options
CFLAGS    := -march=rv64g -mabi=lp64 -static -mcmodel=medany -fvisibility=hidden \
             -nostdlib -nostartfiles  \
             -I./env -T./env/link.ld

# Targets
.PHONY: all run disasm spike clean

all: run

run: $(OUT_DIR)/$(FILENAME)
	@$(MAKE) --no-print-directory disasm
	@$(MAKE) --no-print-directory spike
	@echo "-------------------------------------------------------------------------"
	@echo "DONE"
	@echo "-------------------------------------------------------------------------"

$(OUT_DIR)/$(FILENAME): $(TEST)
	@echo "-------------------------------------------------------------------------"
	@echo "Compiling $(TEST)"
	@echo "-------------------------------------------------------------------------"
	mkdir -p $(OUT_DIR)
	rm -rf $(OUT_DIR)/*
	$(GCC) $(CFLAGS) $< -o $@

disasm: $(OUT_DIR)/$(FILENAME)
	@echo "-------------------------------------------------------------------------"
	@echo "Disassembly Generation"
	@echo "-------------------------------------------------------------------------"
	$(OBJDUMP) --disassemble-all --disassemble-zeroes \
		--section=.text --section=.text.startup --section=.text.init --section=.data \
		$< > $(OUT_DIR)/$(FILENAME).disass
	@echo "-------------------------------------------------------------------------"

spike: $(OUT_DIR)/$(FILENAME)
	@echo "-------------------------------------------------------------------------"
	@echo "Running on Spike"
	@echo "-------------------------------------------------------------------------"
	$(TIMEOUT) $(SPIKE) --log-commits --log $(OUT_DIR)/$(FILENAME).dump \
		 +signature=spike_signature.txt +signature-granularity=4 $<
	@echo "-------------------------------------------------------------------------"

clean:
	@echo "Cleaning $(CURDIR)/work/$(FILENAME)"
	rm -rf $(CURDIR)/work/$(FILENAME)
