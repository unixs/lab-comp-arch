cmake_minimum_required(VERSION 3.16 FATAL_ERROR)

project(feodorov-comp-arch LANGUAGES C ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_EXTENSIONS ON)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release")
endif()

message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")

cmake_host_system_information(RESULT CPU_HAS_SSE2 QUERY HAS_SSE2)

if(CPU_HAS_SSE2)
  message(STATUS "Found SSE2 CPU.")
else()
  message(FATAL_ERROR "CPU is not support SSE2 instruction set." )
endif()

if(CMAKE_COMPILER_IS_GNUCC)
    message(STATUS "Detected GNU compiler. Using specific flags.")
    set(CMAKE_C_FLAGS "-pipe -Wno-unused-parameter -m32 -march=i386")
    set(CMAKE_C_FLAGS_DEBUG "-Wall -Wextra -Wpedantic -O0 -ggdb3")
    set(CMAKE_C_FLAGS_RELEASE "-O3")

    set(CMAKE_ASM_FLAGS "-m32 -march=i386")
    set(CMAKE_ASM_FLAGS_DEBUG "-ggdb3")
endif()

add_subdirectory(src)

enable_testing()
add_subdirectory(tests)
