#!/bin/bash
export XIL_IMPACT_USE_LIBUSB=1
export LD_PRELOAD=/usr/local/libusb-driver/libusb-driver.so
source /home/neithanmo/ixillinx/14.7/ISE_DS/settings64.sh
ise &
