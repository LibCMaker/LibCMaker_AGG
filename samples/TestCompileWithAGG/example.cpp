// This code is based on the
// http://www.antigrain.com/doc/basic_renderers/basic_renderers.agdoc.html#toc0012

#include <string>

#include "agg_pixfmt_rgb.h"
#include "agg_renderer_base.h"

int main()
{
  using pixfmt_type = agg::pixfmt_rgb24;
  using renbase_type = agg::renderer_base<pixfmt_type>;
  using renderer_color = typename renbase_type::color_type;

  enum
  {
    BYTES_PER_PIXEL = 3
  };

  int frame_width = 250;
  int frame_height = 50;
  int stride = frame_width * BYTES_PER_PIXEL;
  unsigned char* frame_buf = new unsigned char[stride * frame_height];

  agg::rendering_buffer rbuf(frame_buf, frame_width, frame_height, stride);
  pixfmt_type pixf(rbuf);
  renbase_type rbase(pixf);

  renderer_color clear_color;
  clear_color.clear();
  clear_color.opacity(255.0 / 255.0);
  clear_color.r = 255;
  clear_color.g = 255;
  clear_color.b = 255;

  rbase.clear(clear_color);

  delete[] frame_buf;
}
