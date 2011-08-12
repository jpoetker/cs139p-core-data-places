//
//  Photo.h
//  CoreDataPlaces
//
//  Created by Jeff Poetker on 8/12/11.
//  Copyright (c) 2011 Medplus, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * descriptionOf;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSString * largeImageURL;
@property (nonatomic, retain) NSDate * lastViewed;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Place *place;

@end
