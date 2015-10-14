# TODO

- add capability for compiling shared libs.

- build dependency chains. build up dependency chains so when you have executable B depending on lib A and lib A depends on pthreads, you don't explicitly link pthreads, you mention A as a dependency and its link dependencies get added as linked libs in B. 

- delete installation headers before doing installation. CMake does not remove headers already existing there, which is a pain if you're working with templates and an old definition file is lurking in the install directory (say if you move it but something in the project is including the old header - everything still builds because the old header is there).

