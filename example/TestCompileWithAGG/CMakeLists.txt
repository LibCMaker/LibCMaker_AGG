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

cmake_minimum_required(VERSION 3.2 FATAL_ERROR)

project(LibCMaker_AGG_Compile_Test CXX)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")


#-----------------------------------------------------------------------
# Configure for find_package.
#-----------------------------------------------------------------------

# Set CMake's search path for find_package(), find_program(), find_library(),
# find_file(), and find_path() commands.
list(APPEND CMAKE_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}")

if(ANDROID)
  list(APPEND CMAKE_FIND_ROOT_PATH "${CMAKE_INSTALL_PREFIX}")
endif()


#-----------------------------------------------------------------------
# Set path to LibCMaker root
#-----------------------------------------------------------------------

set(LIBCMAKER_SRC_DIR "${PROJECT_SOURCE_DIR}/cmake/LibCMaker")
# Uncomment it if need functions from LibCMaker
#list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_SRC_DIR}/cmake/modules")


#-----------------------------------------------------------------------
# Set vars for LibCMaker_AGG.
#-----------------------------------------------------------------------

# Standard CMake vars.
#set(BUILD_SHARED_LIBS ON)

#set(SKIP_INSTALL_HEADERS ON)
#set(SKIP_INSTALL_LIBRARIES ON)
#set(SKIP_INSTALL_ALL ON)

# Set useful vars for lib_cmaker_agg().
set(cmr_PRINT_DEBUG ON)

set(lib_VERSION "2.4.127")

set(DOWNLOAD_DIR "${PROJECT_BINARY_DIR}")
set(UNPACKED_SRC_DIR "${PROJECT_BINARY_DIR}")
set(BUILD_DIR "${PROJECT_BINARY_DIR}/build_agg")

if(ANDROID)
  set(NOT_ADD_AGG_PLATFORM ON)
endif()
set(SKIP_BUILD_AGG_EXAMPLES ON)
set(SKIP_BUILD_AGG_MYAPP ON)

# Library specific vars and options.
set(AGG_DIR "${CMAKE_INSTALL_PREFIX}")
set(ENV{AGG_DIR} "${AGG_DIR}")
set(AGG_DIR_BIN "${CMAKE_INSTALL_PREFIX}/bin")

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
# Build and install the AGG.
#-----------------------------------------------------------------------

include(
  ${PROJECT_SOURCE_DIR}/cmake/LibCMaker_AGG/lib_cmaker_agg.cmake)

# Make compile, build and install the library at a config CMake phase,
# generate the CMake config files.

# Install specified library version.
lib_cmaker_agg(
  VERSION ${lib_VERSION}
  DOWNLOAD_DIR ${DOWNLOAD_DIR}
  UNPACKED_SRC_DIR ${UNPACKED_SRC_DIR}
  BUILD_DIR ${BUILD_DIR}
)


#-----------------------------------------------------------------------
# find_package
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
# Link to the library.
#-----------------------------------------------------------------------

# Build test executables

# agg_platform_support.cpp is not implemented for Android.
if(ANDROID)
  add_executable(${PROJECT_NAME}
    example.cpp
  )

else() # if(NOT ANDROID)
  # Get an example sources from the AGG sources.
  include(
    ${PROJECT_SOURCE_DIR}/cmake/LibCMaker_AGG/cmake/modules/cmr_agg_get_download_params.cmake)
  cmr_agg_get_download_params(${lib_VERSION}
    lib_URL lib_SHA lib_SRC_DIR_NAME lib_ARCH_FILE_NAME)
  set(lib_SRC_DIR "${UNPACKED_SRC_DIR}/${lib_SRC_DIR_NAME}")
  
  add_executable(${PROJECT_NAME} ${WIN32GUI}
    ${lib_SRC_DIR}/examples/aa_demo.cpp
  )
endif()

target_include_directories(${PROJECT_NAME} PRIVATE ${AGG_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} ${AGG_LIBRARIES})
