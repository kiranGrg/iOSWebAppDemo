//
//  NotificationModel.h
//  HottieHunterDemo
//
//  Created by Padam Krishna Prajapati on 12/03/14.
//  Copyright (c) 2014 Ujjwal Shrestha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationModel : NSObject
@property(nonatomic,strong) NSString *notificationSenderID;
@property(nonatomic,strong) NSString *notificationSenderImg;
@property(nonatomic,strong) NSString *notificationfeedImg;
@property(nonatomic,strong) NSString *notificationSenderName;
@property(nonatomic,strong) NSString *notificationReceiverID;
@property(nonatomic,strong) NSString *notificationReceiverName;
@property(nonatomic,strong) NSString *notificationReceiverImage;
@property(nonatomic,strong) NSString *notificationTitle;
@property(nonatomic,strong) NSString *notificationID;
@property(nonatomic,strong) NSString *notificationValue;
@property(nonatomic,strong) NSString *notificationTime;
@property(nonatomic,strong) NSString *notificationToImg;
@property(nonatomic,strong) NSString *notificationToName;


@end
