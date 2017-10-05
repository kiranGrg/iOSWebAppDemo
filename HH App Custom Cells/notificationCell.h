//
//  notificationCell.h
//  HottieHunterDemo
//
//  Created by Padam Krishna Prajapati on 12/03/14.
//  Copyright (c) 2014 Ujjwal Shrestha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customTextView.h"

@interface notificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *senderImgView;
@property (weak, nonatomic) IBOutlet UIImageView *receiverIMgView;

@property (weak, nonatomic) IBOutlet customTextView *notificationTxtView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;




@end
