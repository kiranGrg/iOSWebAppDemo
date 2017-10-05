//
//  DataManager.h
//  HottieHunterDemo
//
//  Created by Kiran's Mac Mini on 7/22/14.
//  Copyright (c) 2014 Design Offshore Nepal. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HHUserDetails,HHhunterKind;

@interface DataManager : NSObject

+ (DataManager * ) sharedDataManger;

- (HHUserDetails *) getUserDetails:(NSDictionary *) resultDict;

- (HHhunterKind *) getHunterKindDetails:(NSDictionary *) resultDict;

- (NSMutableArray *) getFeedData:(NSArray *) resultArray;

- (NSMutableArray *) getNotificationData:(NSArray *) resultArray;

-(NSMutableArray *) getTopHunterData:(NSArray *) resultArray withFlag:(BOOL) search withTag:(int) tag;

-(NSMutableArray *) getCommentListData:(NSArray *) resultArray;

-(NSMutableArray *) getLikeData:(NSArray *) resultArray;

-(NSMutableArray *) getFollowingListData:(NSArray *) resultArray;

-(NSMutableArray *) getFollowingListdataPopUp:(NSArray *) resultArray withAdvancedSearch:(BOOL) flag;

-(NSMutableArray *) getHottieImages:(NSArray *) resultArray;

-(NSMutableArray *) getHashTagList:(NSArray *) resultArray;

-(NSMutableArray *) getHunterList:(NSArray *) resultArray;

@end
