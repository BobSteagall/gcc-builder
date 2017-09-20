
destdir := /

sep_bar := "************************************************************************"
sep_cmd := echo "" ; echo $(sep_bar) ; echo $(sep_bar) ; echo $(sep_bar) ; echo ""

.PHONY: build pack install
.PHONY: build-and-test test-and-pack test-and-install

build:
	./build-gcc.sh -T
	@$(sep_cmd)

pack: build
	@rm -rf packages dist
	./stage-gcc.sh
	@$(sep_cmd)
	./pack-gcc.sh
	@$(sep_cmd)

install: pack
	mkdir -p $(destdir)
	tar -zxvf ./packages/kewb-gcc*.tgz -C $(destdir)


build-and-test:
	./build-gcc.sh
	@$(sep_cmd)

test-and-pack: build-and-test
	@rm -rf packages dist
	./stage-gcc.sh
	@$(sep_cmd)
	./pack-gcc.sh
	@$(sep_cmd)

test-and-install: test-and-pack
	mkdir -p $(destdir)
	tar -zxvf ./packages/kewb-gcc*.tgz -C $(destdir)

