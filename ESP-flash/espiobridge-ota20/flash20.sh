#!/bin/bash
echo #bootstrap
echo    esptool.py -p /dev/cu.wchusbserial1420 write_flash -fs 2MB-c1 -fm dio 0x000000 espiobridge-rboot-boot.bin 0x002000 espiobridge-rboot-image.bin
echo #erase SLAB 4 q
echo    esptool.py -p /dev/cu.SLAB_USBtoUART write_flash -fs 4MB -fm qio 0x000000 espiobridge-rboot-boot.bin 0x001000 rboot-config.bin 0x002000 espiobridge-rboot-image.bin 0x1fc000 esp_init_data_default_v08.bin 0xfb000 blank1.bin 0x1fd000 blank3.bin
echo #erase SLAB 2 d
echo    esptool.py -p /dev/cu.SLAB_USBtoUART write_flash -fs 2MB-c1 -fm dio 0x000000 espiobridge-rboot-boot.bin 0x001000 rboot-config.bin 0x002000 espiobridge-rboot-image.bin 0x1fc000 esp_init_data_default_v08.bin 0xfb000 blank1.bin 0x1fd000 blank3.bin
echo #erase w 4 q
echo    esptool.py -p /dev/cu.SLAB_USBtoUART write_flash -fs 4MB -fm qio 0x000000 espiobridge-rboot-boot.bin 0x001000 rboot-config.bin 0x002000 espiobridge-rboot-image.bin 0x1fc000 esp_init_data_default_v08.bin 0xfb000 blank1.bin 0x1fd000 blank3.bin
echo #erase w 2 d
echo    esptool.py -p /dev/cu.SLAB_USBtoUART write_flash -fs 2MB-c1 -fm dio 0x000000 espiobridge-rboot-boot.bin 0x001000 rboot-config.bin 0x002000 espiobridge-rboot-image.bin 0x1fc000 esp_init_data_default_v08.bin 0xfb000 blank1.bin 0x1fd000 blank3.bin

read -r -p "Are you sure? [Y/n]" response
 response=${response,,} # tolower
 if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
#bootstrap
#    esptool.py -p /dev/cu.wchusbserial1420 write_flash -fs 2MB-c1 -fm dio 0x000000 espiobridge-rboot-boot.bin 0x002000 espiobridge-rboot-image.bin
#erase SLAB 4 q
#    esptool.py -p /dev/cu.SLAB_USBtoUART write_flash -fs 4MB -fm qio 0x000000 espiobridge-rboot-boot.bin 0x001000 rboot-config.bin 0x002000 espiobridge-rboot-image.bin 0x1fc000 esp_init_data_default_v08.bin 0xfb000 blank1.bin 0x1fd000 blank3.bin
#erase SLAB 2 d
#   esptool.py -p /dev/cu.SLAB_USBtoUART write_flash -fs 2MB-c1 -fm dio 0x000000 espiobridge-rboot-boot.bin 0x001000 rboot-config.bin 0x002000 espiobridge-rboot-image.bin 0x1fc000 esp_init_data_default_v08.bin 0xfb000 blank1.bin 0x1fd000 blank3.bin
#erase w 4 q
    esptool.py -p /dev/cu.wchusbserial1420 write_flash -fs 4MB -fm qio 0x000000 espiobridge-rboot-boot.bin 0x001000 rboot-config.bin 0x002000 espiobridge-rboot-image.bin 0x1fc000 esp_init_data_default_v08.bin 0xfb000 blank1.bin 0x1fd000 blank3.bin
#erase w 2 d
#    esptool.py -p /dev/cu.wchusbserial1420 write_flash -fs 2MB-c1 -fm dio 0x000000 espiobridge-rboot-boot.bin 0x001000 rboot-config.bin 0x002000 espiobridge-rboot-image.bin 0x1fc000 esp_init_data_default_v08.bin 0xfb000 blank1.bin 0x1fd000 blank3.bin

 fi
