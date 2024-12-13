#!/bin/bash

# Get the currently logged-in user
loggedInUser=$(stat -f%Su /dev/console)
loggedInUID=$(id -u "$loggedInUser")

# Temporary files
tempGrantFile="/tmp/grantadmin_$$.txt"

# Check if we have a valid non-root logged in user
if [ -z "$loggedInUser" ] || [ "$loggedInUser" = "root" ]; then
    echo "No standard user logged in or the user is root. Exiting."
    exit 1
fi

# Create the text files
echo "
██████████████████████████████████████████████████████████████████
█▌                                                              ▐█
█▌                  ___                                ___      ▐█
█▌      ___        /\__\                   ___        /\__\     ▐█
█▌     /\  \      /::|  |                 /\  \      /::|  |    ▐█
█▌     \:\  \    /:|:|  |                 \:\  \    /:|:|  |    ▐█
█▌     /::\__\  /:/|:|__|__               /::\__\  /:/|:|  |__  ▐█
█▌  __/:/\/__/ /:/ |::::\__\           __/:/\/__/ /:/ |:| /\__\ ▐█
█▌ /\/:/  /    \/__/~~/:/  /          /\/:/  /    \/__|:|/:/  / ▐█
█▌ \::/__/           /:/  /           \::/__/         |:/:/  /  ▐█
█▌  \:\__\          /:/  /             \:\__\         |::/  /   ▐█
█▌   \/__/         /:/  /               \/__/         /:/  /    ▐█
█▌                 \/__/                              \/__/     ▐█
█▌                                                              ▐█
██████████████████████████████████████████████████████████████████

You have been temporarily granted admin privileges for the next 5 minutes." > "$tempGrantFile"

# Function to "notify" user by opening the text file in TextEdit
notify_user_via_file() {
    local file_to_open="$1"
    # Attempt to run 'open' as the logged-in user so TextEdit appears on their screen
    sudo -u "$loggedInUser" open -a TextEdit "$file_to_open"
}

echo "Promoting $loggedInUser to admin..."
dseditgroup -o edit -a "$loggedInUser" -t user admin

# "Notify" the user of admin elevation
notify_user_via_file "$tempGrantFile"

# Give the user a moment to see the second file before removing them
sleep 10

# Clean up the text files
rm -f "$tempGrantFile"

echo "Script complete."
exit 0
