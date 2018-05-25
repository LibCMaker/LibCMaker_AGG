# ****************************************************************************
#  Project:  LibCMaker_AGG
#  Purpose:  A CMake build script for Anti-Grain Geometry (AGG) library
#  Author:   NikitaFeodonit, nfeodonit@yandex.com
# ****************************************************************************
#    Copyright (c) 2017-2018 NikitaFeodonit
#
#    This file is part of the LibCMaker_AGG project.
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published
#    by the Free Software Foundation, either version 3 of the License,
#    or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program. If not, see <http://www.gnu.org/licenses/>.
# ****************************************************************************

include(cmr_print_fatal_error)

function(cmr_agg_get_download_params
    version
    out_url out_sha out_src_dir_name out_tar_file_name)

  # We get the source tar file from an unofficial place,
  # so as not to depend on the "svn" program.
  set(lib_base_url "https://github.com/LibCMaker/LibCMaker_AGG_Sources/archive")

  # Version format is major.minor.patch where patch is svn commit number, r128.
  if(version VERSION_EQUAL "2.4.128")
    set(lib_sha
      "abb572a59013c9eb81cba84a4e2d08e279e224b33f8f5e7169482b043ae0cb71")
  endif()

  if(NOT DEFINED lib_sha)
    cmr_print_fatal_error("Library version ${version} is not supported.")
  endif()

  set(lib_src_name "LibCMaker_AGG_Sources-${version}")
  set(lib_tar_file_name "${lib_src_name}.tar.gz")
  set(lib_url "${lib_base_url}/v${version}.tar.gz")

  set(${out_url} "${lib_url}" PARENT_SCOPE)
  set(${out_sha} "${lib_sha}" PARENT_SCOPE)
  set(${out_src_dir_name} "${lib_src_name}" PARENT_SCOPE)
  set(${out_tar_file_name} "${lib_tar_file_name}" PARENT_SCOPE)
endfunction()
