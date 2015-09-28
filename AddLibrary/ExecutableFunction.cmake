function(MAKE_EXECUTABLE EXEC_NAME)
	set(executable_name "${EXEC_NAME}")
	message("Adding Executable '${executable_name}'")

	cmake_parse_arguments(PARSED_ARGS "" "NAME" "DEPENDENCIES;GENERATED_HEADER_FILES;GENERATED_SOURCE_FILES;COMPILE_FLAGS" ${ARGN})
    set(generated_header_files ${PARSED_ARGS_GENERATED_HEADER_FILES})
    set(generated_source_files ${PARSED_ARGS_GENERATED_SOURCE_FILES})
	set(dependencies ${PARSED_ARGS_DEPENDENCIES})
	set(compiler_flags ${PARSED_ARGS_COMPILE_FLAGS})

    add_source(${CMAKE_CURRENT_SOURCE_DIR} install_headers headers implementation)

    # create the library target
	add_executable(${executable_name}
        ${headers}
		${implementation}
        ${generated_header_files}
		${generated_source_files}
	)

	foreach(flag ${compiler_flags})
			set_property(TARGET ${executable_name} APPEND_STRING PROPERTY COMPILE_FLAGS "${flag} ")
	endforeach(flag)

	# split dependency list into "project" deps and external deps.
	set(local_target_lib_deps "")
	foreach(dependency ${dependencies})
		if(TARGET ${dependency})
			list(APPEND local_target_lib_deps ${dependency})
		endif()
	endforeach()

	# add local deps 
	foreach(local_dep ${local_target_lib_deps})
		add_dependencies(${executable_name} ${local_dep})
	endforeach()

	set(all_deps ${dependencies} ${platform_dependencies})
	list(LENGTH all_deps hasLinkLibs)
	
	if(hasLinkLibs GREATER 0)
		target_link_libraries(
			"${executable_name}" 
			${dependencies} 
			${platform_dependencies}
        )
	endif()

	install(TARGETS ${executable_name} DESTINATION bin)
endfunction()
