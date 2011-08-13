//
//  FlickrTopPlaces+FlickrTopPlaces_Place.h
//  CoreDataPlaces
//
//  Created by Jeff Poetker on 8/12/11.
//  Copyright (c) 2011 Medplus, Inc. All rights reserved.
//

#import "FlickrTopPlaces.h"
#import "Place.h"

@interface FlickrTopPlaces (Place)

+ (Place *) placeForFlickrPlace: (id) place
               inManagedContext: (NSManagedObjectContext *) context;
@end
