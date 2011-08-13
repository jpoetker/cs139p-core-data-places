//
//  PhotoViewController.h
//  Places
//
//  Created by Jeff Poetker on 7/29/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface PhotoViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    UIImageView *imageView;
    Photo *photo;
}

@property (retain) UIScrollView *scrollView;
@property (retain) UIImageView *imageView;
@property (retain, nonatomic) Photo *photo;



@end