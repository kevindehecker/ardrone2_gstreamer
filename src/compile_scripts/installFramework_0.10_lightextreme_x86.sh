sudo rm -rf ~/ctmpx86_light
sudo rm -rf /opt/x86_light/gst
set -ex

export PKG_CONFIG_PATH=/opt/x86_light/gst/lib/pkgconfig
export PATH=/opt/x86_light/gst/bin:$PATH
export LD_LIBRARY_PATH=/opt/x86_light/gst/bin:$LD_LIBRARY_PATH

mkdir -p ~/ctmpx86_light
sudo mkdir -p /opt/x86_light
sudo chown houjebek /opt/x86_light

echo *****************dependacies for gstreamer framework********************

echo "zlib - needed by GLib’s gio"
cd ~/ctmpx86_light
wget -c http://zlib.net/zlib-1.2.8.tar.gz
tar -xf zlib-1.2.8.tar.gz
cd zlib-1.2.8
 ./configure --prefix=/opt/x86_light/gst
 make install

echo "libffi  - needed by glib"
cd ~/ctmpx86_light
wget -c ftp://sourceware.org/pub/libffi/libffi-3.0.13.tar.gz
tar -xf libffi-3.0.13.tar.gz
cd libffi-3.0.13
 ./configure --prefix=/opt/x86_light/gst
 make install

echo "python2.7, Ubuntu 12.04 has some problem without it" 
cd ~/ctmpx86_light
wget http://www.python.org/ftp/python/2.7.5/Python-2.7.5.tar.xz
tar -xf Python-2.7.5.tar.xz
cd Python-2.7.5
./configure --prefix=/opt/x86_light/python
make install

echo "glib"
cd ~/ctmpx86_light
wget https://git.gnome.org/browse/glib/snapshot/glib-2.40.2.tar.xz
tar -xf glib-2.40.2.tar.xz
cd glib-2.40.2
./autogen.sh
 ./configure --prefix=/opt/x86_light/gst --disable-static --with-python=/opt/x86_light/python/bin/python2.7
 make install

echo ***************** gstreamer framework part 1********************

echo "gstreamer"
sudo apt-get -y install bison flex yasm libglib2.0-dev autopoint
cd ~/ctmpx86_light
wget -c http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-0.10.36.tar.xz
tar -xf gstreamer-0.10.36.tar.xz
cd gstreamer-0.10.36
wget http://dinstech.nl/uploads/mavlab/grammar.txt
mv grammar.txt ./gst/parse/grammar.y
./autogen.sh --noconfigure
 ./configure --prefix=/opt/x86_light/gst --disable-nls --disable-static --disable-gobject-cast-checks --disable-loadsave --disable-trace --disable-tests --disable-examples --disable-gst-debug --disable-debug --with-html-dir=/tmp/dump
 make install

echo "orc, replaces liboil"
cd ~/ctmpx86_light
wget -c http://cgit.freedesktop.org/gstreamer/orc/snapshot/orc-0.4.17.tar.gz
tar -xf orc-0.4.17.tar.gz
cd orc-0.4.17
./autogen.sh
 ./configure --prefix=/opt/x86_light/gst --disable-static --with-html-dir=/tmp/dump
make install


echo *****************gstreamer framework part 2********************
echo "gst-plugins-base"
cd ~/ctmpx86_light
wget -c http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-0.10.36.tar.gz
tar -xf gst-plugins-base-0.10.36.tar.gz
cd gst-plugins-base-0.10.36
./autogen.sh --noconfigure
 ./configure --prefix=/opt/x86_light/gst --disable-nls --disable-static --with-html-dir=/tmp/dump --disable-adder --disable-app --disable-audioconvert --disable-audiorate --disable-audioresample --disable-audiotestsrc	--disable-gdp --disable-playback --disable-tcp --disable-typefind --disable-volume --disable-audiotestsrc --disable-gio
make install

echo "gst-plugins-good"
sudo apt-get -y install g++
cd ~/ctmpx86_light
wget -c http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-0.10.31.tar.xz
tar -xf gst-plugins-good-0.10.31.tar.xz
cd gst-plugins-good-0.10.31
wget http://dinstech.nl/uploads/mavlab/gstv4l2bufferpool_x86hacked.c #different fix than with arm!
mv gstv4l2bufferpool_x86hacked.c sys/v4l2/gstv4l2bufferpool.c
./autogen.sh --noconfigure
./configure --prefix=/opt/x86_light/gst --disable-nls --disable-static --with-html-dir=/tmp/dump --disable-gst_v4l2 --disable-alpha --disable-apetag --disable-audiofx --disable-audioparsers --disable-auparse --disable-autodetect --disable-cutter --disable-debugutils --disable-deinterlace --disable-effectv --disable-equalizer --disable-flv --disable-flx --disable-goom --disable-goom2k1 --disable-icydemux --disable-id3demux --disable-imagefreeze --disable-interleave --disable-isomp4 --disable-law --disable-level --disable-matroska --disable-multifile --disable-multipart --disable-replaygain --disable-rtpmanager --disable-rtsp --disable-shapewipe --disable-smpte --disable-spectrum --disable-videobox --disable-videocrop --disable-videofilter --disable-videomixer --disable-wavenc --disable-wavparse --disable-y4m --disable-oss4 --disable-oss
make clean install




#opencv!
sudo apt-get install -y cmake
cd ~/ctmpx86_light
wget https://github.com/Itseez/opencv/archive/2.4.6.1.tar.gz
mv 2.4.6.1.tar.gz opencv-2.4.6.1.tar.gz
tar -xf opencv-2.4.6.1.tar.gz
cd opencv-2.4.6.1
wget http://dinstech.nl/uploads/mavlab/cap_gstreamer.cpp
mv cap_gstreamer.cpp modules/highgui/src/ 
mkdir build
cd build/
cmake -D BUILD_opencv_gpu=OFF -D BUILD_DOCS=OFF -D BUILD_TESTS=OFF -D WITH_OPENCL=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_EXAMPLES=OFF -D WITH_CUDA=OFF -D BUILD_opencv_gpu=OFF -D BUILD_opencv_gpuarithm=OFF -D BUILD_opencv_gpubgsegm=OFF -D BUILD_opencv_gpucodec=OFF -D BUILD_opencv_gpufeatures2d=OFF -D BUILD_opencv_gpufilters=OFF -D BUILD_opencv_gpuimgproc=OFF -D BUILD_opencv_gpulegacy=OFF -D BUILD_opencv_gpuoptflow=OFF -D BUILD_opencv_gpustereo=OFF -D BUILD_opencv_gpuwarping=OFF  cmake -D WITH_OPENCL=OFF -D WITH_CUDA=OFF -D BUILD_opencv_gpu=OFF -D BUILD_opencv_gpuarithm=OFF -D BUILD_opencv_gpubgsegm=OFF -D BUILD_opencv_gpucodec=OFF -D BUILD_opencv_gpufeatures2d=OFF -D BUILD_opencv_gpufilters=OFF -D BUILD_opencv_gpuimgproc=OFF -D BUILD_opencv_gpulegacy=OFF -D BUILD_opencv_gpuoptflow=OFF -D BUILD_opencv_gpustereo=OFF -D BUILD_opencv_gpuwarping=OFF -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/opt/x86_light/gst ..
make install/strip





echo "create tarbal of compiled framework"
cd ~/ctmpx86_light
sudo tar -cvzf x86_light.tgz /opt/x86_light/




