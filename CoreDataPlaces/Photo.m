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
    NSLog(@"Favorite is %@", self.favorite);
    
    self.favorite = [NSNumber numberWithBool: ([self.favorite boolValue]) ? NO : YES];
    
     NSLog(@"And now, favorite is %@", self.favorite);
    
    if ([self.favorite boolValue]) {
        self.place.favoriteCount = [NSNumber numberWithInt: [self.place.favoriteCount intValue] + 1];
    } else {
        self.place.favoriteCount = [NSNumber numberWithInt: [self.place.favoriteCount intValue] - 1];
    }
    
    NSLog(@"Favorite Count for %@ is %@", self.place.city , self.place.favoriteCount);
    
    NSError *error = nil;
    [self.managedObjectContext save: &error];
    if (error) {
        NSLog(@"%@", error.localizedFailureReason);
    }
    
}

@end
