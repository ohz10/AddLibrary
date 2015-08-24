# AddLibrary 

AddLibrary is a boundle of cmake helpers for creating libraries and executables quickly. When library/executable directories follow a directory layout convention, AddLibrary will create unit test executables and run them as post build events.  

### Dependencies 

- cmake 2.8+ 

### Use 

Create a library name `libraryName` and use UnitTest++ (found with FindUnitTest++.cmake module) for running unit tests. 

    MAKE_LIBRARY(libraryName UNITTEST_LIBS ${UnitTest++_LIBRARIES}) 

Inside a larger project, you give each library their own directory. E.g. 

    proj/
         CMakeLists.txt 
         lib1/
         lib2/ 

Say lib2 depends on lib1, lib2's CMakeLists.txt looks like this:

    MAKE_LIBRARY(lib2 DEPENDENCIES lib1 UNITTEST_LIBS ${UnitTest++_LIBRARIES)

### Contributors 

Austin Gilbert <ceretullis@gmail.com>

### License

4-Clause BSD license, see [LICENSE.md](LICENSE.md) for details. Other licensing available upon request. 
