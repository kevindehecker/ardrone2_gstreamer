set -ex

sudo mkdir -p /opt/arm-2009
sudo chown houjebek /opt/arm-2009

cd ~/Downloads
sudo echo "Install crosscompiler"
sudo apt-get install -y bison openjdk-7-jre libxtst6:i386  zlib1g-dev realpath fakeroot libglib2.0 autoconf scratchbox2 libtool libsdl-console libsdl-console-dev & wget -c http://dinstech.nl/uploads/mavlab/arm-2009q3-67-arm-none-linux-gnueabi.bin
read -p "Answer no in next question. Press enter to continue..." nothing
sudo dpkg-reconfigure -plow dash #answer: no
chmod +x arm-2009q3-67-arm-none-linux-gnueabi.bin
read -p "Change 'Default Install Folder' to: /opt/arm-2009! All the rest must stay as default. Press enter to continue..." nothing
./arm-2009q3-67-arm-none-linux-gnueabi.bin -i console

#apt-get install of qemu results in a none workng sb2-init config, so compile ourselves the correct version
echo "qemu"
cd ~/Downloads
sudo mkdir -p /opt/qemu
sudo chown houjebek /opt/qemu
wget http://wiki.qemu-project.org/download/qemu-1.5.0.tar.bz2
tar -xf qemu-1.5.0.tar.bz2
cd qemu-1.5.0
./configure --prefix=/opt/qemu --target-list=arm-linux-user
make install

cd /opt/arm-2009/arm-none-linux-gnueabi/libc/
sb2-init -c /opt/qemu/bin/qemu-arm armv7 /opt/arm-2009/bin/arm-none-linux-gnueabi-gcc