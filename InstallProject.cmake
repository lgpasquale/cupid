#================================
# ${PROJECT_NAME}Config.cmake
#================================

# This file configures and prepares for installation
# ${PROJECT_NAME}Config.cmake and ${PROJECT_NAME}ConfigVersion.cmake
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/InstallCMakeConfigFiles.cmake)

#================================
# Installer
#================================
if(MSVC)
    # Install the required MSVC libraries
    # (should not be needed since we are linking statically)
    include(InstallRequiredSystemLibraries)
    message(STATUS ${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS})
endif()

if(WIN32)
    # Name of the installation directory
    set(CPACK_PACKAGE_INSTALL_DIRECTORY ${PROJECT_NAME})
    # Version
    set(CPACK_PACKAGE_VERSION_MAJOR ${${PROJECT_NAME}_MAJOR_VERSION})
    set(CPACK_PACKAGE_VERSION_MINOR ${${PROJECT_NAME}_MINOR_VERSION})
    set(CPACK_PACKAGE_VERSION_PATCH ${${PROJECT_NAME}_PATCH_VERSION})

    include(CPack)
endif()

