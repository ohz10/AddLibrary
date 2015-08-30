function(add_source BASE_DIR IMPLEMENTATION_FILES)

	cmake_parse_arguments(PARSED_ARGS "" "" "HEADER_PATTERNS;SRC_PATTERNS;PATTERNS;FILTER_DIRS;NO_INSTALL" ${ARGN})
	set(patterns ${PARSED_ARGS_PATTERNS})
	set(header_patterns ${PARSED_ARGS_HEADER_PATTERNS})
	set(src_patterns ${PARSED_ARGS_SRC_PATTERNS})
	set(filter_dirs ${PARSED_ARGS_FILTER_DIRS})
	set(no_install ${PARSED_ARGS_NO_INSTALL})

	# default patterns
	if(NOT patterns)
		list(APPEND patterns *.h *.hpp *.hxx *.hh *.H *.c *.C *.cc *.CC *.cxx *.cpp)
	endif()

	if(NOT header_patterns)
	    list(APPEND header_patterns *.h *.hpp *.hxx *.hh *.H)
	endif()
	
	if(NOT src_patterns)
	    list(APPEND src_patterns *.c *.C *.cc *.CC *.cxx *.cpp)
	endif() 
	
	file(GLOB_RECURSE source_files RELATIVE ${BASE_DIR} ${patterns})	
	filter_path_list(header_files SOURCES ${source_files} PATTERNS ${header_patterns})
	filter_path_list(implementation_files SOURCES ${source_files} PATTERNS ${src_patterns})
	
	remove_ignored_paths(header_files PATHS ${header_files} FILTER_DIRS "..")
	remove_ignored_paths(implementation_files PATHS ${implementation_files} FILTER_DIRS "..")
	
	remove_ignored_paths(header_files PATHS ${header_files} FILTER_DIRS ${filter_dirs})
	remove_ignored_paths(implementation_files PATHS ${implementation_files} FILTER_DIRS ${filter_dirs})

	if(${no_install})
		# skip installing headers.
	else()
		setup_header_installation(${library_name} HEADERS ${header_files})
	endif()

	# Setup Groups for Project Solutions
	unset(header_groups)
	foreach(header ${header_files})
		get_group(${header} "interface" header_group)
		list(APPEND header_group_${header_group} ${header})
		list(APPEND header_groups ${header_group})
	endforeach(header)

	# Setup Groups for Project Solutions
	unset(source_groups)
	foreach(source ${implementation_files})
		get_group(${source} "source" source_group)
		list(APPEND source_group_${source_group} ${source})
		list(APPEND source_groups ${source_group})
	endforeach(source)

	if(header_groups)
		list(REMOVE_DUPLICATES header_groups)
	endif()

	if(source_groups)
		list(REMOVE_DUPLICATES source_groups)
	endif()
	
	foreach(header_group ${header_groups})
		# add base_dir back to the paths
		add_base_dir(header_group_${header_group} PATHS ${header_group_${header_group}} BASE_DIR ${BASE_DIR})
		source_group(${header_group} FILES ${header_group_${header_group}})	
		unset(header_group_${header_group})
	endforeach(header_group)

	foreach(source_group ${source_groups})	
		# add base_dir back to the paths
		add_base_dir(source_group_${source_group} PATHS ${source_group_${source_group}} BASE_DIR ${BASE_DIR})
		source_group(${source_group} FILES ${source_group_${source_group}})
		unset(source_group_${source_group})
	endforeach(source_group)

	# add base_dir back to the paths.
	add_base_dir(header_files PATHS ${header_files} BASE_DIR ${BASE_DIR})
	add_base_dir(implementation_files PATHS ${implementation_files} BASE_DIR ${BASE_DIR})
	
	set(all_sources ${header_files} ${implementation_files})
	
	# return the found implementation files to the calling scope
	set(${IMPLEMENTATION_FILES} ${all_sources} PARENT_SCOPE)
endfunction(add_source)