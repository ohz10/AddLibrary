function(MAKE_EXECUTABLE EXEC_NAME)
	set(executable_name "${EXEC_NAME}")
	message("Adding Executable '${executable_name}'")

	cmake_parse_arguments(PARSED_ARGS "" "NAME" "LINK_DEPS;DEPENDENCIES;GENERATED_SOURCE_FILES;COMPILE_FLAGS" ${ARGN})
	set(generated_source_files ${PARSED_ARGS_GENERATED_SOURCE_FILES})
	set(dependencies ${PARSED_ARGS_DEPENDENCIES})
	set(link_libs ${PARSED_ARGS_LINK_DEPS})
	set(compiler_flags ${PARSED_ARGS_COMPILE_FLAGS})

    add_source(${CMAKE_CURRENT_SOURCE_DIR} implementation)

    # create the library target
	add_executable(${executable_name}
		${implementation}
		${generated_source_files}
	)

	foreach(flag ${compiler_flags})
			set_property(TARGET ${executable_name} APPEND_STRING PROPERTY COMPILE_FLAGS "${flag} ")
	endforeach(flag)

	list(LENGTH dependencies hasDependencies)
	if(hasDependencies GREATER 0)
		add_dependencies(${executable_name} ${dependencies})
	endif()

	set(all_deps ${dependencies} ${platform_dependencies} ${link_libs})
	list(LENGTH all_deps hasLinkLibs)
	
	if(hasLinkLibs GREATER 0)
		target_link_libraries(
			"${executable_name}" 
			${dependencies} 
			${platform_dependencies}
			${link_libs})
	endif()

	install(TARGET ${executable_name} DESTINATION bin)
endfunction()
