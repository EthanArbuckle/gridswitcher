//
//  SBAppSwitcherModel.m
//  Switcher
//
//  Created by Ethan Arbuckle on 10/26/15.
//  Copyright © 2015 Ethan Arbuckle. All rights reserved.
//

#import "gridswitcher.h"
#import "ZKSwizzle.h"
#import "ident_server.h"

ZKSwizzleInterface($_Switcher_SBAppSwitcherModel, SBAppSwitcherModel, NSObject);

@implementation $_Switcher_SBAppSwitcherModel

- (void)_appActivationStateDidChange:(NSNotification *)arg1 {
   
    //get application
    SBApplication *app = [arg1 object];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {

        //make sure our caches are up to date
        [[ident_server daemon] updateSnapshotForBundleID:[app valueForKey:@"_bundleIdentifier"]];
        [[ident_server daemon] identifiers];
        [[ident_server daemon] preheatSnapshots];
        
    });
    
    ZKOrig(void, arg1);
}
@end