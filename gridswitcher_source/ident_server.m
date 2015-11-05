//
//  ident_server.m
//  Switcher
//
//  Created by Ethan Arbuckle on 10/24/15.
//  Copyright © 2015 Ethan Arbuckle. All rights reserved.
//

#import "ident_server.h"

@implementation ident_server

+ (id)daemon {
    
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (id)init {
    
    if (self = [super init]) {
        
        //create caches
        _cached_identifiers = [[NSMutableArray alloc] init];
        __private_cached_snapshots = [[NSMutableDictionary alloc] init];
        _cached_snaps = [[NSMutableArray alloc] init];
        
        //create snapshot queue
        _snap_queue = dispatch_queue_create("snapshotQueue", DISPATCH_QUEUE_CONCURRENT);
        
        //get ready and fill caches
        [self setup];
        
    }
    
    return self;
}

- (NSArray *)cachedSnapshots {
    
    //return immutable array of snapshots
    return [_cached_snaps copy];
}

- (NSArray *)cachedIdentifiers {
    
    //return immutable array of identifiers
    return [_cached_identifiers copy];
}

- (NSArray *)identifiers {
    
    //get all running display items
    NSArray *displayItems = [[NSClassFromString(@"SBAppSwitcherModel") sharedInstance] valueForKey:@"_recentDisplayItems"];
    
    //cycle through get all their idenitifiers
    NSMutableArray *mutable_idents = [[NSMutableArray alloc] initWithCapacity:[displayItems count]];
    for (SBDisplayItem *item in displayItems) {
        [mutable_idents addObject:[item valueForKey:@"_displayIdentifier"]];
    }
    
    //update the cache
    _cached_identifiers = mutable_idents;
    
    //return mutable copy of bundle ids
    return [_cached_identifiers copy];
}

- (SBApplication *)applicationWithIdentifier:(NSString *)bundleID {
    
    if (!_cached_identifiers || ![_cached_identifiers containsObject:bundleID]) {
        NSLog(@"identifier not in cache, returning sbapplication anyways");
    }
    
    return [[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:bundleID];
    
}

- (void)preheatSnapshots {
    
    [_cached_snaps removeAllObjects];
    
    //get all running display items
    NSArray *displayItems = [[NSClassFromString(@"SBAppSwitcherModel") sharedInstance] valueForKey:@"_recentDisplayItems"];

    //cycle through get all their idenitifiers
    for (SBDisplayItem *item in displayItems) {
        
        if (![__private_cached_snapshots valueForKey:[item valueForKey:@"_displayIdentifier"]]) {

            //create snapshot
            SBAppSwitcherSnapshotView *snapshotView = [NSClassFromString(@"SBAppSwitcherSnapshotView") appSwitcherSnapshotViewForDisplayItem:item orientation:0 preferringDownscaledSnapshot:YES loadAsync:YES withQueue:_snap_queue];

            //force load
            [snapshotView _loadSnapshotAsyncPreferringDownscaled:YES];
            
            [__private_cached_snapshots setValue:snapshotView forKey:[item valueForKey:@"_displayIdentifier"]];
            
            [_cached_snaps addObject:snapshotView];
        }
        else {
            
            //already in cache
            [_cached_snaps addObject:[__private_cached_snapshots valueForKey:[item valueForKey:@"_displayIdentifier"]]];
        }
    }
}

- (void)updateSnapshotForBundleID:(NSString *)bundleID {
    
    //create display item
    SBDisplayItem *item = [[NSClassFromString(@"SBDisplayItem") alloc] initWithType:@"App" displayIdentifier:bundleID];
    
    //create snapshot
    if ([__private_cached_snapshots valueForKey:[item valueForKey:@"_displayIdentifier"]]) {
        
        SBAppSwitcherSnapshotView *snapshotView = [__private_cached_snapshots valueForKey:[item valueForKey:@"_displayIdentifier"]];

        //force load
        [snapshotView _loadSnapshotAsyncPreferringDownscaled:YES];
    }
    
}

- (void)addHomescreenCard {
    
    //add springboard identifier to ident cache to keep indexes balanced
    [_cached_identifiers insertObject:@"com.apple.springboard" atIndex:0];
    
    //create homescreen preview view
    SBHomeScreenPreviewView *homescreen = [NSClassFromString(@"SBHomeScreenPreviewView") preview];
    
    //add it to front of snapshot cache
    [__private_cached_snapshots setValue:homescreen forKey:@"com.apple.springboard"];
    
}

- (void)purgeSnapshots {
    
    [__private_cached_snapshots removeAllObjects];
    [_cached_snaps removeAllObjects];
}

- (void)purgeIdentifiers {
    
    [_cached_identifiers removeAllObjects];
}

- (void)setup {
    
    //purge caches
    [self purgeIdentifiers];
    [self purgeSnapshots];
    
    //recache identifiers
    [self identifiers];
    
    //recache snapshots
    [self preheatSnapshots];
}

- (NSInteger)snapshotCount {
    
    //return count of cache
    return [_cached_snaps count];
}

- (NSInteger)identifierCount {
    
    //return count of cache
    return [_cached_identifiers count];
}

@end
