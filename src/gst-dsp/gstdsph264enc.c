/*
 * Copyright (C) 2009-2010 Felipe Contreras
 * Copyright (C) 2009-2010 Nokia Corporation
 *
 * Authors:
 * Juha Alanen <juha.m.alanen@nokia.com>
 * Felipe Contreras <felipe.contreras@nokia.com>
 *
 * This file may be used under the terms of the GNU Lesser General Public
 * License version 2.1, a copy of which is found in LICENSE included in the
 * packaging of this file.
 */

#include "gstdsph264enc.h"
#include "plugin.h"

#include "util.h"
#include "dsp_bridge.h"

#include "log.h"

#define GST_CAT_DEFAULT gstdsp_debug

/*
 * H.264 supported levels
 * Source http://www.itu.int/rec/T-REC-H.264-201003-I/ page 294 - Annex A table A-1
 * the bitrates of the last 2 levels is not up to standard due to encdoder
 * limitations.
 */

static struct gstdsp_codec_level levels[] = {
	{10,  99,   1485 ,   64000 },         /* Level 1 -     QCIF@15fps  */
	{10,  99,   1485 ,  128000 },         /* Level 1b -     QCIF@15fps */
	{11,  396,  3000 ,  192000 },         /* Level 1.1 -    QCIF@30fps */
	{12,  396,  6000 ,  384000 },         /* Level 1.2 -     CIF@15fps */
	{13,  396, 11880 ,  768000 },         /* Level 1.3-      CIF@30fps */
	{20,  396, 11880 , 2000000 },         /* Level 2  -      CIF@30fps */
	{21,  792, 19800 , 4000000 },         /* Level 2.1 - 352x480@30fps */
	{22, 1620, 20250 , 4000000 },         /* Level 2.2 - 720x480@15fps */
	{30, 1620, 40500 , 8000000 },         /* Level 3 - D1@25/30fps (PAL/NTSC) --> 10Mbps */
	{31, 3600, 48600 , 8000000 },         /* Max supported (WVGA) - 864x480@30fps */
};

enum {
	ARG_0,
#ifdef GST_DSP_ENABLE_DEPRECATED
	ARG_BYTESTREAM,
#endif
};

static inline GstCaps *
generate_src_template(void)
{
	GstCaps *caps;
	GstStructure *struc;

	caps = gst_caps_new_empty();

	struc = gst_structure_new("video/x-h264",
				  NULL);

	gst_caps_append_structure(caps, struc);

	return caps;
}

static void
instance_init(GTypeInstance *instance,
	      gpointer g_class)
{
	GstDspBase *base = GST_DSP_BASE(instance);
	GstDspVEnc *self = GST_DSP_VENC(instance);
	base->alg = GSTDSP_H264ENC;
	base->codec = &td_h264enc_codec;

	self->priv.h264.bytestream = true;
	self->supported_levels = levels;
	self->nr_supported_levels = ARRAY_SIZE(levels);
	base->use_pinned = true;
}

static void
base_init(gpointer g_class)
{
	GstElementClass *element_class;
	GstPadTemplate *template;

	element_class = GST_ELEMENT_CLASS(g_class);

	gst_element_class_set_details_simple(element_class,
					     "DSP video encoder",
					     "Codec/Encoder/Video",
					     "Encodes H.264 video with TI's DSP algorithms",
					     "Juha Alanen");

	template = gst_pad_template_new("src", GST_PAD_SRC,
					GST_PAD_ALWAYS,
					generate_src_template());

	gst_element_class_add_pad_template(element_class, template);
	gst_object_unref(template);
}

static void
set_property(GObject *obj,
	     guint prop_id,
	     const GValue *value,
	     GParamSpec *pspec)
{
	GstDspVEnc *self G_GNUC_UNUSED = GST_DSP_VENC(obj);

	switch (prop_id) {
#ifdef GST_DSP_ENABLE_DEPRECATED
	case ARG_BYTESTREAM:
		self->priv.h264.bytestream = g_value_get_boolean(value);
		break;
#endif
	default:
		G_OBJECT_WARN_INVALID_PROPERTY_ID(obj, prop_id, pspec);
		break;
	}
}

static void
get_property(GObject *obj,
	     guint prop_id,
	     GValue *value,
	     GParamSpec *pspec)
{
	GstDspVEnc *self G_GNUC_UNUSED = GST_DSP_VENC(obj);

	switch (prop_id) {
#ifdef GST_DSP_ENABLE_DEPRECATED
	case ARG_BYTESTREAM:
		g_value_set_boolean(value, self->priv.h264.bytestream);
		break;
#endif
	default:
		G_OBJECT_WARN_INVALID_PROPERTY_ID(obj, prop_id, pspec);
		break;
	}
}

static void
class_init(gpointer g_class,
	   gpointer class_data)
{
	GObjectClass *gobject_class;
	gobject_class = G_OBJECT_CLASS(g_class);

	/* Properties stuff */
	gobject_class->set_property = set_property;
	gobject_class->get_property = get_property;

#ifdef GST_DSP_ENABLE_DEPRECATED
	g_object_class_install_property(gobject_class, ARG_BYTESTREAM,
					g_param_spec_boolean("bytestream", "BYTESTREAM", "bytestream",
							     true, G_PARAM_READWRITE));
#endif
}

GType
gst_dsp_h264enc_get_type(void)
{
	static GType type;

	if (G_UNLIKELY(type == 0)) {
		GTypeInfo type_info = {
			.class_size = sizeof(GstDspH264EncClass),
			.base_init = base_init,
			.class_init = class_init,
			.instance_size = sizeof(GstDspH264Enc),
			.instance_init = instance_init,
		};

		type = g_type_register_static(GST_DSP_VENC_TYPE, "GstDspH264Enc", &type_info, 0);
	}

	return type;
}
