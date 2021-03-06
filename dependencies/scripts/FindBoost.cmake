set(BOOST_ROOT ${DEPENDENCIES_Boost_DIR})
# If we allow FindBoost to look for boost-cmake, that version will
# be used despite what we set in BOOST_ROOT
set(Boost_NO_BOOST_CMAKE TRUE)

if (WIN32)
    set(Boost_USE_STATIC_LIBS ON)
endif()

find_package(Boost QUIET COMPONENTS ${DEPENDENCY_COMPONENTS} ${DEPENDENCY_OPTIONAL_COMPONENTS})
