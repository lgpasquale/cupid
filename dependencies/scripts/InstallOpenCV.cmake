set(PRECOMPILED_HEADERS_OPTION "-DENABLE_PRECOMPILED_HEADERS:BOOL=OFF")
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "6.0.0")
        set(PRECOMPILED_HEADERS_OPTION "-DENABLE_PRECOMPILED_HEADERS:BOOL=ON")
    endif()
endif()
if(MSVC)
    set(PRECOMPILED_HEADERS_OPTION "-DENABLE_PRECOMPILED_HEADERS:BOOL=ON")
endif()

ExternalProject_Add(
    OpenCV
    URL "https://github.com/opencv/opencv/archive/3.2.0.zip"
    URL_MD5 "bfc6a261eb069b709bcfe7e363ef5899"
    DOWNLOAD_DIR ${DEPENDENCY_ARCHIVE_DIR}
    PREFIX ${DEPENDENCY_BASE_DIR}
    CMAKE_CACHE_ARGS "-DCMAKE_INSTALL_PREFIX:PATH=${DEPENDENCY_INSTALL_DIR}"
        "${PRECOMPILED_HEADERS_OPTION}"
    BUILD_COMMAND
        ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND
        ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install

)


