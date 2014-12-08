set -ex

export PATH=/opt/arm_full/gst/bin:$PATH
export PKG_CONFIG_PATH=/opt/arm_full/gst/lib/pkgconfig
export LD_LIBRARY_PATH=/opt/arm_full/gst/lib:$LD_LIBRARY_PATH

sudo apt-get -y install autoconf automake build-essential libass-dev libfreetype6-dev libgpac-dev \
  libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libx11-dev \
  libxext-dev libxfixes-dev pkg-config texi2html zlib1g-dev

# rm ~/ctmp -rf
# mkdir -p ~/ctmp

cd ~/ctmp
wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar xzvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
sb2 ./configure --prefix="/opt/arm_full/gst" --bindir="/opt/arm_full/gst/bin" --enable-shared
sb2 make
sb2 make install
#make distclean

cd ~/ctmp
wget http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2
tar xjvf last_x264.tar.bz2
cd x264-snapshot-2014*
sb2 PATH="$PATH:/opt/arm_full/gst/bin" ./configure --prefix="/opt/arm_full/gst" --bindir="/opt/arm_full/gst/bin" --enable-shared --disable-opencl
sb2 PATH="$PATH:/opt/arm_full/gst/bin" make
sb2 make install
#make distclean

sudo apt-get install unzip
cd ~/ctmp
wget -O fdk-aac.zip https://github.com/mstorsjo/fdk-aac/zipball/master
unzip fdk-aac.zip
cd mstorsjo-fdk-aac*
autoreconf -fiv
sb2 ./configure --prefix="/opt/arm_full/gst" --enable-shared
sb2 make
sb2 make install
#make distclean

sudo apt-get install nasm
cd ~/ctmp
wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5
sb2 ./configure --prefix="/opt/arm_full/gst" --enable-nasm --enable-shared
sb2 make # error
sb2 make install
#make distclean

cd ~/ctmp
wget http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz
tar xzvf opus-1.1.tar.gz
cd opus-1.1
sb2 ./configure --prefix="/opt/arm_full/gst" --enable-shared
sb2 make
sb2 make install
#make distclean

cd ~/ctmp
wget http://webm.googlecode.com/files/libvpx-v1.3.0.tar.bz2
tar xjvf libvpx-v1.3.0.tar.bz2
cd libvpx-v1.3.0
sb2 PATH="$PATH:/opt/arm_full/gst/bin" ./configure --prefix="/opt/arm_full/gst" --disable-examples --enable-shared
sb2 PATH="$PATH:/opt/arm_full/gst/bin" make
sb2 make install
#make clean

#cd ~/ctmp
#wget http://download.savannah.gnu.org/releases/freetype/freetype-2.4.0.tar.gz
#tar -xf freetype-2.4.0.tar.gz
#cd freetype-2.4.0
#sb2 PATH="$PATH:/opt/arm_full/gst/bin" ./configure --prefix="/opt/arm_full/gst" --bindir="/opt/arm_full/gst/bin" 
#sb2 PATH="$PATH:/opt/arm_full/gst/bin" make
#sb2 PATH="$PATH:/opt/arm_full/gst/bin" make install

#cd ~/ctmp
#wget http://fribidi.org/download/fribidi-0.19.6.tar.bz2
#tar -xf fribidi-0.19.6.tar.bz2
#cd fribidi-0.19.6
#sb2 PATH="$PATH:/opt/arm_full/gst/bin" ./configure --prefix="/opt/arm_full/gst" --bindir="/opt/arm_full/gst/bin" 
#sb2 PATH="$PATH:/opt/arm_full/gst/bin" make
#sb2 PATH="$PATH:/opt/arm_full/gst/bin" make install

#cd ~/ctmp
#wget https://github.com/libass/libass/releases/download/0.11.2/libass-0.11.2.tar.xz
#tar -xf libass-0.11.2.tar.xz
#cd libass-0.11.2
#sb2 PATH="$PATH:/opt/arm_full/gst/bin" ./configure --prefix="/opt/arm_full/gst" --bindir="/opt/arm_full/gst/bin" 
#sb2 PATH="$PATH:/opt/arm_full/gst/bin" make
#sb2 make install


cd ~/ctmp
wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
sb2 PATH="$PATH:/opt/arm_full/gst/bin" PKG_CONFIG_PATH="/opt/arm_full/gst/lib/pkgconfig" ./configure \
  --prefix="/opt/arm_full/gst" \
  --extra-cflags="-I/opt/arm_full/gst/include" \
  --extra-ldflags="-L/opt/arm_full/gst/lib" \
  --bindir="/opt/arm_full/gst/bin" \
  --enable-gpl \
  --enable-libfdk-aac \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-shared \
  --enable-nonfree
sb2 PATH="$PATH:/opt/arm_full/gst/bin" make
sb2 make install
#make distclean
hash -r


sudo apt-get install -y cmake

#opencv!
cd ~/ctmp
wget https://github.com/Itseez/opencv/archive/2.4.6.1.tar.gz
mv 2.4.6.1.tar.gz opencv-2.4.6.1.tar.gz
tar -xf opencv-2.4.6.1.tar.gz
cd opencv-2.4.6.1
wget http://dinstech.nl/uploads/mavlab/cap_gstreamer.cpp
mv cap_gstreamer.cpp modules/highgui/src/ 
mkdir build
cd build/
sb2 cmake -D CMAKE_CXX_COMPILER="g++" -D CMAKE_C_COMPILER="gcc" -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/opt/arm_full/gst ..
sb2 make install