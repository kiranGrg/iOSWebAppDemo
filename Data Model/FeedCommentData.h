//
//  FeedCommentData.h
//  HottieHunterDemo
//
//  Created by Samir Jwarchan on 23/6/13.
//  Copyright (c) 2013 Ujjwal Shrestha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedCommentData : NSObject
@property(nonatomic,strong) NSString *feedCommentId,*feedCommentText,*feedCommentSenderName,*feedCommentSenderId,*feedCommentSenderImgPath,*feedCommentDateTime,*feedCommentAddress,*feedCommentLikeCount,*feedCommentPostID;
@property(nonatomic,strong) NSString *isMYLike;
@end
