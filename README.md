ARDrone2 gstreamer
==================

==GStreamer for ArDrone2==

=Folders=

 - bin: includes and arm-libraries for ardrone gstreamer
 - gst_plugin_framework: templates for gst plugins
 - sdp: session description protocol: example files to start your video sessions

==Scripts==

 - create_new_plugin.py: start a new plugin
 - ardrone2i.py: upload/install/start code on the drone in a safe way 
 - view_rtp_mp4_port5000.py: script to view an MP4 encoded RTP transported RTP via UDP port 5000 stream


Start New Plugin:
---------------

to create a new plugin, run the script **create_new_plugin.py <PlugInName>**. This will create a new directory and add a compiling pass-through plugin. The files are:

 - gst_PLUGINNAME_plugin.c/h -> the gstreamer interface, including settables
 - PLUGINNAME_code.c/h -> an empty project communicating with paparazzi to add your own code

