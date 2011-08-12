//
//  FlickrPhotosTableViewController.h
//  CoreDataPlaces
//
//  Created by Jeff Poetker on 8/12/11.
//  Copyright (c) 2011 Medplus, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrPhotos.h"

@interface FlickrPhotosTableViewController : UITableViewController
{
    FlickrPlacePhotos *photos;
}
- (id)initWithPhotos: (FlickrPlacePhotos *)somePhotos inManagedObjectContext: (NSManagedObjectContext *) managedObjectContext;

@property (nonatomic, retain) FlickrPlacePhotos *photos;
@property (retain) NSManagedObjectContext *managedObjectContext;
@end
