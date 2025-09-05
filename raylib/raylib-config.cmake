
if (NOT TARGET raylib)
    set(XPREFIX PC_RAYLIB)

    find_package(PkgConfig QUIET)
    pkg_check_modules(${XPREFIX} QUIET raylib)

    set(XPREFIX ${XPREFIX}_STATIC)

    set(raylib_DEFINITIONS ${${XPREFIX}_CFLAGS})

    find_path(raylib_INCLUDE_DIR
        NAMES raylib.h
        HINTS ${${XPREFIX}_INCLUDE_DIRS} ${raylib_DIR}/../../../include/
    )


    set(RAYLIB_NAMES libraylib.a raylib.lib)

    find_library(raylib_LIBRARY
        NAMES ${RAYLIB_NAMES}
        HINTS ${${XPREFIX}_LIBRARY_DIRS} ${raylib_DIR}/../../
    )

    set(raylib_LIBRARIES    ${raylib_LIBRARY})
    set(raylib_INCLUDE_DIRS ${raylib_INCLUDE_DIR})
    set(raylib_LDFLAGS      ${${XPREFIX}_LDFLAGS})

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(raylib DEFAULT_MSG
        raylib_LIBRARY
        raylib_INCLUDE_DIR
    )

    mark_as_advanced(raylib_LIBRARY raylib_INCLUDE_DIR)

    add_library(raylib STATIC IMPORTED GLOBAL)
    string (REPLACE ";" " " raylib_LDFLAGS "${raylib_LDFLAGS}")

    set_target_properties(raylib
      PROPERTIES
      IMPORTED_LOCATION             "${raylib_LIBRARIES}"
      IMPORTED_IMPLIB               "${raylib_LIBRARIES}"
      INTERFACE_INCLUDE_DIRECTORIES "${raylib_INCLUDE_DIRS}"
      INTERFACE_LINK_LIBRARIES      "${raylib_LDFLAGS}"
      INTERFACE_COMPILE_OPTIONS     "${raylib_DEFINITIONS}"
    )

    if (raylib_VERBOSE)
      message(STATUS "raylib_FOUND: ${raylib_FOUND}")
      message(STATUS "raylib_INCLUDE_DIRS: ${raylib_INCLUDE_DIRS}")
      message(STATUS "raylib_LIBRARIES: ${raylib_LIBRARIES}")
      message(STATUS "raylib_LDFLAGS: ${raylib_LDFLAGS}")
      message(STATUS "raylib_DEFINITIONS: ${raylib_DEFINITIONS}")
    endif()
endif()

