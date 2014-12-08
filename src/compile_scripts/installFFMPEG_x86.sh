set -ex

export PATH=/opt/x86_full/gst/bin:$PATH
export PKG_CONFIG_PATH=/opt/x86_full/gst/lib/pkgconfig
export LD_LIBRARY_PATH=/opt/x86_full/gst/lib:$LD_LIBRARY_PATH

sudo apt-get -y install autoconf automake build-essential libass-dev libfreetype6-dev libgpac-dev \
  libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libx11-dev \
  libxext-dev libxfixes-dev pkg-config texi2html zlib1g-dev

# rm ~/ctmpx86_full -rf
# mkdir -p ~/ctmpx86_full

cd ~/ctmpx86_full
wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar xzvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --prefix="/opt/x86_full/gst" --bindir="/opt/x86_full/gst/bin" --enable-shared
make
make install
make distclean

cd ~/ctmpx86_full
wget http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2
tar xjvf last_x264.tar.bz2
cd x264-snapshot*
PATH="$PATH:/opt/x86_full/gst/bin" ./configure --prefix="/opt/x86_full/gst" --bindir="/opt/x86_full/gst/bin" --disable-opencl --enable-shared
PATH="$PATH:/opt/x86_full/gst/bin" make
make install
make distclean

sudo apt-get install unzip
cd ~/ctmpx86_full
wget -O fdk-aac.zip https://github.com/mstorsjo/fdk-aac/zipball/master
unzip fdk-aac.zip
cd mstorsjo-fdk-aac*
autoreconf -fiv
./configure --prefix="/opt/x86_full/gst" --enable-shared
make
make install
make distclean

sudo apt-get install nasm
cd ~/ctmpx86_full
wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix="/opt/x86_full/gst" --enable-nasm --enable-shared
make
make install
make distclean

cd ~/ctmpx86_full
wget http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz
tar xzvf opus-1.1.tar.gz
cd opus-1.1
./configure --prefix="/opt/x86_full/gst" --enable-shared
make
make install
make distclean

cd ~/ctmpx86_full
wget http://webm.googlecode.com/files/libvpx-v1.3.0.tar.bz2
tar xjvf libvpx-v1.3.0.tar.bz2
cd libvpx-v1.3.0
PATH="$PATH:/opt/x86_full/gst/bin" ./configure --prefix="/opt/x86_full/gst" --disable-examples --enable-shared
PATH="$PATH:/opt/x86_full/gst/bin" make
make install
make clean

cd ~/ctmpx86_full
wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="$PATH:/opt/x86_full/gst/bin" PKG_CONFIG_PATH="/opt/x86_full/gst/lib/pkgconfig" ./configure \
  --prefix="/opt/x86_full/gst" \
  --extra-cflags="-I/opt/x86_full/gst/include" \
  --extra-ldflags="-L/opt/x86_full/gst/lib" \
  --bindir="/opt/x86_full/gst/bin" \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-nonfree \
  --enable-shared \
  --enable-x11grab
PATH="$PATH:/opt/x86_full/gst/bin" make
make install
make distclean
hash -r


sudo apt-get install -y cmake

#opencv!
cd ~/ctmpx86_full
wget https://github.com/Itseez/opencv/archive/2.4.6.1.tar.gz
mv 2.4.6.1.tar.gz opencv-2.4.6.1.tar.gz
tar -xf opencv-2.4.6.1.tar.gz
cd opencv-2.4.6.1
wget http://dinstech.nl/uploads/mavlab/cap_gstreamer.cpp
mv cap_gstreamer.cpp modules/highgui/src/ 
mkdir build
cd build/
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/opt/x86_full/gst ..
make install