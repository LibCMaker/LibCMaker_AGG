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

# Part of "LibCMaker/cmake/cmr_find_package.cmake".

  #-----------------------------------------------------------------------
  # Library specific build arguments.
  #-----------------------------------------------------------------------

## +++ Common part of the lib_cmaker_<lib_name> function +++
  set(find_LIB_VARS
    NOT_ADD_AGG_PLATFORM
    SKIP_BUILD_AGG_EXAMPLES
    SKIP_BUILD_AGG_MYAPP

    agg_USE_GPC
    agg_USE_FREETYPE
    agg_USE_EXPAT
    agg_USE_SDL_PLATFORM
    agg_USE_PACK
    agg_USE_AGG2D
    agg_USE_DEBUG
    agg_USE_AGG2D_FREETYPE
  )

  foreach(d ${find_LIB_VARS})
    if(DEFINED ${d})
      list(APPEND find_CMAKE_ARGS
        -D${d}=${${d}}
      )
    endif()
  endforeach()
## --- Common part of the lib_cmaker_<lib_name> function ---


  #-----------------------------------------------------------------------
  # Building
  #-----------------------------------------------------------------------

## +++ Common part of the lib_cmaker_<lib_name> function +++
  cmr_lib_cmaker_main(
    LibCMaker_DIR ${find_LibCMaker_DIR}
    NAME          ${find_NAME}
    VERSION       ${find_VERSION}
    LANGUAGES     CXX C
    BASE_DIR      ${find_LIB_DIR}
    DOWNLOAD_DIR  ${cmr_DOWNLOAD_DIR}
    UNPACKED_DIR  ${cmr_UNPACKED_DIR}
    BUILD_DIR     ${lib_BUILD_DIR}
    CMAKE_ARGS    ${find_CMAKE_ARGS}
    INSTALL
  )
## --- Common part of the lib_cmaker_<lib_name> function ---

  # Copy CMmake support files to the standard place.
  set(cmake_support_files_install_dir
    "${CMAKE_INSTALL_PREFIX}/lib/cmake/agg-${find_VERSION}"
  )
  execute_process(
    COMMAND
    ${CMAKE_COMMAND} -E make_directory
      ${cmake_support_files_install_dir}
  )
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
      ${CMAKE_INSTALL_PREFIX}/bin/AggConfig.cmake
      ${cmake_support_files_install_dir}/AggConfig.cmake
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
      ${CMAKE_INSTALL_PREFIX}/bin/UseAgg.cmake
      ${cmake_support_files_install_dir}/UseAgg.cmake
  )
