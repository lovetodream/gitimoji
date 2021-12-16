#!/bin/sh

#  appcast.sh
#  gitimoji
#
#  Created by Timo Zacherl on 16.12.21.
#  

set -exu

appName=$(xcodebuild -showBuildSettings | grep PRODUCT_NAME | tr -d 'PRODUCT_NAME =' | tail -1)
version=$(xcodebuild -showBuildSettings | grep MARKETING_VERSION | tr -d 'MARKETING_VERSION =')
date="$(date +'%a, %d %b %Y %H:%M:%S %z')"
minimumSystemVersion=$(xcodebuild -showBuildSettings | grep MACOSX_DEPLOYMENT_TARGET | tr -d 'MACOSX_DEPLOYMENT_TARGET =' | tail -1)
zipName="$appName.app.zip"

# The following might not be necessary but let's have it here for future ref
#SPARKLE_ED_PRIVATE_KEY=$(security find-generic-password -a ed25519 -w)
#XCODE_BUILD_PATH=$(xcodebuild -showBuildSettings | grep TARGET_BUILD_DIR | tr -d 'TARGET_BUILD_DIR =' | tail -1)
#edSignatureAndLength=$($XCODE_BUILD_PATH/../../../SourcePackages/articats/Sparkle/bin/sign_update -s $SPARKLE_ED_PRIVATE_KEY "$XCODE_BUILD_PATH/$appName")
# if this is needed add it to the <enclosure /> tag via $edSignatureAndLength

echo "
        <item>
            <title>Version $version</title>
            <pubDate>$date</pubDate>
            <sparkle:minimumSystemVersion>$minimumSystemVersion</sparkle:minimumSystemVersion>
            <sparkle:releaseNotesLink>https://github.com/lovetodream/gitimoji/releases/tag/v$version</sparkle:releaseNotesLink>
            <enclosure
                url=\"https://github.com/lovetodream/gitimoji/releases/download/v$version/$zipName\"
                sparkle:version=\"$version\"
                sparkle:shortVersionString=\"$version\"
                type=\"application/octet-stream\"/>
        </item>
" > ITEM.txt

sed -i '' -e "/<\/language>/r ITEM.txt" appcast.xml
