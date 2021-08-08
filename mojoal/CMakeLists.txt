project(mojoAL)
cmake_minimum_required(VERSION 3.0.0)

add_library(mojoal SHARED mojoal.c)
target_include_directories(mojoal PRIVATE "${PSPDEV}/psp/include/SDL2")
target_link_libraries(mojoal "SDL2 m GL pspvram ${PSP_LIBRARIES}")

