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


@implementation PhotoViewController

@synthesize scrollView, imageView;
@synthesize photo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.photo = nil;
    }
    return self;
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
    
    UIImage *image = [aPhoto largeImage];
    
    UIImageView *uiiv = [[UIImageView alloc] initWithImage: image];
    self.imageView = uiiv;
    [uiiv release];
    
    [self.scrollView addSubview: self.imageView];
    
    self.scrollView.contentSize = imageView.bounds.size;
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
    CGRect zoomRect = [self calculateZoomRectForImageWithBounds: self.imageView.bounds forViewBounds: self.scrollView.bounds];
    
    [self.scrollView zoomToRect:zoomRect animated:NO];    
   
    self.scrollView.minimumZoomScale = [self calculateMinimumScaleForImageWithBounds: self.imageView.bounds forViewBounds: self.scrollView.bounds];
}


#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
    sv.minimumZoomScale = 0.3;
    sv.maximumZoomScale = 3.0;
    sv.delegate = self;
    
    self.scrollView = sv;
    self.view = sv;
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
    [super dealloc];
}
@end
