mount /dev/sda1 /opt
export PATH=/opt/arm/gst/bin:$PATH
mount --bind /opt /data/video/kevin/usb

#clear debug info:
dmesg -c

export DSP_PATH=/bin/dsp
/bin/dspbridge/cexec.out -T /bin/dsp/baseimage.dof -v
/bin/dspbridge/dynreg.out -r /bin/dsp/720p_h264venc_sn.dll64P -v

#ftp server start:
inetd


GST_DEBUG=dsp*:2 gst-launch v4l2src device=/dev/video1 ! dsph264enc ! rtph264pay! udpsink host=192.168.1.3 port=5000