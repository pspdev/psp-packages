cmake_minimum_required(VERSION 3.0)

project(text-ttf)

add_executable(${PROJECT_NAME} main.c)

find_package(SDL2 REQUIRED)

target_include_directories(${PROJECT_NAME} 
    PRIVATE ${SDL2_INCLUDE_DIRS}
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    ${SDL2_LIBRARIES}
)

if(PSP)
    target_link_libraries(${PROJECT_NAME} PRIVATE
        SDL2_ttf
        freetype
        m
        bz2
        png16
        z
    )
    create_pbp_file(
        TARGET ${PROJECT_NAME}
        ICON_PATH NULL
        BACKGROUND_PATH NULL
        PREVIEW_PATH NULL
        TITLE ${PROJECT_NAME}
    )
endif()
