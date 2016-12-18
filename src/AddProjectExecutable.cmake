# Create and install an executable
# Takes as arguments the target name and the list of source files
FUNCTION(ADD_PROJECT_EXECUTABLE TARGET_NAME)
    add_executable(${TARGET_NAME} ${ARGN})
    target_link_libraries(${TARGET_NAME} ${LIBRARIES})

    install (TARGETS ${TARGET_NAME}
        DESTINATION ${PROJECT_BIN_INSTALL_DIR})

ENDFUNCTION()

