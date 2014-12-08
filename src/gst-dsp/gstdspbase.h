/*
 * Copyright (C) 2009-2010 Felipe Contreras
 *
 * Author: Felipe Contreras <felipe.contreras@gmail.com>
 *
 * This file may be used under the terms of the GNU Lesser General Public
 * License version 2.1, a copy of which is found in LICENSE included in the
 * packaging of this file.
 */

#ifndef GST_DSP_BASE_H
#define GST_DSP_BASE_H

#include <gst/gst.h>

G_BEGIN_DECLS

#define GST_DSP_BASE(obj) (GstDspBase *)(obj)
#define GST_DSP_BASE_TYPE (gst_dsp_base_get_type())
#define GST_DSP_BASE_CLASS(obj) (GstDspBaseClass *)(obj)
#define GST_DSP_BASE_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS((obj), GST_DSP_BASE_TYPE, GstDspBaseClass))

/* #define TS_COUNT */

typedef struct _GstDspBase GstDspBase;
typedef struct _GstDspBaseClass GstDspBaseClass;

typedef struct du_port_t du_port_t;

#include "dmm_buffer.h"
#include "sem.h"
#include "async_queue.h"

struct td_buffer;

typedef void (*port_buffer_cb_t) (GstDspBase *base, struct td_buffer *tb);

struct td_buffer {
	struct du_port_t *port;
	dmm_buffer_t *data;
	dmm_buffer_t *comm;
	dmm_buffer_t *params;
	void *user_data;
	bool keyframe;
	bool pinned;
	bool clean;
};

struct du_port_t {
	int id;
	struct td_buffer *buffers;
	guint num_buffers;
	AsyncQueue *queue;
	port_buffer_cb_t send_cb;
	port_buffer_cb_t recv_cb;
	int dir;
};

struct td_codec {
	const struct dsp_uuid *uuid;
	const char *filename;
	void (*setup_params)(GstDspBase *base);
	void (*create_args)(GstDspBase *base, unsigned *profile_id, void **arg_data);
	bool (*handle_extra_data)(GstDspBase *base, GstBuffer *buf);
	void (*flush_buffer)(GstDspBase *base);
	void (*send_params)(GstDspBase *base, struct dsp_node *node);
	void (*update_params) (GstDspBase *base, struct dsp_node *node, uint32_t msg);
	unsigned (*get_latency)(GstDspBase *base, unsigned frame_duration);
};

struct ts_item {
	GstClockTime time;
	GstClockTime duration;
	GstEvent *event;
};

struct _GstDspBase {
	GstElement element;

	GstPad *sinkpad, *srcpad;

	struct td_codec *codec;
	int dsp_handle;
	void *proc;
	struct dsp_node *node;
	struct dsp_notification *events[3];

	GstFlowReturn status;
	unsigned long input_buffer_size;
	unsigned long output_buffer_size;
	GThread *dsp_thread, *out_thread;
	gboolean done;
	int deferred_eos;
	int eos;

	du_port_t *ports[2];
	dmm_buffer_t *alg_ctrl;
	struct ts_item ts_array[20];
	guint ts_in_pos, ts_out_pos, ts_push_pos;
	GMutex *ts_mutex;
	gulong ts_count;
	GstClockTime default_duration;
	GSem *flush;
	guint alg;

	gboolean use_pad_alloc; /**< Use pad_alloc for output buffers. */
	gboolean use_pinned; /**< Reuse output buffers. */
	guint dsp_error;

	void *(*create_node)(GstDspBase *base);
	bool (*parse_func)(GstDspBase *base, GstBuffer *buf);
	void (*pre_process_buffer)(GstDspBase *base, GstBuffer *buf);
	void (*reset)(GstDspBase *base);
	void (*flush_buffer)(GstDspBase *base);
	void (*got_message)(GstDspBase *self, struct dsp_msg *msg);
	bool (*send_buffer)(GstDspBase *self, struct td_buffer *tb);
	bool (*send_play_message)(GstDspBase *self);
	bool (*send_stop_message)(GstDspBase *self);
	GstCaps *tmp_caps;

	struct timespec eos_start;
	gint eos_timeout; /* how much to wait for the EOS from DSP (ms) */

	GstBuffer *codec_data;
	bool parsed;

	/* hacks */
	guint skip_hack; /* don't push x number of buffers */
	guint skip_hack_2; /* don't process x number of buffers */
};

struct _GstDspBaseClass {
	GstElementClass parent_class;

	gboolean (*sink_event)(GstDspBase *base, GstEvent *event);
	gboolean (*src_event)(GstDspBase *base, GstEvent *event);
};

GType gst_dsp_base_get_type(void);

du_port_t *du_port_new(int id, int dir);
void du_port_free(du_port_t *p);
void du_port_alloc_buffers(du_port_t *p, guint num_buffers);

gboolean gstdsp_start(GstDspBase *self);
gboolean gstdsp_send_codec_data(GstDspBase *self, GstBuffer *buf);
gboolean gstdsp_set_codec_data_caps(GstDspBase *base, GstBuffer *buf);
gboolean gstdsp_reinit(GstDspBase *base);
void gstdsp_got_error(GstDspBase *self, guint id, const char *message);
void gstdsp_post_error(GstDspBase *self, const char *message);
void gstdsp_send_alg_ctrl(GstDspBase *self, struct dsp_node *node, dmm_buffer_t *b);
void gstdsp_base_flush_buffer(GstDspBase *self);

typedef void (*gstdsp_setup_params_func)(GstDspBase *base, dmm_buffer_t *b);

static inline void gstdsp_port_setup_params(GstDspBase *self,
					    du_port_t *p,
					    size_t size,
					    gstdsp_setup_params_func func)
{
	unsigned i;
	for (i = 0; i < p->num_buffers; i++) {
		dmm_buffer_t *b;
		b = dmm_buffer_calloc(self->dsp_handle,
				      self->proc, size, DMA_BIDIRECTIONAL);
		if (func)
			func(self, b);
		dmm_buffer_map(b);
		p->buffers[i].params = b;
	}
}

/* this is saner than gst_pad_set_caps() */
static inline bool gst_pad_take_caps(GstPad *pad, GstCaps *caps)
{
	bool ret;
	ret = gst_pad_set_caps(pad, caps);
	gst_caps_unref(caps);
	return ret;
}

extern struct td_codec td_mp4vdec_codec;
extern struct td_codec td_h264dec_codec;
extern struct td_codec td_wmvdec_codec;
extern struct td_codec td_jpegdec_codec;

extern struct td_codec td_mp4venc_codec;
extern struct td_codec td_jpegenc_codec;
extern struct td_codec td_h264enc_codec;

extern struct td_codec td_vpp_codec;
extern struct td_codec td_aacdec_codec;

G_END_DECLS

#endif /* GST_DSP_BASE_H */
