#!/bin/bash

# Clone the Git repository
git clone "$GIT_URL" /home/developer/app

# Move into the app directory
cd /home/developer/app

#get packages
flutter pub get
# Build the APK
flutter build apk 

FILE_PATH="build\app\outputs\flutter-apk\app-release.apk"

# Install the AWS CLI if not already installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Installing..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip
fi

# Set AWS credentials for the session
export AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY"

# Upload the file to S3
aws s3 cp "$FILE_PATH" "s3://$S3_BUCKET/$(basename $UPLOAD_FILE_PATH)"

# Clear AWS credentials
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY


# Stop the container
echo "APK build and upload complete. Stopping the container..."
shutdown -h now