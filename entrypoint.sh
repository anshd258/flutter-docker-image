#!/bin/bash
start=`date +%s`


# Clone the Git repository
git clone -b "$BRANCH" "$SCRIPT_URL" /home/developer/script

# Move into the app directory
cd /home/developer/script

#get script
sh build.sh



# Stop the container
echo "APK build and upload complete. Stopping the container..."
en=`date +%s`
echo Execution time was `expr $en - $start` seconds.
shutdown -h now