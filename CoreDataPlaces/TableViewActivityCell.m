//
//  UITableViewAcitivityCell.m
//  CoreDataPlaces
//
//  Created by Jeff Poetker on 8/21/11.
//  Copyright (c) 2011 Medplus, Inc. All rights reserved.
//

#import "TableViewActivityCell.h"

@implementation TableViewActivityCell

@synthesize spinner = __spinner;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                        UIActivityIndicatorViewStyleGray] autorelease];
        self.spinner.hidesWhenStopped = YES;
        
        UIImage *tempSpacer = [UIImage imageNamed:@"spacer"];
        
        UIGraphicsBeginImageContext(self.spinner.frame.size);
        
        [tempSpacer drawInRect:CGRectMake(0,0,self.spinner.frame.size.width, self.spinner.frame.size.height)];
        UIImage *spacer = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        self.imageView.image = spacer;
        [self.imageView addSubview: self.spinner];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) dealloc {
    [__spinner release];
    [super dealloc];
}

@end

