# Assumes we reside in CMAKE_MODULE_PATH/AddLibrary/
set(dir ${CMAKE_MODULE_PATH}/AddLibrary/)

include(${dir}/AddBaseDir.cmake)
include(${dir}/FilterPathList.cmake)
include(${dir}/GetGroup.cmake)
include(${dir}/GetInstallGroup.cmake)
include(${dir}/SetupHeaderInstallation.cmake)
include(${dir}/SplitPath.cmake)
include(${dir}/RemoveIgnoredPaths.cmake)
include(${dir}/AddSource.cmake)

include(${dir}/ExecutableFunction.cmake)
include(${dir}/LibraryFunction.cmake)
