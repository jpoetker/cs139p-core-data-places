//
//  Place.h
//  CoreDataPlaces
//
//  Created by Jeff Poetker on 8/12/11.
//  Copyright (c) 2011 Medplus, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * cityLocation;
@property (nonatomic, retain) NSString * placeId;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
