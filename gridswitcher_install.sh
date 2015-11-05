#!/bin/sh

#  gridswitcher_install.sh
#  gridswitcher
#
#  Created by Ethan Arbuckle
#  Copyright © 2015 CortexDevTeam. All rights reserved.

rm -rf Builds/ || true
xctool -sdk iphoneos -project gridswitcher.xcodeproj/ -scheme gridswitcher CODE_SIGNING_REQUIRED=NO owner=$1
ldid -S Builds/gridswitcher.dylib
scp -P 2222 Builds/gridswitcher.dylib root@localhost:/Library/MobileSubstrate/DynamicLibraries/gridswitcher.dylib
ssh root@localhost -p 2222 "ldid -S /Library/MobileSubstrate/DynamicLibraries/gridswitcher.dylib && killall SpringBoard"