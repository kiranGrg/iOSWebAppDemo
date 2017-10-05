//
//  UIView+ViewSnapShot.m
//  HottieHunterDemo
//
//  Created by Kiran's Mac Mini on 2/27/15.
//  Copyright (c) 2015 Design Offshore Nepal. All rights reserved.
//

#import "UIView+ViewSnapShot.h"

@implementation UIView (ViewSnapShot)

- (UIImage *) getSnapshot
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, self.window.screen.scale);
//    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
//    [self drawViewHierarchyInRect:self.frame afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

@end
