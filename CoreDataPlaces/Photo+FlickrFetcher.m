//
//  Photo+FlickrFetcher.m
//  CoreDataPlaces
//
//  Created by Jeff Poetker on 8/13/11.
//  Copyright (c) 2011 Medplus, Inc. All rights reserved.
//

#import "Photo+FlickrFetcher.h"
#import "FlickrFetcher.h"

@implementation Photo (FlickrFetcher)

- (UIImage *) largeImage
{
//    NSLog(@"%@", self);
    NSData *imageData = [FlickrFetcher imageDataForPhotoWithURLString: self.largeImageURL];
    return [UIImage imageWithData:imageData];
}

@end
