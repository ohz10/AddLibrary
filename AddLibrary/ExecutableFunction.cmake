function(MAKE_EXECUTABLE EXEC_NAME)
	set(executable_name "${EXEC_NAME}")
	message("Adding Executable '${executable_name}'")

	cmake_parse_arguments(PARSED_ARGS "" "NAME" "LINK_DEPS;DEPENDENCIES" ${ARGN})
	set(dependencies ${PARSED_ARGS_DEPENDENCIES})
	set(link_libs ${PARSED_ARGS_LINK_DEPS})

    add_source(${CMAKE_CURRENT_SOURCE_DIR} implementation)

    # create the library target
	add_executable(${executable_name}
		${implementation}
	)

	list(LENGTH dependencies hasDependencies)
	if(hasDependencies GREATER 0)
		add_dependencies(${executable_name} ${dependencies})
	endif()

	if(${link_libs})
		target_link_libraries("${executable_name}" ${link_libs})
	endif()
endfunction()
