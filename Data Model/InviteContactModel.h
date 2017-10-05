//
//  InviteContactModel.h
//  HottieHunterDemo
//
//  Created by Kiran's Mac Mini on 1/26/15.
//  Copyright (c) 2015 Design Offshore Nepal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InviteContactModel : NSObject

@property   (nonatomic, assign)     BOOL    isPhoneContact;
@property   (nonatomic, assign)     BOOL    isTwitterContact;
@property   (nonatomic, assign)     BOOL    isGmailContact;

    //common for all
@property   (nonatomic, strong)     NSString    *fullName;
@property   (nonatomic, assign)     BOOL        isChecked;

    //for phonecontact
@property   (nonatomic, strong)     NSString    *phoneNo;
@property   (nonatomic, strong)      UIImage    *contactImage;
@property   (nonatomic, strong)     NSString    *email;

    //for twittercontact
@property   (nonatomic, strong)     NSString    *userID;
@property   (nonatomic, strong)     NSString    *screenName;
@property   (nonatomic, strong)     NSString    *profileImageURL;

    //for gmailcontact
@property   (nonatomic, strong)     NSString    *userEmail;

@end
