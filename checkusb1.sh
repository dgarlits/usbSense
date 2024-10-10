#!/bin/bash

# Automatically detect the USB device by checking the size and type (removable)
get_usb_device() {
    lsblk -o NAME,SIZE,RM | grep '^sd.* 1$' | awk '{print "/dev/"$1}'
}

# Get the USB device path
USB_DEVICE=$(get_usb_device)

# Check if a USB device was found
if [ -z "$USB_DEVICE" ]; then
    echo "No USB device found. Exiting."
    exit 1
else
    echo "Monitoring USB device: $USB_DEVICE"
fi

# Function to check if the USB device is still connected
check_usb() {
    if lsblk | grep -q "${USB_DEVICE##*/}"; then
        return 0  # USB is still connected
    else
        return 1  # USB has been removed
    fi
}

# Infinite loop to keep checking the USB stick status
while true; do
    if check_usb; then
        # USB is still connected, wait before checking again
        sleep 2
    else
        # USB has been removed, shut down the system
        echo "USB device removed. Shutting down the system..."
        sudo poweroff
    fi
done
