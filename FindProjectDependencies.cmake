macro(FIND_PROJECT_DEPENDENCIES)
    message(STATUS "Looking for dependencies")

    foreach(DEPENDENCY_NAME ${${PROJECT_NAME}_DEPENDENCIES})
        #================================
        # Find the dependency
        #================================
        foreach(SUBDEPENDENCY ${SUBDEPENDENCIES})
            find_project_dependency(SUBDEPENDENCY)
        endforeach()
        message(STATUS "    ==> Looking for ${DEPENDENCY_NAME}")
        find_project_dependency(${DEPENDENCY_NAME})
    endforeach()

endmacro()
