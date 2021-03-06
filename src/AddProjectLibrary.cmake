# Create and install a library
# Takes as arguments the target name and the list of source files
FUNCTION(ADD_PROJECT_LIBRARY TARGET_NAME)
    set(SOURCES ${ARGN})
    add_library(${TARGET_NAME} ${SOURCES})
    target_link_libraries(${TARGET_NAME} ${LIBRARIES})

    install (TARGETS ${TARGET_NAME} DESTINATION ${PROJECT_LIB_INSTALL_DIR})

    # Add this library to the list of libraries generated by this project
    set(${PROJECT_NAME}_LIBRARIES ${TARGET_NAME} ${${PROJECT_NAME}_LIBRARIES} CACHE INTERNAL "")

    # Add this library to the list of libraries (both generated by this project and dependencies)
    set(LIBRARIES ${TARGET_NAME} ${LIBRARIES} CACHE INTERNAL "")

ENDFUNCTION()

