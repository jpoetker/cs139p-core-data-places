//
//  TopPlaces.h
//  Places
//
//  Created by Jeff Poetker on 7/28/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrPhotos.h"

@interface FlickrTopPlaces : NSObject
{
    NSArray *places; 
}

@property (retain, nonatomic) NSArray *places;

- (id) placeAtIndex: (NSUInteger) index;
- (FlickrPlacePhotos *) photosForPlaceAtIndex: (NSUInteger) index;

+ (NSString *)cityFromPlace: (id)place;
+ (NSString *)cityLocationFromPlace: (id)place;
+ (NSString *) placeIdFromPlace: (id) place;

@end
