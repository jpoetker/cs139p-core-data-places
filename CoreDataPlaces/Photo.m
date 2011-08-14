//
//  Photo.m
//  CoreDataPlaces
//
//  Created by Jeff Poetker on 8/12/11.
//  Copyright (c) 2011 Medplus, Inc. All rights reserved.
//

#import "Photo.h"
#import "Place.h"


@implementation Photo

@dynamic descriptionOf;
@dynamic favorite;
@dynamic largeImageURL;
@dynamic lastViewed;
@dynamic thumbnailURL;
@dynamic title;
@dynamic uniqueId;
@dynamic place;

- (void) toggleFavoriteStatus
{
    self.favorite = [NSNumber numberWithBool: (self.favorite) ? NO : YES];
    if (self.favorite) {
        self.place.hasFavorites = self.favorite;
    } else {
        BOOL favoriteFound = NO;
        for(Photo *p in self.place.photos) {
            if (p.favorite) {
                favoriteFound = YES;
                break;
            }
        }
        if (!favoriteFound) {
            self.place.hasFavorites = self.favorite;
        }
    }
    NSError *error = nil;
    [self.managedObjectContext save: &error];
    if (error) {
        NSLog(@"%@", error.localizedFailureReason);
    }
}

@end
