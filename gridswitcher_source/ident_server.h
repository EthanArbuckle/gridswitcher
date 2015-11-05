//
//  ident_server.h
//  Switcher
//
//  Created by Ethan Arbuckle on 10/24/15.
//  Copyright © 2015 Ethan Arbuckle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "gridswitcher.h"

@interface ident_server : NSObject

@property (nonatomic, retain) NSMutableArray *cached_identifiers;
@property (nonatomic, retain) NSMutableDictionary *_private_cached_snapshots;
@property (nonatomic, retain) NSMutableArray *cached_snaps;
@property dispatch_queue_t snap_queue;

+ (id)daemon;
- (NSArray *)cachedSnapshots;
- (NSArray *)cachedIdentifiers;
- (NSArray *)identifiers;
- (SBApplication *)applicationWithIdentifier:(NSString *)bundleID;
- (void)preheatSnapshots;
- (void)updateSnapshotForBundleID:(NSString *)bundleID;
- (void)addHomescreenCard;
- (void)purgeSnapshots;
- (void)purgeIdentifiers;
- (void)setup;
- (NSInteger)snapshotCount;
- (NSInteger)identifierCount;

@end
