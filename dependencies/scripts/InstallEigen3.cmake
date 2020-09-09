ExternalProject_Add(
    EIGEN3
    URL "https://gitlab.com/libeigen/eigen/-/archive/3.3.0/eigen-3.3.0.tar.bz2"
    URL_MD5 "26aac7f87f3a50ca4db22a356b7f2c43"
    PREFIX ${DEPENDENCY_BASE_DIR}
    DOWNLOAD_DIR ${DEPENDENCY_ARCHIVE_DIR}
    CMAKE_CACHE_ARGS "-DCMAKE_INSTALL_PREFIX:PATH=${DEPENDENCY_INSTALL_DIR}"
)
