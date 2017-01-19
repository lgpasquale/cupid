ExternalProject_Add(
    SuiteSparse
    GIT_REPOSITORY "https://github.com/jlblancoc/suitesparse-metis-for-windows"
    DOWNLOAD_DIR ${DEPENDENCY_ARCHIVE_DIR}
    PREFIX ${DEPENDENCY_BASE_DIR}
    CMAKE_CACHE_ARGS "-DCMAKE_INSTALL_PREFIX:PATH=${DEPENDENCY_INSTALL_DIR}"
)

