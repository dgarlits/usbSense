#!/bin/bash

# Specify the approximate size of your USB stick (e.g., 64G, 32G, etc.)
USB_SIZE="64G"  # Adjust this to match your USB stick's size

# Function to get the USB device name by size
get_usb_device() {
    # Use lsblk to find a device that matches the specified size and type
    lsblk -o NAME,SIZE,TYPE | grep "disk" | grep "${USB_SIZE}" | awk '{print $1}'
}

# Function to check if the USB device is present
check_usb() {
    USB_DEVICE=$(get_usb_device)

    if [ -n "${USB_DEVICE}" ]; then
        return 0  # USB is still plugged in
    else
        return 1  # USB has been removed
    fi
}

# Initial check for USB device
USB_DEVICE=$(get_usb_device)

if [ -z "${USB_DEVICE}" ]; then
    echo "USB device not found. Exiting..."
    exit 1
fi

# Infinite loop to keep checking the USB stick status
while true; do
    if check_usb; then
        # USB is still connected, wait before checking again
        sleep 2
    else
        # USB is removed, shutdown the system
        echo "USB device removed. Shutting down the system..."
        sudo poweroff
    fi
done
