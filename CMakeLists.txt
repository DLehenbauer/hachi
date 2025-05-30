cmake_minimum_required(VERSION 3.12)

# Have pico_sdk_import.cmake use the local SDK if it was pulled down; otherwise, use path at
# PICO_SDK_PATH environment variable as specified within pico_sdk_import.cmake
if (EXISTS "${CMAKE_SOURCE_DIR}/ext/pico-sdk/CMakeLists.txt")
    set(PICO_SDK_PATH "${CMAKE_SOURCE_DIR}/ext/pico-sdk/" CACHE INTERNAL PICO_SDK_PATH)
    message("Using local pico SDK at ('${PICO_SDK_PATH}')")
endif ()

if (NOT DEFINED PICO_SDK_PATH AND NOT DEFINED ENV{PICO_SDK_PATH})
    message(FATAL_ERROR "PICO_SDK_PATH not defined; either execute:\ngit submodule update --recursive --init\nor set PICO_SDK_PATH in environment")
endif ()

set(PICO_PLATFORM rp2040)
set(PICO_BOARD build_hat)
set(PICO_BOARD_HEADER_DIRS "${CMAKE_CURRENT_LIST_DIR}/board")
set(PICO_DEFAULT_BOOT_STAGE2_FILE "${CMAKE_SOURCE_DIR}/boot2/boot2_hachi.S")

# Pull in SDK (must be before project)
include(pico_sdk_import.cmake)
# include(pico_extras_import_optional.cmake)

project(hachi C CXX ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

if (PICO_SDK_VERSION_STRING VERSION_LESS "2.0.0")
    message(FATAL_ERROR "Raspberry Pi Pico SDK version 2.0.0 (or later) required. Your version is ${PICO_SDK_VERSION_STRING}")
endif()

# Initialize the SDK
pico_sdk_init()

add_compile_options(-Wall
        -Wno-format          # int != int32_t as far as the compiler is concerned because gcc has int32_t as long int
        -Wno-unused-function # we have some for the docs that aren't called
        )
if (CMAKE_C_COMPILER_ID STREQUAL "GNU")
    add_compile_options(-Wno-maybe-uninitialized)
endif()

add_subdirectory(src hachi)

target_compile_definitions(hachi PRIVATE
    RASPBERRYPI_PICO
    PICO_DEFAULT_UART=0
    PICO_DEFAULT_UART_TX_PIN=0
    PICO_DEFAULT_UART_RX_PIN=1
    PICO_DEFAULT_LED_PIN=25
    PICO_DEFAULT_I2C=0
    PICO_DEFAULT_I2C_SDA_PIN=4
    PICO_DEFAULT_I2C_SCL_PIN=5
    PICO_DEFAULT_SPI=0
    PICO_DEFAULT_SPI_SCK_PIN=18
    PICO_DEFAULT_SPI_TX_PIN=19
    PICO_DEFAULT_SPI_RX_PIN=16
    PICO_DEFAULT_SPI_CSN_PIN=17
    PICO_BOOT_STAGE2_CHOOSE_W25Q080=1
    PICO_FLASH_SPI_CLKDIV=2
    PICO_FLASH_SIZE_BYTES=2097152
    PICO_SMPS_MODE_PIN=23
    PICO_RP2040_B0_SUPPORTED=1
    PICO_VBUS_PIN=24
    PICO_VSYS_PIN=29

    SD_SPI=1
    SD_SPI_INSTANCE=spi1
    SD_SPI_SCK_PIN=14
    SD_SPI_TX_PIN=11
    SD_SPI_RX_PIN=12
    SD_SPI_CSN_PIN=9
    SD_DETECT_PIN=8
    SD_BAUD_RATE=12500000
)
