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

cmake_minimum_required(VERSION 3.2)

project(LibCMaker_AGG_Compile_Test CXX)

set(CMAKE_VERBOSE_MAKEFILE ON)
set(cmr_PRINT_DEBUG ON)


#-----------------------------------------------------------------------
# Configure to find_package()
#-----------------------------------------------------------------------

# Set CMake's search path for find_*() commands.
list(APPEND CMAKE_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}")

if(ANDROID)
  list(APPEND CMAKE_FIND_ROOT_PATH "${CMAKE_INSTALL_PREFIX}")
endif()

# To use our FindAgg.cmake.
list(APPEND CMAKE_MODULE_PATH
  "${PROJECT_SOURCE_DIR}/cmake/LibCMaker_AGG/cmake"
)


#-----------------------------------------------------------------------
# Set path to LibCMaker root
#-----------------------------------------------------------------------

set(LIBCMAKER_SRC_DIR "${PROJECT_SOURCE_DIR}/cmake/LibCMaker")
# Uncomment it if need functions from LibCMaker
#list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_SRC_DIR}/cmake/modules")


#-----------------------------------------------------------------------
# Set vars to LibCMaker_AGG
#-----------------------------------------------------------------------

# Standard CMake vars.
#set(BUILD_SHARED_LIBS ON)

# Vars to lib_cmaker_agg().
set(AGG_lib_VERSION   "2.4.128")
set(AGG_DOWNLOAD_DIR  "${PROJECT_BINARY_DIR}")
set(AGG_UNPACKED_DIR  "${PROJECT_BINARY_DIR}")
set(AGG_BUILD_DIR     "${PROJECT_BINARY_DIR}/build_agg")

set(AGG_DIR "${CMAKE_INSTALL_PREFIX}")
set(ENV{AGG_DIR} "${AGG_DIR}")
set(AGG_DIR_BIN "${CMAKE_INSTALL_PREFIX}/bin")

if(ANDROID)
  set(NOT_ADD_AGG_PLATFORM ON)
endif()
set(SKIP_BUILD_AGG_EXAMPLES ON)
set(SKIP_BUILD_AGG_MYAPP ON)

# Library specific vars and options.

option(agg_USE_GPC "Use Gpc Boolean library" OFF)
option(agg_USE_FREETYPE "Use Freetype library" OFF)
option(agg_USE_EXPAT "Use Expat library" OFF)
option(agg_USE_SDL_PLATFORM "Use SDL as platform" OFF)
option(agg_USE_PACK "Package Agg" OFF)
option(agg_USE_AGG2D "Agg 2D graphical context" OFF)
option(agg_USE_DEBUG "For debug version" OFF)
option(agg_USE_AGG2D_FREETYPE "Agg 2D graphical context uses freetype" OFF)    

# TODO: set ENV{FREETYPE_DIR}


#-----------------------------------------------------------------------
# Build and install the AGG
#-----------------------------------------------------------------------

include(
  ${PROJECT_SOURCE_DIR}/cmake/LibCMaker_AGG/lib_cmaker_agg.cmake)

# Make compile, build and install the library at a config CMake phase.
lib_cmaker_agg(
  VERSION       ${AGG_lib_VERSION}
  DOWNLOAD_DIR  ${AGG_DOWNLOAD_DIR}
  UNPACKED_DIR  ${AGG_UNPACKED_DIR}
  BUILD_DIR     ${AGG_BUILD_DIR}
)


#-----------------------------------------------------------------------
# find_package()
#-----------------------------------------------------------------------

# Use newly got library.
find_package(Agg REQUIRED CONFIG)
include(${AGG_USE_FILE})


#-----------------------------------------------------------------------
# Find dependencies and set properties for it.
# Warning: find_package(Agg REQUIRED CONFIG) must be first.
#-----------------------------------------------------------------------

if(WIN32)
  add_definitions(
    -D_MSWVC_ -D_CRT_SECURE_NO_WARNINGS -D_CRT_SECURE_NO_DEPRECATE
  )
  set(WIN32GUI WIN32)    
endif()

if(UNIX AND NOT ANDROID)
  add_definitions( -D__UNIX__ )
  set(WIN32GUI "")

  find_package(X11)
  if(X11_FOUND)  
    include_directories(${X11_INCLUDE_DIRS})
    link_libraries(${X11_LIBRARIES})
  endif()
endif()

if(agg_USE_EXPAT)
  find_package(EXPAT)                    
  if(EXPAT_FOUND)  
    include_directories(${EXPAT_INCLUDE_DIRS})
    link_libraries(${EXPAT_LIBRARIES})
  else()  
    message(SEND_ERROR "expat not found")
  endif()
endif()

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
# Link to the library
#-----------------------------------------------------------------------

# Build test executables.

# agg_platform_support.cpp is not implemented for Android.
if(ANDROID)
  add_executable(${PROJECT_NAME}
    example.cpp
  )

else() # if(NOT ANDROID)
  # Get an example sources from the lib sources.
  set(lib_SRC_DIR
    "${AGG_UNPACKED_DIR}/agg-${AGG_lib_VERSION}/LibCMaker_AGG_Sources-${AGG_lib_VERSION}"
  )
  set(lib_EXAMPLES_SRC_DIR ${lib_SRC_DIR}/examples)

  add_executable(${PROJECT_NAME} ${WIN32GUI}
    ${lib_EXAMPLES_SRC_DIR}/aa_demo.cpp
  )
endif()

# AGG
target_include_directories(${PROJECT_NAME} PRIVATE ${AGG_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} ${AGG_LIBRARIES})
