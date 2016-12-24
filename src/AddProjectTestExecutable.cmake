# Create an executable and the relative test
# Takes as arguments the target name and the list of source files
# The test name can be specified with the TEST_NAME option
# The arguments be passed to the executable can be specified with the ARGUMENTS option
FUNCTION(ADD_PROJECT_TEST_EXECUTABLE TARGET_NAME)
    # Parse the arguments (accepted arguments are COMPONENTS and OPTIONAL_COMPONENTS)
    # and store their values in DEPENDENCY_COMPONENTS and DEPENDENCY_OPTIONAL_COMPONENTS
    set(OPTION_NAMES)
    set(ONE_VALUE_ARG_NAMES TEST_NAME)
    set(MULTIPLE_VALUE_ARG_NAMES ARGUMENTS)
    cmake_parse_arguments(TEST "${OPTION_NAMES}" "${ONE_VALUE_ARG_NAMES}" "${MULTIPLE_VALUE_ARG_NAMES}" ${ARGN})

    # TEST_UNPARSED_ARGUMENTS is defined by cmake_parse_arguments()
    set(SOURCES ${TEST_UNPARSED_ARGUMENTS})
    add_executable(${TARGET_NAME} ${SOURCES})
    target_link_libraries(${TARGET_NAME} ${LIBRARIES})
    # This allows the test to be executed with ctest
    add_test(NAME ${TEST_TEST_NAME}
        COMMAND ${TARGET_NAME} ${TEST_ARGUMENTS}) # this is the command that will be executed to run the test

ENDFUNCTION()

