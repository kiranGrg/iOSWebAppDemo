//
//  notificationCell.m
//  HottieHunterDemo
//
//  Created by Padam Krishna Prajapati on 12/03/14.
//  Copyright (c) 2014 Ujjwal Shrestha. All rights reserved.
//

#import "notificationCell.h"

@implementation notificationCell
@synthesize senderImgView;
@synthesize timeLabel;
@synthesize receiverIMgView;
@synthesize notificationTxtView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
