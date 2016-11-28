ExternalProject_Add(
    EIGEN3
    URL "http://bitbucket.org/eigen/eigen/get/3.3.0.tar.bz2"
    URL_MD5 "fd1ecefaacc9223958b6a66f9a348424"
    PREFIX ${PROJECT_BASE_DIR}
    DOWNLOAD_DIR ${PROJECT_ARCHIVE_DIR}
    CMAKE_CACHE_ARGS "-DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_INSTALL_DIR}"
)
