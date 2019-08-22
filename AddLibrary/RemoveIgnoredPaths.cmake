n(remove_ignored_paths filtered_paths)
    # given a list of paths in PATHS
    # and a list of FILTER_DIRS 
    # return a list of paths not starting 
    # with paths in FILTER_DIRS 
    cmake_parse_arguments(PARSED_ARGS "" "" "PATHS;FILTER_DIRS" ${ARGN})
    set(paths ${PARSED_ARGS_PATHS})
    set(filter_dirs ${PARSED_ARGS_FILTER_DIRS})

    unset(filtered)
    set(filtered "")
    
    foreach(path ${paths})
		split_path(${path} split_path)
		 
 		list(LENGTH split_path length)
 		if(length GREATER 0)
			list(GET split_path 0 part)
			
			list(FIND filter_dirs ${part} matched)
			if(matched EQUAL -1)
				list(APPEND filtered ${path})
			endif()
		endif()
	endforeach(path)
    
    set(${filtered_paths} ${filtered} PARENT_SCOPE)
endfunction(remove_ignored_paths)
