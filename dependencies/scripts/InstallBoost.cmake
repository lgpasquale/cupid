set(Boost_MAJOR_VERSION 1)
set(Boost_MINOR_VERSION 62)
set(Boost_PATCH_VERSION 0)
set(Boost_VERSION "${Boost_MAJOR_VERSION}.${Boost_MINOR_VERSION}.${Boost_PATCH_VERSION}")
set(Boost_UNDERSCORED_VERSION "${Boost_MAJOR_VERSION}_${Boost_MINOR_VERSION}_${Boost_PATCH_VERSION}")

if( UNIX )
    set(Boost_BOOTSTRAP_COMMAND ./bootstrap.sh )
    set(Boost_B2_COMMAND ./b2 )
else()
    if( WIN32 )
        set(Boost_BOOTSTRAP_COMMAND bootstrap.bat )
        set(Boost_B2_COMMAND b2.exe )
    endif()
endif()

message(STATUS "COMPONENTS: ${COMPONENTS}")
foreach(COMPONENT ${COMPONENTS})
    set(COMPONENTS_OPTIONS ${COMPONENTS_OPTIONS} "--with-${COMPONENT}")
endforeach()

ExternalProject_Add(
    Boost
    URL "https://downloads.sourceforge.net/project/boost/boost/${Boost_VERSION}/boost_${Boost_UNDERSCORED_VERSION}.tar.bz2"
    URL_MD5 "5fb94629535c19e48703bdb2b2e9490f"
    DOWNLOAD_DIR ${PROJECT_ARCHIVE_DIR}
    PREFIX ${PROJECT_BASE_DIR}
    CONFIGURE_COMMAND ${Boost_BOOTSTRAP_COMMAND}
    BUILD_COMMAND ${Boost_B2_COMMAND}
        --prefix=${PROJECT_INSTALL_DIR}
        --variant=release
        -j ${PROCESSOR_COUNT}
        ${COMPONENTS_OPTIONS}
        install
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND
    ""
)
