if(NOT "${DEPENDENCY_ZLIB_DIR}" STREQUAL "")
    set(ZLIB_ROOT ${DEPENDENCY_ZLIB_DIR})
endif()

find_package(ZLIB QUIET)