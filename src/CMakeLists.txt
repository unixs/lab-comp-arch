set(CMAKE_INCLUDE_CURRENT_DIR_IN_INTERFACE  ON)


add_library(e97
        STATIC
        e97.s)

target_include_directories(e97
        INTERFACE
        include)
