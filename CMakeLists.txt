cmake_minimum_required(VERSION 3.10)
set(VMOD_NAME example)
project(vmod_${VMOD_NAME} VERSION 1.0)
enable_testing()

find_package(PkgConfig REQUIRED)
find_package(Python REQUIRED COMPONENTS Interpreter Development)

find_program(RST2MAN rst2man)

pkg_check_modules(VARNISHAPI REQUIRED varnishapi>=6.6)
pkg_get_variable(VARNISHAPI_VMODTOOL varnishapi vmodtool)
pkg_get_variable(VARNISHAPI_VMODDIR varnishapi vmoddir)
include_directories(${VARNISHAPI_INCLUDE_DIRS})
include_directories(${CMAKE_BINARY_DIR})
configure_file(config.h.in config.h)

add_custom_command(
	OUTPUT vcc_${VMOD_NAME}_if.c vcc_${VMOD_NAME}_if.h vmod_${VMOD_NAME}.rst vmod_${VMOD_NAME}.man.rst
	MAIN_DEPENDENCY ${CMAKE_CURRENT_SOURCE_DIR}/src/vmod_${VMOD_NAME}.vcc
	COMMAND ${Python_EXECUTABLE}
	ARGS ${VARNISHAPI_VMODTOOL} -o vcc_${VMOD_NAME}_if ${CMAKE_CURRENT_SOURCE_DIR}/src/vmod_${VMOD_NAME}.vcc
)

add_library(vmod_${VMOD_NAME} MODULE ./src/vmod_${VMOD_NAME}.c vcc_${VMOD_NAME}_if.c vcc_${VMOD_NAME}_if.h)
install(TARGETS vmod_${VMOD_NAME} DESTINATION ${VARNISHAPI_VMODDIR})

add_custom_command(
	OUTPUT vmod_${VMOD_NAME}.3
	MAIN_DEPENDENCY ${CMAKE_BINARY_DIR}/vmod_${VMOD_NAME}.rst
	COMMAND ${RST2MAN} ${CMAKE_BINARY_DIR}/vmod_${VMOD_NAME}.rst vmod_${VMOD_NAME}.3
)
add_custom_target(manpage ALL DEPENDS ${CMAKE_BINARY_DIR}/vmod_${VMOD_NAME}.3)
install(FILES ${CMAKE_BINARY_DIR}/vmod_${VMOD_NAME}.3 TYPE MAN)

file(GLOB vtcs ${CMAKE_CURRENT_SOURCE_DIR}/src/tests/*.vtc)
foreach(vtc ${vtcs})
	add_test(NAME ${vtc} COMMAND varnishtest -v "-Dvmod_${VMOD_NAME}=${VMOD_NAME} from \"${CMAKE_BINARY_DIR}/libvmod_${VMOD_NAME}.so\"" ${vtc})
endforeach()
