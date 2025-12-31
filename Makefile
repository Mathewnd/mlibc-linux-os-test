JINX_COMMIT=6940f35b6031df4aa7d06c94d968e674ad93019e
JINX_ARCH=x86_64
JINX_DIR=build-$(JINX_ARCH)

.phony: test build create-sysroot

create-sysroot: jinx $(JINX_DIR)/.ok
	cd $(JINX_DIR) && ../jinx install ../sysroot \*

$(JINX_DIR)/.ok:
	mkdir -p $(JINX_DIR)
	touch $(JINX_DIR)/.ok
	cd $(JINX_DIR) && ../jinx init ..

test:
	sudo chroot sysroot /usr/bin/run-os-test.sh

html:
	./generate-html.sh

jinx:
	curl --raw https://codeberg.org/Mintsuki/jinx/raw/commit/$(JINX_COMMIT)/jinx > jinx
	chmod +x jinx
