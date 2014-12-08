#sudo rm -rf ~/ctmp
sudo rm -rf /opt/arm/gst
set -ex
export PKG_CONFIG_PATH=/opt/arm/gst/lib/pkgconfig

mkdir -p ~/ctmp
sudo mkdir -p /opt/arm
sudo chown houjebek /opt/arm


echo *****************dependacies for gstreamer framework********************

echo "zlib - needed by GLib’s gio"
cd ~/ctmp
wget -c http://zlib.net/zlib-1.2.8.tar.gz
tar -xf zlib-1.2.8.tar.gz
cd zlib-1.2.8
sb2 ./configure --prefix=/opt/arm/gst
sb2 make install

echo "libffi  - needed by glib"
cd ~/ctmp
wget -c ftp://sourceware.org/pub/libffi/libffi-3.0.13.tar.gz
tar -xf libffi-3.0.13.tar.gz
cd libffi-3.0.13
sb2 ./configure --prefix=/opt/arm/gst
sb2 make install

echo "python2.7, Ubuntu 12.04 has some problem without it" 
cd ~/ctmp
wget http://www.python.org/ftp/python/2.7.5/Python-2.7.5.tar.xz
tar -xf Python-2.7.5.tar.xz
cd Python-2.7.5
sb2 ./configure --prefix=/opt/arm/gst
sb2 make install

echo "glib"
cd ~/ctmp
wget -c https://git.gnome.org/browse/glib/snapshot/glib-2.36.2.tar.gz
tar -xf glib-2.36.2.tar.gz
cd glib-2.36.2
./autogen.sh
sb2 ./configure --prefix=/opt/arm/gst --disable-static --with-python=/opt/arm/gst/bin/python2.7
sb2 make install

echo ***************** gstreamer framework part 1********************

echo "gstreamer"
sudo apt-get -y install bison flex yasm libglib2.0-dev autopoint
cd ~/ctmp
wget -c http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-0.10.36.tar.xz
tar -xf gstreamer-0.10.36.tar.xz
cd gstreamer-0.10.36
wget http://dinstech.nl/uploads/mavlab/grammar.txt
mv grammar.txt ./gst/parse/grammar.y
./autogen.sh --noconfigure
sb2 ./configure --prefix=/opt/arm/gst --disable-nls --disable-static --disable-gobject-cast-checks --disable-loadsave --disable-trace --with-html-dir=/tmp/dump
sb2 make install

# echo "liboil"
# echo "Needed by many GStreamer components."
# cd ~/ctmp
# wget -c http://liboil.freedesktop.org/download/liboil-0.3.17.tar.gz
# tar -xf liboil-0.3.17.tar.gz
# cd liboil-0.3.17
# #./autogen.sh #--noconfigure #geeft een of andere error, geen idee of probleem
# sb2 ./configure --prefix=/opt/arm/gst --disable-static --with-html-dir=/tmp/dump
# sudo sb2 make install

echo "orc, replaces liboil"
cd ~/ctmp
wget -c http://cgit.freedesktop.org/gstreamer/orc/snapshot/orc-0.4.17.tar.gz
tar -xf orc-0.4.17.tar.gz
cd orc-0.4.17
./autogen.sh
sb2 ./configure --prefix=/opt/arm/gst --disable-static --with-html-dir=/tmp/dump
sb2 make install

echo *****************needed for theora enc********************
echo "lib ogg"
cd ~/ctmp
wget http://downloads.xiph.org/releases/ogg/libogg-1.3.1.tar.gz
tar -xf libogg-1.3.1.tar.gz
cd libogg-1.3.1/ 
sb2 ./configure --prefix=/opt/arm/gst --disable-static
sb2 make install

echo "lib vorbis"
cd ~/ctmp
wget http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.3.tar.gz
tar -xf libvorbis-1.3.3.tar.gz
cd libvorbis-1.3.3/ 
./autogen.sh
sb2 ./configure --prefix=/opt/arm/gst --disable-static
sb2 make install

echo "lib theora enc"
cd ~/ctmp
wget http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2
tar -xf libtheora-1.1.1.tar.bz2
cd libtheora-1.1.1/ 
./autogen.sh
sb2 ./configure --prefix=/opt/arm/gst --disable-static
sb2 make install

echo *****************Zbar***********************
cd ~/ctmp
wget http://sourceforge.net/projects/zbar/files/zbar/0.10/zbar-0.10.tar.bz2/download -O zbar-0.10.tar.bz2
tar -xf zbar-0.10.tar.bz2
cd zbar-0.10/
sb2 ./configure --prefix=/opt/arm/gst --without-gtk --without-qt --without-python --without-imagemagick
sb2 make install

echo *****************gstreamer framework part 2********************
echo "gst-plugins-base"
cd ~/ctmp
wget -c http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-0.10.36.tar.gz
tar -xf gst-plugins-base-0.10.36.tar.gz
cd gst-plugins-base-0.10.36
./autogen.sh --noconfigure
sb2 ./configure --prefix=/opt/arm/gst --disable-nls --disable-static --with-html-dir=/tmp/dump
sb2 make install

echo "gst-plugins-good"
sudo apt-get -y install g++
cd ~/ctmp
wget -c http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-0.10.31.tar.xz
tar -xf gst-plugins-good-0.10.31.tar.xz
cd gst-plugins-good-0.10.31
#fix the "bug" that calls an uunsupported feature of the v4l2 driver
wget http://dinstech.nl/uploads/mavlab/v4l2src_calls_hacked.c
mv v4l2src_calls_hacked.c ~/ctmp/gst-plugins-good-0.10.31/sys/v4l2/v4l2src_calls.c
wget http://dinstech.nl/uploads/mavlab/gstv4l2object_hacked.c
mv gstv4l2object_hacked.c ~/ctmp/gst-plugins-good-0.10.31/sys/v4l2/gstv4l2object.c
./autogen.sh --noconfigure
sb2 ./configure --prefix=/opt/arm/gst --disable-nls --disable-static --with-html-dir=/tmp/dump #--with-plugins=avi,qtdemux
sb2 make install

echo "gst-plugins-bad"
cd ~/ctmp
wget http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-0.10.23.tar.xz
tar -xf gst-plugins-bad-0.10.23.tar.xz
cd gst-plugins-bad-0.10.23
./autogen.sh --noconfigure
sb2 ./configure --prefix=/opt/arm/gst --disable-nls --disable-static --with-html-dir=/tmp/dump
# sb2 ./configure --prefix=/opt/arm/gst --disable-nls --disable-static --with-html-dir=/tmp/dump --disable-adpcmdec --disable-adpcmdec --disable-adpcmenc --disable-aiff --disable-asfmux --disable-audiovisualizers --disable-autoconvert --disable-bayer --disable-camerabin --disable-camerabin2 --disable-cdxaparse --disable-coloreffects --disable-colorspace --disable-dataurisrc --disable-dccp --disable-debugutils --disable-dtmf --disable-dvbsuboverlay --disable-dvdspu --disable-faceoverlay --disable-festival --disable-fieldanalysis --disable-freeverb --disable-freeze --disable-frei0r --disable-gaudieffects --disable-geometrictransform --disable-h264parse --disable-hdvparse --disable-hls --disable-id3tag --disable-inter --disable-interlace --disable-ivfparse --disable-jp2kdecimator --disable-jpegformat --disable-legacyresample --disable-librfb --disable-liveadder --disable-mpegdemux --disable-mpegpsmux --disable-mpegtsdemux --disable-mpegtsmux --disable-mpegvideoparse --disable-mve --disable-mxf --disable-nsf --disable-nuvdemux --disable-patchdetect --disable-pcapparse --disable-pnm --disable-rawparse --disable-removesilence --disable-rtpmux --disable-rtpvp8 --disable-scaletempo --disable-sdi --disable-sdp --disable-segmentclip --disable-siren --disable-smooth --disable-speed --disable-stereo --disable-suben --disable-tta --disable-videofilters --disable-videomaxrate --disable-videomeasure --disable-videoparsers --disable-videosignal --disable-vmnc --disable-y4m --disable-real --disable-decklink --disable-dvb --disable-fbdevsink --disable-gsettings --disable-linsys --disable-shm --disable-vcdsrc
sb2 make install

echo "x264, does not work yet"
cd ~/ctmp
# git clone git://git.videolan.org/x264.git
# cd x264
wget ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20110904-2245-stable.tar.bz2
tar -xf x264-snapshot-20110904-2245-stable.tar.bz2
cd x264-snapshot-20110904-2245-stable
sb2 ./configure --prefix=/opt/arm/gst
sb2 make install

echo "gst-plugins-ugly"
cd ~/ctmp
wget http://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-0.10.19.tar.xz
tar -xf gst-plugins-ugly-0.10.19.tar.xz
cd gst-plugins-ugly-0.10.19
./autogen.sh --noconfigure
sb2 ./configure --prefix=/opt/arm/gst --with-html-dir=/tmp/dump --disable-nls --disable-static
sb2 make install

echo *****************additional plugins********************

echo "gst-mmpeg"
cd ~/ctmp
wget http://gstreamer.freedesktop.org/src/gst-ffmpeg/gst-ffmpeg-0.10.13.tar.gz
tar -xf gst-ffmpeg-0.10.13.tar.gz
cd gst-ffmpeg-0.10.13
./autogen.sh --noconfigure
sb2 ./configure --prefix=/opt/arm/gst --disable-nls --disable-static --with-html-dir=/tmp/dump
sb2 make install

#newest version gst-dsp, original from Felipe git
#does not work automatically, hacks are required to run manually!
#instead, one can also use the personal svn version
#echo "gst-dsp, needed to run encoding on dsp. Does not work 100% yet"
#export PATH=/opt/arm/gst/bin:$PATH
#cd ~/ctmp
#export PKG_CONFIG_PATH=/opt/arm/gst/lib/pkgconfig
#git clone git://github.com/felipec/gst-dsp.git
#cd gst-dsp
#git checkout -b stable v0.10.2 #is currently the newest version
#sb2 ./configure --prefix=/opt/arm/gst
#hack the Makefile:
#override CFLAGS += -std=c99 -D_GNU_SOURCE -DGST_DISABLE_DEPRECATED -mcpu=cortex-a8 -mfpu=neon -mfloat-abi=softfp -ftree-vectorize
#hack  Makefile.conf:
#GST_LIBS := -L/opt/arm/gst/lib -lgstreamer-0.10 -lgobject-2.0 -lgmodule-2.0 -pthread -lrt -lgthread-2.0 -pthread -lrt -lglib-2.0 -lffi
#sb2 make
#sudo mv libgstdsp.so /opt/arm/gst/lib/gstreamer-0.10


#newest version gst-dsp, differs from Felipe Contreras version. Fixes some compile problems and bugs:
echo "Compiling gst-dsp."
cd ~/ctmp
wget http://dinstech.nl/uploads/mavlab/gst-dsp.tgz
tar -xzf gst-dsp.tgz
cd gst-dsp
export PATH=/opt/arm/gst/bin:$PATH
export PKG_CONFIG_PATH=/opt/arm/gst/lib/pkgconfig
make clean
sb2 make
mv libgstdsp.so /opt/arm/gst/lib/gstreamer-0.10

#test plugin
echo "Compiling test plugin."
cd ~/ctmp
wget http://dinstech.nl/uploads/mavlab/gst-example-plugin.tgz
tar -xzf gst-example-plugin.tgz
cd gst-plugin_example
export PATH=/opt/arm/gst/bin:$PATH
export PKG_CONFIG_PATH=/opt/arm/gst/lib/pkgconfig
sb2 make clean install

#copy the needed dsp binarie files:
cd ~/ctmp
wget http://dinstech.nl/uploads/mavlab/tidsp.tgz
cp tidsp.tgz /opt/arm/
cd /opt/arm/
tar -xzf tidsp.tgz
mv tidsp tidsp-binaries-23.i3.8

echo "create tarbal of compiled framework"
cd ~/ctmp
tar -cvzf arm_full.tgz /opt/arm/

#TODO:
#ftp it to drone
#untar on the drone to /opt/arm






