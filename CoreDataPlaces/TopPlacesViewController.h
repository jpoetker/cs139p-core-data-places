//
//  TopPlacesViewController.h
//  Places
//
//  Created by Jeff Poetker on 7/28/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrTopPlaces.h"

@interface TopPlacesViewController : UITableViewController
{
    @private
    FlickrTopPlaces *topPlaces;
}
- (id)initWithStyle:(UITableViewStyle)style inManagedObjectContext: (NSManagedObjectContext *) managedObjectContext;

@property (retain, nonatomic) FlickrTopPlaces *topPlaces;
@property (retain) NSManagedObjectContext *managedObjectContext;

@end
