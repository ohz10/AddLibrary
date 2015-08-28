function(MAKE_LIBRARY LIB_NAME)
	set(library_name "${LIB_NAME}")
	
	cmake_parse_arguments(PARSED_ARGS "" "NAME" "DEPENDENCIES;UNITTEST_LIBS;GENERATED_SOURCE_FILES;GENERATED_TESTING_SOURCE_FILES;GENERATED_UT_SOURCE_FILES;COMPILE_FLAGS;TESTING_COMPILE_FLAGS;UT_COMPILE_FLAGS" ${ARGN})
	set(dependencies ${PARSED_ARGS_DEPENDENCIES})
	set(unit_test_dependencies ${PARSED_ARGS_UNITTEST_LIBS})
	set(generated_source_files ${PARSED_ARGS_GENERATED_SOURCE_FILES})
	set(generated_testing_source_files ${PARSED_ARGS_GENERATED_TESTING_SOURCE_FILES})
	set(generated_ut_source_files ${PARSED_ARGS_GENERATED_UT_SOURCE_FILES})
	
	set(compiler_flags ${PARSED_ARGS_COMPILE_FLAGS})
	set(testing_compiler_flags ${PARSED_ARGS_TESTING_COMPILE_FLAGS})
	set(ut_compiler_flags ${PARSED_ARGS_UT_COMPILE_FLAGS})

	message("Adding Library '${library_name}'")
	
	add_source(
		${CMAKE_CURRENT_SOURCE_DIR} 
		source_files 
		FILTER_DIRS "tests" "testing")
	add_library(${library_name} STATIC ${source_files} ${generated_source_files})

	foreach(flag ${compiler_flags})
		set_property(TARGET ${library_name} APPEND_STRING PROPERTY COMPILE_FLAGS "${flag} ")
	endforeach(flag)

	if(${dependencies})
		add_dependencies(${library_name} ${dependencies})
	endif()

	# build a testing library that holds mocks and test dummies
	set(testing_lib "") 
	if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/testing/")
		set(testing_lib "${library_name}-Testing")	
		message("Adding Library '${testing_lib}'")

		add_source("${CMAKE_CURRENT_SOURCE_DIR}/testing/" testing_source)
		add_library(${testing_lib} ${testing_source} ${generated_testing_source_files})

		foreach(flag ${testing_compiler_flags})
			set_property(TARGET ${testing_lib} APPEND_STRING PROPERTY COMPILE_FLAGS "${flag} ")
		endforeach(flag)

		add_dependencies(${testing_lib} ${library_name})
	endif()


	# build a unit test executable
	if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/tests/unit_test/")
		set(executable_name "${library_name}-UT")
		message("Adding Unit Test Executable '${executable_name}'")

		add_source("${CMAKE_CURRENT_SOURCE_DIR}/tests/unit_test/" ut_implementation)
		add_executable(${executable_name} ${ut_implementation} ${generated_ut_source_files})

		foreach(flag ${ut_compiler_flags})
			set_property(TARGET ${executable_name} APPEND_STRING PROPERTY COMPILE_FLAGS "${flag} ")
		endforeach(flag)

		add_dependencies(
			${executable_name}
			${library_name} 
			${testing_library}
		)

		target_link_libraries(
			 ${executable_name}
			 ${library_name}
			 ${testing_lib}
			 ${dependencies}
			 ${platform_unit_test_lib}
			 ${unit_test_dependencies}
			 ${platform_dependencies}
		)

		# run the UT as a post build event
		if(WIN32)
			add_custom_command(TARGET "${executable_name}" POST_BUILD COMMAND @echo off)
		endif()

		add_custom_command(TARGET "${executable_name}" POST_BUILD COMMAND "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/${executable_name}")
	endif()

	# the tests/acceptance_test/ directory is expected to
	# contain folders (1 for each acceptance test executable)
	# containing a CMakeLists.txt file. 
	if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/tests/acceptance_test/")
		file(GLOB acceptance_tests ${CMAKE_CURRENT_SOURCE_DIR}/tests/acceptance_test/* )

		foreach(evaluate_test ${acceptance_tests}) 
			add_subdirectory(${evaluate_test})
		endforeach(evaluate_test)
	endif()

endfunction()