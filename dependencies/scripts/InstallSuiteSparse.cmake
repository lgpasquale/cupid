ExternalProject_Add(
    SuiteSparse
    GIT_REPOSITORY "https://github.com/jlblancoc/suitesparse-metis-for-windows"
    DOWNLOAD_DIR ${PROJECT_ARCHIVE_DIR}
    PREFIX ${PROJECT_BASE_DIR}
    CMAKE_CACHE_ARGS "-DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_INSTALL_DIR}"
)

