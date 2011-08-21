//
//  FlickrPhotosTableViewController.m
//  CoreDataPlaces
//
//  Created by Jeff Poetker on 8/12/11.
//  Copyright (c) 2011 Medplus, Inc. All rights reserved.
//

#import "FlickrPhotosTableViewController.h"
#import "FlickrPhotos.h"
#import "FlickrPhotos+Photo.h"
#import "PhotoViewController.h"
#import "TableViewActivityCell.h"

@implementation FlickrPhotosTableViewController

@synthesize photos;
@synthesize managedObjectContext = __managedObjectContext;


- (id)initWithPhotos: (FlickrPlacePhotos *)somePhotos inManagedObjectContext: (NSManagedObjectContext *) managedObjectContext
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.photos = somePhotos;
        self.managedObjectContext = managedObjectContext;
        
    }
    return self;
}

-(void)setPhotos:(FlickrPlacePhotos *)somePhotos  
{
    [photos release];
    photos = [somePhotos retain];
    [self.view setNeedsDisplay];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return [photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierWithThumb = @"PhotoWithThumb";
    static NSString *CellIdentifierWaiting = @"CellWaiting";
    
    id photo = [photos photoAtIndex: indexPath.row];
    UITableViewCell *cell = nil;
    
    NSData *imageData = [FlickrPhotos thumbnailDataOf: photo];
    if (imageData) {
        cell  = [tableView dequeueReusableCellWithIdentifier:CellIdentifierWithThumb];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierWithThumb] autorelease];
        }
        cell.imageView.image = [UIImage imageWithData: imageData];
    } else {
        cell  = [tableView dequeueReusableCellWithIdentifier:CellIdentifierWaiting];
        
        if (cell == nil) {
            cell = [[[TableViewActivityCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierWaiting] autorelease];
        }
        
        [((TableViewActivityCell *) cell).spinner startAnimating];
        imageData = [FlickrPhotos squareThumbnailForPhoto: photo usingBlock: ^(NSData *imageData) {
            if (imageData && self.view.window) {
                [self.tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation:  UITableViewRowAnimationFade];
            }
            [((TableViewActivityCell *) cell).spinner stopAnimating];
        }];
    }

    
    NSString *title = [FlickrPhotos titleForPhoto:photo];
    NSString *description = [FlickrPhotos descriptionForPhoto:photo];
    
    if ((title) && ([title length] > 0)) {
        cell.textLabel.text = title;
        if ((description) && ([description length] > 0)) {
            cell.detailTextLabel.text = description;
        } else {
            cell.detailTextLabel.text = nil;
        }
    } else if ((description) && ([description length] > 0)) {
        cell.textLabel.text = description;
        cell.detailTextLabel.text = nil;
    } else {
        cell.textLabel.text = @"Unknown";
        cell.detailTextLabel.text = nil;
    }

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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    id flickrPhoto = [photos photoAtIndex:indexPath.row];
    
    Photo *photo = [FlickrPhotos photoForFlickrPhoto:flickrPhoto
                                             takenAt:photos.place
                              inManagedObjectContext:self.managedObjectContext];
    photo.lastViewed = [NSDate date];
    
    NSError *error = nil;
    [self.managedObjectContext save: &error];
    
    if (error) {
        NSLog(@"%@", error.localizedFailureReason);
    }
    
    // Next create the photo view controller, give it the photo, and push 
    // it on to the navigation controller
    //PhotoViewController *pvc = [[PhotoViewController alloc] initWithPhoto: photo];
    PhotoViewController *pvc = [[PhotoViewController alloc] init];
    pvc.photo = photo;
    
    [self.navigationController pushViewController: pvc animated: YES];
    [pvc release];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) dealloc 
{
    [photos release];
    [__managedObjectContext release];
    [super dealloc];
}
@end
