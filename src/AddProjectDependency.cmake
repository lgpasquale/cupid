macro(ADD_PROJECT_DEPENDENCY DEPENDENCY_NAME)

include(ExternalProject)

if(NOT DEFINED DEPENDENCIES_ARCHIVE_DIR)
    set(DEPENDENCIES_ARCHIVE_DIR "${CUPID_DIR}/dependencies/src" CACHE PATH
        "Path where dependency source archives are downloaded to and/or can be found")
endif()
mark_as_advanced(DEPENDENCIES_ARCHIVE_DIR)

if(NOT DEFINED DEPENDENCIES_INSTALL_DIR)
    set(DEPENDENCIES_INSTALL_DIR "${CMAKE_BINARY_DIR}/dependencies/" CACHE PATH "Path where dependencies should be installed (when used during building)")
endif()
mark_as_advanced(DEPENDENCIES_INSTALL_DIR)

#================================
# Recursively find dependencies
#================================
# If there is an Add${DEPENDENCY_NAME}Dependencies.cmake file, use it to add dependecies
# (such a file should itself call this function)
set(DEPENDENCY_ADDDEPENDENCIES_SCRIPT "")
# First look in the project specific directories
foreach(DEPENDENCIES_INSTALL_SCRIPTS_DIR ${DEPENDENCIES_INSTALL_SCRIPTS_DIRS})
    if(EXISTS "${DEPENDENCIES_INSTALL_SCRIPTS_DIR}/Add${DEPENDENCY_NAME}Dependencies.cmake")
        set(DEPENDENCY_ADDDEPENDENCIES_SCRIPT
            "${DEPENDENCIES_INSTALL_SCRIPTS_DIR}/Add${DEPENDENCY_NAME}Dependencies.cmake")
    endif()
endforeach()
# Then look in the generic directory
if("${DEPENDENCY_ADDDEPENDENCIES_SCRIPT}" STREQUAL "")
    if (EXISTS "${CUPID_DEPENDENCIES_INSTALL_SCRIPTS_DIR}/Add${DEPENDENCY_NAME}Dependencies.cmake")
        set(DEPENDENCY_ADDDEPENDENCIES_SCRIPT "${CUPID_DEPENDENCIES_INSTALL_SCRIPTS_DIR}/Add${DEPENDENCY_NAME}Dependencies.cmake")
    endif()
endif()

# If we have found the script, include it
if(NOT "${DEPENDENCY_ADDDEPENDENCIES_SCRIPT}" STREQUAL "")
    message(STATUS "Adding dependencies of ${DEPENDENCY_NAME}")
    include("${DEPENDENCY_ADDDEPENDENCIES_SCRIPT}")
endif()

#================================
# Components
#================================
message(STATUS "Adding dependency: ${DEPENDENCY_NAME}")
# Parse the arguments (accepted arguments are COMPONENTS and OPTIONAL_COMPONENTS)
# and store their values in DEPENDENCY_COMPONENTS and DEPENDENCY_OPTIONAL_COMPONENTS
set(OPTION_NAMES)
set(ONE_VALUE_ARG_NAMES)
set(MULTIPLE_VALUE_ARG_NAMES COMPONENTS OPTIONAL_COMPONENTS)
cmake_parse_arguments(DEPENDENCY "${OPTION_NAMES}" "${ONE_VALUE_ARG_NAMES}" "${MULTIPLE_VALUE_ARG_NAMES}" ${ARGN})

# Keep a list of the components (and optional components) of this dependency,
# in case this dependency is added more than once with different components
set(DEPENDENCY_${DEPENDENCY_NAME}_COMPONENTS ${DEPENDENCY_${DEPENDENCY_NAME}_COMPONENTS} CACHE INTERNAL "")
LIST(SORT DEPENDENCY_${DEPENDENCY_NAME}_COMPONENTS)
LIST(APPEND DEPENDENCY_${DEPENDENCY_NAME}_COMPONENTS ${DEPENDENCY_COMPONENTS})
LIST(REMOVE_DUPLICATES DEPENDENCY_${DEPENDENCY_NAME}_COMPONENTS)
LIST(SORT DEPENDENCY_${DEPENDENCY_NAME}_COMPONENTS)
# Same thing for optional components
set(DEPENDENCY_${DEPENDENCY_NAME}_OPTIONAL_COMPONENTS ${DEPENDENCY_${DEPENDENCY_NAME}_OPTIONAL_COMPONENTS} CACHE INTERNAL "")
LIST(SORT DEPENDENCY_${DEPENDENCY_NAME}_OPTIONAL_COMPONENTS)
LIST(APPEND DEPENDENCY_${DEPENDENCY_NAME}_OPTIONAL_COMPONENTS ${DEPENDENCY_OPTIONAL_COMPONENTS})
LIST(REMOVE_DUPLICATES DEPENDENCY_${DEPENDENCY_NAME}_OPTIONAL_COMPONENTS)
LIST(SORT DEPENDENCY_${DEPENDENCY_NAME}_OPTIONAL_COMPONENTS)

list(APPEND ${PROJECT_NAME}_DEPENDENCIES ${${PROJECT_NAME}_DEPENDENCIES} ${DEPENDENCY_NAME})
list(REMOVE_DUPLICATES ${PROJECT_NAME}_DEPENDENCIES)


endmacro(ADD_PROJECT_DEPENDENCY)

