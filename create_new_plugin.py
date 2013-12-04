#!/usr/bin/env python

import sys
import os

if (len(sys.argv) <= 1) :
    print("Error: Please specify a plugin name\ncreate_new_plugin.py <NAME>\n")
    sys.exit()

name = str(sys.argv[1])
dirname = "../modules/" + name + "/gst_plugin/"
print("Creating new GStreamer pluging called: '" + name + "' in '" + dirname + "'")


# Function definition is here
def copy_and_convert( fn_in, fn_out ):
    infile = open(fn_in)
    outfile = open(fn_out, 'w')

    replacements = {'%%%pluginname%%%':name.lower(), '%%%Pluginname%%%':name, '%%%PLUGINNAME%%%':name.upper()}

    for line in infile:
        for src, target in replacements.iteritems():
            line = line.replace(src, target)
        outfile.write(line)
    infile.close()
    outfile.close
    return;


os.makedirs(dirname)

templates = './gst_plugin_framework/template/'
copy_and_convert(templates + 'gst_plugin_template.h', dirname + 'gst_' + name.lower() + '_plugin.h')
copy_and_convert(templates + 'gst_plugin_template.c', dirname + 'gst_' + name.lower() + '_plugin.c')
copy_and_convert(templates + 'plugin_code.h', dirname + name.lower() + '_code.h')
copy_and_convert(templates + 'plugin_code.c', dirname + name.lower() + '_code.c')
copy_and_convert(templates + 'Makefile', dirname + 'Makefile')



