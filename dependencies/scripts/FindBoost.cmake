set(BOOST_ROOT ${DEPENDENCIES_Boost_DIR})
# If we allow FindBoost to look for boost-cmake, that version will
# be used despite what we set in BOOST_ROOT
set(Boost_NO_BOOST_CMAKE TRUE)

find_package(Boost QUIET COMPONENTS ${DEPENDENCY_COMPONENTS} ${DEPENDENCY_OPTIONAL_COMPONENTS})
