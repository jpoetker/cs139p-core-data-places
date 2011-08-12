//
//  Photos.h
//  Places
//
//  Created by Jeff Poetker on 7/29/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPhotos : NSObject
{
    NSArray *photos;
}

@property (nonatomic, retain) NSArray *photos;

- (NSUInteger) count;
- (id) photoAtIndex: (NSUInteger) index;


+ (NSString *) titleForPhoto: (id) photo;
+ (NSString *) descriptionForPhoto: (id) photo;
+ (UIImage *) squareThumbnailForPhoto: (id) photo;
+ (UIImage *) largeImageForPhoto: (id)photo;
//+ (void) savePhotoAsViewed: (id) photo;
//+ (FlickrPhotos *) photosRecentlyViewed;
@end


@interface FlickrPlacePhotos : FlickrPhotos
{
    id place;
}

- (id) initWithPlace: (id) aPlace;

@property (nonatomic, retain) id place;

@end
