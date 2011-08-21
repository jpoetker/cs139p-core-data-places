//
//  TopPlacesViewController.m
//  Places
//
//  Created by Jeff Poetker on 7/28/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import "TopPlacesViewController.h"
#import "FlickrPhotosTableViewController.h"
#import "FlickrPhotos.h"

@implementation TopPlacesViewController

@synthesize topPlaces;
@synthesize managedObjectContext = __managedObjectContext;

- (void) setup
{
    UITabBarItem *tabItem = [[UITabBarItem alloc] initWithTabBarSystemItem: UITabBarSystemItemFeatured tag:0];
    tabItem.title = @"Top Places";
    
    self.tabBarItem = tabItem;
    self.title = @"Top Places";
    
    [tabItem release];
}

- (id)initWithStyle:(UITableViewStyle)style inManagedObjectContext: (NSManagedObjectContext *) managedObjectContext
{
    self = [super initWithStyle:style];
    if (self) {
        [self setup];
        self.managedObjectContext = managedObjectContext;
    }
    return self;
}

- (FlickrTopPlaces *)topPlaces
{
    if (!topPlaces) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        dispatch_queue_t topPlacesQueue = dispatch_queue_create("TopPlaces Queue", NULL);
        dispatch_async(topPlacesQueue, ^{
            topPlaces = [[FlickrTopPlaces alloc] init];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });    
        });
        dispatch_release(topPlacesQueue);
    }
    return topPlaces;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.topPlaces.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Place";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    id place = [topPlaces placeAtIndex: indexPath.row];

    cell.textLabel.text = [FlickrTopPlaces cityFromPlace: place];
    cell.detailTextLabel.text = [FlickrTopPlaces cityLocationFromPlace:place];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    FlickrPlacePhotos *somePhotos = [topPlaces photosForPlaceAtIndex: indexPath.row];
    FlickrPhotosTableViewController *photosController = [[FlickrPhotosTableViewController alloc] 
                                                         initWithPhotos: somePhotos 
                                                         inManagedObjectContext:self.managedObjectContext];
    
    photosController.title = [FlickrTopPlaces cityFromPlace:[topPlaces placeAtIndex:indexPath.row]];
    [self.navigationController pushViewController:photosController animated:YES];
    [photosController release];    
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(void) dealloc
{
    [topPlaces release];
    [__managedObjectContext release];
    [super dealloc];
}

@end
