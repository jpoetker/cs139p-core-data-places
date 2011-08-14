//
//  Photo+Cache.h
//  CoreDataPlaces
//
//  Created by Jeff Poetker on 8/14/11.
//  Copyright (c) 2011 Medplus, Inc. All rights reserved.
//

#import "Photo.h"

@interface Photo (Cache)

- (NSData *) cachedImageData: (int) kind;
- (void) saveDataToCache: (NSData *) photoData forKind: (int) kind;
- (BOOL) removeFromCache: (int) kind;

@end
