//
//  Photo+FlickrFetcher.h
//  CoreDataPlaces
//
//  Created by Jeff Poetker on 8/13/11.
//  Copyright (c) 2011 Medplus, Inc. All rights reserved.
//

#import "Photo.h"

@interface Photo (FlickrFetcher)

- (UIImage *) largeImage;
- (UIImage *) thumbnailImage;
- (void)processImageDataWithBlock:(void (^)(NSData *imageData))processImage;

@end
