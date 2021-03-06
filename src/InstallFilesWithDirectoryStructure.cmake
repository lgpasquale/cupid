FUNCTION(INSTALL_FILES_WITH_DIRECTORY_STRUCTURE DEST_DIR)

FOREACH(FILE_WITH_DIR ${ARGN})
STRING(REGEX MATCH "(.*)[/\\]" DIR ${FILE_WITH_DIR})
INSTALL(FILES ${FILE_WITH_DIR} DESTINATION ${DEST_DIR}/${DIR})
ENDFOREACH(FILE_WITH_DIR)

ENDFUNCTION(INSTALL_FILES_WITH_DIRECTORY_STRUCTURE)
