set(CMAKE_INCLUDE_CURRENT_DIR_IN_INTERFACE  ON)


add_compile_options("-Wno-unused-function" "-Wno-unused-variable" "-Wno-unused-function")

list(APPEND _tests
        test_1)

foreach(_test IN LISTS _tests)
  add_executable(${_test} ${_test}.c)

  target_include_directories(${_test}
          PRIVATE)

  target_link_libraries(${_test}
          e97)

  add_test(
          NAME ${_test}
          COMMAND $<TARGET_FILE:${_test}>)
endforeach()
