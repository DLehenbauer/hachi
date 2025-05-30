#! /bin/bash

if [ ! -e /dev/ttyACM0 ]; then
    echo "Error: '/dev/ttyACM0' not found.  Do you need to 'sudo modprobe cdc_acm' on host?"
    echo "       (Or use 'echo cdc_acm | sudo tee -a /etc/modules' to make it permanent.)"
    exit 1
fi

minicom -b 115200 -o -D /dev/ttyACM0
