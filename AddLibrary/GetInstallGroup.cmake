function(get_install_group path default_group group)
	# extract the group information from path
	# e.g. "src/details" will be group "src\\details"
	get_filename_component(dir ${path} DIRECTORY)

	if(dir)
		set(${group} "${default_group}/${dir}" PARENT_SCOPE)
	else()
		set(${group} ${default_group} PARENT_SCOPE)
	endif()
endfunction(get_install_group)