#!/bin/bash

# Get the currently logged-in user
loggedInUser=$(stat -f%Su /dev/console)
loggedInUID=$(id -u "$loggedInUser")

# Temporary files
tempRevokeFile="/tmp/revokeadmin_$$.txt"

# Check if we have a valid non-root logged in user
if [ -z "$loggedInUser" ] || [ "$loggedInUser" = "root" ]; then
    echo "No standard user logged in or the user is root. Exiting."
    exit 1
fi

echo "
██████████████████████████████████████████████████████████████████████████████████
█▌                                                                              ▐█
█▌                  ___                    ___           ___           ___      ▐█
█▌      ___        /\__\                  /\  \         /\__\         /\  \     ▐█
█▌     /\  \      /::|  |                /::\  \       /:/  /         \:\  \    ▐█
█▌     \:\  \    /:|:|  |               /:/\:\  \     /:/  /           \:\  \   ▐█
█▌     /::\__\  /:/|:|__|__            /:/  \:\  \   /:/  /  ___       /::\  \  ▐█
█▌  __/:/\/__/ /:/ |::::\__\          /:/__/ \:\__\ /:/__/  /\__\     /:/\:\__\ ▐█
█▌ /\/:/  /    \/__/~~/:/  /          \:\  \ /:/  / \:\  \ /:/  /    /:/  \/__/ ▐█
█▌ \::/__/           /:/  /            \:\  /:/  /   \:\  /:/  /    /:/  /      ▐█
█▌  \:\__\          /:/  /              \:\/:/  /     \:\/:/  /     \/__/       ▐█
█▌   \/__/         /:/  /                \::/  /       \::/  /                  ▐█
█▌                 \/__/                  \/__/         \/__/                   ▐█
█▌                                                                              ▐█
██████████████████████████████████████████████████████████████████████████████████

Your admin privileges have now been revoked." > "$tempRevokeFile"

# Function to "notify" user by opening the text file in TextEdit
notify_user_via_file() {
    local file_to_open="$1"
    # Attempt to run 'open' as the logged-in user so TextEdit appears on their screen
    sudo -u "$loggedInUser" open -a TextEdit "$file_to_open"
}

echo "Reverting $loggedInUser to standard user..."
dseditgroup -o edit -d "$loggedInUser" -t user admin

# "Notify" the user of admin revocation
notify_user_via_file "$tempRevokeFile"

# Give the user a moment to see the second file before removing them
sleep 10

# Clean up the text files
rm -f "$tempRevokeFile"

echo "Script complete."
exit 0
