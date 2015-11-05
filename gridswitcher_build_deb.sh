#!/bin/sh

#  gridswitcher_install.sh
#  gridswitcher
#
#  Created by Ethan Arbuckle
#  Copyright © 2015 CortexDevTeam. All rights reserved.

rm gridswitcher.deb || true
rm -rf Builds/ || true
find . -name ".DS_Store" | xargs rm -f
rm gridswitcher_staging/Library/MobileSubstrate/DynamicLibraries/gridswitcher.dylib || true
xctool -sdk iphoneos -project gridswitcher.xcodeproj/ -scheme gridswitcher CODE_SIGNING_REQUIRED=NO owner=$1
cp Builds/gridswitcher.dylib gridswitcher_staging/Library/MobileSubstrate/DynamicLibraries/gridswitcher.dylib
ldid -S gridswitcher_staging/Library/MobileSubstrate/DynamicLibraries/gridswitcher.dylib
dpkg-deb -b gridswitcher_staging/ gridswitcher.deb