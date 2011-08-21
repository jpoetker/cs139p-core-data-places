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
    if (self.thumbnailData) {
        return [UIImage imageWithData: self.thumbnailData];
    } else {
        NSString *thumbnailUrl = self.thumbnailURL;
        dispatch_queue_t downloadQueue = dispatch_queue_create("Flickr Thumbnail Download Queue", NULL);
        dispatch_async(downloadQueue, ^{
            NSData *imageData = [FlickrFetcher imageDataForPhotoWithURLString: thumbnailUrl];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.thumbnailData = imageData;
            });
            
        });
    }
    return nil;
}

@end
