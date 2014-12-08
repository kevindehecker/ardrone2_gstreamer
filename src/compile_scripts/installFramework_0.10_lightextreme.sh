sudo rm -rf ~/ctmp_light
sudo rm -rf /opt/arm_light/gst
set -ex
export PKG_CONFIG_PATH=/opt/arm_light/gst/lib/pkgconfig

mkdir -p ~/ctmp_light
sudo mkdir -p /opt/arm_light
sudo chown houjebek /opt/arm_light


echo *****************dependacies for gstreamer framework********************

echo "zlib - needed by GLib’s gio"
cd ~/ctmp_light
wget -c http://zlib.net/zlib-1.2.8.tar.gz
tar -xf zlib-1.2.8.tar.gz
cd zlib-1.2.8
sb2 ./configure --prefix=/opt/arm_light/gst
sb2 make install

echo "libffi  - needed by glib"
cd ~/ctmp_light
wget -c ftp://sourceware.org/pub/libffi/libffi-3.0.13.tar.gz
tar -xf libffi-3.0.13.tar.gz
cd libffi-3.0.13
sb2 ./configure --prefix=/opt/arm_light/gst
sb2 make install

echo "python2.7, Ubuntu 12.04 has some problem without it" 
cd ~/ctmp_light
wget http://www.python.org/ftp/python/2.7.5/Python-2.7.5.tar.xz
tar -xf Python-2.7.5.tar.xz
cd Python-2.7.5
sb2 ./configure --prefix=/opt/arm_light/python
sb2 make install

echo "glib"
cd ~/ctmp_light
wget -c https://git.gnome.org/browse/glib/snapshot/glib-2.36.2.tar.gz
tar -xf glib-2.36.2.tar.gz
cd glib-2.36.2
./autogen.sh
sb2 ./configure --prefix=/opt/arm_light/gst --disable-static --with-python=/opt/arm_light/python/bin/python2.7
sb2 make install

echo ***************** gstreamer framework part 1********************

echo "gstreamer"
sudo apt-get -y install bison flex yasm libglib2.0-dev autopoint
cd ~/ctmp_light
wget -c http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-0.10.36.tar.xz
tar -xf gstreamer-0.10.36.tar.xz
cd gstreamer-0.10.36
wget http://dinstech.nl/uploads/mavlab/grammar.txt
mv grammar.txt ./gst/parse/grammar.y
./autogen.sh --noconfigure
sb2 ./configure --prefix=/opt/arm_light/gst --disable-nls --disable-static --disable-check --disable-gobject-cast-checks --disable-loadsave --disable-trace --disable-tests --disable-examples --disable-gst-debug --disable-debug --with-html-dir=/tmp/dump
sb2 make install

echo "orc, replaces liboil"
cd ~/ctmp_light
wget -c http://cgit.freedesktop.org/gstreamer/orc/snapshot/orc-0.4.17.tar.gz
tar -xf orc-0.4.17.tar.gz
cd orc-0.4.17
./autogen.sh
sb2 ./configure --prefix=/opt/arm_light/gst --disable-static --with-html-dir=/tmp/dump
sb2 make install

echo *****************gstreamer framework part 2********************
echo "gst-plugins-base"
cd ~/ctmp_light
wget -c http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-0.10.36.tar.gz
tar -xf gst-plugins-base-0.10.36.tar.gz
cd gst-plugins-base-0.10.36
./autogen.sh --noconfigure
sb2 ./configure --prefix=/opt/arm_light/gst --disable-nls --disable-static --with-html-dir=/tmp/dump --disable-adder --disable-audioconvert --disable-audiorate --disable-audioresample --disable-audiotestsrc	--disable-gdp --disable-playback --disable-tcp --disable-typefind --disable-volume --disable-audiotestsrc --disable-gio
sb2 make install

echo "gst-plugins-good"
sudo apt-get -y install g++
cd ~/ctmp_light
wget -c http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-0.10.31.tar.xz
tar -xf gst-plugins-good-0.10.31.tar.xz
cd gst-plugins-good-0.10.31
#fix the "bug" that calls an uunsupported feature of the v4l2 driver
wget http://dinstech.nl/uploads/mavlab/v4l2src_calls_hacked.c
mv v4l2src_calls_hacked.c ~/ctmp_light/gst-plugins-good-0.10.31/sys/v4l2/v4l2src_calls.c
wget http://dinstech.nl/uploads/mavlab/gstv4l2object_hacked.c
mv gstv4l2object_hacked.c ~/ctmp_light/gst-plugins-good-0.10.31/sys/v4l2/gstv4l2object.c
./autogen.sh --noconfigure
sb2 ./configure --prefix=/opt/arm_light/gst --disable-nls --disable-static --with-html-dir=/tmp/dump --disable-alpha --disable-apetag --disable-audiofx --disable-audioparsers --disable-auparse --disable-autodetect --disable-cutter --disable-debugutils --disable-deinterlace --disable-effectv --disable-equalizer --disable-flv --disable-flx --disable-goom --disable-goom2k1 --disable-icydemux --disable-id3demux --disable-imagefreeze --disable-interleave --disable-isomp4 --disable-law --disable-level --disable-matroska --disable-multifile --disable-multipart --disable-replaygain --disable-rtpmanager --disable-rtsp --disable-shapewipe --disable-smpte --disable-spectrum --disable-videobox --disable-videocrop --disable-videofilter --disable-videomixer --disable-wavenc --disable-wavparse --disable-y4m --disable-oss4 --disable-oss
sb2 make install

echo *****************additional plugins********************

#newest version gst-dsp, differs from Felipe Contreras version. Fixes some compile problems and bugs:
echo "Compiling gst-dsp."
cd ~/ctmp_light
wget http://dinstech.nl/uploads/mavlab/gst-dsp.tgz
tar -xzf gst-dsp.tgz
cd gst-dsp
export PATH=/opt/arm_light/gst/bin:$PATH
export PKG_CONFIG_PATH=/opt/arm_light/gst/lib/pkgconfig
make clean
sb2 make
mv libgstdsp.so /opt/arm_light/gst/lib/gstreamer-0.10

#test plugin
echo "Compiling test plugin."
cd ~/ctmp_light
wget http://dinstech.nl/uploads/mavlab/gst-example-plugin.tgz
tar -xzf gst-example-plugin.tgz
cd gst-plugin_example
export PATH=/opt/arm_light/gst/bin:$PATH
export PKG_CONFIG_PATH=/opt/arm_light/gst/lib/pkgconfig
sb2 make clean install

#copy the needed dsp binarie files:
cd ~/ctmp_light
wget http://dinstech.nl/uploads/mavlab/tidsp.tgz
cp tidsp.tgz /opt/arm_light/
cd /opt/arm_light/
tar -xzf tidsp.tgz
mv tidsp tidsp-binaries-23.i3.8

echo "create tarbal of compiled framework"
cd ~/ctmp_light
tar -cvzf arm_light_full.tgz /opt/arm_light/

#TODO:
#ftp it to drone
#untar on the drone to /opt/arm_light




export PATH=/opt/arm_light/gst/bin:$PATH
export PKG_CONFIG_PATH=/opt/arm_light/gst/lib/pkgconfig
export LD_LIBRARY_PATH=/opt/arm_light/gst/lib:$LD_LIBRARY_PATH

#opencv!
cd ~/ctmp_light
wget https://github.com/Itseez/opencv/archive/2.4.6.1.tar.gz
mv 2.4.6.1.tar.gz opencv-2.4.6.1.tar.gz
tar -xf opencv-2.4.6.1.tar.gz
cd opencv-2.4.6.1
wget http://dinstech.nl/uploads/mavlab/cap_gstreamer.cpp
mv cap_gstreamer.cpp modules/highgui/src/ 
mkdir build
cd build/
sb2 cmake -D BUILD_opencv_gpu=OFF -D BUILD_DOCS=OFF -D BUILD_TESTS=OFF -D WITH_OPENCL=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_EXAMPLES=OFF -D WITH_CUDA=OFF -D BUILD_opencv_gpu=OFF -D BUILD_opencv_gpuarithm=OFF -D BUILD_opencv_gpubgsegm=OFF -D BUILD_opencv_gpucodec=OFF -D BUILD_opencv_gpufeatures2d=OFF -D BUILD_opencv_gpufilters=OFF -D BUILD_opencv_gpuimgproc=OFF -D BUILD_opencv_gpulegacy=OFF -D BUILD_opencv_gpuoptflow=OFF -D BUILD_opencv_gpustereo=OFF -D BUILD_opencv_gpuwarping=OFF  cmake -D WITH_OPENCL=OFF -D WITH_CUDA=OFF -D BUILD_opencv_gpu=OFF -D BUILD_opencv_gpuarithm=OFF -D BUILD_opencv_gpubgsegm=OFF -D BUILD_opencv_gpucodec=OFF -D BUILD_opencv_gpufeatures2d=OFF -D BUILD_opencv_gpufilters=OFF -D BUILD_opencv_gpuimgproc=OFF -D BUILD_opencv_gpulegacy=OFF -D BUILD_opencv_gpuoptflow=OFF -D BUILD_opencv_gpustereo=OFF -D BUILD_opencv_gpuwarping=OFF -D CMAKE_CXX_COMPILER="g++" -D CMAKE_C_COMPILER="gcc" -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/opt/arm_light/gst ..
sb2 make install/strip


