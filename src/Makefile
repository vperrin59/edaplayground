PRJ_ROOT=$(shell git root)

SIM_OPTS=\
	-nowarn DLCLIB \
	-nowarn DLCOMB\
	-nowarn DLCVAR\
	-nowarn DSEM2009\

%.log: TGT_SUF=$(suffix $@)
%.log: OBJ_DIR=$(shell dirname $(subst src,obj,$(realpath $(subst $(TGT_SUF),.sv,$@))))

# Create corresponding dir in obj
%.dir: %.sv
	mkdir -p ${OBJ_DIR}

%.log: %.sv %.dir
	xrun -access +rwc -sv $< -l ${OBJ_DIR}/$@ ${SIM_OPTS}

.PHONY: dbg_dst dbg_src test.db

clean:
	rm -rf ${PRJ_ROOT}/obj
	rm -rf *.log
	rm -rf *.history

dbg_src:
	@echo dbg_src

dbg_dst: clean dbg_src
	$(info $$@ = $@)
	$(info $$< = $<)
	$(info $$< = $<)



test.db: TGT_SUF=$(suffix $@)
test.db:
	echo ${TGT_SUF}

#OBJ_DIR=$(shell dirname $(subst src,obj,$(realpath $<)));
