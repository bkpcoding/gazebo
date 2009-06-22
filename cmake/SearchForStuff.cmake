INCLUDE (${gazebo_cmake_dir}/GazeboUtils.cmake)

INCLUDE (FindFLTK)
INCLUDE (FindPkgConfig)

SET (INCLUDE_WEBGAZEBO ON CACHE BOOL "Build webgazebo" FORCE)
SET (OGRE_LIBRARY_PATH "/usr/local/lib" CACHE INTERNAL "Ogre library path")

SET (freeimage_include_dir "/usr/include/" CACHE STRING "FreeImage include paths")
SET (freeimage_library_dir "/usr/lib" CACHE STRING "FreeImage library paths")
SET (freeimage_library "freeimage" CACHE STRING "FreeImage library")

SET (boost_include_dirs "" CACHE STRING "Boost include paths. Use this to override automatic detection.")
SET (boost_library_dirs "" CACHE STRING "Boost library paths. Use this to override automatic detection.")
SET (boost_libraries "" CACHE STRING "Boost libraries. Use this to override automatic detection.")

########################################
# Find packages
IF (PKG_CONFIG_FOUND)

  pkg_check_modules(OGRE OGRE>=${OGRE_VERSION})
  IF (NOT OGRE_FOUND)
    MESSAGE (SEND_ERROR "\nError: Ogre3d version ${OGRE_VERSION} and development files not found. See the following website: http://www.orge3d.org")
  ELSE (NOT OGRE_FOUND)
 
    SET (OGRE_LIBRARY_PATH ${OGRE_LIBRARY_DIRS} CACHE INTERNAL "Ogre library path")
    APPEND_TO_CACHED_LIST(gazeboserver_include_dirs 
                          ${gazeboserver_include_dirs_desc} 
                          ${OGRE_INCLUDE_DIRS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_dirs 
                          ${gazeboserver_link_dirs_desc} 
                          ${OGRE_LIBRARY_DIRS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_libs 
                          ${gazeboserver_link_libs_desc} 
                          ${OGRE_LINK_LIBS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_libs 
                          ${gazeboserver_link_libs_desc} 
                          ${OGRE_LIBRARIES})
    APPEND_TO_CACHED_LIST(gazeboserver_link_libs 
                          ${gazeboserver_link_libs_desc} 
                          ${OGRE_LDFLAGS})
  ENDIF (NOT OGRE_FOUND)

  pkg_check_modules(ODE ode>=${ODE_VERSION})
  IF (NOT ODE_FOUND)
    MESSAGE (SEND_ERROR "\nError: ODE and development files not found. See the following website: http://www.ode.org")
  ELSE (NOT ODE_FOUND)
    APPEND_TO_CACHED_LIST(gazeboserver_include_dirs 
                          ${gazeboserver_include_dirs_desc} 
                          ${ODE_INCLUDE_DIRS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_dirs 
                          ${gazeboserver_link_dirs_desc} 
                          ${ODE_LIBRARY_DIRS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_libs 
                          ${gazeboserver_link_libs_desc} 
                          ${ODE_LINK_LIBS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_libs 
                          ${gazeboserver_link_libs_desc} 
                          ${ODE_LIBRARIES})
    APPEND_TO_CACHED_LIST(gazeboserver_link_libs 
                          ${gazeboserver_link_libs_desc} 
                          ${ODE_LDFLAGS})
  ENDIF (NOT ODE_FOUND)

  pkg_check_modules(FI freeimage>=${FREEIMAGE_VERSION})
  IF (NOT FI_FOUND)
    MESSAGE (STATUS "freeimage.pc not found, trying freeimage_include_dir and freeimage_library_dir flags.")

    FIND_PATH(freeimage_include_dir FreeImage.h ${freeimage_include_dir})
    IF (NOT freeimage_include_dir)
      MESSAGE (STATUS "Looking for FreeImage.h - not found")
      MESSAGE (FATAL_ERROR "Unable to find FreeImage.h")
    ELSE (NOT freeimage_include_dir)

      # Check the FreeImage header for the right version
      SET (testFreeImageSource ${CMAKE_CURRENT_BINARY_DIR}/CMakeTmp/test_freeimage.cc)
      FILE (WRITE ${testFreeImageSource}
            "#include <FreeImage.h>\nint main () { if (FREEIMAGE_MAJOR_VERSION >= ${FREEIMAGE_MAJOR_VERSION} && FREEIMAGE_MINOR_VERSION >= ${FREEIMAGE_MINOR_VERSION}) return 1; else return 0;} \n")
      TRY_RUN(FREEIMAGE_RUNS FREEIMAGE_COMPILES ${CMAKE_CURRENT_BINARY_DIR} 
                ${testFreeImageSource})
      IF (NOT FREEIMAGE_RUNS)
        MESSAGE (FATAL_ERROR "Invalid FreeImage Version. Requires 
                  ${FREEIMAGE_VERSION}")
      ELSE (NOT FREEIMAGE_RUNS)
        MESSAGE (STATUS "Looking for FreeImage.h - found")
      ENDIF (NOT FREEIMAGE_RUNS)

    ENDIF (NOT freeimage_include_dir)

    FIND_LIBRARY(freeimage_library freeimage ${freeimage_library_dir})
    IF (NOT freeimage_library)
      MESSAGE (STATUS "Looking for libfreeimage - not found")
      MESSAGE (FATAL_ERROR "Unable to find libfreeimage")
    ELSE (NOT freeimage_library)
      MESSAGE (STATUS "Looking for libfreeimage - found")
    ENDIF (NOT freeimage_library)

  ELSE (NOT FI_FOUND)
    APPEND_TO_CACHED_LIST(gazeboserver_include_dirs 
                          ${gazeboserver_include_dirs_desc} 
                          ${FI_INCLUDE_DIRS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_dirs 
                          ${gazeboserver_link_dirs_desc} 
                          ${FI_LIBRARY_DIRS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_libs 
                          ${gazeboserver_link_libs_desc} 
                          ${FI_LINK_LIBS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_libs 
                          ${gazeboserver_link_libs_desc} 
                          ${FI_LIBRARIES})
    APPEND_TO_CACHED_LIST(gazeboserver_link_libs 
                          ${gazeboserver_link_libs_desc} 
                          ${FI_LDFLAGS})
  ENDIF (NOT FI_FOUND)

  pkg_check_modules(XML libxml-2.0)
  IF (NOT XML_FOUND)
    MESSAGE (SEND_ERROR "\nError: libxml2 and development files not found. See the following website: http://www.xmlsoft.org")
  ELSE (NOT XML_FOUND)
    APPEND_TO_CACHED_LIST(gazeboserver_include_dirs 
                          ${gazeboserver_include_dirs_desc} 
                          ${XML_INCLUDE_DIRS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_dirs 
                          ${gazeboserver_link_dirs_desc} 
                          ${XML_LIBRARY_DIRS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_libs 
                          ${gazeboserver_link_libs_desc} 
                          ${XML_LINK_LIBS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_libs 
                          ${gazeboserver_link_libs_desc} 
                          ${XML_LIBRARIES})
  ENDIF (NOT XML_FOUND)

  pkg_check_modules(XFT xft)
  IF (NOT XFT_FOUND)
    MESSAGE (SEND_ERROR "\nError: XFT and development files not found. See the following website: http://www.fontconfig.org")
  ELSE (NOT XFT_FOUND)
    APPEND_TO_CACHED_LIST(gazeboserver_include_dirs 
                          ${gazeboserver_include_dirs_desc} 
                          ${XFT_INCLUDE_DIRS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_dirs 
                          ${gazeboserver_link_dirs_desc} 
                          ${XFT_LIBRARY_DIRS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_libs 
                          ${gazeboserver_link_libs_desc} 
                          ${XFT_LINK_LIBS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_libs 
                          ${gazeboserver_link_libs_desc} 
                          ${XFT_LIBRARIES})
  ENDIF (NOT XFT_FOUND)

  pkg_check_modules(OAL openal)
  IF (NOT OAL_FOUND)
    MESSAGE (STATUS "Warning: Openal and development files not found. Audio capabilities will be disabled. See the following website: http://connect.creativelabs.com/openal/default.aspx")
  ELSE (NOT OAL_FOUND)
    SET (HAVE_OPENAL TRUE)
    APPEND_TO_CACHED_LIST(gazeboserver_include_dirs 
                          ${gazeboserver_include_dirs_desc} 
                          ${OAL_INCLUDE_DIRS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_dirs 
                          ${gazeboserver_link_dirs_desc} 
                          ${OAL_LIBRARY_DIRS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_libs 
                          ${gazeboserver_link_libs_desc} 
                          ${OAL_LINK_LIBS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_libs 
                          ${gazeboserver_link_libs_desc} 
                          ${OAL_LIBRARIES})
  ENDIF (NOT OAL_FOUND)

  pkg_check_modules(AVF libavformat)
  IF (NOT AVF_FOUND)
    MESSAGE (STATUS "Warning: libavformat and development files not found. Audio capabilities will be disabled.")
  ELSE (NOT AVF_FOUND)
    APPEND_TO_CACHED_LIST(gazeboserver_include_dirs 
                          ${gazeboserver_include_dirs_desc} 
                          ${AVF_INCLUDE_DIRS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_dirs 
                          ${gazeboserver_link_dirs_desc} 
                          ${AVF_LIBRARY_DIRS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_libs 
                          ${gazeboserver_link_libs_desc} 
                          ${AVF_LINK_LIBS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_libs 
                          ${gazeboserver_link_libs_desc} 
                          ${AVF_LIBRARIES})
  ENDIF (NOT AVF_FOUND)

  pkg_check_modules(AVC libavcodec)
  IF (NOT AVC_FOUND)
    MESSAGE (STATUS "Warning: libavcodec and development files not found. Audio capabilities will be disabled.")
  ELSE (NOT AVC_FOUND)
    APPEND_TO_CACHED_LIST(gazeboserver_include_dirs 
                          ${gazeboserver_include_dirs_desc} 
                          ${AVC_INCLUDE_DIRS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_dirs 
                          ${gazeboserver_link_dirs_desc} 
                          ${AVC_LIBRARY_DIRS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_libs 
                          ${gazeboserver_link_libs_desc} 
                          ${AVC_LINK_LIBS})
    APPEND_TO_CACHED_LIST(gazeboserver_link_libs 
                          ${gazeboserver_link_libs_desc} 
                          ${AVC_LIBRARIES})
  ENDIF (NOT AVC_FOUND)

  IF (AVF_FOUND AND AVC_FOUND)
    SET (HAVE_FFMPEG TRUE)
  ENDIF (AVF_FOUND AND AVC_FOUND)

  pkg_check_modules(PLAYER playerc++)
  IF (NOT PLAYER_FOUND)
    SET (INCLUDE_PLAYER OFF CACHE BOOL "Build gazebo plugin for player" FORCE)
    MESSAGE (STATUS "Warning: Player not found. The gazebo plugin for player will not be built. See the following website: http://playerstage.sourceforge.net")
  ELSE (NOT PLAYER_FOUND)
    SET (INCLUDE_PLAYER ON CACHE BOOL "Build gazebo plugin for player" FORCE)
    SET (PLAYER_INCLUDE_DIRS ${PLAYER_INCLUDE_DIRS} CACHE INTERNAL
         "Player include directory")
    SET (PLAYER_LINK_DIRS ${PLAYER_LINK_DIRS} CACHE INTERNAL
         "Player link directory")
    SET (PLAYER_LINK_LIBS ${PLAYER_LIBRARIES} CACHE INTERNAL
         "Player libraries")
  ENDIF (NOT PLAYER_FOUND)

  pkg_check_modules(WEBSIM websim)
  IF (NOT WEBSIM_FOUND)
    SET (INCLUDE_WEBGAZEBO OFF CACHE BOOL "Build webgazebo" FORCE)
    MESSAGE (STATUS "Warning: Websim not found. Webgazebo will not be built")
  ELSE (NOT WEBSIM_FOUND)
    SET (WEBSIM_INCLUDE_DIRS ${WEBSIM_INCLUDE_DIRS} CACHE INTERNAL
         "Websim include directory")
    SET (WEBSIM_LINK_DIRS ${WEBSIM_LINK_DIRS} CACHE INTERNAL 
         "Websim link directory")
    SET (WEBSIM_LINK_LIBS ${WEBSIM_LIBRARIES} CACHE INTERNAL
         "Websim libraries")
  ENDIF (NOT WEBSIM_FOUND)

ELSE (PKG_CONFIG_FOUND)
  SET (BUILD_GAZEBO OFF CACHE INTERNAL "Build Gazebo" FORCE)
  MESSAGE (FATAL_ERROR "\nError: pkg-config not found")
ENDIF (PKG_CONFIG_FOUND)


########################################
# Find Boost, if not specified manually
IF (NOT boost_include_dirs AND NOT boost_library_dirs AND NOT boost_libraries )

  # Clear some variables to ensure that the checks for boost are 
  # always run
  SET (Boost_THREAD_FOUND OFF CACHE INTERNAL "" FORCE)
  SET (Boost_SIGNALS_FOUND OFF CACHE INTERNAL "" FORCE)

  SET(Boost_ADDITIONAL_VERSIONS "1.35" "1.35.0" "1.36" "1.36.1" "1.37.0" CACHE INTERNAL "Boost Additional versions" FORCE)
  INCLUDE (FindBoost)

  FIND_PACKAGE( Boost ${MIN_BOOST_VERSION} REQUIRED thread signals )

  IF (NOT Boost_FOUND)
    SET (BUILD_GAZEBO OFF CACHE INTERNAL "Build Gazebo" FORCE)
    MESSAGE (FATAL_ERROR "Boost thread and signals not found. Please install Boost threads and signals version ${MIN_BOOST_VERSION} or higher.")
  ENDIF (NOT Boost_FOUND)

  SET (boost_include_dirs ${Boost_INCLUDE_DIRS} CACHE STRING 
    "Boost include paths. Use this to override automatic detection." FORCE)

  SET (boost_library_dirs ${Boost_LIBRARY_DIRS} CACHE STRING
    "Boost link dirs. Use this to override automatic detection." FORCE)

  LIST_TO_STRING(tmp "${Boost_LIBRARIES}")
  SET (boost_libraries ${tmp} CACHE STRING 
    "Boost libraries. Use this to override automatic detection." FORCE )

ENDIF (NOT boost_include_dirs AND NOT boost_library_dirs AND NOT boost_libraries ) 

STRING(REGEX REPLACE "(^| )-L" " " boost_library_dirs "${boost_library_dirs}")
STRING(REGEX REPLACE "(^| )-l" " " boost_libraries "${boost_libraries}")
#STRING(STRIP ${boost_library_dirs} boost_library_dirs)
#STRING(STRIP ${boost_libraries} boost_libraries)
STRING(REGEX REPLACE " " ";" boost_libraries "${boost_libraries}")

MESSAGE (STATUS "Boost Include Path: ${boost_include_dirs}")
MESSAGE (STATUS "Boost Library Path: ${boost_library_dirs}")
MESSAGE (STATUS "Boost Libraries: ${boost_libraries}")

########################################
# Find avformat and avcodec
IF (HAVE_FFMPEG)
  SET (libavformat_search_path 
    /usr/include /usr/include/libavformat /usr/local/include 
    /usr/local/include/libavformat
  )
  
  SET (libavcodec_search_path 
    /usr/include /usr/include/libavcodec /usr/local/include 
    /usr/local/include/libavcodec
  )
  
  FIND_PATH(LIBAVFORMAT_PATH avformat.h ${libavformat_search_path})
  IF (NOT LIBAVFORMAT_PATH)
    MESSAGE (STATUS "Looking for avformat.h - not found")
    MESSAGE (STATUS "  Warning: audio/video will not be built")
    SET (LIBAVFORMAT_PATH /usr/include)
  ELSE (NOT LIBAVFORMAT_PATH)
    MESSAGE (STATUS "Looking for avformat.h - found")
  ENDIF (NOT LIBAVFORMAT_PATH)

  FIND_PATH(LIBAVCODEC_PATH avcodec.h ${libavcodec_search_path})
  IF (NOT LIBAVCODEC_PATH)
    MESSAGE (STATUS "Looking for avcodec.h - not found")
    MESSAGE (STATUS "  Warning: audio/video will not be built")
    SET (LIBAVCODEC_PATH /usr/include)
  ELSE (NOT LIBAVCODEC_PATH)
    MESSAGE (STATUS "Looking for avcodec.h - found")
  ENDIF (NOT LIBAVCODEC_PATH)

ELSE (HAVE_FFMPEG)
  SET (LIBAVFORMAT_PATH /usr/include)
  SET (LIBAVCODEC_PATH /usr/include)
ENDIF (HAVE_FFMPEG)


########################################
# Find libevent
SET (libevent_search_path /usr/include /usr/local/include)
FIND_PATH(LIBEVENT_PATH event.h ${libevent_search_path})
IF (NOT LIBEVENT_PATH)
  MESSAGE (STATUS "Looking for event.h - not found")
  MESSAGE (STATUS "  Warning: webgazebo will not be built")
  SET (INCLUDE_WEBGAZEBO OFF CACHE BOOL "Found libevent" FORCE)
ELSE (NOT LIBEVENT_PATH)
  MESSAGE (STATUS "Looking for event.h - found")
ENDIF (NOT LIBEVENT_PATH)

########################################
# Find profiler library, optional
FIND_LIBRARY(PROFILER "profiler")
IF (PROFILER)
  SET (CMAKE_LINK_FLAGS_PROFILE "${CMAKE_LINK_FLAGS_PROFILE} -lprofiler" 
       CACHE INTERNAL "Link flags for profile" FORCE)
ENDIF (PROFILER)

########################################
# Find tcmalloc library, optional
FIND_LIBRARY(TCMALLOC "tcmalloc")
IF (TCMALLOC)
  SET (CMAKE_LINK_FLAGS_PROFILE "${CMAKE_LINK_FLAGS_PROFILE} -ltcmalloc" 
       CACHE INTERNAL "Link flags for profile" FORCE)
ENDIF (TCMALLOC)

########################################
# Find libtool
FIND_PATH(libtool_include_dir ltdl.h /usr/include /usr/local/include)
IF (NOT libtool_include_dir)
  MESSAGE (STATUS "Looking for ltdl.h - not found")
  MESSAGE (STATUS "Warning: Unable to find libtool, plugins will not be supported.")
  SET (libtool_include_dir /usr/include)
ELSE (NOT libtool_include_dir)
  MESSAGE (STATUS "Looking for ltdl.h - found")
ENDIF (NOT libtool_include_dir)

FIND_LIBRARY(libtool_library ltdl /usr/lib /usr/local/lib)
IF (NOT libtool_library)
  MESSAGE (STATUS "Looking for libltdl - not found")
  MESSAGE (STATUS "Warning: Unable to find libtool, plugins will not be supported.")
ELSE (NOT libtool_library)
  MESSAGE (STATUS "Looking for libltdl - found")
ENDIF (NOT libtool_library)

IF (libtool_library AND libtool_include_dir)
  SET (HAVE_LTDL TRUE)
ENDIF (libtool_library AND libtool_include_dir)
