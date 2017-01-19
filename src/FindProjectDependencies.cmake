macro(FIND_PROJECT_DEPENDENCIES)
    message(STATUS "Looking for dependencies")

    foreach(DEPENDENCY_NAME ${${PROJECT_NAME}_DEPENDENCIES})
        #================================
        # Find the dependency
        #================================
        # If there is a script named Find${DEPENDENCY_NAME}.cmake in one of
        # ${DEPENDENCIES_INSTALL_SCRIPTS_DIRS} use that to find the dependency,
        # otherwise use find_package() which relies on the modules provided by
        # CMake or by the ${DEPENDENCY_NAME}Config.cmake file provided by the
        # package itself

        message(STATUS "    ==> Looking for ${DEPENDENCY_NAME}")

        # CMAKE_PREFIX_PATH is where find_package, find_library and find_file
        # look for files. We set this to the user defined DEPENDENCIES_<package>_DIR
        # so that system installations of the library don't prevail (we later restore it to its original value)
        set(ENV_CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH})
        set(DEPENDENCIES_${DEPENDENCY_NAME}_DIR "" CACHE PATH "${DEPENDENCY_NAME} installation base directory")
        set(CMAKE_PREFIX_PATH ${DEPENDENCIES_${DEPENDENCY_NAME}_DIR})

        set(DEPENDENCY_FIND_SCRIPT "")
        # First look in the project specific additional directories
        foreach(DEPENDENCIES_INSTALL_SCRIPTS_DIR ${DEPENDENCIES_INSTALL_SCRIPTS_DIRS})
            if(EXISTS "${DEPENDENCIES_INSTALL_SCRIPTS_DIR}/Find${DEPENDENCY_NAME}.cmake")
                set(DEPENDENCY_FIND_SCRIPT
                    "${DEPENDENCIES_INSTALL_SCRIPTS_DIR}/Find${DEPENDENCY_NAME}.cmake")
            endif()
        endforeach()
        # Then look in the generic directory
        if("${DEPENDENCY_FIND_SCRIPT}" STREQUAL "")
            if (EXISTS "${CUPID_DEPENDENCIES_INSTALL_SCRIPTS_DIR}/Find${DEPENDENCY_NAME}.cmake")
                set(DEPENDENCY_FIND_SCRIPT "${CUPID_DEPENDENCIES_INSTALL_SCRIPTS_DIR}/Find${DEPENDENCY_NAME}.cmake")
            endif()
        endif()

        # If we have found the script, use it to find the dependency, otherwise
        # rely on find_package()
        if(NOT "${DEPENDENCY_FIND_SCRIPT}" STREQUAL "")
            set(DEPENDENCY_COMPONENTS ${DEPENDENCY_${DEPENDENCY_NAME}_COMPONENTS})
            set(DEPENDENCY_OPTIONAL_COMPONENTS ${DEPENDENCY_${DEPENDENCY_NAME}_OPTIONAL_COMPONENTS})
            include(${DEPENDENCY_FIND_SCRIPT})
        else()
            find_package(${DEPENDENCY_NAME} QUIET COMPONENTS ${DEPENDENCY_${DEPENDENCY_NAME}_COMPONENTS} ${DEPENDENCY_${DEPENDENCY_NAME}_OPTIONAL_COMPONENTS})
        endif()

        # We want the user to use DEPENDENCIES_${DEPENDENCY_NAME}_DIR, and not ${DEPENDENCY_NAME}_DIR,
        # which is set by find_package
        mark_as_advanced(${DEPENDENCY_NAME}_DIR)

        if(NOT ${DEPENDENCY_NAME}_FOUND)
            message(FATAL_ERROR "${DEPENDENCY_NAME} not found. Try setting DEPENDENCIES_${DEPENDENCY_NAME}_DIR to the installation path of ${DEPENDENCY_NAME}")
        endif()

        # Restore CMAKE_PREFIX_PATH to its original value
        set(CMAKE_PREFIX_PATH ${ENV_CMAKE_PREFIX_PATH})

        # Different packages use different variables to store include directories
        if(DEFINED ${DEPENDENCY_NAME}_INCLUDES)
            set(${PROJECT_NAME}_DEPENDENCIES_INCLUDE_DIRS ${${PROJECT_NAME}_DEPENDENCIES_INCLUDE_DIRS}
                ${${DEPENDENCY_NAME}_INCLUDES}
                CACHE INTERNAL "")
        endif()
        if(DEFINED ${DEPENDENCY_NAME}_INCLUDE_DIR)
            set(${PROJECT_NAME}_DEPENDENCIES_INCLUDE_DIRS ${${PROJECT_NAME}_DEPENDENCIES_INCLUDE_DIRS}
                ${${DEPENDENCY_NAME}_INCLUDE_DIR}
                CACHE INTERNAL "")
        endif()
        if(DEFINED ${DEPENDENCY_NAME}_INCLUDE_DIRS)
            set(${PROJECT_NAME}_DEPENDENCIES_INCLUDE_DIRS ${${PROJECT_NAME}_DEPENDENCIES_INCLUDE_DIRS}
            ${${DEPENDENCY_NAME}_INCLUDE_DIRS}
            CACHE INTERNAL "")
        endif()
        if(DEFINED ${DEPENDENCY_NAME}_INCLUDE_DIR_CPP)
            set(${PROJECT_NAME}_DEPENDENCIES_INCLUDE_DIRS ${${PROJECT_NAME}_DEPENDENCIES_INCLUDE_DIRS}
                ${${DEPENDENCY_NAME}_INCLUDE_DIR_CPP}
                CACHE INTERNAL "")
        endif()

        # Library directories
        if(DEFINED ${DEPENDENCY_NAME}_LIBRARY_DIRS)
            set(${PROJECT_NAME}_DEPENDENCIES_LIBRARY_DIRS ${${PROJECT_NAME}_DEPENDENCIES_LIBRARY_DIRS}
                ${${DEPENDENCY_NAME}_LIBRARY_DIRS}
                CACHE INTERNAL "")
        endif()

        # Libraries
        if(DEFINED ${DEPENDENCY_NAME}_LIBRARIES)
            set(${PROJECT_NAME}_DEPENDENCIES_LIBRARIES ${${PROJECT_NAME}_DEPENDENCIES_LIBRARIES}
                ${${DEPENDENCY_NAME}_LIBRARIES}
                CACHE INTERNAL "")
        endif()

        # Some libraries have a USE_FILE which needs to be included
        if(DEFINED ${DEPENDENCY_NAME}_USE_FILE)
            set(${PROJECT_NAME}_DEPENDENCIES_USE_FILES
                ${${PROJECT_NAME}_DEPENDENCIES_USE_FILES}
                ${${DEPENDENCY_NAME}_USE_FILE})
            include(${${DEPENDENCY_NAME}_USE_FILE})
        endif()

        # The package itself could have DEPENDENCIES libraries and includes
        if(DEFINED ${DEPENDENCY_NAME}_DEPENDENCIES_INCLUDE_DIRS)
            set(${PROJECT_NAME}_DEPENDENCIES_INCLUDE_DIRS ${${PROJECT_NAME}_DEPENDENCIES_INCLUDE_DIRS}
                ${${DEPENDENCY_NAME}_DEPENDENCIES_INCLUDE_DIRS}
                CACHE INTERNAL "")
        endif()
        if(DEFINED ${DEPENDENCY_NAME}_DEPENDENCIES_LIBRARY_DIRS)
            set(${PROJECT_NAME}_DEPENDENCIES_LIBRARY_DIRS ${${PROJECT_NAME}_DEPENDENCIES_LIBRARY_DIRS}
                ${${DEPENDENCY_NAME}_DEPENDENCIES_LIBRARY_DIRS}
                CACHE INTERNAL "")
        endif()
        if(DEFINED ${DEPENDENCY_NAME}_DEPENDENCIES_USE_FILES)
            set(${PROJECT_NAME}_DEPENDENCIES_USE_FILES
                ${${PROJECT_NAME}_DEPENDENCIES_USE_FILES}
                ${${DEPENDENCY_NAME}_DEPENDENCIES_USE_FILES}
                CACHE INTERNAL "")
        endif()
    endforeach()

    # Use the dependencies found
    include_directories(SYSTEM ${${PROJECT_NAME}_DEPENDENCIES_INCLUDE_DIRS})
    link_directories(${${PROJECT_NAME}_DEPENDENCIES_LIBRARY_DIRS})
    set(LIBRARIES
        ${${PROJECT_NAME}_DEPENDENCIES_LIBRARIES}
        CACHE INTERNAL "")

endmacro()
