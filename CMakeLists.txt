cmake_minimum_required(VERSION 3.11)

project(libserialport VERSION 0.1.2)

add_compile_definitions(LIBSERIALPORT_MSBUILD)

file(GLOB SOURCES serialport.c timing.c windows.c)
file(GLOB HEADERS libserialport.h libserialport_internal.h)

add_library(libserialport ${SOURCES} ${HEADERS})
