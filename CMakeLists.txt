cmake_minimum_required(VERSION 3.11)

project(libserialport VERSION 0.1.2)

option(LIBSERIALPORT_STATIC_BUILD "Build libserialport as static library" ON)

include(GenerateExportHeader)

message("Building libserialport for system: ${CMAKE_SYSTEM_NAME}")

if(CMAKE_SYSTEM_NAME MATCHES "^Windows$")
    add_compile_definitions(LIBSERIALPORT_MSBUILD)
    set(SOURCES serialport.c timing.c windows.c)
elseif(CMAKE_SYSTEM_NAME MATCHES "^Linux$")
    set(SOURCES serialport.c timing.c linux.c linux_termios.c)
    if(COMPILER_HAS_HIDDEN_VISIBILITY)
        set(SP_PRIV "__attribute__((visibility(\"hidden\")))")
    endif()
endif()

add_compile_definitions(_DEBUG)


if(LIBSERIALPORT_STATIC_BUILD)
    message("Building libserialport as static")
    add_library(libserialport STATIC ${SOURCES})
    add_compile_definitions(LIBSERIALPORT_STATIC_BUILD)
else()
    message("Building libserialport as dynamic")
    add_library(libserialport SHARED ${SOURCES})
endif()

generate_export_header(libserialport
             BASE_NAME libserialport
             EXPORT_MACRO_NAME SP_API
             EXPORT_FILE_NAME libserialport_export.h
             STATIC_DEFINE LIBSERIALPORT_STATIC_BUILD
)

include(CheckFunctionExists)
include(CheckIncludeFiles)

check_function_exists(clock_gettime HAVE_CLOCK_GETTIME)
check_include_files(dlfcn.h HAVE_DLFCN_H)
check_include_files(sys/file.h HAVE_SYS_FILE_H)
check_function_exists(flock HAVE_FLOCK)
check_function_exists(realpath HAVE_REALPATH)


configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config.h.in ${CMAKE_CURRENT_BINARY_DIR}/config.h)

target_link_libraries(libserialport setupapi)

target_include_directories(libserialport PUBLIC 
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
    $<INSTALL_INTERFACE:include>
)
