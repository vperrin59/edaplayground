PRJ_ROOT=$(shell git root)
CWD=$(shell pwd)

# Remove uvm files for now
# Compilation issue, need to import uvm_pkg
SV_FILES=$(shell find . -name "*.sv" | grep -v uvm)
LOG_FILES=$(subst .sv,.log,$(SV_FILES))

SIM_OPTS += \
	-nowarn DLCLIB \
	-nowarn DLCOMB \
	-nowarn DLCVAR \
	-nowarn DSEM2009 \
	-errsev_return_status_0 \
	-exit \


%.log: TGT_SUF=$(suffix $@)
%.log: SV=`
%.log: OBJ_DIR=$(shell dirname $(subst src,obj,$(realpath $(subst $(TGT_SUF),.sv,$@))))

# Create corresponding dir in obj
%.dir: %.sv
	mkdir -p ${OBJ_DIR}

# Do not stop on simulation errors
%.log: %.sv %.dir
	cd ${OBJ_DIR} && xrun -access +rwc -sv ${CWD}/$< -l $(shell basename $@) ${SIM_OPTS} || true

.PHONY: dbg_dst dbg_src test.db dbg

clean:
	rm -rf xcelium.d
	rm -rf xrun.key
	rm -rf ${PRJ_ROOT}/obj
	rm -rf *.log
	rm -rf *.history

dbg_src:
	@echo dbg_src

dbg_dst: clean dbg_src
	$(info $$@ = $@)
	$(info $$< = $<)
	$(info $$< = $<)

all: $(LOG_FILES)

test.db: TGT_SUF=$(suffix $@)
test.db:
	echo ${TGT_SUF}

dbg:
	echo $(LOG_FILES)

#OBJ_DIR=$(shell dirname $(subst src,obj,$(realpath $<)));
