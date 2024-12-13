# Intune-MacOS-Admins

Solution for Intune IT admins to handle admin access elevation for MacOS users using Intune without having to deploy any third-party tools.

## What is this?

- Intune does not natively handle admin elevation on macOS. Handling admin elevation requires JAMF or other third-party tools. I decided to fix that.
- This script temporarily elevates the currently logged-in user to admin for a set duration, then revokes those privileges.
- Also included scripts to promote and demote users to admin and standard user with no time limit.

## How does it work

1. The script runs via Intune on the macOS device.  
2. Identifies the currently logged-in user and grants them admin rights.  
3. Opens a text file via TextEdit to inform the user of their temporary elevation (notifications for MacOS do not work with Intune scripts).
4. After the configured time (default: 5 minutes), revokes admin rights.  
5. Opens another text file to inform the user that admin access has ended, then cleans up the temporary files.

## How to deploy

1. Create a Security Group with the desired name in Intune.
2. Adjust the `adminDuration` variable if needed (line 8).
3. Upload admin_5mins_file_notifications.sh script to Intune as a MacOS shell script.
4. Run as root (Run script as signed-in user: NO, leave everything else as not configured or whatever you want).
5. Assign the Security Group you just created to the Script.

Same for the promote/demote scripts.

## How to use

1. When a user needs admin access, the IT admin must assign the user's DEVICE to the Security Group.
2. After waiting a 2-3 mins, user goes to Company Portal on their Mac machine and and clicks on "Check Status" on the three dots at the top right to force pull the admin script.
    - This can be a little buggy, might require user to hit "Check Status" a few times.
3. When triggered, it will elevate the user, wait, then revert them to standard.
4. IT Admin removes the user from the Security Group.

**Why use this?**  

- Allows brief admin access for tasks without permanently granting admin rights.  
- Provides a user-friendly “notification” via text files without relying on system notifications.

### Disclaimer

These scripts are provided as-is and without any warranty or support. Use at your own risk.