function(MAKE_EXECUTABLE EXEC_NAME)
	set(executable_name "${EXEC_NAME}")
	set(dependencies ${ARGN})
	message("Adding Executable '${executable_name}'")
	
	# there should only be private headers for executables.
	file( GLOB implementation RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
		src/*.h 
		src/*.hh
		src/*.hpp 
		src/*.c 
		src/*.cc
		src/*.cpp
	)
    source_group("src" FILES ${implementation})

    # create the library target
	add_executable(${executable_name}
		${implementation}
	)

	if(${dependencies} OR ${platform_dependencies})
		add_dependencies(${executable_name} ${dependencies})
		target_link_libraries(
			"${executable_name}" 
			${dependencies} 
			${platform_dependencies})
	endif()

endfunction()
