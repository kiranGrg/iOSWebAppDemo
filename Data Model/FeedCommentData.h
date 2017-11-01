//
//  FeedCommentData.h
//  HottieHunterDemo

//  Copyright (c) 2013 DesignOffshore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedCommentData : NSObject
@property(nonatomic,strong) NSString *feedCommentId,*feedCommentText,*feedCommentSenderName,*feedCommentSenderId,*feedCommentSenderImgPath,*feedCommentDateTime,*feedCommentAddress,*feedCommentLikeCount,*feedCommentPostID;
@property(nonatomic,strong) NSString *isMYLike;
@end
