# ****************************************************************************
#  Project:  LibCMaker_AGG
#  Purpose:  A CMake build script for Anti-Grain Geometry (AGG) library
#  Author:   NikitaFeodonit, nfeodonit@yandex.com
# ****************************************************************************
#    Copyright (c) 2017-2019 NikitaFeodonit
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

cmake_minimum_required(VERSION 3.4)

project(LibCMaker_AGG_Compile_Test CXX)

option(CMAKE_VERBOSE_MAKEFILE "CMAKE_VERBOSE_MAKEFILE" OFF)
option(cmr_PRINT_DEBUG "cmr_PRINT_DEBUG" OFF)


#-----------------------------------------------------------------------
# Configure to find_package()
#-----------------------------------------------------------------------

# Set CMake's search path for find_*() commands.
list(APPEND CMAKE_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}")

if(ANDROID)
  list(APPEND CMAKE_FIND_ROOT_PATH "${CMAKE_INSTALL_PREFIX}")
endif()


#-----------------------------------------------------------------------
# Set path vars
#-----------------------------------------------------------------------

set(libs_DIR "${CMAKE_CURRENT_LIST_DIR}/libs")
set(cmr_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}")
# To use below for sample sources.
set(cmr_UNPACKED_DIR ${CMAKE_CURRENT_BINARY_DIR}/download/unpacked)


#-----------------------------------------------------------------------
# LibCMaker settings
#-----------------------------------------------------------------------

set(LibCMaker_DIR "${libs_DIR}/LibCMaker")
list(APPEND CMAKE_MODULE_PATH "${LibCMaker_DIR}/cmake")
include(cmr_find_package)


#-----------------------------------------------------------------------
# Download, configure, build, install and find the required libraries
#-----------------------------------------------------------------------

option(BUILD_TESTING "Build the testing tree." OFF)
if(BUILD_TESTING)
  enable_testing()
  include(${libs_DIR}/LibCMaker_GoogleTest/cmr_build_googletest.cmake)
endif()

include(${libs_DIR}/LibCMaker_AGG/cmr_build_agg.cmake)


#-----------------------------------------------------------------------
# Find dependencies and set properties for it.
# Warning: find_package(Agg REQUIRED CONFIG) must be first.
#-----------------------------------------------------------------------

#if(WIN32)
#  add_definitions(
#    -D_MSWVC_ -D_CRT_SECURE_NO_WARNINGS -D_CRT_SECURE_NO_DEPRECATE
#  )
#  set(WIN32GUI WIN32)
#endif()

#if(UNIX AND NOT ANDROID)
#  add_definitions( -D__UNIX__ )
#
#  find_package(X11)
#  if(X11_FOUND)
#    include_directories(${X11_INCLUDE_DIRS})
#    link_libraries(${X11_LIBRARIES})
#  endif()
#endif()

#if(agg_USE_EXPAT)
#  find_package(EXPAT)
#  if(EXPAT_FOUND)
#    include_directories(${EXPAT_INCLUDE_DIRS})
#    link_libraries(${EXPAT_LIBRARIES})
#  else()
#    message(SEND_ERROR "expat not found")
#  endif()
#endif()

if(agg_USE_FREETYPE)
  find_package(Freetype)
  if(FREETYPE_FOUND)
    include_directories(${FREETYPE_INCLUDE_DIRS})
    link_libraries(${FREETYPE_LIBRARIES})
    link_directories(${FREETYPE_LINK_DIR})
  else()
    message(SEND_ERROR "freetype not found")
  endif()
endif()


#-----------------------------------------------------------------------
# Build the executable of the example
#-----------------------------------------------------------------------

# agg_platform_support.cpp is not implemented for Android.
#if(ANDROID)
#  set(example_src_DIR "${CMAKE_CURRENT_LIST_DIR}/src")
#  add_executable(${PROJECT_NAME}
#    ${example_src_DIR}/example.cpp
#  )
#
#else() # if(NOT ANDROID)
#  # Get an example sources from the lib sources.
#  set(lib_SRC_DIR
#    "${cmr_UNPACKED_DIR}/agg-${AGG_lib_VERSION}/LibCMaker_AGG_Sources-${AGG_lib_VERSION}"
#  )
#  set(lib_EXAMPLES_SRC_DIR ${lib_SRC_DIR}/examples)

#  add_executable(${PROJECT_NAME} ${WIN32GUI}
#    ${lib_EXAMPLES_SRC_DIR}/aa_demo.cpp
#  )
#endif()

set(example_src_DIR "${CMAKE_CURRENT_LIST_DIR}/src")

add_executable(${PROJECT_NAME}
  ${example_src_DIR}/example.cpp
)
set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD 11)


#-----------------------------------------------------------------------
# Link to the libraries
#-----------------------------------------------------------------------

# AGG
target_include_directories(${PROJECT_NAME} PRIVATE ${AGG_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} PRIVATE ${AGG_LIBRARY})


#-----------------------------------------------------------------------
# Testing
#-----------------------------------------------------------------------

set(test_src_DIR "${CMAKE_CURRENT_LIST_DIR}/src")
add_subdirectory(test)
