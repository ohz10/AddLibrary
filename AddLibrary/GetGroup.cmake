function(get_group path default_group group)
	# extract the group information from path
	# e.g. "src/details" will be group "src\\details"
	get_filename_component(dir ${path} DIRECTORY)

	if(dir)
		string(REGEX MATCH "(^src$|^src/)" matched ${dir})	# special handling for src/ in libs.

        if(matched)
            string(REGEX REPLACE "^src$" "source" dir ${dir})
            string(REGEX REPLACE "^src/" "source/" dir ${dir})
            string(REGEX REPLACE "/" "\\\\" dir ${dir})

            set(${group} "${dir}" PARENT_SCOPE)
        else()
            string(REGEX REPLACE "/" "\\\\" dir ${dir})
            set(${group} "${default_group}\\${dir}" PARENT_SCOPE)
        endif()
	else()
		set(${group} ${default_group} PARENT_SCOPE)
	endif()
endfunction(get_group)