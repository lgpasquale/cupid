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

set(LAYOUT_OPTION "--layout=system")
if(MSVC)
    set(LAYOUT_OPTION "--layout=tagged")
endif()

message(STATUS "COMPONENTS: ${COMPONENTS}")
foreach(COMPONENT ${COMPONENTS})
    set(COMPONENTS_OPTIONS ${COMPONENTS_OPTIONS} "--with-${COMPONENT}")
endforeach()

string(TOUPPER "${CMAKE_BUILD_TYPE}" UPPERCASE_BUILD_TYPE)
set(COMPILER_FLAGS "")
get_cmake_property(VARIABLE_NAMES CACHE_VARIABLES)
foreach(VARIABLE_NAME ${VARIABLE_NAMES})
    if ("${VARIABLE_NAME}" MATCHES "^CMAKE_CX*X*_FLAGS_${UPPERCASE_BUILD_TYPE}\$" OR
        "${VARIABLE_NAME}" MATCHES "^CMAKE_CX*X*_FLAGS\$")
        MESSAGE(STATUS "VARIABLE: ${${VARIABLE_NAME}}")
        if ("${${VARIABLE_NAME}}" MATCHES "_GLIBCXX_DEBUG")
            set(COMPILER_FLAGS "cxxflags=-D_GLIBCXX_DEBUG")
        endif()
    endif()
endforeach()

ExternalProject_Add(
    Boost
    URL "https://downloads.sourceforge.net/project/boost/boost/${Boost_VERSION}/boost_${Boost_UNDERSCORED_VERSION}.tar.bz2"
    URL_MD5 "5fb94629535c19e48703bdb2b2e9490f"
    DOWNLOAD_DIR ${DEPENDENCY_ARCHIVE_DIR}
    PREFIX ${DEPENDENCY_BASE_DIR}
    CONFIGURE_COMMAND ${Boost_BOOTSTRAP_COMMAND}
    BUILD_COMMAND ${Boost_B2_COMMAND}
        --prefix=${DEPENDENCY_INSTALL_DIR}
        --variant=release
        address-model=64
        ${LAYOUT_OPTION}
        ${COMPILER_FLAGS}
        -j ${PROCESSOR_COUNT}
        ${COMPONENTS_OPTIONS}
        link=static
        runtime-link=static
        install
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND
    ""
)
