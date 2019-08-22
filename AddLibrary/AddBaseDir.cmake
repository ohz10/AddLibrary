function(add_base_dir adjusted_paths)
    # given a list of PATHS, append BASE_DIR to them
    # and return them in 'adjusted_paths'
    cmake_parse_arguments(PARSED_ARGS "" "" "PATHS;BASE_DIR" ${ARGN})
    set(paths ${PARSED_ARGS_PATHS})
    set(base_dir ${PARSED_ARGS_BASE_DIR})
    unset(updated_paths)
    
    foreach(path ${paths})
		list(APPEND updated_paths "${base_dir}/${path}")
    endforeach(path)
    
    set(${adjusted_paths} ${updated_paths} PARENT_SCOPE)
endfunction(add_base_dir)
