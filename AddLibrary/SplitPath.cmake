function(split_path path path_parts)
    # split path into parts by "/", save the parts
    # into path_parts 
    string(REPLACE "/" ";" dir_list ${path})
    set(${path_parts} ${dir_list} PARENT_SCOPE)
endfunction(split_path)
