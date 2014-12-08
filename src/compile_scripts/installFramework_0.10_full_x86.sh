sudo rm -rf ~/ctmpx86_full
sudo rm -rf /opt/x86_full/gst
set -ex

export PKG_CONFIG_PATH=/opt/x86_full/gst/lib/pkgconfig
export PATH=/opt/x86_full/gst/bin:$PATH
export LD_LIBRARY_PATH=/opt/x86_full/gst/bin:$LD_LIBRARY_PATH

mkdir -p ~/ctmpx86_full
sudo mkdir -p /opt/x86_full
sudo chown houjebek /opt/x86_full

echo *****************dependacies for gstreamer framework********************

echo "zlib - needed by GLib’s gio"
cd ~/ctmpx86_full
wget -c http://zlib.net/zlib-1.2.8.tar.gz
tar -xf zlib-1.2.8.tar.gz
cd zlib-1.2.8
 ./configure --prefix=/opt/x86_full/gst
 make install

echo "libffi  - needed by glib"
cd ~/ctmpx86_full
wget -c ftp://sourceware.org/pub/libffi/libffi-3.0.13.tar.gz
tar -xf libffi-3.0.13.tar.gz
cd libffi-3.0.13
 ./configure --prefix=/opt/x86_full/gst
 make install

echo "python2.7, Ubuntu 12.04 has some problem without it" 
cd ~/ctmpx86_full
wget http://www.python.org/ftp/python/2.7.5/Python-2.7.5.tar.xz
tar -xf Python-2.7.5.tar.xz
cd Python-2.7.5
./configure --prefix=/opt/x86_full/gst
make install

echo "glib"
cd ~/ctmpx86_full
wget https://git.gnome.org/browse/glib/snapshot/glib-2.40.2.tar.xz
tar -xf glib-2.40.2.tar.xz
cd glib-2.40.2
./autogen.sh
 ./configure --prefix=/opt/x86_full/gst --disable-static --with-python=/opt/x86_full/gst/bin/python2.7
 make install

echo ***************** gstreamer framework part 1********************

echo "gstreamer"
sudo apt-get -y install bison flex yasm libglib2.0-dev autopoint
cd ~/ctmpx86_full
wget -c http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-0.10.36.tar.xz
tar -xf gstreamer-0.10.36.tar.xz
cd gstreamer-0.10.36
wget http://dinstech.nl/uploads/mavlab/grammar.txt
mv grammar.txt ./gst/parse/grammar.y
./autogen.sh --noconfigure
 ./configure --prefix=/opt/x86_full/gst --disable-nls --disable-static --disable-gobject-cast-checks --disable-loadsave --disable-trace --with-html-dir=/tmp/dump
 make install

# echo "liboil"
# echo "Needed by many GStreamer components."
# cd ~/ctmpx86_full
# wget -c http://liboil.freedesktop.org/download/liboil-0.3.17.tar.gz
# tar -xf liboil-0.3.17.tar.gz
# cd liboil-0.3.17
# #./autogen.sh #--noconfigure #geeft een of andere error, geen idee of probleem
#  ./configure --prefix=/opt/x86_full/gst --disable-static --with-html-dir=/tmp/dump
# sudo  make install

echo "orc, replaces liboil"
cd ~/ctmpx86_full
wget -c http://cgit.freedesktop.org/gstreamer/orc/snapshot/orc-0.4.17.tar.gz
tar -xf orc-0.4.17.tar.gz
cd orc-0.4.17
./autogen.sh
 ./configure --prefix=/opt/x86_full/gst --disable-static --with-html-dir=/tmp/dump
make install

echo *****************needed for theora enc********************
echo "lib ogg"
cd ~/ctmpx86_full
wget http://downloads.xiph.org/releases/ogg/libogg-1.3.1.tar.gz
tar -xf libogg-1.3.1.tar.gz
cd libogg-1.3.1/ 
 ./configure --prefix=/opt/x86_full/gst --disable-static
make install

echo "lib vorbis"
cd ~/ctmpx86_full
wget http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.3.tar.gz
tar -xf libvorbis-1.3.3.tar.gz
cd libvorbis-1.3.3/ 
./autogen.sh
 ./configure --prefix=/opt/x86_full/gst --disable-static
make install

echo "lib theora enc"
cd ~/ctmpx86_full
wget http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2
tar -xf libtheora-1.1.1.tar.bz2
cd libtheora-1.1.1/ 
./autogen.sh
 ./configure --prefix=/opt/x86_full/gst --disable-static
make install

#echo *****************Zbar***********************
cd ~/ctmpx86_full
wget http://sourceforge.net/projects/zbar/files/zbar/0.10/zbar-0.10.tar.bz2/download -O zbar-0.10.tar.bz2
tar -xf zbar-0.10.tar.bz2
cd zbar-0.10/
export CFLAGS=""
./configure --prefix=/opt/x86_full/gst --without-gtk --without-qt --without-python --without-imagemagick --disable-video --includedir=/opt/x86_full/gst/include --oldincludedir=/opt/x86_full/gst/include
make install
unset CFLAGS

echo *****************gstreamer framework part 2********************
echo "gst-plugins-base"
cd ~/ctmpx86_full
wget -c http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-0.10.36.tar.gz
tar -xf gst-plugins-base-0.10.36.tar.gz
cd gst-plugins-base-0.10.36
./autogen.sh --noconfigure
 ./configure --prefix=/opt/x86_full/gst --disable-nls --disable-static --with-html-dir=/tmp/dump
make install

echo "gst-plugins-good"
sudo apt-get -y install g++
cd ~/ctmpx86_full
wget -c http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-0.10.31.tar.xz
tar -xf gst-plugins-good-0.10.31.tar.xz
cd gst-plugins-good-0.10.31
wget http://dinstech.nl/uploads/mavlab/gstv4l2bufferpool_x86hacked.c #different fix than with arm!
mv gstv4l2bufferpool_x86hacked.c sys/v4l2/gstv4l2bufferpool.c
./autogen.sh --noconfigure
./configure --prefix=/opt/x86_full/gst --disable-nls --disable-static --with-html-dir=/tmp/dump --disable-gst_v4l2 #--with-plugins=avi,qtdemux
make clean install

echo "gst-plugins-bad"
cd ~/ctmpx86_full
wget http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-0.10.23.tar.xz
tar -xf gst-plugins-bad-0.10.23.tar.xz
cd gst-plugins-bad-0.10.23
./autogen.sh --noconfigure
 ./configure --prefix=/opt/x86_full/gst --disable-nls --disable-static --with-html-dir=/tmp/dump
make clean install

echo "gst-plugins-ugly"
cd ~/ctmpx86_full
wget http://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-0.10.19.tar.xz
tar -xf gst-plugins-ugly-0.10.19.tar.xz
cd gst-plugins-ugly-0.10.19
./autogen.sh --noconfigure
 ./configure --prefix=/opt/x86_full/gst --with-html-dir=/tmp/dump --disable-nls --disable-static
make install

echo *****************additional plugins********************

echo "gst-mmpeg"
cd ~/ctmpx86_full
wget http://gstreamer.freedesktop.org/src/gst-ffmpeg/gst-ffmpeg-0.10.13.tar.gz
tar -xf gst-ffmpeg-0.10.13.tar.gz
cd gst-ffmpeg-0.10.13
wget https://github.com/openembedded/oe-core/raw/master/meta/recipes-multimedia/gstreamer/gst-ffmpeg-0.10.13/h264_qpel_mmx.patch
patch -Np1 -i h264_qpel_mmx.patch
./autogen.sh --noconfigure
./configure --prefix=/opt/x86_full/gst --disable-static --with-html-dir=/tmp/dump
make install

#test plugin
echo "Compiling test plugin."
cd ~/ctmpx86_full
wget http://dinstech.nl/uploads/mavlab/gst-example-plugin.tgz
tar -xzf gst-example-plugin.tgz
cd gst-plugin_example
export PATH=/opt/x86_full/gst/bin:$PATH
export PKG_CONFIG_PATH=/opt/x86_full/gst/lib/pkgconfig
make PROCESSOR=x86 clean install

echo "create tarbal of compiled framework"
cd ~/ctmpx86_full
tar -cvzf x86_full_full.tgz /opt/x86_full/




