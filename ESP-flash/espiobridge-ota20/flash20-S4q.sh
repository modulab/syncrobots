#!/bin/bash
read -r -p "Are you sure? [Y/n]" response
 response=${response,,} # tolower
 if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
    esptool.py -p /dev/cu.SLAB_USBtoUART write_flash --erase-all -fs 4MB -fm qio 0x000000 espiobridge-rboot-boot.bin 0x001000 rboot-config.bin 0x002000 espiobridge-rboot-image.bin 0x1fc000 esp_init_data_default_v08.bin 0xfb000 blank1.bin 0x1fd000 blank3.bin
 fi
