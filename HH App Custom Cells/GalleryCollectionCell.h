//
//  IssueCollectionCell_iPhone.h
//  M&S
//
//  Created by Sajjan's MackBook Pro on 11/17/13.
//  Copyright (c) 2013 Kantipur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgThumb;

+ (id)newCollectionViewWithImage:(UIImage *)image;

@end
