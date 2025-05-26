# Author: Hai Cao -- cxhai.sdh221@hcmut.edu.vn
# Copyright 2024

TOP=tbench
SEED=1

## Do NOT change the content below unless you know what you're doing
FLAGS =  --binary -Wall -Wno-UNUSEDSIGNAL --trace --sv --timing --trace-fst
FLAGS += -O3 --compiler gcc -CFLAGS -std=gnu++20
FLAGS += -x-initial unique
FLAGS += -x-assign unique
FLAGS += --assert
FLAGS += --build -j 0
LFLAGS = --lint-only --sv --timing
RFLAGS =  +verilator+seed+$(SEED)
RFLAGS += +verilator+quiet

TARGET = -f ./flist

.PHONY: all
all: sim

.PHONY: lint
lint:
	@echo "[*] LINT"
	verilator $(LFLAGS) $(TARGET)

.PHONY: comp
comp:
	@echo "[*] COMPILE"
	verilator $(FLAGS) $(TARGET)

.PHONY: sim
sim: comp
	@echo "[*] SIM"
	./obj_dir/V$(TOP) $(RFLAGS)

.PHONY: wave
wave:
	gtkwave wave.vcd -f wave.gtkw

.PHONY: surf
surf:
	surfer wave.vcd -s wave.ron

.PHONY: clean
clean:
	@echo "[*] CLEAN"
	@rm -rf ./obj_dir *.vcd
