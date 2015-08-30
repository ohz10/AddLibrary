function(setup_header_installation library_name)
	# setup installation for headers where the folders in include/ match 
	# the pattern we have in the project. 
	# HEADERS should have a list of headers with relative path to the target directory. 
	# BASE_PROJECT_DIR if set, a top level directory will be put in place and target paths will go under it. 

	cmake_parse_arguments(PARSED_ARGS "" "" "HEADERS;BASE_PROJECT_DIR" ${ARGN})
	set(install_header_files ${PARSED_ARGS_HEADERS})
	set(install_base_project ${PARSED_ARGS_BASE_PROJECT_DIR})

	remove_ignored_paths(install_header_files PATHS ${install_header_files} FILTER_DIRS "src" "tests" "unit_test" "internal")

	unset(installation_groups)
	foreach(header ${install_header_files})
		get_install_group(${header} "${library_name}" installation_group)

		if(NOT installation_group MATCHES "IGNORE")
			if(${install_base_project})
				set(group_name "${install_base_project}/${installation_group}")
			else()
				set(group_name "${installation_group}")
			endif()

			list(APPEND installation_group_${group_name} ${header})
			list(APPEND installation_groups ${group_name})
		endif()
	endforeach(header)
	
	# add install targets.
	foreach(install_group ${installation_groups})
		install(FILES ${installation_group_${install_group}} DESTINATION include/${install_group})
	endforeach(install_group)
endfunction(setup_header_installation)
