# We create and install ${PROJECT_NAME}Config.cmake and
# ${PROJECT_NAME}ConfigVersion.cmake so that ${PROJECT_NAME} can be used
# by other projects using CMake

# Make relative paths absolute (needed later on)
foreach(p LIB BIN INCLUDE CMAKE)
    set(VAR_NAME PROJECT_${p}_INSTALL_DIR)
    set(ABSOLUTE_VAR_NAME PROJECT_${p}_INSTALL_ABSOLUTE_DIR)
    if(NOT IS_ABSOLUTE "${${VAR_NAME}}")
        set(${ABSOLUTE_VAR_NAME} "${CMAKE_INSTALL_PREFIX}/${${VAR_NAME}}")
    else()
        set(${ABSOLUTE_VAR_NAME} "${${VAR_NAME}}")
    endif()
endforeach()

# Generate a string containing this project libraries
STRING(REPLACE ";" " " CONF_LIBRARIES "${${PROJECT_NAME}_LIBRARIES}")

# We use variables agnostic of the project name,
# so that we don't have to change these for every project
set(PROJECT_DEPENDENCIES_INCLUDE_DIRS ${${PROJECT_NAME}_DEPENDENCIES_INCLUDE_DIRS})
set(PROJECT_DEPENDENCIES_LIBRARY_DIRS ${${PROJECT_NAME}_DEPENDENCIES_LIBRARY_DIRS})
set(PROJECT_DEPENDENCIES_LIBRARIES ${${PROJECT_NAME}_DEPENDENCIES_LIBRARIES})
set(PROJECT_DEPENDENCIES_PROVIDING_USE_FILES ${${PROJECT_NAME}_DEPENDENCIES_PROVIDING_USE_FILES})
set(PROJECT_LIBRARIES ${${PROJECT_NAME}_LIBRARIES})
# Packages providing a USE_FILE still need to be found, so we export the directory in which they can be found in ${PROJECT_NAME}_DEPENDENCIES_${PACKAGE}_DIR
foreach(PACKAGE ${PROJECT_DEPENDENCIES_PROVIDING_USE_FILES})
    if(NOT "${DEPENDENCIES_${PACKAGE}_DIR}" STREQUAL "")
        set(SET_DEPENDENCIES_DIRS_COMMANDS "${SET_DEPENDENCIES_DIRS_COMMANDS}\nset(DEPENDENCIES_${PACKAGE}_DIR ${DEPENDENCIES_${PACKAGE}_DIR} CACHE INTERNALE \"${PACKAGE} installation base directory\")")
    endif()
endforeach()

# Create the ${PROJECT_NAME}Config.cmake and ${PROJECT_NAME}ConfigVersion files
set(CMAKE_FILES_DIRECTORY "")
file(RELATIVE_PATH REL_INCLUDE_DIR "${PROJECT_CMAKE_INSTALL_ABSOLUTE_DIR}"
    "${PROJECT_INCLUDE_INSTALL_ABSOLUTE_DIR}")
file(RELATIVE_PATH REL_LIBRARY_DIR "${PROJECT_CMAKE_INSTALL_ABSOLUTE_DIR}"
    "${PROJECT_LIB_INSTALL_ABSOLUTE_DIR}")
# ... for the install tree
set(CONF_INCLUDE_DIRS "\${${PROJECT_NAME}_CMAKE_DIR}/${REL_INCLUDE_DIR}")
set(CONF_LIBRARY_DIRS "\${${PROJECT_NAME}_CMAKE_DIR}/${REL_LIBRARY_DIR}")
configure_file(${CUPID_DIR}/src/ProjectConfig.cmake.in
    "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake" @ONLY)
# ... for both
configure_file(${CUPID_DIR}/src/ProjectConfigVersion.cmake.in
    "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake" @ONLY)

# Install the ${PROJECT_NAME}Config.cmake and ${PROJECT_NAME}ConfigVersion.cmake
install(FILES
    "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
    "${CMAKE_CURRENT_LIST_DIR}/FindThirdPartyLibrary.cmake"
    DESTINATION "${PROJECT_CMAKE_INSTALL_DIR}" COMPONENT dev)

