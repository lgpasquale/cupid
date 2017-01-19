macro(INSTALL_PROJECT_DEPENDENCIES)
    message(STATUS "Installing dependencies")

    option(DEPENDENCIES_ENABLE_INSTALLATION "Enable installation of dependencies" ON)
    foreach(DEPENDENCY_NAME ${${PROJECT_NAME}_DEPENDENCIES})
        #================================
        # Install the dependency
        #================================
        option(DEPENDENCIES_INSTALL_${DEPENDENCY_NAME} "Install ${DEPENDENCY_NAME}" ON)
        if(DEPENDENCIES_INSTALL_${DEPENDENCY_NAME} AND DEPENDENCIES_ENABLE_INSTALLATION)
            set(DEPENDENCY_ARCHIVE_DIR "${DEPENDENCIES_ARCHIVE_DIR}")
            set(DEPENDENCY_BASE_DIR "${DEPENDENCIES_INSTALL_DIR}/${DEPENDENCY_NAME}")
            set(DEPENDENCY_INSTALL_DIR "${DEPENDENCY_BASE_DIR}/install")
            if("${DEPENDENCIES_${DEPENDENCY_NAME}_DIR}" STREQUAL "")
                set(DEPENDENCIES_${DEPENDENCY_NAME}_DIR "${DEPENDENCY_INSTALL_DIR}"
                    CACHE PATH "${DEPENDENCY_NAME} installation base directory")
            endif()

            if (NOT EXISTS "${DEPENDENCY_BASE_DIR}/installation_completed.cupid")
                message(STATUS "    ==> Installing ${DEPENDENCY_NAME}")
                # Find the script providing instructions on how to install this dependency
                set(DEPENDENCY_INSTALL_SCRIPT "")
                # First look in the project specific additional directories
                foreach(DEPENDENCIES_INSTALL_SCRIPTS_DIR ${DEPENDENCIES_INSTALL_SCRIPTS_DIRS})
                    if(EXISTS "${DEPENDENCIES_INSTALL_SCRIPTS_DIR}/Install${DEPENDENCY_NAME}.cmake")
                        set(DEPENDENCY_INSTALL_SCRIPT
                            "${DEPENDENCIES_INSTALL_SCRIPTS_DIR}/Install${DEPENDENCY_NAME}.cmake")
                    endif()
                endforeach()
                # Then look in the generic directory
                if("${DEPENDENCY_INSTALL_SCRIPT}" STREQUAL "")
                    if (EXISTS "${CUPID_DEPENDENCIES_INSTALL_SCRIPTS_DIR}/Install${DEPENDENCY_NAME}.cmake")
                        set(DEPENDENCY_INSTALL_SCRIPT "${CUPID_DEPENDENCIES_INSTALL_SCRIPTS_DIR}/Install${DEPENDENCY_NAME}.cmake")
                    endif()
                endif()

                # If we have found the install script, use it to install the dependency
                if(NOT "${DEPENDENCY_INSTALL_SCRIPT}" STREQUAL "")
                    set(DEPENDENCY_SUPERBUILD_DIR ${DEPENDENCY_BASE_DIR}/superbuild)
                    configure_file("${CUPID_DIR}/src/DependencyCMakeLists.txt.in"
                        "${DEPENDENCY_SUPERBUILD_DIR}/CMakeLists.txt" @ONLY)
                    set(CONFIGURE_PROCESS_OUTPUT_FILE "${DEPENDENCY_SUPERBUILD_DIR}/configure_process.log")
                    set(BUILD_PROCESS_OUTPUT_FILE "${DEPENDENCY_SUPERBUILD_DIR}/build_process.log")
                    # If we don't escape ';', cmake will expand the list using spaces to separate values
                    string(REPLACE ";" "\;" ESCAPED_DEPENDENCY_COMPONENTS "${DEPENDENCY_COMPONENTS}")
                    string(REPLACE ";" "\;" ESCAPED_DEPENDENCY_OPTIONAL_COMPONENTS "${DEPENDENCY_OPTIONAL_COMPONENTS}")
                    # Find how many processors are available for the build
                    include(ProcessorCount)
                    ProcessorCount(PROCESSOR_COUNT)
                    if(PROCESSOR_COUNT EQUAL 0)
                        set(PROCESSOR_COUNT 1)
                    endif()
                    # Pass to the child cmake process all DEPENDENCIES_*_DIR variables
                    set(INPUT_VARIABLES "")
                    get_cmake_property(VARIABLE_NAMES CACHE_VARIABLES)
                    foreach(VARIABLE_NAME ${VARIABLE_NAMES})
                        if("${VARIABLE_NAME}" MATCHES "^DEPENDENCIES_.*_DIR$")
                            list(APPEND INPUT_VARIABLES "-D${VARIABLE_NAME}=${${VARIABLE_NAME}}")
                        endif()
                    endforeach()
                    # Configure the project
                    execute_process(COMMAND ${CMAKE_COMMAND} .
                        -G${CMAKE_GENERATOR}
                        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                        -DPROJECT_ARCHIVE_DIR=${DEPENDENCY_ARCHIVE_DIR}
                        -DPROJECT_BASE_DIR=${DEPENDENCY_BASE_DIR}
                        -DPROJECT_INSTALL_DIR=${DEPENDENCY_INSTALL_DIR}
                        -DDEPENDENCIES_ARCHIVE_DIR=${DEPENDENCIES_ARCHIVE_DIR}
                        -DDEPENDENCIES_INSTALL_DIR=${DEPENDENCIES_INSTALL_DIR}
                        -DDEPENDENCIES_INSTALL_SCRIPTS_DIRS=${DEPENDENCIES_INSTALL_SCRIPTS_DIRS}
                        -DCUPID_DIR=${CUPID_DIR}
                        -DCOMPONENTS=${ESCAPED_DEPENDENCY_COMPONENTS}
                        -DOPTIONAL_COMPONENTS=${ESCAPED_DEPENDENCY_OPTIONAL_COMPONENTS}
                        -DPROCESSOR_COUNT=${PROCESSOR_COUNT}
                        ${INPUT_VARIABLES}
                        WORKING_DIRECTORY "${DEPENDENCY_SUPERBUILD_DIR}"
                        RESULT_VARIABLE PROCESS_RESULT
                        OUTPUT_FILE ${CONFIGURE_PROCESS_OUTPUT_FILE}
                        ERROR_FILE ${CONFIGURE_PROCESS_OUTPUT_FILE}
                        )
                    if(NOT ${PROCESS_RESULT} EQUAL 0)
                        message(FATAL_ERROR "Error building ${DEPENDENCY_NAME}. Check: ${CONFIGURE_PROCESS_OUTPUT_FILE}")
                    endif()
                    # Build the project
                    execute_process(COMMAND ${CMAKE_COMMAND} --build .
                        WORKING_DIRECTORY ${DEPENDENCY_SUPERBUILD_DIR}
                        RESULT_VARIABLE PROCESS_RESULT
                        OUTPUT_FILE ${BUILD_PROCESS_OUTPUT_FILE}
                        ERROR_FILE ${BUILD_PROCESS_OUTPUT_FILE}
                        )
                    if(NOT ${PROCESS_RESULT} EQUAL 0)
                        message(FATAL_ERROR "Error building ${DEPENDENCY_NAME}. Check: ${BUILD_PROCESS_OUTPUT_FILE}")
                    endif()
                    # Retrieve all DEPENDENCIES_*_DIR variables
                    include(${DEPENDENCY_SUPERBUILD_DIR}/output_variables.cmake)
                else()
                    message(FATAL_ERROR "Cannot find Install${DEPENDENCY_NAME}.cmake. Try setting DEPENDENCIES_INSTALL_SCRIPTS_DIRS to a directory providing this file")
                endif()

                file(WRITE "${DEPENDENCY_BASE_DIR}/installation_completed.cupid"
                    "File created to mark the completion of the installation process.\n"
                    "This package won't be reinstalled as long as this file is here")
            else()
                message(STATUS "    ==> ${DEPENDENCY_NAME} has already been installed")
            endif()
        else()
            message(STATUS "    ==> Not installing ${DEPENDENCY_NAME}")
        endif()

        #================================
        # Bundle the dependency
        #================================
        # Find the script providing instructions on how to bundle libraries, binaries, ... into this installation
        set(DEPENDENCY_BUNDLE_SCRIPT "")
        # First look in the project specific directories
        foreach(DEPENDENCIES_INSTALL_SCRIPTS_DIR ${DEPENDENCIES_INSTALL_SCRIPTS_DIRS})
            if(EXISTS "${DEPENDENCIES_INSTALL_SCRIPTS_DIR}/Bundle${DEPENDENCY_NAME}.cmake")
                set(DEPENDENCY_BUNDLE_SCRIPT
                    "${DEPENDENCIES_INSTALL_SCRIPTS_DIR}/Bundle${DEPENDENCY_NAME}.cmake")
            endif()
        endforeach()
        # Then look in the generic directory
        if("${DEPENDENCY_BUNDLE_SCRIPT}" STREQUAL "")
            if (EXISTS "${CUPID_DEPENDENCIES_INSTALL_SCRIPTS_DIR}/Bundle${DEPENDENCY_NAME}.cmake")
                set(DEPENDENCY_BUNDLE_SCRIPT "${CUPID_DEPENDENCIES_INSTALL_SCRIPTS_DIR}/Bundle${DEPENDENCY_NAME}.cmake")
            endif()
        endif()

        # If we have found the bundle script, include it
        if(NOT "${DEPENDENCY_BUNDLE_SCRIPT}" STREQUAL "")
            message(STATUS "    ==> Bundling ${DEPENDENCY_NAME}")
            include("${DEPENDENCY_BUNDLE_SCRIPT}")
        endif()

    endforeach()

endmacro()
