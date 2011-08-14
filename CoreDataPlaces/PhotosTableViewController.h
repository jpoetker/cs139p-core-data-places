//
//  PhotosTableViewController.h
//  CoreDataPlaces
//
//  Created by Jeff Poetker on 8/13/11.
//  Copyright (c) 2011 Medplus, Inc. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface PhotosTableViewController : CoreDataTableViewController

- (id) initInManagedObjectContext:(NSManagedObjectContext *)context;
- (id) initWithPhotoPredicate: (NSPredicate *) predicate 
           withSortDescriptor: (NSArray *) sortDescriptors
       inManagedObjectContext: (NSManagedObjectContext *)context;

@end
