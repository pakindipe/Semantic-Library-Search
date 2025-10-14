cmake_minimum_required(VERSION 3.16)

project(LibrarySemanticSearch VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)                       # CHANGE: ensure C++17

# FIX: we need Quick (GUI), Qml (qmlRegisterSingletonType), and Core (Qt types)
find_package(Qt6 REQUIRED COMPONENTS Quick Qml Core)   # FIX

qt_standard_project_setup(REQUIRES 6.8)

# Robust absolute paths (space-safe for "GUI Files")
set(CORE_DIR "${CMAKE_CURRENT_LIST_DIR}/../core")                  # CHANGE
set(PY_FILE  "${CMAKE_CURRENT_LIST_DIR}/../python_interface.py")   # CHANGE

# -----------------------------------------------------------------------------
# Build the 'core' bridge library (NO plugin)
# -----------------------------------------------------------------------------
add_library(core STATIC
    "${CORE_DIR}/SearchBridge.cpp"     # CHANGE
    "${CORE_DIR}/SearchBridge.h"       # CHANGE
    "${CORE_DIR}/SearchService.h"      # CHANGE
)
target_include_directories(core PUBLIC
    "${CORE_DIR}"
    "${CMAKE_CURRENT_LIST_DIR}/.."     # optional: lets core include ../book.h later
)
target_compile_definitions(core PUBLIC
    PY_SCRIPT_PATH="${PY_FILE}"
)
target_link_libraries(core
    PUBLIC Qt6::Core                   # FIX: gives QString/QObject/QProcess/QJson*
)

# -----------------------------------------------------------------------------
# Executable (the app)
# -----------------------------------------------------------------------------
qt_add_executable(appLibrarySemanticSearch
    main.cpp
)

# FIX: add RegisterSearch.cpp to the APP target (NOT in RESOURCES!)
target_sources(appLibrarySemanticSearch PRIVATE
    "${CMAKE_CURRENT_LIST_DIR}/RegisterSearch.cpp"
)

# QML module: keep QML and assets only here
qt_add_qml_module(appLibrarySemanticSearch
    URI LibrarySemanticSearch
    VERSION 1.0
    QML_FILES
        Main.qml
        HomePage.qml
        SearchResults.qml
        BookDetails.qml
    RESOURCES
        assets/cover1.jpg
)

set_target_properties(appLibrarySemanticSearch PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appLibrarySemanticSearch
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Qml                   # FIX: needed for qmlRegisterSingletonType
    PRIVATE core
)

# Optional: show python_interface.py in the tree (not built)
add_custom_target(ProjectExtras ALL
    SOURCES
        "${PY_FILE}"
)

include(GNUInstallDirs)
install(TARGETS appLibrarySemanticSearch
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
