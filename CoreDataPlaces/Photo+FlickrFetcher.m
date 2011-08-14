//
//  Photo+FlickrFetcher.m
//  CoreDataPlaces
//
//  Created by Jeff Poetker on 8/13/11.
//  Copyright (c) 2011 Medplus, Inc. All rights reserved.
//

#import "Photo+FlickrFetcher.h"
#import "FlickrFetcher.h"
#import "Photo+Cache.h"

@implementation Photo (FlickrFetcher)

- (UIImage *) largeImage
{
//    NSLog(@"%@", self);
    NSData *imageData = nil;
    
    imageData = [self cachedImageData: FlickrFetcherPhotoFormatLarge];
    if (!imageData) {
        NSLog(@"Cache miss for %@", self.title);
        imageData = [FlickrFetcher imageDataForPhotoWithURLString: self.largeImageURL];
    }
    return [UIImage imageWithData:imageData];
}

- (UIImage *) thumbnailImage
{
    //    NSLog(@"%@", self);
    NSData *imageData = nil;
    
    imageData = [self cachedImageData: FlickrFetcherPhotoFormatSquare];
    if (!imageData) {
        imageData = [FlickrFetcher imageDataForPhotoWithURLString: self.thumbnailURL];
    }
    
    return [UIImage imageWithData:imageData];
}

@end
