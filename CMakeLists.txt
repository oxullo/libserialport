cmake_minimum_required(VERSION 3.11)

project(libserialport VERSION 0.1.2)

option(LIBSERIALPORT_STATIC_BUILD "Build libserialport as static library" ON)

include(GenerateExportHeader)

add_compile_definitions(LIBSERIALPORT_MSBUILD)
add_compile_definitions(_DEBUG)

set(SOURCES serialport.c timing.c windows.c)

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

target_link_libraries(libserialport setupapi)

target_include_directories(libserialport PUBLIC 
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
    $<INSTALL_INTERFACE:include>
)
