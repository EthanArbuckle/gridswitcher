//
//  gridswitcher.h
//  gridswitcher
//
//  Created by Ethan Arbuckle on 10/24/15.
//  Copyright © 2015 Ethan Arbuckle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define kMultiViewCardWidth 	80
#define kMultiViewCardHeight 	150
#define kMultiViewCardSpacing 	20

@interface SBDisplayItem : NSObject
- (id)initWithType:(NSString *)arg1 displayIdentifier:(id)arg2;
@end

@interface _UIBackdropView : UIView
- (id)initWithStyle:(int)arg1;
@end

@interface SBUIController : NSObject
+ (id)sharedInstance;
- (void)activateApplicationAnimated:(id)animated;
- (void)getRidOfAppSwitcher;
@end

@interface SBAppStatusBarManager : NSObject
- (id)sharedInstance;
- (void)showStatusBar;
@end

@interface FBWindowContextHostManager : NSObject
@end

@interface FBScene : NSObject
- (id)contextHostManager;
@end

@interface SBApplication : NSObject
@property(readonly, assign, nonatomic) int pid;
- (FBScene *)mainScene;
-(void)setFlag:(int)flag forActivationSetting:(unsigned)activationSetting;
@end

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (id)applicationWithBundleIdentifier:(id)arg1;
@end

@interface SBAppSwitcherSnapshotView : UIView
- (void)_loadSnapshotAsyncPreferringDownscaled:(_Bool)arg1;
+ (id)appSwitcherSnapshotViewForDisplayItem:(id)arg1 orientation:(long long)arg2 preferringDownscaledSnapshot:(_Bool)arg3 loadAsync:(_Bool)arg4 withQueue:(id)arg5;
@end

@interface SBHomeScreenPreviewView : UIView
+ (id)preview;
@end

@interface UIApplication (Switcher)
- (void)launchApplicationWithIdentifier: (NSString*)identifier suspended: (BOOL)suspended;
- (id)_accessibilityFrontMostApplication;
@end

@interface SBWallpaperEffectView : UIView
- (id)initWithWallpaperVariant:(long long)arg1;
- (void)setStyle:(int)style;
@end

@interface SBWallpaperController : NSObject
+(id)sharedInstance;
-(void)beginRequiringWithReason:(id)reason;
@end

@interface SBApplicationIcon : UIView
-(id)initWithApplication:(id)application;
-(id)generateIconImage:(int)image;
@end