# AddLibrary 

AddLibrary is a boundle of cmake helpers for creating libraries and executables quickly. When library/executable directories follow a directory layout convention, AddLibrary will create library & executable targets from the source files found. Further, it will automatically create "testing" libraries for mocks and unit test executables. Unit test executables will be run as post build events. If acceptance tests are defined, their CMakeLists.txt files will be included as a subdirectory, so they can be built/viewed in any generated project. 

### Dependencies 

- cmake 2.8+ 

### Directory Layout Convention 

Here we show and briefly discuss our directory layout convention.

    proj/
         CMakeLists.txt 
         lib1/
              CMakeLists.txt
              lib1.hpp
              details/
                      public.hpp
              src/
                  lib2.cpp
                  private.hpp
              testing/
                      mock1.hpp
                      src/
                          mock1.cpp
              tests/
                    acceptance_test/
                                    stress_test/
                                                CMakeLists.txt // <- own project defs & layout
                    unit_test/
                              platform/
                                       ut.hpp
                              main.cpp
                              verifyComponent1-UT.cpp
                              verifyComponent2-UT.cpp
         lib2/ 
              CMakeLists.txt
              lib2.hpp
              something.hpp
              something_else.hp
              src/
                  Dummy.cpp
          cli/
              src/
                  main.cpp

There would be 5 top-level targets defined with this layout. `lib1`, `lib1-testing`, `lib1-UT`, `lib2`, and `cli`. There could potentially be more targets, because an acceptance test `stress_test` is present. 

`lib1` would have an associated "testing" library. This is a place to put mocks, dummies, and fakes. In larger projects, keeping mocks, dummies, and fakes in the unit tests folder leads to them being recreated many times over. Better to have an official place to keep these. `lib1` also has an associated unit test executable `lib1-UT` which is run as a post build event on a successful build. Finally, `lib1` has some acceptance tests defined. Any folder under `tests/acceptance_test/` is added to the project and built, but not executed. The 'stress_test' CMakeLists.txt would define its own targets, and it doesn't need to adhere to AddLibrary conventions. 

`lib2` is a header only library, but we like to go ahead and provide a library archive for CMake to chew on, and so a Dummy.cpp is defined the contents should look like this: 

    namespace lib2 {
    	char Dummy;
    }

You should not initialize Dummy. You may need to suppress errors for unused variables, etc. 

Subdirectories under a target get included in the project as subdirectories. For example, there would be a folder for `lib1`, under that folder `interface` for headers and `src` for source files. Under `lib1/interface` there would be `lib1/interface/details`. You can add as many layers as your heart desires, any headers will be added to the project. 

Currently we match any .h .H .hpp .hh .hxx as a header. And we match .c .C .cc .CC .cxx .cpp as C/C++ source. 

### Examples

#### Create a library target

Create a library name `libraryName` and use UnitTest++ (found with FindUnitTest++.cmake module) for running unit tests. 

    MAKE_LIBRARY(libraryName 
    	UNITTEST_LIBS 
    		${UnitTest++_LIBRARIES}
    ) 

Or, if you've a lot of targets and would rather _not_ specify the unit test libs each time, set the following variable somewhere convenient.

    set(platform_unit_test_lib ${UnitTest++_LIBRARIES})

Then we can create `libraryName` like so:

    MAKE_LIBRARY(libraryName)


#### Create an executable target

To create an executable `executableName` use the following: 

    MAKE_EXECUTABLE(executableName)

When there are external linking dependencies: 

    MAKE_EXECUTABLE(executableName
    	DEPENDENCIES
    		${PNG_LIBRARIES}
    		${Boost_LIBRARIES}
    )

#### Inter-project dependencies 

Inside a larger project, you give each library/executable target their own directory. E.g. 

    proj/
         CMakeLists.txt 
         lib1/
         lib2/ 

When there are inter-project dependencies, you declare them using the project names. If we create `lib1` using `MAKE_LIBRARY`, and we want `lib2` to depend on it, we put the following in proj/lib2/CMakeLists.txt.

    MAKE_LIBRARY(lib2 
    	DEPENDENCIES lib1
    )

#### Add extra compiler flags for a specific project

When you need to build a specific library with some compiler flags not needed project wide (to suppress errors for example), you can supply the COMPILE_FLAGS argument with a list of flags to add. Adding flags to the "testing" library and unit tests is also supported. 

    MAKE_LIBRARY(lib1
    	COMPILE_FLAGS
    		-Wno-unused-parameter
    	TESTING_COMPILE_FLAGS
    		-Wno-float-equal
    	UT_COMPILE_FLAGS
    		-Wno-unused-macros
    )

#### Generated source files

When you have targets depending on generated sources (which you've added with the appropriate calls to add_custom_command(OUTPUT)), you can add these to a library/executable target using `GENERATED_SOURCE`, `GENERATED_TESTING_SOURCE`, and `GENERATED_UT_SOURCE`.

	add_custom_command(
		OUTPUT 
			myfile.h 
			myfile.cpp
		COMMAND generate ARGS arg1 arg2
		MAIN_DEPENDENCY 
			myfile.h.m4
		COMMENT "Generating myfile.h and myfile.cpp"
	)

    MAKE_LIBRARY(lib1
    	GENERATED_SOURCE "myfile.h" "myfile.cpp"
    )

### Contributors 

Austin Gilbert <ceretullis@gmail.com>

### License

4-Clause BSD license, see [LICENSE.md](LICENSE.md) for details. Other licensing available upon request. 
