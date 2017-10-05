//
//  IssueCollectionCell_iPhone.m
//  M&S
//
//  Created by Sajjan's MackBook Pro on 11/17/13.
//  Copyright (c) 2013 Kantipur. All rights reserved.
//

#import "GalleryCollectionCell.h"

@implementation GalleryCollectionCell

@synthesize imgThumb;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imgThumb = nil;
    }
    return self;
}

+ (id)newCollectionViewWithImage:(UIImage *)image {
    UINib *nib = [UINib nibWithNibName:@"GalleryCollectionCell" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    GalleryCollectionCell *view = [nibArray objectAtIndex:0];
    view.imgThumb.image = image;
    return view;
}

@end
