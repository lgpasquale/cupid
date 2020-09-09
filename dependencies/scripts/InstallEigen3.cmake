ExternalProject_Add(
    EIGEN3
    URL "https://gitlab.com/libeigen/eigen/-/archive/3.3.0/eigen-3.3.0.tar.bz2"
    URL_MD5 "fd1ecefaacc9223958b6a66f9a348424"
    PREFIX ${DEPENDENCY_BASE_DIR}
    DOWNLOAD_DIR ${DEPENDENCY_ARCHIVE_DIR}
    CMAKE_CACHE_ARGS "-DCMAKE_INSTALL_PREFIX:PATH=${DEPENDENCY_INSTALL_DIR}"
)
