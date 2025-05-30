
add_executable(hachi hachi.c 
        xmodem.c 
        led.c
        sd.c
        run_prog.S
)

target_include_directories(hachi PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory("../ext/no-OS-FatFS-SD-SPI-RPi-Pico/FatFs_SPI" hachi)

# pull in common dependencies
target_link_libraries(hachi 
        pico_stdlib 
        hardware_timer 
        hardware_flash 
        boot_uf2_headers
        FatFs_SPI
)

pico_set_binary_type(hachi default)
pico_set_linker_script(hachi ${CMAKE_CURRENT_SOURCE_DIR}/memmap.ld)

# print elf size
add_custom_command(TARGET hachi POST_BUILD
        COMMAND arm-none-eabi-size $<TARGET_FILE:hachi>
        COMMENT "Printing binary size..."
)

# create map/bin/hex file etc.
pico_add_extra_outputs(hachi)
