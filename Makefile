MCU = at90usb162
#MCU = at90usb1286 # Teensy++ 2.0
#MCU = atmega32u4  # Teensy 2.0/Pro Micro

APPPATH=/Applications
TOOLPATH=Arduino.app/Contents/Resources/Java/hardware/tools/avr
CC=$(APPPATH)/$(TOOLPATH)/bin/avr-gcc
OBJCOPY=$(APPPATH)/$(TOOLPATH)/bin/avr-objcopy

FLASH = teensy_loader_cli -mmcu=$(MCU) -w main.hex # Teensy
#FLASH = avrdude -p atmega32u4 -c avr109 -P /dev/ttyACM0 -D -U main.hex # Pro Micro

# 4ms is plenty often for all the updates we do
DEFINES += -DUSB_KEYBOARD_BINTERVAL=4

all:
	$(CC) -mmcu=$(MCU) -DF_CPU=16000000 -DHAVE_CONFIG_H $(DEFINES) \
		-Os -o main.elf -I. *.c
	$(OBJCOPY) -R .eeprom -R .fuse -R .lock -R .signature -O ihex main.elf main.hex

flash: all
	$(FLASH)
