##
# check out other repos we need
##
set( DEPDIR ${CMAKE_SOURCE_DIR}/git-dep )
##
# LIST MODULES HERE
##
set( GIT_MODULES cmdargs shm qthreads )
##
# NOW CHECK THEM OUT 
##
include(ExternalProject)

foreach( GMOD ${GIT_MODULES} )
 message( INFO " Initializing sub-module ${DEPDIR}/${GMOD} from git repo!" )
 execute_process( COMMAND git submodule init ${DEPDIR}/${GMOD}
                  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}) 
 execute_process( COMMAND git submodule update ${DEPDIR}/${GMOD} 
                  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
 ##
 # build execs if needed
 ##
 if( EXISTS ${DEPDIR}/${GMOD}/CMakeLists.txt )
    add_subdirectory( ${DEPDIR}/${GMOD} )
 elseif( EXISTS ${DEPDIR}/${GMOD}/autogen.sh )
    message( INFO " Found automake dir in git, attempting to incorporate..." )
    ExternalProject_Add( ${GMOD}
        SOURCE_DIR ${DEPDIR}/${GMOD}
        CONFIGURE_COMMAND ${DEPDIR}/${GMOD}/autogen.sh && ${DEPDIR}/${GMOD}/configure --prefix=${DEPDIR}/${GMOD}
#        INSTALL_DIR ${DEPDIR}/${GMOD}/build
        TEST_COMMAND make test
        BUILD_COMMAND make
        TEST_BEFORE_INSTALL 1
        BUILD_IN_SOURCE 1 )
 endif( EXISTS ${DEPDIR}/${GMOD}/CMakeLists.txt )
 ##
 # assume we have an include dir in the sub-module
 ##
 if( EXISTS ${DEPDIR}/${GMOD}/include )
    include_directories( ${DEPDIR}/${GMOD}/include )
 endif( EXISTS ${DEPDIR}/${GMOD}/include )
endforeach( GMOD ${GIT_MODULES} )
