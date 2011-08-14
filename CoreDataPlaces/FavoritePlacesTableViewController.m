//
//  FavoritePlacesTableViewController.m
//  CoreDataPlaces
//
//  Created by Jeff Poetker on 8/14/11.
//  Copyright (c) 2011 Medplus, Inc. All rights reserved.
//

#import "FavoritePlacesTableViewController.h"
#import "PhotosTableViewController.h"
#import "Place.h"

@implementation FavoritePlacesTableViewController

- (id) initWithManagedObjectContext: (NSManagedObjectContext *) context
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName: @"Place"
                                     inManagedObjectContext:context];
        request.sortDescriptors = [NSArray arrayWithObjects:
                                   [NSSortDescriptor sortDescriptorWithKey:@"city"
                                                                 ascending:YES
                                                                  selector:@selector(caseInsensitiveCompare:)],
                                   [NSSortDescriptor sortDescriptorWithKey:@"cityLocation"
                                                                 ascending:YES
                                                                  selector:@selector(caseInsensitiveCompare:)], nil];
        
        request.predicate = [NSPredicate predicateWithFormat: @"favoriteCount > %@", [NSNumber numberWithInt: 0]];
        request.fetchBatchSize = 20;
        
        NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
                                           initWithFetchRequest:request
                                           managedObjectContext:context
                                           sectionNameKeyPath: nil
                                           cacheName: nil];
        [request release];
        
        
        self.fetchedResultsController = frc;
        [frc release];
        
        self.titleKey = @"city";
        self.subtitleKey = @"cityLocation";

    }
    return self;
}

- (void)managedObjectSelected:(NSManagedObject *)managedObject
{
    Place *place = (Place *)managedObject;
    
    NSPredicate *favoritePredicate = [NSPredicate predicateWithFormat: @"favorite = %@", [NSNumber numberWithBool: YES]];
    NSPredicate *placePredicate = [NSPredicate predicateWithFormat: @"place = %@", place];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
                                      [NSArray arrayWithObjects: favoritePredicate, placePredicate, nil]];
    
    NSSortDescriptor *recentlyViewed = [[NSSortDescriptor alloc] initWithKey: @"lastViewed" 
                                                                   ascending:NO];
                                          
    PhotosTableViewController *photoTvc = [[PhotosTableViewController alloc]
                                           initWithPhotoPredicate: predicate                                           withSortDescriptor: [NSArray arrayWithObject: recentlyViewed]
                                           inManagedObjectContext: place.managedObjectContext];
    [recentlyViewed release];
    
    photoTvc.title = place.city;
    [self.navigationController pushViewController: photoTvc animated: YES];
    [photoTvc release];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
