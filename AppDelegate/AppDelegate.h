//
//  AppDelegate.h
//  HottieHunterDemo
//
//  Copyright (c) 2013 DesignOffshore. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

extern NSString *const SCSessionStateChangedNotification;

@class MainViewController;
@class PKRevealController;
@class FeedVC;
@class ExploreView;
@class PostVC;
@class NotificationSegmentView;
@class ProfileVC;
@class Reachability;
@class FirstInviteView;
@class FollowingFilterVC;
@class GenderFilterVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>


@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UITabBarController *tabbarController;
@property (nonatomic, assign) int tabindex;
@property (nonatomic, assign) int previousTabIndex;
@property (nonatomic, strong) UIView *connView;
@property (nonatomic, strong) UILabel *connLbl;
@property (nonatomic, strong) UIButton *cameraButton;

@property(nonatomic,assign) BOOL isPostSucess;

@property (nonatomic, strong) MainViewController * mainVController;
@property (nonatomic, strong) FirstInviteView *firstInviteVC;
@property (nonatomic, strong, readwrite) PKRevealController *revealController;
@property (nonatomic, strong) FeedVC *feedVC;
@property (nonatomic, strong) ExploreView *exploreVC;
@property (nonatomic, strong) PostVC *postVC;
@property (nonatomic, strong) NotificationSegmentView *notificationsegmentVC;
@property (nonatomic, strong) ProfileVC *profileVC;
    //added
@property (nonatomic, strong) GenderFilterVC * genderMaleFeed;
@property (nonatomic, strong) GenderFilterVC * genderFeMaleFeed;
@property (nonatomic, strong) FollowingFilterVC * followingFeed;
@property (nonatomic, strong) NSString * previousViewAtIndexFirst;
@property (nonatomic, assign) NSInteger lastSelectedRightMenuItemIndex;

@property (nonatomic, strong) UIViewController * leftViewController, * rightViewController;

//@property (nonatomic, strong) FBSession *session;
@property (nonatomic,strong) FBSDKLoginManager *facebooklogin;

@property (nonatomic, strong) UIPopoverController * popUp;

    //reachability
@property (nonatomic, strong) Reachability *internetReachable;
@property (nonatomic, strong) Reachability *hostReachable;

    //nav bar items
@property (nonatomic, strong) UIBarButtonItem *negativeSpacerLeft;
@property (nonatomic, strong) UIBarButtonItem *positiveSpacerRight;
@property (nonatomic, strong) UIButton * leftBtn;
@property (nonatomic, strong) UIButton * rightBtn;
@property (nonatomic, strong) UIBarButtonItem * btnLeft;
@property (nonatomic, strong) UIBarButtonItem * btnRight;
@property (nonatomic, strong) UIImageView * navTitleImage;
@property(nonatomic,strong) NSString *TimeZoneOfUser;

    //feedvc appearance counts
@property (nonatomic, assign) int countOfFeedViewApperance;

@property (nonatomic, assign) BOOL isWith_WWAN;

- (void)createTabBar;
- (void)displayLoginView;
- (void)popToFeedView;
- (void)moveToProile;
- (void)showNoConnectionwithDisplayMessage:(NSString*)displayMessage;
-(void)pullLatestPostToFeedTop;

- (void) showTabBarPrevView:(int) index;
- (void) voteListDownload;
- (void) showLeftMenuViewManually;
@end
