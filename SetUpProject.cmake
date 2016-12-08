# Only interpret if() arguments as variables or keywords when unquoted
if (NOT ${CMAKE_VERSION} VERSION_LESS "3.1")
    cmake_policy(SET CMP0054 NEW)
endif()

# This variable allows macros and functions to know where other cupid cmake
# scripts are located
set(CUPID_DIR ${CMAKE_CURRENT_LIST_DIR} CACHE INTERNAL "")
set(CUPID_DEPENDENCIES_INSTALL_SCRIPTS_DIR ${CUPID_DIR}/dependencies/scripts CACHE INTERNAL "")

#================================
# Includes
#================================
# Include cmake scripts defining other functions and macros
include(${CMAKE_CURRENT_LIST_DIR}/CopyFilesToBinaryDir.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/LinkFilesToBinaryDir.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/AddProjectDependency.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/InstallProjectDependencies.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/FindProjectDependencies.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/InstallFilesWithDirectoryStructure.cmake)

#================================
# Dependencies
#================================
# Reset cache variables
set(${PROJECT_NAME}_DEPENDENCIES "" CACHE INTERNAL "")
set(${PROJECT_NAME}_DEPENDENCIES_INCLUDE_DIRS "" CACHE INTERNAL "")
set(${PROJECT_NAME}_DEPENDENCIES_LIBRARY_DIRS "" CACHE INTERNAL "")
set(${PROJECT_NAME}_DEPENDENCIES_LIBRARIES "" CACHE INTERNAL "")
set(${PROJECT_NAME}_DEPENDENCIES_PROVIDING_USE_FILES "" CACHE INTERNAL "")

#================================
# Flags
#================================
if("${CMAKE_BUILD_TYPE}" STREQUAL "")
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release Profile CodeCoverage." FORCE)
endif()

if(MSVC)
    # Statically link libraries
    foreach(flag_var
            CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE
            CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO)
        if(${flag_var} MATCHES "/MD")
            string(REGEX REPLACE "/MD" "/MT" ${flag_var} "${${flag_var}}")
        endif(${flag_var} MATCHES "/MD")
    endforeach(flag_var)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MT")
endif()

#================================
# Installation directories
#================================
# Offer the user the choice of overriding the installation directories
set(PROJECT_LIB_INSTALL_DIR lib CACHE PATH "Installation directory for libraries")
set(PROJECT_BIN_INSTALL_DIR bin CACHE PATH "Installation directory for executables")
set(PROJECT_INCLUDE_INSTALL_DIR include CACHE PATH
  "Installation directory for header files")

if(WIN32 AND NOT CYGWIN)
  set(DEFAULT_CMAKE_INSTALL_DIR CMake)
else()
  set(DEFAULT_CMAKE_INSTALL_DIR lib/cmake/${PROJECT_NAME})
endif()
set(PROJECT_CMAKE_INSTALL_DIR ${DEFAULT_CMAKE_INSTALL_DIR} CACHE PATH
  "Installation directory for CMake files")

mark_as_advanced(PROJECT_LIB_INSTALL_DIR
    PROJECT_BIN_INSTALL_DIR
    PROJECT_INCLUDE_INSTALL_DIR
    PROJECT_CMAKE_INSTALL_DIR)

set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/${PROJECT_LIB_INSTALL_DIR}")

#================================
# Clear cache variables
#================================
set(${PROJECT_NAME}_LIBRARIES "" CACHE INTERNAL "")
set(LIBRARIES "" CACHE INTERNAL "")
