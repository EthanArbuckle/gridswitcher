//
//  Switcher.m
//  Switcher
//
//  Created by Ethan Arbuckle on 10/24/15.
//  Copyright © 2015 Ethan Arbuckle. All rights reserved.
//

#import "gridswitcher.h"
#import "ZKSwizzle.h"
#import "ident_server.h"
#import "MultitaskView.h"

ZKSwizzleInterface($_Switcher_SBDeckSwitcherViewController, SBDeckSwitcherViewController, NSObject);

@implementation $_Switcher_SBDeckSwitcherViewController

- (void)viewWillAppear:(_Bool)arg {
    
    ZKOrig(void, arg);
    
    for (UIView *view in [[(UIViewController *)self view] subviews]) {
        
        [view removeFromSuperview];
    }
    
    MultitaskView *multi = [[MultitaskView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [[(UIViewController *)self view] addSubview:multi];
    
}

@end