cmake_minimum_required(VERSION 3.15)
project(finance_proto_models)

find_package(Protobuf REQUIRED)

file(GLOB_RECURSE PROTO_SRCS "gen/cpp/*.pb.cc")

add_library(finance_proto_models ${PROTO_SRCS})

target_include_directories(finance_proto_models PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/gen/cpp
)

target_link_libraries(finance_proto_models PUBLIC
    protobuf::libprotobuf
)