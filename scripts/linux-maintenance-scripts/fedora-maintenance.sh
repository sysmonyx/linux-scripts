################################################################################################################################
#    /$$$$$$
#   /$$__  $$
#  | $$  \__/ /$$   /$$  /$$$$$$$ /$$$$$$/$$$$   /$$$$$$  /$$$$$$$  /$$   /$$ /$$   /$$         # Author:   Soham Ray [Sysmonyx]
#  |  $$$$$$ | $$  | $$ /$$_____/| $$_  $$_  $$ /$$__  $$| $$__  $$| $$  | $$|  $$ /$$/
#   \____  $$| $$  | $$|  $$$$$$ | $$ \ $$ \ $$| $$  \ $$| $$  \ $$| $$  | $$ \  $$$$/          # Website:  https://sysmonyx.com
#   /$$  \ $$| $$  | $$ \____  $$| $$ | $$ | $$| $$  | $$| $$  | $$| $$  | $$  >$$  $$
#  |  $$$$$$/|  $$$$$$$ /$$$$$$$/| $$ | $$ | $$|  $$$$$$/| $$  | $$|  $$$$$$$ /$$/\  $$         # Email:    contact@sysmonyx.com
#   \______/  \____  $$|_______/ |__/ |__/ |__/ \______/ |__/  |__/ \____  $$|__/  \__/
#             /$$  | $$                                             /$$  | $$
#            |  $$$$$$/                                            |  $$$$$$/
#             \______/                                              \______/
################################################################################################################################
#   Description:    This script updates, repairs & cleans DNF & Flatpak packages on a Fedora system.
#
#   Last Updated:   06.05.2024
################################################################################################################################
#!/bin/bash

# Install necessary dependencies if not already installed. #####################################################################
echo "Checking Dependencies . . . ."

if ! command -v rpmconf &> /dev/null; then
    sudo dnf install -y rpmconf
fi
if ! command -v flatpak &> /dev/null; then
    sudo dnf install -y flatpak
fi
if ! command -v remove-retired-packages &> /dev/null; then
    sudo dnf install -y remove-retired-packages
fi


# System Update. ###############################################################################################################
echo -e "\033[7m\033[7mStarting System Update . . . .\033[0m"

# Refresh the DNF Cache.
echo "Refreshing the DNF cache . . . ."
sudo dnf -y makecache --refresh

# Check Configuration files for packages.
echo "Checking Configuration files for Packages . . . ."
sudo rpmconf -a

# Check for any Flatpak issues.
echo "Checking Flatpak packages . . . ."
sudo flatpak repair

# Update Packages.
echo "Updating DNF packages . . . ."
sudo dnf -y update

# Update Flatpaks.
echo "Updating Flatpak Packages . . . ."
sudo flatpak -y update

# Check & Install Security Updates.
echo "Checking for Security Updates . . . ."
SECUP=$(sudo dnf check-update --security | grep updates)

if [ -z "$SECUP" ]
then
    echo "No security updates found. Moving to nest step."
else
    echo "Installing Security Updates . . . ."
    sudo dnf update --security -y
fi


# System Cleanup. ##############################################################################################################
echo -e "\033[7m\033[7mStarting System Cleanup . . . .\033[0m"

# Run remove-retired-packages.
echo "Running remove-retired-packages . . . ."
sudo remove-retired-packages

# Clean old unused packages.
echo "Cleaning up old & unused packages . . . ."
sudo dnf -y autoremove

# Clean old Kernels.
echo "Cleaning up old Kernels . . . ."
sudo dnf remove --oldinstallonly -y

# Clean all cached package data.
echo "Cleaning up all Cached package data . . . ."
sudo dnf clean all

# Clean Orphaned configuration files.
sudo rpmconf -c


# User Prompt. #################################################################################################################
echo -e "\033[7m\033[7mSystem Update & Cleanup complete. Would you like to \033[0m"
echo "1. Reboot (Recommended)"
echo "2. Power-off"
echo "or"
echo "3. Exit the Terminal"

read choice

case $choice in
    1)
        sudo reboot
    ;;
    2)
        sudo poweroff
    ;;
    3)
        exit
    ;;
    *)
        echo "Invalid choice!!! Please choose 1, 2, or 3."
    ;;
esac
################################################################################################################################
