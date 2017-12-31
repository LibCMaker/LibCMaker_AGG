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

include(GNUInstallDirs)

include(cmr_lib_cmaker_post)
include(cmr_print_debug_message)
include(cmr_print_fatal_error)
include(cmr_print_message)
include(cmr_print_var_value)

include(cmr_agg_get_download_params)

# TODO: make docs
function(cmr_agg_cmaker)
  cmake_minimum_required(VERSION 3.2)

  cmr_lib_cmaker_post()

  # Required vars
  if(NOT lib_VERSION)
    cmr_print_fatal_error("Variable lib_VERSION is not defined.")
  endif()
  if(NOT lib_BUILD_DIR)
    cmr_print_fatal_error("Variable lib_BUILD_DIR is not defined.")
  endif()

  # Optional vars
  if(NOT lib_DOWNLOAD_DIR)
    set(lib_DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR})
  endif()
  if(NOT lib_UNPACKED_SRC_DIR)
    set(lib_UNPACKED_SRC_DIR "${lib_DOWNLOAD_DIR}/sources")
  endif()
  
  cmr_agg_get_download_params(${lib_VERSION}
    lib_URL lib_SHA lib_SRC_DIR_NAME lib_ARCH_FILE_NAME)

  set(lib_ARCH_FILE "${lib_DOWNLOAD_DIR}/${lib_ARCH_FILE_NAME}")
  set(lib_SRC_DIR "${lib_UNPACKED_SRC_DIR}/${lib_SRC_DIR_NAME}")
  set(lib_BUILD_SRC_DIR "${lib_BUILD_DIR}/${lib_SRC_DIR_NAME}")

  # Library specific vars.
  set(antigrain_SOURCE_DIR ${lib_SRC_DIR})
  set(antigrain_BINARY_DIR ${CMAKE_INSTALL_PREFIX})


  #-----------------------------------------------------------------------
  # Build library.
  #-----------------------------------------------------------------------

  #-----------------------------------------------------------------------
  # Download tar file.
  #
  if(NOT EXISTS "${lib_ARCH_FILE}")
    cmr_print_message("Download ${lib_URL}")
    file(
      DOWNLOAD "${lib_URL}" "${lib_ARCH_FILE}"
      EXPECTED_HASH SHA256=${lib_SHA}
      SHOW_PROGRESS
    )
  endif()
  
  #-----------------------------------------------------------------------
  # Extract tar file.
  #
  if(NOT EXISTS "${lib_SRC_DIR}")
    cmr_print_message("Extract ${lib_ARCH_FILE}")
    file(MAKE_DIRECTORY ${lib_UNPACKED_SRC_DIR})
    execute_process(
      COMMAND ${CMAKE_COMMAND} -E tar xjf ${lib_ARCH_FILE}
      WORKING_DIRECTORY ${lib_UNPACKED_SRC_DIR}
    )
  endif()


  #-----------------------------------------------------------------------
  # Overwrite CMake files with patched files.
  #
  cmr_print_message(
    "Overwrite CMake files with patched files in unpacked sources.")
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
      ${PROJECT_SOURCE_DIR}/cmake/modules/patched_CMakeLists.txt
      ${lib_SRC_DIR}/CMakeLists.txt
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
      ${PROJECT_SOURCE_DIR}/cmake/modules/patched_src_CMakeLists.txt
      ${lib_SRC_DIR}/src/CMakeLists.txt
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
      ${PROJECT_SOURCE_DIR}/cmake/modules/patched_bin_FindAgg.cmake
      ${lib_SRC_DIR}/bin/FindAgg.cmake
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
      ${PROJECT_SOURCE_DIR}/cmake/modules/patched_bin_AggConfig.cmake.in
      ${lib_SRC_DIR}/bin/AggConfig.cmake.in
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
      ${PROJECT_SOURCE_DIR}/cmake/modules/patched_bin_AggConfigOutBuild.cmake.in
      ${lib_SRC_DIR}/bin/AggConfigOutBuild.cmake.in
  )


  #-----------------------------------------------------------------------
  # Overwrite <src>/examples/CMakeLists.txt with empty file
  # to exclude its building.
  #
  if(SKIP_BUILD_AGG_EXAMPLES)
    cmr_print_message(
      "Overwrite <src>/examples/CMakeLists.txt with empty file in unpacked sources.")
    execute_process(
      COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${PROJECT_SOURCE_DIR}/cmake/modules/empty_CMakeLists.txt
        ${lib_SRC_DIR}/examples/CMakeLists.txt
    )
  endif()


  #-----------------------------------------------------------------------
  # Overwrite <src>/myapp/CMakeLists.txt with empty file
  # to exclude its building.
  #
  if(SKIP_BUILD_AGG_MYAPP)
    cmr_print_message(
      "Overwrite <src>/myapp/CMakeLists.txt with empty file in unpacked sources.")
    execute_process(
      COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${PROJECT_SOURCE_DIR}/cmake/modules/empty_CMakeLists.txt
        ${lib_SRC_DIR}/myapp/CMakeLists.txt
    )
  endif()


  #-----------------------------------------------------------------------
  # Configure library.
  #
  add_subdirectory(${lib_SRC_DIR} ${lib_BUILD_SRC_DIR})

endfunction()
