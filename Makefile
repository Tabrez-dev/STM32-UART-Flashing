# Makefile for flashing STM32 firmware via UART using stm32flash
#
# Hardware assumptions:
# - The STM32F072 board uses USART1 (PA9 = TX, PA10 = RX).
# - The FTDI adapter's DTR line is connected to the board's BOOT0 pin.
#   (DTR is normally high, and this connection is used to pulse BOOT0.)
# - The built-in bootloader (activated by BOOT0 high and with nBOOT1 default = 1)
#   listens on USART1.
#
# Usage:
#   make uflash FW=firmware1.bin [PORT=/dev/ttyUSB0] [BAUD=115200]
#
# Variables:
#   FW   - The firmware binary file to flash.
#   PORT - The serial port (default: /dev/ttyUSB0).
#   BAUD - The baud rate (default: 115200).

PORT ?= /dev/ttyUSB0
BAUD ?= 115200

# The uflash target flashes the firmware specified by FW.
uflash: $(FW)
	./stm32flash -b $(BAUD) -R -i dtr:-dtr -v -w $< $(PORT)

.PHONY: uflash

