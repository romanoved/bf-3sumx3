.DELETE_ON_ERROR:
.PHONY: test

bfcomp := bfcomp-0.09

test: 3SUMx3.bf $(bfcomp)/bfrun
	@echo 'EXPECTED: "result: 21"'
	echo "5 4 2 2 5 5 4 0 2 1 1 4 3 2 2 -1 " | $(bfcomp)/bfrun $<

$(bfcomp).tar.gz:
	wget 'http://www.clifford.at/bfcpu/$@'

$(bfcomp)/bfrun $(bfcomp)/bfc $(bfcomp)/bfa: $(bfcomp).tar.gz
	tar xzf $<
	sed -i 's/int config_checks = 1/int config_checks = 0/' $(bfcomp)/bfrun.c
	sed -i 's|builtins.bfc|$(bfcomp)/builtins.bfc|' $(bfcomp)/bfc.c
	cd $(dir $@) && $(MAKE) bfrun bfc bfa

%.bfa:  %.bfc $(bfcomp)/bfc
	$(bfcomp)/bfc < $< > $@

%.bf: %.bfa $(bfcomp)/bfa
	$(bfcomp)/bfa < $< > $@


clean:
	-rm -rf $(bfcomp) $(bfcomp).tar.gz
