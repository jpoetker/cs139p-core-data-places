//
//  PhotoViewController.m
//  Places
//
//  Created by Jeff Poetker on 7/29/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import "PhotoViewController.h"
#import "Photo.h"
#import "Photo+FlickrFetcher.h"
#import "Photo+Cache.h"
#import "FlickrFetcher.h"

@implementation PhotoViewController

@synthesize scrollView, imageView, activitySpinner;
@synthesize photo;

- (id) init
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.photo = nil;
        
        UIBarButtonItem *favoriteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                                                        target: self
                                                                                        action: @selector(toggleFavoriteStatus)];
        self.navigationItem.rightBarButtonItem = favoriteButton;
        [favoriteButton release];
    }
    return self;
}

- (void) toggleFavoriteStatus
{
    [self.photo toggleFavoriteStatus];
    if (self.photo.favorite) {
        [self.photo saveDataToCache: UIImagePNGRepresentation(self.imageView.image) forKind: FlickrFetcherPhotoFormatLarge];
    } else {
        [self.photo removeFromCache: FlickrFetcherPhotoFormatLarge];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)setPhoto:(Photo *)aPhoto
{
    [photo release];
    photo = [aPhoto retain];
    self.title = photo.title;
    
    [self.view setNeedsDisplay];
}

- (CGRect) calculateZoomRectForImageWithBounds: (CGRect) imageBounds forViewBounds: (CGRect) viewBounds
{
    CGRect zoomRect;
    
    CGFloat viewAspect = viewBounds.size.width / viewBounds.size.height;
    CGFloat imageAspect = imageBounds.size.width / imageBounds.size.height;
    
    if (viewAspect > imageAspect) {
        // adjust according to the image width
        CGFloat height = imageBounds.size.width / viewAspect;
        CGFloat y = imageBounds.size.height / 2 - height / 2;
        zoomRect = CGRectMake(0, y, imageBounds.size.width, height);
        [self.scrollView flashScrollIndicators];
    } else if (viewAspect < imageAspect) {
        // adjust according to image height
        CGFloat width = imageBounds.size.height * viewAspect;
        CGFloat x = imageBounds.size.width / 2 - width / 2;
        zoomRect = CGRectMake(x, 0, width, imageBounds.size.height);
        [self.scrollView flashScrollIndicators];
    } else {
        // how lucky.
        zoomRect = imageBounds;
    }
    return zoomRect;
}

- (float)calculateMinimumScaleForImageWithBounds: (CGRect) imageBounds forViewBounds: (CGRect) viewBounds
{
    float scaleWide = viewBounds.size.width / imageBounds.size.width;
    float scaleHeight = viewBounds.size.height / imageBounds.size.height;
    
    return (scaleWide <= scaleHeight) ? scaleWide : scaleHeight;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.activitySpinner startAnimating];
    [self.photo processImageDataWithBlock:^(NSData *imageData) {
		if (self.view.window) {
            UIImage *image = [UIImage imageWithData: imageData];
            UIImageView *uiiv = [[UIImageView alloc] initWithImage: image];
            self.imageView = uiiv;
            [uiiv release];
            
            [self.scrollView addSubview: self.imageView];
            
            self.scrollView.contentSize = imageView.bounds.size;
            
            CGRect zoomRect = [self calculateZoomRectForImageWithBounds: self.imageView.bounds forViewBounds: self.scrollView.bounds];
            
            [self.scrollView zoomToRect:zoomRect animated:NO];    
            
            self.scrollView.minimumZoomScale = [self calculateMinimumScaleForImageWithBounds: self.imageView.bounds forViewBounds: self.scrollView.bounds];
            [self.activitySpinner stopAnimating];
        }
    }];
}


#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    self.view = contentView;
    [contentView release];

    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.hidesWhenStopped = YES;
    //spinner.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	spinner.center = self.view.center;
    
    self.activitySpinner = spinner;
    [self.view addSubview: spinner];
    [spinner release];
    
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame: self.view.frame];
    sv.minimumZoomScale = 0.3;
    sv.maximumZoomScale = 3.0;
    sv.delegate = self;
    
    self.scrollView = sv;
    [self.view addSubview: sv];
    [sv release];
    

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)sender
{
    return self.imageView;
}

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

- (void)dealloc
{
    [scrollView release];
    [photo release];
    [imageView release];
    [managedObjectContext release];
    [activitySpinner release];
    [super dealloc];
}
@end
