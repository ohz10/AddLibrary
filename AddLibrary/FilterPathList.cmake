function(filter_path_list output_filtered_list)
    # given a list of regex filters in the form "*.h"
    # remove any file which isn't matched by the filter.
    cmake_parse_arguments(PARSED_ARGS "" "" "SOURCES;PATTERNS" ${ARGN})
    set(filters ${PARSED_ARGS_PATTERNS})
    set(path_list ${PARSED_ARGS_SOURCES})
    unset(matched_files)

    foreach(file ${path_list})
 foreach(pattern ${filters})
     string(REGEX MATCHALL "^.${pattern}$" matched ${file})
     if(matched)
		list(APPEND matched_files ${file})
     endif()
 endforeach(pattern)
    endforeach(file)

    set(${output_filtered_list} ${matched_files} PARENT_SCOPE)
endfunction(filter_path_list)
