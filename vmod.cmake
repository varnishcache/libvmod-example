function (vtc vmod_name vtc_paths)
	enable_testing()
	foreach(vtc_path ${vtc_paths})
		add_test(NAME ${vtc_path} COMMAND varnishtest -v "-Dvmod_${vmod_name}=${vmod_name} from \"${CMAKE_BINARY_DIR}/libvmod_${vmod_name}.so\"" ${vtc_path})
		set_tests_properties(${vtc_path} PROPERTIES SKIP_RETURN_CODE 77)
	endforeach()
endfunction()

function (vmod vmod_name vc_api_req src_files) 
	find_package(PkgConfig REQUIRED)
	find_package(Python REQUIRED COMPONENTS Interpreter Development)
	
	find_program(RST2MAN rst2man)
	
	pkg_check_modules(VARNISHAPI REQUIRED varnishapi>=${vc_api_req})
	pkg_get_variable(VARNISHAPI_VMODTOOL varnishapi vmodtool)
	pkg_get_variable(VARNISHAPI_VMODDIR varnishapi vmoddir)
	include_directories(${VARNISHAPI_INCLUDE_DIRS})
	include_directories(${CMAKE_BINARY_DIR})
	configure_file(config.h.in config.h)
	
	add_custom_command(
		OUTPUT vcc_${vmod_name}_if.c vcc_${vmod_name}_if.h vmod_${vmod_name}.rst vmod_${vmod_name}.man.rst
		MAIN_DEPENDENCY ${CMAKE_CURRENT_SOURCE_DIR}/src/vmod_${vmod_name}.vcc
		COMMAND ${Python_EXECUTABLE}
		ARGS ${VARNISHAPI_VMODTOOL} -o vcc_${vmod_name}_if ${CMAKE_CURRENT_SOURCE_DIR}/src/vmod_${vmod_name}.vcc
	)
	
	add_library(vmod_${vmod_name} MODULE ${src_files} vcc_${vmod_name}_if.c vcc_${vmod_name}_if.h)
	install(TARGETS vmod_${vmod_name} DESTINATION ${VARNISHAPI_VMODDIR})
	
	add_custom_command(
		OUTPUT vmod_${vmod_name}.3
		MAIN_DEPENDENCY ${CMAKE_BINARY_DIR}/vmod_${vmod_name}.rst
		COMMAND ${RST2MAN} ${CMAKE_BINARY_DIR}/vmod_${vmod_name}.rst vmod_${vmod_name}.3
	)
	add_custom_target(manpage ALL DEPENDS ${CMAKE_BINARY_DIR}/vmod_${vmod_name}.3)
	install(FILES ${CMAKE_BINARY_DIR}/vmod_${vmod_name}.3 TYPE MAN)
endfunction()
