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
    FlickrPhotos *photos;
}
- (id)initWithPhotos: (FlickrPhotos *)somePhotos;

@property (nonatomic, retain) FlickrPhotos *photos;

@end
