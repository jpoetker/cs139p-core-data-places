//
//  FlickrPhotos+FlickrPhotos_Photo.m
//  CoreDataPlaces
//
//  Created by Jeff Poetker on 8/12/11.
//  Copyright (c) 2011 Medplus, Inc. All rights reserved.
//

#import "FlickrPhotos+FlickrPhotos_Photo.h"
#import "Photo.h"
#import "FlickrTopPlaces.h"
#import "FlickrTopPlaces+FlickrTopPlaces_Place.h"

@implementation FlickrPhotos (FlickrPhotos_Photo)

+ (Photo *) findPhotoByUniqueId: (NSString *) uniqueId 
         inManagedObjectContext: (NSManagedObjectContext *) managedObjectContext
{
    Photo *photo = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:managedObjectContext];
    request.predicate = [NSPredicate predicateWithFormat: @"uniqueId = %@", uniqueId];
    
    NSError *error = nil;
    photo = [[managedObjectContext executeFetchRequest:request error:&error] lastObject];
    [request release];
    
    if (error) {
        NSLog(@"%@", [error localizedFailureReason]);
        photo = nil;
    }
    return photo;
}

+ (Photo *) photoForFlickrPhoto: (id) flickrPhoto 
                        takenAt: (id) place
         inManagedObjectContext: (NSManagedObjectContext *) managedObjectContext
{
    Photo *photo = nil;
    NSString *uniqueId = [FlickrPhotos uniqueIdForPhoto:flickrPhoto];
    photo = [FlickrPhotos findPhotoByUniqueId: uniqueId inManagedObjectContext: managedObjectContext];
    
    if (!photo) {
        // create a photo
        photo = [NSEntityDescription insertNewObjectForEntityForName: @"Photo"
                                              inManagedObjectContext: managedObjectContext];
        photo.uniqueId = uniqueId;
        photo.title = [FlickrPhotos titleForPhoto: photo];
        photo.descriptionOf = [FlickrPhotos descriptionForPhoto: photo];
        photo.thumbnailURL = [FlickrPhotos squareThumbnailURLForPhoto: photo];
        photo.largeImageURL = [FlickrPhotos largeImageURLForPhoto: photo];
        photo.lastViewed = [NSDate date];
        photo.favorite = NO;
        photo.place = [FlickrTopPlaces placeForFlickrPlace: place
                                          inManagedContext: managedObjectContext];    
        
    }
    return photo;
}
@end
