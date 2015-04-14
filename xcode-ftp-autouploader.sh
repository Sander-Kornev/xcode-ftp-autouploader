#!/bin/sh

#  autodeploy-ftp.sh
#
#  Created by Vladimir on 20.03.15.
#  Copyright (c) 2015 ITCraft. All rights reserved.

if !(("$CONFIGURATION" == "Release")); then
    echo "Non Release. Exiting..."
    exit 0
fi

# FTP hostname
HOST='<YOUR_HOST>'
# FTP username
USER='<YOUR_USERNAME>'
# FTP password
PASSWD='<YOUR_PASSWORD>'
# name of project (on FTP)
PROJECT='<YOUR_PROJECT>'
# path to provision profile
PROVISIONING_PROFILE="<PATH_TO_PROVISIONING_PROFILE>"
# code signing identity
DEVELOPER="<DEVELOPER_NAME>"

# plist filename on FTP
PLIST_FILENAME="${PROJECT}.plist"
# current date for archive path
DATE=$( /bin/date +"%Y-%m-%d" )
# path to folder with archives
ARCHIVE_PATH="${HOME}/Library/Developer/Xcode/Archives/${DATE}"
# path to last created archive in archives folder
ARCHIVE=$(/bin/ls -t $ARCHIVE_PATH | /usr/bin/grep xcarchive | /usr/bin/sed -n 1p)
# path to dSYM file
DSYM="${ARCHIVE_PATH}/${ARCHIVE}/dSYMs/${PROJECT_NAME}.app.dSYM"
# path to application in archive
APP="${ARCHIVE_PATH}/${ARCHIVE}/Products/Applications/${PROJECT_NAME}.app"
# name of temporary ipa file
TMP_IPA="${PROJECT_NAME//[[:blank:]]/}.ipa"
# path to info.plist file in archive
INFOPLIST="${APP}/Info.plist"
# path to application icon in archive
ICOPATH="${APP}/AppIcon60x60@2x.png"
# get version of application from info.plist file
VERSION_NUM=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${INFOPLIST}")
# get build number of application from info.plist file
BUILD_NUM=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${INFOPLIST}")
# get bundle identifier from info.plist file
BUNDLE_IDENTIFIER=$(/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" "${INFOPLIST}")
# full version of application  - version(build). Warning: don't use spaces in this name.
FULL_VERSION=$VERSION_NUM"("$BUILD_NUM")"
# name of application icon on the server
ICONNAME="appicon.png"

# create IPA file
/usr/bin/xcrun -sdk iphoneos PackageApplication -v "${APP}" -o "$(pwd)/${TMP_IPA}" --sign "${DEVELOPER}" --embed "${PROVISIONING_PROFILE}"

# make info.plist file
cat << EOF > "$(pwd)/${PLIST_FILENAME}"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>items</key>
    <array>
        <dict>
            <key>assets</key>
            <array>
                <dict>
                    <key>kind</key>
                    <string>software-package</string>
                    <key>url</key>
                    <string>https://m.itcraftlab.com/proxy.php?app_file=projects/$PROJECT/$FULL_VERSION/${TMP_IPA}</string>
                </dict>
                <dict>
                    <key>kind</key>
                    <string>display-image</string>
                     
                    <!-- optional. icon needs shine effect applied. -->
                    <key>needs-shine</key>
                    <true/>
                </dict> 
            </array>
            <key>metadata</key>
            <dict>
                <key>bundle-identifier</key>
                <string>$BUNDLE_IDENTIFIER</string>
                <key>bundle-version</key>
                <string>$FULL_VERSION</string>
                <key>kind</key>
                <string>software</string>
                <key>title</key>
                <string>$PROJECT_NAME</string>
            </dict>
        </dict>
    </array>
</dict>
</plist>
EOF

# copy application icon
cp "${ICOPATH}" "${ICONNAME}"

# upload files to FTP server
ftp -n $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
cd "projects"
cd "$PROJECT"
mkdir "$FULL_VERSION"
cd "$FULL_VERSION"
binary
put "$TMP_IPA"
put "$PLIST_FILENAME"
binary
put "${ICONNAME}"
quit
END_SCRIPT

# remove tmp-files
rm "$PLIST_FILENAME"
rm "$TMP_IPA"

exit 0