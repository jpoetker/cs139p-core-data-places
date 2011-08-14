//
//  Photo+Cache.m
//  CoreDataPlaces
//
//  Created by Jeff Poetker on 8/14/11.
//  Copyright (c) 2011 Medplus, Inc. All rights reserved.
//

#import "Photo+Cache.h"

@implementation Photo (Cache)

- (NSString *) cacheLocation: (int) kind {
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    return [cache stringByAppendingPathComponent: [NSString stringWithFormat: @"%@-%d", self.uniqueId, kind]];
}

- (void) saveDataToCache: (NSData *) photoData forKind: (int) kind
{
    NSString *photoFile = [self cacheLocation: kind];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    if (![fileManager fileExistsAtPath: photoFile]) {
        [photoData writeToFile: photoFile atomically: YES];
    }
    [fileManager release];
}

- (BOOL) removeFromCache: (int) kind
{
    BOOL removed = NO;
    NSString *photoFile = [self cacheLocation: kind];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    if ([fileManager fileExistsAtPath: photoFile]) {
        NSError *error;
        [fileManager removeItemAtPath: photoFile error: &error];
        if (error) {
            NSLog(@"%@", error.localizedFailureReason);
        } else {
            removed = YES;
        }
    }
    [fileManager release];
    return removed;
}

- (NSData *) cachedImageData: (int) kind
{
    NSString *photoFile = [self cacheLocation: kind];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSData *imageData = nil;
    
    if ([fileManager isReadableFileAtPath: photoFile]) {
        NSLog(@"Cache hit for %@", photoFile);
        imageData = [NSData dataWithContentsOfFile: photoFile];
    }
    [fileManager release];
    
    return imageData;
}

@end
