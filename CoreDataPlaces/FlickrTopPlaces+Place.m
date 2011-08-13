//
//  FlickrTopPlaces+FlickrTopPlaces_Place.m
//  CoreDataPlaces
//
//  Created by Jeff Poetker on 8/12/11.
//  Copyright (c) 2011 Medplus, Inc. All rights reserved.
//

#import "FlickrTopPlaces+FlickrTopPlaces_Place.h"

@implementation FlickrTopPlaces (FlickrTopPlaces_Place)

+ (Place *) findPlaceByPlaceId: (NSString *) placeId 
         inManagedObjectContext: (NSManagedObjectContext *) managedObjectContext
{
    Place *place = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Place" inManagedObjectContext:managedObjectContext];
    request.predicate = [NSPredicate predicateWithFormat: @"placeId = %@", placeId];
    
    NSError *error = nil;
    place = [[managedObjectContext executeFetchRequest:request error:&error] lastObject];
    [request release];
    
    if (error) {
        NSLog(@"%@", [error localizedFailureReason]);
        place = nil;
    }
    return place;
}

+ (Place *) placeForFlickrPlace: (id) flickrPlace
               inManagedContext: (NSManagedObjectContext *) context
{
    Place *place = nil;
    NSString *placeId = [FlickrTopPlaces placeIdFromPlace: place];
    
    place = [FlickrTopPlaces findPlaceByPlaceId: placeId
                         inManagedObjectContext:context];
    
    if (!place) {
        place = [NSEntityDescription insertNewObjectForEntityForName: @"Place"
                                              inManagedObjectContext: context];
        place.placeId = placeId;
        place.city = [FlickrTopPlaces cityFromPlace: place];
        place.cityLocation = [FlickrTopPlaces cityLocationFromPlace: place];
    }
    
    return place;
}
@end
