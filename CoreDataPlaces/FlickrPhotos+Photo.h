//
//  FlickrPhotos+FlickrPhotos_Photo.h
//  CoreDataPlaces
//
//  Created by Jeff Poetker on 8/12/11.
//  Copyright (c) 2011 Medplus, Inc. All rights reserved.
//

#import "FlickrPhotos.h"
#import "Photo.h"

@interface FlickrPhotos (Photo)

+ (Photo *) photoForFlickrPhoto: (id) flickrPhoto 
                        takenAt: (id) place 
         inManagedObjectContext: (NSManagedObjectContext *) managedObjectContext;

@end
