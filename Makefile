all:
	tar -xzf ./bin/arm_light.tgz

install:
	sudo apt-get install scratchbox2 qemu
	sb2-init -c qemu-arm armv7 /usr/local/codesourcery/arm-2009q3/bin/arm-none-linux-gnueabi-gcc

