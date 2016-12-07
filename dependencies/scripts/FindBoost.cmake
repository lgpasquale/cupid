set(BOOST_ROOT ${DEPENDENCY_Boost_DIR})
# If we allow FindBoost to look for boost-cmake, that version will
# be used despite what we set in BOOST_ROOT
set(Boost_NO_BOOST_CMAKE TRUE)

find_package(Boost QUIET COMPONENTS ${DEPENDENCY_${DEPENDENCY_NAME}_COMPONENTS} ${DEPENDENCY_${DEPENDENCY_NAME}_OPTIONAL_COMPONENTS})
