#

ffplay:
	ffplay udp://192.168.1.3:5000

gst:
	gst-launch-0.10 -vvv udpsrc port=5000 caps="application/x-rtp" ! rtpmp4vdepay ! ffdec_mpeg4 ! xvimagesink
	#gst-launch-0.10 -vvv playbin uri=file:///home/mavlab/paparazzi/sw/ext/ardrone2_vision/ardrone2_gstreamer/sdp/x86_config-mp4.sdp

gstrecord:
	gst-launch-0.10 udpsrc caps="application/x-rtp,framerate=15/1" port=5000 ! rtpmp4vdepay ! ffdec_mpeg4 ! tee name=x ! xvimagesink x. ! queue ! ffenc_mpeg4 ! filesink location=/tmp/xx.mp4

cvlc:
	cvlc file:///home/mavlab/paparazzi/sw/ext/ardrone2_vision/ardrone2_gstreamer/sdp/x86_config-h264.sdp

