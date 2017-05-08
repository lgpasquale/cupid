ExternalProject_Add(
    OpenCV
    URL "https://github.com/opencv/opencv/archive/3.2.0.zip"
    URL_MD5 "bfc6a261eb069b709bcfe7e363ef5899"
    DOWNLOAD_DIR ${DEPENDENCY_ARCHIVE_DIR}
    PREFIX ${DEPENDENCY_BASE_DIR}
    CMAKE_CACHE_ARGS "-DCMAKE_INSTALL_PREFIX:PATH=${DEPENDENCY_INSTALL_DIR}"
        "-DENABLE_PRECOMPILED_HEADERS:BOOL=OFF"
    BUILD_COMMAND
        ${CMAKE_COMMAND} --build . --config {CMAKE_BUILD_TYPE}
    INSTALL_COMMAND
        ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install

)


