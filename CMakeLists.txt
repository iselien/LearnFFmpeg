cmake_minimum_required(VERSION 3.5)
project(LearnFFmpeg)

find_package(PkgConfig REQUIRED)
pkg_check_modules(LIBAV REQUIRED IMPORTED_TARGET
    # libavdevice
    # libavfilter
    libavformat
    libavcodec
    libswresample
    # libswscale
    libavutil
)

include_directories(${CMAKE_SOURCE_DIR}/includes)

add_executable(${PROJECT_NAME} src/main.c)

target_link_libraries(${PROJECT_NAME} PkgConfig::LIBAV)
