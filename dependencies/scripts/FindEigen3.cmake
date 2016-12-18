# Eigen sets variables with prefix 'EIGEN3', we want the lowercase version 'Eigen3'
find_package(Eigen3)

set(Eigen3_FOUND ${EIGEN3_FOUND})
set(Eigen3_INCLUDE_DIRS ${EIGEN3_INCLUDE_DIRS})
set(Eigen3_VERSION_STRING ${EIGEN3_VERSION_STRING})
set(Eigen3_VERSION_MAJOR ${EIGEN3_VERSION_MAJOR})
set(Eigen3_VERSION_MINOR ${EIGEN3_VERSION_MINOR})
set(Eigen3_VERSION_PATCH ${EIGEN3_VERSION_PATCH})

