//
//  PhotosTableViewController.m
//  CoreDataPlaces
//
//  Created by Jeff Poetker on 8/13/11.
//  Copyright (c) 2011 Medplus, Inc. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "PhotoViewController.h"
#import "Photo.h";
#import "Photo+FlickrFetcher.h"

@implementation PhotosTableViewController

- (id) initWithPhotoPredicate: (NSPredicate *) predicate 
           withSortDescriptor: (NSArray *) sortDescriptor
       inManagedObjectContext: (NSManagedObjectContext *)context
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName: @"Photo"
                                     inManagedObjectContext:context];
        request.sortDescriptors = sortDescriptor;
        request.predicate = predicate;
        request.fetchBatchSize = 20;
        
        NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
                                           initWithFetchRequest:request
                                           managedObjectContext:context
                                           sectionNameKeyPath: nil
                                           cacheName:@"PhotoCache"];
        [request release];
        
        self.fetchedResultsController = frc;
        [frc release];
        
        self.titleKey = @"title";
        self.subtitleKey = @"descriptionOf";
        self.searchKey = @"title";
    }
    return self;
}

- (id)initInManagedObjectContext:(NSManagedObjectContext *)context
{
    if (self = [self initWithPhotoPredicate: nil 
                         withSortDescriptor: nil 
                     inManagedObjectContext:context]) 
    {
        
    }
    return self;
}

- (UIImage *)thumbnailImageForManagedObject:(NSManagedObject *)managedObject
{
    Photo *photo = (Photo *)managedObject;
    return [photo thumbnailImage];
}

- (void)managedObjectSelected:(NSManagedObject *)managedObject
{
    Photo *photo = (Photo *)managedObject;
    
    PhotoViewController *pvc = [[PhotoViewController alloc] initWithNibName: nil
                                                                     bundle: nil];
    pvc.photo = photo;
    pvc.title = photo.title;
    
    [self.navigationController pushViewController: pvc animated: YES];
    [pvc release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
