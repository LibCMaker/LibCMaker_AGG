/*****************************************************************************
 * Project:  LibCMaker_AGG
 * Purpose:  A CMake build script for Anti-Grain Geometry (AGG) library
 * Author:   NikitaFeodonit, nfeodonit@yandex.com
 *****************************************************************************
 *   Copyright (c) 2017-2019 NikitaFeodonit
 *
 *    This file is part of the LibCMaker_AGG project.
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published
 *    by the Free Software Foundation, either version 3 of the License,
 *    or (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *    See the GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program. If not, see <http://www.gnu.org/licenses/>.
 ****************************************************************************/

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
