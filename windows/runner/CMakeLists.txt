cmake_minimum_required(VERSION 3.14)
project(runner LANGUAGES CXX)

# Define the application target. To change its name, change BINARY_NAME in the
# top-level CMakeLists.txt, not the value here, or `flutter run` will no longer
# work.
#
# Any new source files that you add to the application should be added here.
add_executable(${BINARY_NAME} WIN32
  "flutter_window.cpp"
  "main.cpp"
  "utils.cpp"
  "win32_window.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
  "Runner.rc"
  "runner.exe.manifest"
)

# Apply the standard set of build settings. This can be removed for applications
# that need different build settings.
apply_standard_settings(${BINARY_NAME})

# Add preprocessor definitions for the build version.
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION=\"${FLUTTER_VERSION}\"")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MAJOR=${FLUTTER_VERSION_MAJOR}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MINOR=${FLUTTER_VERSION_MINOR}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_PATCH=${FLUTTER_VERSION_PATCH}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_BUILD=${FLUTTER_VERSION_BUILD}")

# Disable Windows macros that collide with C++ standard library functions.
target_compile_definitions(${BINARY_NAME} PRIVATE "NOMINMAX")

# Add dependency libraries and include directories. Add any application-specific
# dependencies here.
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE "dwmapi.lib")
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")

# Run the Flutter tool portions of the build. This must not be removed.
add_dependencies(${BINARY_NAME} flutter_assemble)

# Bundle the RTL-SDR Blog drivers (the V4-compatible rtlsdr.dll + the DLLs it
# depends on) next to the executable, so the app can talk to the dongle out of
# the box. The files are fetched by scripts/fetch_rtlsdr_drivers.ps1 from the
# official rtlsdr-blog release; when they are absent (e.g. a bare CI checkout)
# the build still succeeds and the app simply reports that no RTL-SDR is
# available.
set(RTLSDR_BLOG_DIR "${CMAKE_SOURCE_DIR}/../resources/rtlsdr/windows")
foreach(rtlsdr_dll IN ITEMS rtlsdr.dll pthreadVC2.dll msvcr100.dll)
  if(EXISTS "${RTLSDR_BLOG_DIR}/${rtlsdr_dll}")
    add_custom_command(TARGET ${BINARY_NAME} POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${RTLSDR_BLOG_DIR}/${rtlsdr_dll}"
        "$<TARGET_FILE_DIR:${BINARY_NAME}>/${rtlsdr_dll}"
      COMMENT "Bundling ${rtlsdr_dll}"
    )
  endif()
endforeach()
