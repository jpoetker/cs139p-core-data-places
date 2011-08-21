//
//  Photos.m
//  Places
//
//  Created by Jeff Poetker on 7/29/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import "FlickrPhotos.h"
#import "FlickrTopPlaces.h"
#import "FlickrFetcher.h"

@interface FlickrPhotos() 
+ (NSDictionary *) castToDictionaryOrNil: (id) photo;
+ (NSString *) property: (NSString *) photoProperty of: (id) photo;
+ (void) setThumbnailData: (NSData *) imageData for: (id) photo;

//+ (NSMutableArray *) loadRecentlyViewedPhotos;
@end

@implementation FlickrPhotos

@synthesize photos;

- (id)init
{
    self = [super init];
    if (self) {
        self.photos = nil;
    }
    
    return self;
}

- (id)initWithPhotos: (NSArray *)somePhotos
{
    self = [self init];
    if (self) {
        self.photos = somePhotos;
    }
    return self;
}

- (NSUInteger) count
{
    return [photos count];
}

- (id) photoAtIndex:(NSUInteger)index
{
    return [photos objectAtIndex:index];
}

- (void) dealloc
{
    [photos release];
    [super dealloc];
}

//+ (NSArray *) loadRecentlyViewedPhotos
//{
//    NSArray *loaded = [[NSUserDefaults standardUserDefaults] valueForKey: @"recentlyViewedPhotos"];
//    return loaded;
//}
//
//+ (void) savePhotoAsViewed: (id) photo
//{
//    NSDictionary *dict = [Photos castToDictionaryOrNil: photo];
//    
//    if (dict) {
//        NSMutableArray *viewed = [[Photos loadRecentlyViewedPhotos] mutableCopy];
//        if (!viewed) {
//            viewed = [[NSMutableArray alloc] initWithCapacity:1];
//        }
//        // if the photo is alread in the set, remove it to move it the top
//        [viewed removeObject: dict];
//        [viewed insertObject:dict atIndex:0];
//        
//        for (NSUInteger i = [viewed count] - 1; i > 50; i--) {
//            [viewed removeObjectAtIndex: i];
//        }
//        
//        [[NSUserDefaults standardUserDefaults] setValue: viewed forKey:@"recentlyViewedPhotos"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        [viewed release];
//    }
//}
//
//+ (Photos *) photosRecentlyViewed
//{
//    Photos *photos = [[Photos alloc] initWithPhotos: [Photos loadRecentlyViewedPhotos]];
//    return [photos autorelease];
//}

+ (NSDictionary *) castToDictionaryOrNil: (id) photo
{
    if ([photo isKindOfClass:[NSDictionary class]]) {
        return photo;
    }
    return nil;
}
+ (NSString *) property:(NSString *)photoProperty of:(id)photo
{
    return [[FlickrPhotos castToDictionaryOrNil:photo] valueForKey:photoProperty];
}

+ (NSString *) uniqueIdForPhoto:(id)photo
{
    return [FlickrPhotos property: @"id" of: photo];
}

+ (NSString *) titleForPhoto:(id)photo
{
    return [FlickrPhotos property: @"title" of: photo];
}

+ (NSString *)descriptionForPhoto:(id)photo
{
    return [[[FlickrPhotos castToDictionaryOrNil: photo] valueForKey: @"description"] valueForKey: @"_content"];
}

+ (NSData *)squareThumbnailForPhoto:(id)photo usingBlock: (void (^)(NSData *imageData))procesImage
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; 
    NSData *imageData = [FlickrPhotos thumbnailDataOf: photo];
    if (!imageData) {
        dispatch_queue_t callerQueue = dispatch_get_current_queue();
        dispatch_queue_t downloadQueue = dispatch_queue_create("Thumbnail Download Queue", NULL);
        dispatch_async(downloadQueue, ^{
            [FlickrPhotos setThumbnailData:
             [FlickrFetcher imageDataForPhotoWithFlickrInfo:[FlickrPhotos castToDictionaryOrNil: photo] format:
              FlickrFetcherPhotoFormatSquare]
                                       for: photo ];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            dispatch_async(callerQueue, ^{
                procesImage([FlickrPhotos thumbnailDataOf:photo]);
            });
        });
        dispatch_release(downloadQueue);
    }
//    UIImage *image = [[[UIImage alloc] initWithData:[FlickrFetcher imageDataForPhotoWithFlickrInfo:[FlickrPhotos castToDictionaryOrNil: photo] format:FlickrFetcherPhotoFormatSquare]] autorelease];
//    
    
    return imageData;
}

+ (NSString *) squareThumbnailURLForPhoto: (id) photo
{
    return [FlickrFetcher urlStringForPhotoWithFlickrInfo: [FlickrPhotos castToDictionaryOrNil: photo]
                                                   format: FlickrFetcherPhotoFormatSquare];
}
+ (UIImage *)largeImageForPhoto: (id)photo
{
    return [[[UIImage alloc] initWithData: [FlickrFetcher imageDataForPhotoWithFlickrInfo:[FlickrPhotos castToDictionaryOrNil: photo] format:FlickrFetcherPhotoFormatLarge]] autorelease];
}
+ (NSString *) largeImageURLForPhoto: (id) photo
{
    return [FlickrFetcher urlStringForPhotoWithFlickrInfo: [FlickrPhotos castToDictionaryOrNil: photo]
                                                   format: FlickrFetcherPhotoFormatLarge];
}


+ (NSData *) thumbnailDataOf: (id) photo {
    return [[FlickrPhotos castToDictionaryOrNil: photo] objectForKey: @"thumbnailImageData"];
}

+ (void) setThumbnailData: (NSData *) imageData for: (id) photo {
    [[FlickrPhotos castToDictionaryOrNil: photo] setValue: imageData forKey: @"thumbnailImageData"];
}

@end


@implementation FlickrPlacePhotos

@synthesize place;


- (id)init
{
    self = [super init];
    if (self) {
        self.place = nil;
    }
    
    return self;
}

- (id)initWithPlace: (id) aPlace
{
    self = [self init];
    if (self) {
        self.place = aPlace;
    }
    
    return self;
}

- (void)setPlace:(id) aPlace
{
    if (![[FlickrTopPlaces placeIdFromPlace:aPlace] isEqualToString:[FlickrTopPlaces placeIdFromPlace: place]]) {
        [place release];
        place = [aPlace retain];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        self.photos = [FlickrFetcher photosAtPlace: [FlickrTopPlaces placeIdFromPlace: aPlace]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;        
    }
}


@end
