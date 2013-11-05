HOST ?= 192.168.1.1
PWD ?= $(shell pwd)



all:
	@echo "==== INSTALLING GST4ARDRONE2 Framework ===="
	tar -xzf ./bin/arm_light.tgz
	@echo "Post Install Steps:"
	@echo "1) Install compile tools using:        \033[1m make install\033[0m"
	@echo "2) Setup an ARDrone for vision with:   \033[1m make drone\033[0m"

clean:
	rm -rf ./opt

install:
	sudo apt-get install scratchbox2 qemu
	sb2-init -c qemu-arm armv7 /usr/local/codesourcery/arm-2009q3/bin/arm-none-linux-gnueabi-gcc

drone:
	-{							\
		echo "rm -rf /opt";				\
		echo "rm -rf /lib/dsp";				\
	} | telnet $(HOST)
	{							\
		echo "binary";					\
		echo "put ./bin/arm_light.tgz arm_light.tgz";	\
		echo "quit";					\
	} | ftp -n $(HOST)
	{							\
		echo "tar -xzf arm_light.tgz";			\
		echo "mkdir -p /opt/arm";			\
		echo "mkdir -p /lib/dsp";			\
		echo "mount --bind /data/video/opt /opt";	\
		echo "ls -altr /opt/arm/gst/bin";		\
	} | telnet $(HOST)

explain:
	{							\
		cat /firmware/version.txt;			\
		uname -a;					\
	} | telnet $(HOST)
	
