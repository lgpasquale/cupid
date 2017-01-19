# CMake Utilities for Project Installation and Development
This is a set of CMake scripts aimed at easing the development of CMake based projects.
The main goal is ease of use both for the developer and for the end user.

They provide:
- Dependency management
  - Dependencies are installed through CMake, making their insallation portable
  - Support for dependency graphs (each dependency can itself have other dependencies)
  - Bundling of dependencies in the installation package
  - Installation scripts for a set of dependency packages is already provided, but other dependencies can be added without having to modify this project
- Proper installation, complete with CMake modules needed to use this project in other projects


# Usage

## Basic usage

### Creating a project

Include this project somewhere in your source tree. If you are using git you can add this repository as a git submodule.

First you need to include `SetUpProject.cmake`. Assuming the contents of this repository are availabe at `${CMAKE_CURRENT_SOURCE_DIR}/cmake`:
```cmake
cmake_minimum_required(VERSION 3.0)
set(PROJECT_NAME YourProjectName)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/SetUpProject.cmake)
```

You can then add dependencies by calling:
```cmake
add_project_dependency(<dependency_name>
    [COMPONENTS <component_name> [component_name [...]]]
    [OPTIONAL_COMPONENTS <component_name> [component_name [...]]]
    )
```
The first argument of this function should be the dependency name (capitalization is important and should be the same used in Find<package_name>.cmake module).
For example:
```cmake
add_project_dependency(EIGEN3)
add_project_dependency(Boost COMPONENTS regex filesystem)
```

Once you have added all the dependencies you need to install them and/or find them.
```cmake
install_project_dependencies()
find_project_dependencies()
```
Note that dependencies are installed only if `DEPENDENCY_INSTALL_<dependency_name>` is set to ON (which it is by default).
`find_project_dependencies()` defines the following variables:
`${PROJECT_NAME}_DEPENDENCIES_INCLUDE_DIRS`, `${PROJECT_NAME}_DEPENDENCIES_LIBRARY_DIRS` and `${PROJECT_NAME}_DEPENDENCIES_LIBRARIES`

You don't then need to make explicit use of these variables (i.e. `include_directories` and `link_directories` is already called)

After providing instructions to compile your project, you can use the following script to properly install it
```cmake
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/InstallProject.cmake)
```

### Using a project

When configuring a project that uses CUPID, you can set the following (optional) CMake variables to manage dependencies:
- `DEPENDENCIES_ENABLE_INSTALLATION`: `BOOL` if set to OFF dependencies are not installed
- `DEPENDENCIES_INSTALL_<dependency_name>`: `BOOL` if set to OFF the given dependency won't be installed. It must be already installed. CMake will try to find it in the default system paths, but its location can optionally be set via the `DEPENDENCIES_<dependency_name>_DIR` variable
- `DEPENDENCIES_<dependency_name>_DIR`: `PATH` where the given dependency can be found if its installation is disabled (either by setting `DEPENDENCIES_INSTALL_<dependency_name>` to OFF or by disabling all installations by `DEPENDENCIES_ENABLE_INSTALLATION` ot OFF)
- `DEPENDENCIES_ARCHIVE_DIR`: `PATH` where dependencies source archives can be found. If the archives are found in this directory they won't be downloaded again. Defaults to `${CUPID_DIR}/dependencies/src`
- `DEPENDENCIES_INSTALL_DIR`: `PATH` where dependencies will be installed. Defaults to `${CMAKE_BINARY_DIR}/dependencies`

These variables can be set either when invoking cmake via the command line (e.g.: `cmake -D DEPENDENCIES_INSTALL_DIR=/where/you/want/them/installed path/to/source/dir`) or by using its GUI.

## Adding support for other dependencies

In order to add support for a custom dependency, you should provide 3 files: `Add<dependency_name>Dependencies.cmake`, `Install<dependency_name>.cmake` and `Bundle<dependency_name>.cmake`.
Additionally, if this dependency does not provide its own '<dependency_name>Config.cmake' file and it is not supported by any of the cmake 'Find<dependency_name>.cmake' modules, you should provide a 'Find<dependency_name>.cmake' script.

You can specify where these files are located by adding directories to the cache variable `DEPENDENCIES_INSTALL_SCRIPTS_DIRS`. e.g.:
```cmake
set(DEPENDENCIES_INSTALL_SCRIPTS_DIRS "${CMAKE_SOURCE_DIR}/dependency_install_scripts" CACHE INTERNAL "")
```

### `Add<dependency_name>Dependencies.cmake`
This file should simply add other dependency needed by this dependency by calling `add_project_dependency()`, as shown above.
If there are no other dependencies, this file is not needed.

### `Install<dependency_name>.cmake`
This script should actually install the dependency, most likely by using `ExternalProject_Add()`.
The installation can rely on the following variables (and assume they are already properly set):
- `DEPENDENCY_ARCHIVE_DIR`: directory where the source package should be downloaded. This defaults to a subdirectory of this scripts: `dependencies/src`
- `DEPENDENCY_BASE_DIR`: directory used for the build. If `ExternalProject_Add` is used, the `PREFIX` argument should be set to this value. Defaults to `${CMAKE_BINARY_DIR}/dependencies/<dependency_name>`.
- `DEPENDENCY_INSTALL_DIR`: directory where the project should be installed. This defaults to `${DEPENDENCY_BASE_DIR}/install`

### `Bundle<dependency_name>.cmake`
This script should install any file that needs to be bundled with the project (e.g. dynamic libraries).
If nothing needs to be bundled, this file is not needed.

### `Find<dependency_name>.cmake`
This script is only needed if the dependency does not provide its own '<dependency_name>Config.cmake' file and it is not supported by any of the cmake 'Find<dependency_name>.cmake' modules.
This script should rely on `${DEPENDENCIES_${DEPENDENCY_NAME}_DIR}` and can assume that `${CMAKE_PREFIX_PATH}` has already been set to that path.
It can also rely on the variables `DEPENDENCY_COMPONENTS` and `DEPENDENCY_OPTIONAL_COMPONENTS` to know thich components it has to find.

If the package is found, it should set the variable `${DEPENDENCY_NAME}_FOUND` to `ON` and should set `${DEPENDENCY_NAME}_INCLUDE_DIRS`, `${DEPENDENCY_NAME}_LIBRARY_DIRS` and `${DEPENDENCY_NAME}_LIBRARIES` appropriately.

