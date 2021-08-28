cmake_minimum_required(VERSION 3.10)
set(VMOD_NAME example)
project(vmod_${VMOD_NAME} VERSION 0.0.1)

include(vmod.cmake)

vmod(${VMOD_NAME} 6.6 src/vmod_${VMOD_NAME}.c)

file(GLOB vtc_paths ${CMAKE_CURRENT_SOURCE_DIR}/tests/*.vtc)
vtc(${VMOD_NAME} "${vtc_paths}")
