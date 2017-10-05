//
//  DataManager.m
//  HottieHunterDemo
//
//  Created by Kiran's Mac Mini on 7/22/14.
//  Copyright (c) 2014 Design Offshore Nepal. All rights reserved.
//

#import "DataManager.h"

#import "FeedDataModel.h"
#import "HHUserDetails.h"
#import "HHhunterKind.h"
#import "TopHunter.h"
#import "FeedCommentData.h"
#import "FeedLikeData.h"
#import "FollowingDataModel.h"
#import "HottiesDaily.h"
#import "HashListModel.h"
#import "Hunter.h"

#import "Helper.h"

#import "N_NotificationModel.h"

static DataManager * _sharedDataManager = nil;

@interface DataManager()

@end

@implementation DataManager

+ (DataManager *) sharedDataManger{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataManager = [[DataManager alloc] init];
    });
    return _sharedDataManager;
}

- (HHUserDetails *) getUserDetails:(NSDictionary *) resultDict{
    
    HHUserDetails *user     = [[HHUserDetails alloc]init];
    user.userid             = [resultDict objectForKey:@"provider_id"];
    user.username           = [resultDict objectForKey:@"name"];
    user.gender             = [resultDict objectForKey:@"gender"];
    user.email              = [resultDict objectForKey:@"email"];
    user.location           = [resultDict objectForKey:@"location"];
    user.bio                = [resultDict objectForKey:@"bio"];
    user.uservote           = [resultDict objectForKey:@"user_vote"];
    user.userrank           = [resultDict objectForKey:@"User rank"];
    user.followers          = [resultDict objectForKey:@"followers"];
    user.followings         = [resultDict objectForKey:@"followings"];
    user.pickuplines        = [resultDict objectForKey:@"Pick up line"];
    user.favouriteplace     = [resultDict objectForKey:@"Favourite place"];
    user.unusualplace       = [resultDict objectForKey:@"Unusual place"];
    user.teachename         = [resultDict objectForKey:@"Teacher name"];
    user.celebrityname      = [resultDict objectForKey:@"Celebrity name"];
    user.athletename        = [resultDict objectForKey:@"Athlete name"];
    user.teacheimage        = [resultDict objectForKey:@"Teacher image"];
    user.athleteimage       = [resultDict objectForKey:@"Athlete Image"];
    user.celebrityimage     = [resultDict objectForKey:@"Celebrity Image"];
    user.profileimage       = [resultDict objectForKey:@"Profile Image"];
    user.backgroundimage    = [resultDict objectForKey:@"Background Image"];
    user.dob                = [resultDict objectForKey:@"dob"];
    user.totalPost          = [resultDict objectForKey:@"win_count"];
    user.dob_date           = [resultDict objectForKey:@"dob_date"];
    user.ismyFollowing      = [resultDict objectForKey:@"ismyfollowing"];
    user.inviteBoxStatus    = [resultDict objectForKey:@"invite_box_status"];
    user.inviteBoxStatus    = [resultDict objectForKey:@"invite_box_status"];
    user.timeZoneValue      = [resultDict objectForKey:@"timezone"];
    return user;
}

- (HHhunterKind *) getHunterKindDetails:(NSDictionary *) resultDict{
    HHhunterKind *hunterkind=[[HHhunterKind alloc]init];
    
    hunterkind.pickuplinetext1      =   [[[resultDict objectForKey:@"pickup_line"]objectAtIndex:0]objectForKey:@"name"];
    hunterkind.pickuplinetext2      =   [[[resultDict objectForKey:@"pickup_line"]objectAtIndex:1]objectForKey:@"name"];
    hunterkind.pickuplinetext3      =   [[[resultDict objectForKey:@"pickup_line"]objectAtIndex:2]objectForKey:@"name"];
    hunterkind.pickuplineImg1       =   [[[resultDict objectForKey:@"pickup_line"]objectAtIndex:0]objectForKey:@"image"];
    hunterkind.pickuplineImg2       =   [[[resultDict objectForKey:@"pickup_line"]objectAtIndex:1]objectForKey:@"image"];
    hunterkind.pickuplineImg3       =   [[[resultDict objectForKey:@"pickup_line"]objectAtIndex:2]objectForKey:@"image"];
    
    hunterkind.favPlacetext1        =   [[[resultDict objectForKey:@"favourite_place"]objectAtIndex:0]objectForKey:@"name"];
    hunterkind.favPlacetext2        =   [[[resultDict objectForKey:@"favourite_place"]objectAtIndex:1]objectForKey:@"name"];
    hunterkind.favPlacetext3        =   [[[resultDict objectForKey:@"favourite_place"]objectAtIndex:2]objectForKey:@"name"];
    hunterkind.favPlaceImg1         =   [[[resultDict objectForKey:@"favourite_place"]objectAtIndex:0]objectForKey:@"image"];
    hunterkind.favPlaceImg2         =   [[[resultDict objectForKey:@"favourite_place"]objectAtIndex:1]objectForKey:@"image"];
    hunterkind.favPlaceImg3         =   [[[resultDict objectForKey:@"favourite_place"]objectAtIndex:2]objectForKey:@"image"];
    
    hunterkind.unusualPlacetext1    =   [[[resultDict objectForKey:@"hunter_type"]objectAtIndex:0]objectForKey:@"name"];
    hunterkind.unusualPlacetext2    =   [[[resultDict objectForKey:@"hunter_type"]objectAtIndex:1]objectForKey:@"name"];
    hunterkind.unusualPlacetext3    =   [[[resultDict objectForKey:@"hunter_type"]objectAtIndex:2]objectForKey:@"name"];
    hunterkind.unusualPlaceImg1     =   [[[resultDict objectForKey:@"hunter_type"]objectAtIndex:0]objectForKey:@"image"];
    hunterkind.unusualPlaceImg2     =   [[[resultDict objectForKey:@"hunter_type"]objectAtIndex:1]objectForKey:@"image"];
    hunterkind.unusualPlaceImg3     =   [[[resultDict objectForKey:@"hunter_type"]objectAtIndex:2]objectForKey:@"image"];
    
    hunterkind.lineSelectedId       =   [resultDict objectForKey:@"line_selected_id"];
    hunterkind.placeSelectedId      =   [resultDict objectForKey:@"place_selected_id"];
    hunterkind.typeSelectedId       =   [resultDict objectForKey:@"type_selected_id"];
    
    return hunterkind;
}

- (NSMutableArray *) getFeedData:(NSArray *) resultArray{
    
    __block NSDictionary * feedVCDictionary = [[NSDictionary alloc] init];
    NSMutableArray * feedDataArray = [[NSMutableArray alloc] init];
    
    [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            // Parsing Feeds
        FeedDataModel *feedDataModel = [[FeedDataModel alloc] init];
        feedVCDictionary = (NSDictionary *) obj;
        
        feedDataModel.feedId                = [feedVCDictionary valueForKey:@"id"];
        feedDataModel.userProviderID        = [feedVCDictionary valueForKey:@"user_provider_id"];
        feedDataModel.feedUserImgPath       = [feedVCDictionary valueForKey:@"user_photo"];
        feedDataModel.feedUserName          = [feedVCDictionary valueForKey:@"username"];
        feedDataModel.feedDateTime          = [feedVCDictionary valueForKey:@"time"];;
        feedDataModel.feedAddress           = [feedVCDictionary valueForKey:@"user_address"];
        feedDataModel.fullfeedAddress       = [feedVCDictionary valueForKey:@"user_full_address"];
        feedDataModel.isMyFollowing         = [feedVCDictionary valueForKey:@"ismyfollowing"];
        feedDataModel.feedName              = [feedVCDictionary valueForKey:@"user_feed"];
        feedDataModel.feedImgPath           = [feedVCDictionary valueForKey:@"file_uploads"];
        feedDataModel.ismyLike              = [feedVCDictionary valueForKey:@"is_my_like"];
        feedDataModel.noOfLikesForFeed      = [feedVCDictionary valueForKey:@"feed_like_count"];
        feedDataModel.noOfFeedComments      = [feedVCDictionary valueForKey:@"comment_count"];
        feedDataModel.isFeedCommentPresent  = [feedVCDictionary valueForKey:@"comments"];
        feedDataModel.feedVoteData          = [feedVCDictionary valueForKey:@"post_vote"];
        feedDataModel.uservoteData          = [feedVCDictionary valueForKey:@"user_post_vote"];
        feedDataModel.gender                = [feedVCDictionary valueForKey:@"user_gender"];
        feedDataModel.isUserLocation        = [feedVCDictionary valueForKey:@"user_location"];
        feedDataModel.isUserPost            = [feedVCDictionary valueForKey:@"user_post"];
        feedDataModel.longitute             = [feedVCDictionary valueForKey:@"longitude"];
        feedDataModel.latitude              = [feedVCDictionary valueForKey:@"latitude"];
        
        [feedDataArray addObject:feedDataModel];
    }];
    
    return feedDataArray;
}

- (NSMutableArray *) getNotificationData:(NSArray *) resultArray{
    
    __block NSDictionary * notifDictionary = [[NSDictionary alloc] init];
    NSMutableArray * notifDataArray = [[NSMutableArray alloc] init];
    
    [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        N_NotificationModel * notificationmodel = [[N_NotificationModel alloc] init];
        notifDictionary = (NSDictionary *) obj;
        
        notificationmodel.notif_id                      = [notifDictionary objectForKey:@"id"];
        notificationmodel.notif_dateTime                = [notifDictionary objectForKey:@"datetime"];
        notificationmodel.notif_msg_type                = [notifDictionary objectForKey:@"message_name"];
        notificationmodel.notif_msg                     = [notifDictionary objectForKey:@"message_str"];
        
        notificationmodel.notif_user_id                 = [notifDictionary objectForKey:@"x_user_provider_id"];
        notificationmodel.notif_user_name               = [notifDictionary objectForKey:@"x_user_name"];
        notificationmodel.notif_user_image              = [notifDictionary objectForKey:@"x_user_image"];
        
        notificationmodel.notif_liked_type              = [notifDictionary objectForKey:@"liked_type"];
        notificationmodel.notif_comment_like_id         = [notifDictionary objectForKey:@"x_comment_id"];
        notificationmodel.notif_comment_like_feed_id    = [notifDictionary objectForKey:@"x_comment_feed_id"];
        notificationmodel.notif_comment_like_feed_image = [notifDictionary objectForKey:@"x_comment_feed_image"];
        
        notificationmodel.notif_hottie_image            = [notifDictionary objectForKey:@"x_hottie_image"];
        notificationmodel.notif_hottie_image_id         = [notifDictionary objectForKey:@"x_hottie_image_id"];
        notificationmodel.notif_hottie_post_id          = [notifDictionary objectForKey:@"x_hottie_id"];
        
        notificationmodel.notif_vote_id                 = [notifDictionary objectForKey:@"x_vote_id"];
        notificationmodel.notif_vote_text               = [notifDictionary objectForKey:@"x_vote_text"];
        
        notificationmodel.notif_user_visible            = [notifDictionary objectForKey:@"x_hottie_is_user_visible"];
        
            //for followiing actitivites only or else empty
        notificationmodel.notif_user2_id                = [notifDictionary objectForKey:@"x_user2_provider_id"];
        notificationmodel.notif_user2_name              = [notifDictionary objectForKey:@"x_user2_name"];
        notificationmodel.notif_user2_image             = [notifDictionary objectForKey:@"x_user2_image"];
        notificationmodel.notif_user2_pro               = [notifDictionary objectForKey:@"x_user2_pronoun"];
        
        BOOL flagInput = NO;
        if (![[Helper getUserProfileDetail].userid isEqualToString:notificationmodel.notif_user2_id]){
            flagInput = YES;
            if (([notificationmodel.notif_msg_type isEqualToString:@"F_TRENDING_GIRLS"]
                 ||
                 [notificationmodel.notif_msg_type isEqualToString:@"F_TRENDING_GUYS"]
                 )
                &&
                ([notificationmodel.notif_user_visible isEqualToString:@"no"]
                 ||
                 [notificationmodel.notif_user_visible isEqualToString:@"No"]))
            {
                
                flagInput = NO;
                
            }
            if (flagInput) {
                [notifDataArray addObject:notificationmodel];
            }
        }
    }];
    
    return notifDataArray;
}

    //rankview and tophunter search as well as showing normal

-(NSMutableArray *) getTopHunterData:(NSArray *) resultArray withFlag:(BOOL)search withTag:(int)tag{
    __block NSDictionary * topHunterDictionary = [[NSDictionary alloc] init];
    NSMutableArray * topHunterDataArray = [[NSMutableArray alloc] init];
    
    [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            // Parsing top Hunter list
        TopHunter *topHunter=[[TopHunter alloc]init];
        topHunterDictionary = (NSDictionary *) obj;
        
        topHunter.rank          = [topHunterDictionary valueForKey:@"rank"];
        topHunter.name          = [topHunterDictionary valueForKey:@"name"];
        topHunter.user_name     = [topHunterDictionary valueForKey:@"user_name"];
        topHunter.bio           = [topHunterDictionary valueForKey:@"bio"];
        topHunter.provider_id   = [topHunterDictionary valueForKey:@"provider_id"];
        topHunter.image         = [topHunterDictionary valueForKey:@"image"];
        
        topHunter.myfollowing   = [topHunterDictionary valueForKey:@"myfollowing"];
        topHunter.myfollower    = [topHunterDictionary valueForKey:@"myfollower"];
        topHunter.gender        = [topHunterDictionary valueForKey:@"gender"];
        
        if (search) {
            if (tag == 1) {
                topHunter.follow_status = [topHunterDictionary valueForKey:@"status"];
            }
            else if (tag == 2){
                topHunter.follow_status = [topHunterDictionary valueForKey:@"follow_status"];
            }
        }
        else{
            topHunter.follow_status = [topHunterDictionary valueForKey:@"follow_status"];
        }
        
        
        if (search && [topHunter.provider_id isEqualToString:[Helper getUserProfileDetail].userid]) {
                //            [topHunterDataArray addObject:topHunter];
            
        }
        else{
            [topHunterDataArray addObject:topHunter];
        }
    }];
    
    return topHunterDataArray;
}

-(NSMutableArray *) getCommentListData:(NSArray *) resultArray{
    __block NSDictionary * commentDictionary = [[NSDictionary alloc] init];
    NSMutableArray * commentDataArray = [[NSMutableArray alloc] init];
    
    [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FeedCommentData *commentListModel = [[FeedCommentData alloc] init];
        commentDictionary = (NSDictionary *) obj;
        
        commentListModel.feedCommentText            = [commentDictionary valueForKey:@"comment_content"];
        commentListModel.feedCommentSenderImgPath   = [commentDictionary valueForKey:@"commenter_photo"];
        commentListModel.feedCommentLikeCount       = [commentDictionary valueForKey:@"commentlike_count"];
        commentListModel.feedCommentDateTime        = [commentDictionary valueForKey:@"comment_time"];
        commentListModel.feedCommentSenderId        = [commentDictionary valueForKey:@"comment_user_id"];
        commentListModel.feedCommentPostID          = [commentDictionary valueForKey:@"comment_post_id"];
        commentListModel.feedCommentId              = [commentDictionary valueForKey:@"comment_id"];
        commentListModel.feedCommentSenderName      = [commentDictionary valueForKey:@"comment_name"];
        commentListModel.isMYLike                   = [commentDictionary valueForKey:@"is_my_like"];
        
        [commentDataArray addObject:commentListModel];
    }];
    
    return commentDataArray;
}

-(NSMutableArray *) getLikeData:(NSArray *) resultArray{
    __block NSDictionary * feedLikeDictionary = [[NSDictionary alloc] init];
    NSMutableArray * likeDataArray = [[NSMutableArray alloc] init];
    
    [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FeedLikeData *likeData = [[FeedLikeData alloc] init];
        feedLikeDictionary = (NSDictionary *) obj;
        
        likeData.feedLikedPersonName    = [feedLikeDictionary valueForKey:@"user_name"];
        likeData.feedLikedPersonId      = [feedLikeDictionary valueForKey:@"user_id"];
        likeData.feedLikedPersonImgPath = [feedLikeDictionary valueForKey:@"user_photo"];
        
        [likeDataArray addObject:likeData];
    }];
    
    return likeDataArray;
}

-(NSMutableArray *) getFollowingListData:(NSArray *) resultArray{
    __block NSDictionary * followingListDictionary = [[NSDictionary alloc] init];
    NSMutableArray * followingListDataArray = [[NSMutableArray alloc] init];
    
    [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            // Parsing Following List
        FollowingDataModel *followingDataModel = [[FollowingDataModel alloc] init];
        followingListDictionary = (NSDictionary *) obj;
        
        followingDataModel.followingName        = [followingListDictionary valueForKey:@"name"];
        followingDataModel.followingUserImgPath = [followingListDictionary valueForKey:@"img"];
        followingDataModel.followStatus         = [followingListDictionary valueForKey:@"follow_status"];
        followingDataModel.followersNo          = [followingListDictionary valueForKey:@"followers"];
        followingDataModel.followersposts       = [followingListDictionary valueForKey:@"win_count"];
        followingDataModel.userViewID           = [followingListDictionary valueForKey:@"user_id"];
        followingDataModel.bio                  = [followingListDictionary valueForKey:@"bio"];
        followingDataModel.gender               = [followingListDictionary valueForKey:@"gender"];
        
        [followingListDataArray addObject:followingDataModel];
    }];
    
    return followingListDataArray;
}

-(NSMutableArray *) getFollowingListdataPopUp:(NSArray *) resultArray withAdvancedSearch:(BOOL) flag{
    __block NSDictionary * followingListDictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray * followingListDataArray = [[NSMutableArray alloc] init];
    
    [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            // Parsing Following List
        FollowingDataModel *followingDataModel = [[FollowingDataModel alloc] init];
        followingListDictionary = (NSDictionary *) obj;
        
        followingDataModel.followingName        = [followingListDictionary valueForKey:@"name"];
        followingDataModel.followingUserImgPath = [followingListDictionary valueForKey:@"image"];
        followingDataModel.IDperson             = [followingListDictionary valueForKey:@"id"];
        
        if (flag) {
                //advancedSettingCondition To check status\
                //value on or off
                //default off
            followingDataModel.status_checked = [followingListDictionary valueForKey:@"pn_status"];
        }
        
        [followingListDataArray addObject:followingDataModel];
    }];
    
    return followingListDataArray;
}

-(NSMutableArray *) getHottieImages:(NSArray *) resultArray{
    __block NSDictionary * hottieImageListDictionary = [[NSDictionary alloc] init];
    NSMutableArray * hotttieImageListDataArray = [[NSMutableArray alloc] init];
    
    [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            // Parsing hottieImages for explore page List
        HottiesDaily * hottiesDaily = [[HottiesDaily alloc] init];
        hottieImageListDictionary = (NSDictionary *) obj;
        
        hottiesDaily.hottieUrl  = [hottieImageListDictionary objectForKey:@"img"];
        hottiesDaily.feedId     = [hottieImageListDictionary objectForKey:@"id"];
        
        [hotttieImageListDataArray addObject:hottiesDaily];
    }];
    
    return hotttieImageListDataArray;
}

-(NSMutableArray *) getHashTagList:(NSArray *) resultArray{
    __block NSDictionary * hashTagListDictionary = [[NSDictionary alloc] init];
    NSMutableArray * hashTagListDataArray = [[NSMutableArray alloc] init];
    
    [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            // Parsing hashtag List
        HashListModel * hashListModel = [[HashListModel alloc] init];
        hashTagListDictionary = (NSDictionary *) obj;
        
        hashListModel.hashName = [hashTagListDictionary objectForKey:@"hash_name"];
        hashListModel.hashdate = [hashTagListDictionary objectForKey:@"time"];
        
        [hashTagListDataArray addObject:hashListModel];
    }];
    
    return hashTagListDataArray;
}

-(NSMutableArray *) getHunterList:(NSArray *) resultArray{
    __block NSDictionary * hunterListDictionary = [[NSDictionary alloc] init];
    NSMutableArray * hunterListDataArray = [[NSMutableArray alloc] init];
    
    [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            // Parsing Hunter List
        Hunter * hunterModel = [[Hunter alloc] init];
        hunterListDictionary = (NSDictionary *) obj;
        
        hunterModel.hunterName      = [hunterListDictionary valueForKey:@"name"];
        hunterModel.hunterId        = [hunterListDictionary valueForKey:@"provider_id"];
        hunterModel.hunterPhoto     = [hunterListDictionary valueForKey:@"photo"];
        hunterModel.IsMyFollowing   = [hunterListDictionary valueForKey:@"ismyfollowing"];
        
        [hunterListDataArray addObject:hunterModel];
    }];
    
    return hunterListDataArray;
}

@end
