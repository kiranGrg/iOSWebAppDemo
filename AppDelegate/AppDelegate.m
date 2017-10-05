//
//  AppDelegate.m
//  HottieHunterDemo
//
//  Created by Ujjwal Shrestha on 02/06/2013.
//  Copyright (c) 2013 Ujjwal Shrestha. All rights reserved.
//

#import "AppDelegate.h"

#import <TMAPIClient.h>

#import "MainViewController.h"
#import "FeedVC.h"
#import "PostVC.h"
#import "CameraVC.h"
#import "NotificationSegmentView.h"
#import "ProfileVC.h"
#import "ExploreView.h"
#import "HottieImagesVC.h"
#import "RearViewController.h"
#import "RightViewController.h"
#import "PKRevealController.h"
#import "Reachability.h"
#import "Constants.h"
#import "ImageConstants.h"
#import "Helper.h"
#import "ServerURL+Constants.h"
#import "FirstInviteView.h"

#import "NotificationSegmentView.h"
#import "NotificationVC.h"
#import "HottieAPI.h"

#import "FollowingFilterVC.h"
#import "GenderFilterVC.h"

#import <TwitterKit/TwitterKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Appsee/Appsee.h>
#import "Countly.h"

NSString *const SCSessionStateChangedNotification =
@"com.facebook.HottieHunter:SCSessionStateChangedNotification";

@interface AppDelegate ()
@property (nonatomic, assign) BOOL firstRunForOneTime;
@end

@implementation AppDelegate

- (void)uiViewCustomisation
{
    float fontSizeUnSel = 12, fontSizeSel = 13;
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : HH_BLACK_COLOR, NSFontAttributeName: FONT_ROBOTO_LIGHT(fontSizeUnSel)} forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : HH_BLACK_COLOR, NSFontAttributeName:FONT_ROBOTO_MEDIUM(fontSizeSel)} forState:UIControlStateSelected];
    
    self.negativeSpacerLeft = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                               target:nil action:nil];
    self.negativeSpacerLeft.width = -10;// it was -6 in iOS 6
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftBtn setImage:[UIImage imageNamed:TOPBAR_LEFT_MENU_ICON] forState:UIControlStateNormal];
    self.leftBtn.frame = CGRectMake(0, 0, 32, 32);
    [self.leftBtn addTarget:self action:@selector(getRearView) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //    self.btnLeft = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
    
    self.btnLeft = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:TOPBAR_LEFT_MENU_ICON] style:UIBarButtonItemStylePlain target:self action:@selector(getRearView)];
    
    
    self.positiveSpacerRight = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                target:nil action:nil];
    self.positiveSpacerRight.width = -10;
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setImage:[UIImage imageNamed:TOPBAR_RIGHT_MENU_ICON] forState:UIControlStateNormal];
    self.rightBtn.frame = CGRectMake(0, 0, 32, 32);
    [self.rightBtn addTarget:self action:@selector(getRightView) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //    self.btnRight = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    
    self.btnRight = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:TOPBAR_RIGHT_MENU_ICON] style:UIBarButtonItemStylePlain target:self action:@selector(getRightView)];
    
    self.navTitleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TOPBAR_HOTTIE_LOGO]];
    
    //setting navbar bartint color
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:TOPBAR_YELLOW_BANNER_BACKGROUND_YELLOW_IMAGE] forBarMetrics:UIBarMetricsDefault];
    
    
    //setting navbar bartint color
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:TOPBAR_YELLOW_BANNER_BACKGROUND_YELLOW_IMAGE] forBarMetrics:UIBarMetricsDefault];
    //[[UINavigationBar appearance] setTranslucent:NO];
    
    //[[UINavigationBar appearance] setBarTintColor:HH_DEFAULT_YELLOW_COLOR];
    //[[UINavigationBar appearance] setTintColor:HH_DEFAULT_YELLOW_COLOR];
    
//    [[UINavigationBar appearance] setBackgroundColor:HH_DEFAULT_YELLOW_COLOR];
    
    if (IOS7_OR_HIGHER) {
        [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
    }
    //    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
    
}

#pragma mark - Application LifeCycle Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions");
    [Helper GetUNIQUEID];
    NSLog(@"iD:%@",[Helper GetUNIQUEID]);
    [Appsee start:APPSEE_KEY]; //for appsee
    //feed vc appreance count
    
    //[[Countly sharedInstance] start:COUNTLY_KEY withHost:@"http://TYPE_HERE_URL_WHERE_API_IS_HOSTED"]; // newly added line
    
    [[Countly sharedInstance] startOnCloudWithAppKey:COUNTLY_KEY];
    [[Countly sharedInstance] startCrashReporting];
    self.countOfFeedViewApperance = 0;
    
    self.firstRunForOneTime = NO;
    
    
    
    //for Twitter-Fabrics
    [[Twitter sharedInstance] startWithConsumerKey:TWITTER_CONSUMER_KEY
                                    consumerSecret:TWITTER_CONSUMER_SECRET];
    // [Fabric with:@[[Twitter sharedInstance]]];
    //[Fabric with:@[TwitterKit,CrashlyticsKit]];
    
    //[Fabric with:@[[Twitter sharedInstance]]];
    //[Fabric with:@[CrashlyticsKit]];
    [Fabric with:@[[Twitter class], [Crashlytics class]]];

    
    
    //tmblr
    [TMAPIClient sharedInstance].OAuthConsumerKey = TumblrkOAuthConsumerKey;
    [TMAPIClient sharedInstance].OAuthConsumerSecret = TumblrkOAuthConsumerSecret;
    
    //Reachability //Start for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachable = [Reachability reachabilityForInternetConnection];
    [self.internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    self.hostReachable = [Reachability reachabilityWithHostname:GoogleURL];
    [self.hostReachable startNotifier];
    
    //for nav bar custom button initialization
    [self uiViewCustomisation];
    [self voteListDownload];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    //register for push notification
    if ([Helper isVersionEqualorGreaterThan8])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    //display view..
    self.connView = [[UIView alloc]initWithFrame:CGRectMake(0, 22, SCREEN_WIDTH, 32)];
    self.connLbl = [[UILabel alloc]initWithFrame:_connView.frame];
    self.connLbl.backgroundColor = [UIColor greenColor];
    self.connLbl.text = @"No Internet Connection";
    self.connLbl.textAlignment = NSTextAlignmentCenter;
    self.connLbl.font = FONT_ROBOTO_LIGHT(14);
    [self.connView addSubview:self.connLbl];
    self.connView.tag = 1000;
    
    
    //for changing the default navigation back button color, font in all view
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0.0, 0.0);
    shadow.shadowColor = [UIColor clearColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:HH_BLACK_COLOR,
       NSShadowAttributeName:shadow,
       NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:15.0f]
       }
     forState:UIControlStateNormal];
    
    NSString *s=[[NSUserDefaults standardUserDefaults] stringForKey:@"firstTime"];
    
    if (s.length==0 || [s isEqualToString:@""] || s==nil || [s isEqual:[NSNull null]])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"firstTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    //start of other pre initialization
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.mainVController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    
    if ([Helper getUserProfileDetail]==nil || [Helper isUSerLoggedIn]==FALSE)
    {
        UINavigationController * mainNav = [[UINavigationController alloc]initWithRootViewController:self.mainVController];
        self.window.rootViewController = mainNav;
    }
    else
    {
        //creating and settig tabbar controller
        [self createTabBar];
        
        //nagivation from dropdown notifications of home screen
        if (launchOptions != nil)
            
        {
            
            NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            
            if (dictionary != nil)
                
            {
                //
                //                NSLog(@"Launched from push notification: %@", dictionary);
                //
                //                NSString *alertValue = [[dictionary valueForKey:@"aps"] valueForKey:@"alert"];
                //                NSLog(@"alert:%@",alertValue);
                //
                //                NSLog(@"Launched from push notification: %@", dictionary);
                
                //                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"pushdd" message:[dictionary description] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                //                alert show];
                
                if ([dictionary objectForKey:@"feed_id"] != [NSNull null] || [dictionary objectForKey:@"profile_id"] != [NSNull null] || [[dictionary objectForKey:@"push_name"] isEqualToString:@"M_HOTTIE_OF_DAY"]) {
                    [self presentNotificationSegmentWithRespectivePage:YES withNotificationDict:dictionary];
                }
            }
            
        }
    }
    
    //for facebook
    
    [self.window makeKeyAndVisible];
    HHUserDetails *user = [Helper getUserProfileDetail];
    [CrashlyticsKit setUserIdentifier:user.userid];
    [CrashlyticsKit setUserEmail:user.email];
    [CrashlyticsKit setUserName:user.username];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //    [self.tabbarController setSelectedIndex:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self voteListDownload];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationForwinfailAnimation" object:nil userInfo:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    NSLog(@"Application become active called");
    
    // [FBSession.activeSession handleDidBecomeActive];
    [FBSDKAppEvents activateApp];
    
    // UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    UIRemoteNotificationType types;
    if ([Helper isVersionEqualorGreaterThan8])
    {
        types = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    }
    else{
        types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        
    }
    
    
    if ([UIApplication sharedApplication].applicationIconBadgeNumber != 0)
    {
        UITabBarItem* tabitem = [self.tabbarController.tabBar.items objectAtIndex:3];
        tabitem.badgeValue = [NSString stringWithFormat:@"%ld",(long)[UIApplication sharedApplication].applicationIconBadgeNumber];
    }
    if (types == UIRemoteNotificationTypeNone)
    {
        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"PUSH_NOTIFICATION_DEVICE_TOKEN"]!=[NSString stringWithFormat:@""])
        {
            //cancel notification in API
        }
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"PUSH_NOTIFICATION_DEVICE_TOKEN"];
    }
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    _TimeZoneOfUser = [timeZone name];
    HHUserDetails *user = [Helper getUserProfileDetail];
    
    if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"userTimeZone"]isEqualToString:_TimeZoneOfUser])
    {
        if (!user.userid.length==0)
        {
            [self postTimezone];
        }
        
    }
    
    if (!self.firstRunForOneTime) {
        self.firstRunForOneTime = YES;
        NSString *fbsavedswitchValue = [[NSUserDefaults standardUserDefaults]stringForKey:@"fbswitchStatus"];
        NSString *twittersavedswitchValue = [[NSUserDefaults standardUserDefaults]stringForKey:@"twitterswitchStatus"];
        NSString *instagramsavedswitchValue = [[NSUserDefaults standardUserDefaults]stringForKey:@"instagramswitchStatus"];
        
        if (fbsavedswitchValue == NULL) {
            [[NSUserDefaults standardUserDefaults] setObject:@"ON" forKey:@"fbswitchStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        if (twittersavedswitchValue == NULL) {
            [[NSUserDefaults standardUserDefaults] setObject:@"OFF" forKey:@"twitterswitchStatus"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"twitterAuthtoken"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"twitterAuthtokenSecretKey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        if (instagramsavedswitchValue == NULL) {
            [[NSUserDefaults standardUserDefaults] setObject:@"OFF" forKey:@"instagramswitchStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        NSString *promotefbsavedswitchValue = [[NSUserDefaults standardUserDefaults]stringForKey:@"promotefbswitchStatus"];
        NSString *promotetwittersavedswitchValue = [[NSUserDefaults standardUserDefaults]stringForKey:@"promotetwitterswitchStatus"];
        NSString *promoteinstagramsavedswitchValue = [[NSUserDefaults standardUserDefaults]stringForKey:@"promoteinstagramswitchStatus"];
        
        
        if (promotefbsavedswitchValue == NULL) {
            [[NSUserDefaults standardUserDefaults] setObject:@"ON" forKey:@"promotefbswitchStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        if (promotetwittersavedswitchValue == NULL) {
            [[NSUserDefaults standardUserDefaults] setObject:@"OFF" forKey:@"promotetwitterswitchStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        if (promoteinstagramsavedswitchValue == NULL) {
            [[NSUserDefaults standardUserDefaults] setObject:@"OFF" forKey:@"promoteinstagramswitchStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
    }
}

- (void)postTimezone
{
    if ([Helper checkConnection] == YES)
    {
        HHUserDetails *user = [Helper getUserProfileDetail];
        NSLog(@"userid::%@",user.userid);
        NSLog(@"GetUNIQUEID::%@",[Helper GetUNIQUEID]);
        NSLog(@"_TimeZoneOfUser:::%@",_TimeZoneOfUser);
        NSDictionary *postParams = @{@"device_token"    : [Helper GetUNIQUEID],
                                     @"user_id"         :user.userid,
                                     @"timezone"        : _TimeZoneOfUser
                                     
                                     };
        [[HottieAPI sharedHottieHTTPClient]requestWithPath:TIME_ZONE_UPDATE_URL params:postParams onCompletion:^(NSDictionary *jsonDic, NSString *errorMessage)
         {
             if (errorMessage == nil)
             {
                 [[NSUserDefaults standardUserDefaults] setObject:_TimeZoneOfUser forKey:@"userTimeZone"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
             }
             else{
                 NSLog(@"Error on Timezone: %@",[jsonDic objectForKey:@"message"]);
             }
         }];
    }
    else{
        [APP_DEL showNoConnectionwithDisplayMessage:NO_INTERNET_CONNECTION_MESSAGE
         
         ];
    }
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // [FBSession.activeSession close];
    
    
    if (self.feedVC != nil)
    {
        [self.feedVC saveLatestFeed];
    }
    
    if (![[Helper getUserProfileDetail].userid isEqualToString:@""]) {
        
        NSString * rightRefString = [NSString stringWithFormat:@"RIGHT_MENU_FILTER_PREFERENCE_%@",[Helper getUserProfileDetail].userid];
        
        NSIndexPath * lastIndexPath = [NSIndexPath indexPathForRow:self.lastSelectedRightMenuItemIndex inSection:0];
        
//        [[NSUserDefaults standardUserDefaults] setObject:lastIndexPath forKey:@"LAST_RIGHT_MENU_SELECTED_INDEX"];
        [[NSUserDefaults standardUserDefaults] setObject:self.previousViewAtIndexFirst forKey:rightRefString];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
}
/*
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
 {
 if ([url.absoluteString hasPrefix:@"hottiehunter://tumblr"])
 {
 return [[TMAPIClient sharedInstance] handleOpenURL:url];
 }
 return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:self.session];
 }
 
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    /*
     if ([url.absoluteString hasPrefix:@"hottiehunter://tumblr"])
     {
     return [[TMAPIClient sharedInstance] handleOpenURL:url];
     }
     */
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}

#pragma mark - Public Utility Methods

- (void)moveToProile
{
    NSLog(@"profile.......");
    [self.tabbarController setSelectedViewController:(UINavigationController *)[self.tabbarController.viewControllers objectAtIndex:4]];
}

- (void)showTabBarPrevView:(int)index{
    [self.tabbarController setSelectedViewController:(UINavigationController *)[self.tabbarController.viewControllers objectAtIndex:index]];
}
- (void)displayLoginView
{
    UINavigationController *mainNav = [[UINavigationController alloc]initWithRootViewController:self.mainVController];
    self.window.rootViewController = mainNav;
}

- (void)createTabBar
{
    self.genderFeMaleFeed = [[GenderFilterVC alloc] init];
    self.genderFeMaleFeed.gender = @"female";
    
    self.genderMaleFeed = [[GenderFilterVC alloc] init];
    self.genderMaleFeed.gender = @"male";
    
    self.followingFeed = [[FollowingFilterVC alloc]init];
    
    //create tabbar
    self.tabbarController = [[UITabBarController alloc]init];
    self.tabbarController.delegate = self;
    
    self.feedVC = [[FeedVC alloc]init];
    self.exploreVC = [[ExploreView alloc]init];
    self.postVC = [[PostVC alloc]init];
    self.notificationsegmentVC = [[NotificationSegmentView alloc]initWithNibName:@"NotificationSegmentView" bundle:nil];
    self.profileVC = [[ProfileVC alloc]init];
    
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.0f/255.0f green:190.0f/255.0f blue:0.0f/255.0f alpha:0.95]];
    self.tabbarController.tabBar.barTintColor = [UIColor colorWithRed:0.0f/255.0f green:190.0f/255.0f blue:0.0f/255.0f alpha:0.95];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular" size:10.0f],
                                                        NSForegroundColorAttributeName : HH_DEFAULT_YELLOW_COLOR
                                                        } forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular" size:10.0f],
                                                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                                        } forState:UIControlStateSelected];
    
    
    
    UIImage *homeselectedImage = [UIImage imageNamed:TABBAR_HOME_IMAGE_SELECTED];
    UIImage *homeunselectedImage = [UIImage imageNamed:TABBAR_HOME_IMAGE];
    // navFeed.tabBarItem.title = @"Feed";
    
    
    //explore navigation
    UINavigationController *navExplore = [[UINavigationController alloc]initWithRootViewController:self.exploreVC];
    UIImage *exploreselectedImage = [UIImage imageNamed:TABBAR_EXPLORE_IMAGE_SELECTED];
    UIImage *exploreunselectedImage = [UIImage imageNamed:TABBAR_EXPLORE_IMAGE];
    // navExplore.tabBarItem.title = @"Explore";
    
    [navExplore.tabBarItem setImage:[exploreunselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [navExplore.tabBarItem setSelectedImage:[exploreselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController *navPost = [[UINavigationController alloc]initWithRootViewController:self.postVC];
    UIImage *postselectedImage = [UIImage imageNamed:TABBAR_POST_IMAGE_SELECTED];
    UIImage *postunselectedImage = [UIImage imageNamed:TABBAR_POST_IMAGE];
    // navPost.tabBarItem.title = @"Post";
    [navPost.tabBarItem setImage:[postunselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [navPost.tabBarItem setSelectedImage:[postselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //notification navigation
    UINavigationController *navNotification = [[UINavigationController alloc]initWithRootViewController:self.notificationsegmentVC];
    UIImage *notificationselectedImage = [UIImage imageNamed:TABBAR_NOTIFICATION_IMAGE_SELECTED];
    UIImage *notificationunselectedImage = [UIImage imageNamed:TABBAR_NOTIFICATION_IMAGE];
    //navNotification.tabBarItem.title = @"Notification";
    [navNotification.tabBarItem setImage:[notificationunselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [navNotification.tabBarItem setSelectedImage:[notificationselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //profile navigation
    UINavigationController *navProfile = [[UINavigationController alloc]initWithRootViewController:self.profileVC];
    UIImage *profileselectedImage = [UIImage imageNamed:TABBAR_PROFILE_IMAGE_SELECTED];
    UIImage *profileunselectedImage = [UIImage imageNamed:TABBAR_PROFILE_IMAGE];
    //navProfile.tabBarItem.title = @"Profile";
    
    [navProfile.tabBarItem setImage:[profileunselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [navProfile.tabBarItem setSelectedImage:[profileselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
        //allocationg left and right view
    self.leftViewController = [[RearViewController alloc] init];
    self.rightViewController = [[RightViewController alloc] init];
    
    
        //feed navigation
    
    UINavigationController *navFeed ;//= [[UINavigationController alloc]initWithRootViewController:self.feedVC];
    NSString * rightRefString = [NSString stringWithFormat:@"RIGHT_MENU_FILTER_PREFERENCE_%@",[Helper getUserProfileDetail].userid];
        //    NSLog(@"----right____ : %@",rightRefString);
        //
        //    NSLog(@"LOL : %@",[[NSUserDefaults standardUserDefaults] objectForKey:rightRefString]);
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:rightRefString] == NULL) {
            //        NSLog(@"LOL2 : %@",[[NSUserDefaults standardUserDefaults] objectForKey:rightRefString]);
        self.previousViewAtIndexFirst = FEED_VC;
        self.lastSelectedRightMenuItemIndex = 0;
        navFeed = [[UINavigationController alloc]initWithRootViewController:self.feedVC];
    }
    else{
            //        NSLog(@"LOL3 : %@",[[NSUserDefaults standardUserDefaults] objectForKey:rightRefString]);
        self.previousViewAtIndexFirst = [[NSUserDefaults standardUserDefaults] objectForKey:rightRefString];
        if ([self.previousViewAtIndexFirst isEqualToString:FEED_VC]) {
            self.lastSelectedRightMenuItemIndex = 4;
            navFeed = [[UINavigationController alloc]initWithRootViewController:self.feedVC];
        }
        else if ([self.previousViewAtIndexFirst isEqualToString:FOLLOWING_FILTER_VC]) {
            self.lastSelectedRightMenuItemIndex = 3;
            navFeed = [[UINavigationController alloc]initWithRootViewController:self.followingFeed];
        }
        else if ([self.previousViewAtIndexFirst isEqualToString:GENDER_FILTER_MALE_VC]) {
            self.lastSelectedRightMenuItemIndex = 1;
            navFeed = [[UINavigationController alloc]initWithRootViewController:self.genderMaleFeed];
        }
        else if ([self.previousViewAtIndexFirst isEqualToString:GENDER_FILTER_FEMALE_VC]) {
            self.lastSelectedRightMenuItemIndex = 2;
            navFeed = [[UINavigationController alloc]initWithRootViewController:self.genderFeMaleFeed];
        }
        
    }
    
    [navFeed.tabBarItem setImage:[homeunselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [navFeed.tabBarItem setSelectedImage:[homeselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    NSArray * tabBarItemsArray = @[navFeed, navExplore, navPost, navNotification, navProfile];
    
    navFeed.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
    navExplore.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
    navPost.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    navNotification.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
    navProfile.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
    self.tabbarController.viewControllers = tabBarItemsArray;
    // self.tabbarController.tabBar.backgroundImage = [UIImage imageNamed:TABBAR_BACKGROUND_IMAGE];
    self.tabbarController.tabBar.barTintColor=[UIColor blackColor];
    //post navigation
    self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cameraButton.frame = CGRectMake(120, 0.0, 70, 60);
    
    [self.cameraButton addTarget:self action:@selector(btnShowCameraAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabbarController.tabBar addSubview:self.cameraButton];
    
    self.revealController = [PKRevealController revealControllerWithFrontViewController:self.tabbarController leftViewController:self.leftViewController rightViewController:self.rightViewController options:nil];
    self.tabindex = 0;
    self.window.rootViewController = self.revealController;
}

- (void)popToFeedView
{
    UINavigationController *customnav=(UINavigationController*)[self.tabbarController.viewControllers objectAtIndex:0];
    if (![[customnav.viewControllers objectAtIndex:0]isKindOfClass:[FeedVC class]])
    {
        [customnav setViewControllers:[NSArray arrayWithObject:self.feedVC]];
    }
}


#pragma mark - IBAction Methods

- (void)btnShowCameraAction:(id)sender
{
    
    CameraVC *cameraVC = [[CameraVC alloc]initWithNibName:@"CameraVC" bundle:nil];
    
    UINavigationController *cameraNav = [[UINavigationController alloc]initWithRootViewController:cameraVC];
    [self.tabbarController presentViewController:cameraNav animated:YES completion:nil];
}


#pragma mark - Reachabiltiy Methods

- (void)showConnecton
{
    if ([self.window viewWithTag:1000] != nil)
    {
        [self.connView setHidden:NO];
        [self.window bringSubviewToFront:self.connView];
    }
    else
    {
        [self.window addSubview:self.connView];
        [self.connView setHidden:NO];
        [self.window bringSubviewToFront:self.connView];
    }
    
    self.connLbl.text = @"Connectted to Internet";
    self.connLbl.font=FONT_ROBOTO_LIGHT(14);
    self.connLbl.textColor=[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    self.connLbl.backgroundColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:0.8f];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hideConnView) userInfo:nil repeats:NO];
    
}

- (void)showNoConnectionwithDisplayMessage:(NSString*)displayMessage
{
    if ([self.window viewWithTag:1000] != nil)
    {
        [self.connView setHidden:NO];
        [self.window bringSubviewToFront:self.connView];
    }
    else
    {
        [self.window addSubview:self.connView];
        [self.connView setHidden:NO];
        [self.window bringSubviewToFront:self.connView];
    }
    self.connLbl.text = displayMessage;
    self.connLbl.font=FONT_ROBOTO_LIGHT(14);
    self.connLbl.textColor=[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    self.connLbl.backgroundColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:0.8f];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hideConnView) userInfo:nil repeats:NO];
    
}

-(void)hideConnView
{
    if ([self.window viewWithTag:1000] != nil)
    {
        [self.connView setHidden:YES];
    }
}

-(void)checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [self.internetReachable currentReachabilityStatus];
    BOOL internet_signal = NO;
    BOOL internet_service = NO;
    
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            break;
            
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            internet_signal = YES;
            self.isWith_WWAN = NO;
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            internet_signal = YES;
            self.isWith_WWAN = YES;
            break;
        }
    }
    
    NetworkStatus hostStatus = [self.hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            internet_service = YES;
            self.isWith_WWAN = NO;
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            internet_service = YES;
            self.isWith_WWAN = YES;
            break;
        }
    }
    
    if (internet_signal && internet_service) {
        //Internet is Back one
        //        [self showConnecton];
    }
    else{
        [self showNoConnectionwithDisplayMessage:NO_INTERNET_CONNECTION_MESSAGE]; ////
    }
}

#pragma mark - UITabBarControllerDelegate Methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == 0) {
        if (![self.revealController hasRightViewController]) {
            [self.revealController setRightViewController:self.rightViewController];
        }
        
        UINavigationController *customnav=(UINavigationController*)[tabBarController.viewControllers objectAtIndex:0];
        if (![[customnav.viewControllers objectAtIndex:0]isKindOfClass:[FeedVC class]] && ![[customnav.viewControllers objectAtIndex:0]isKindOfClass:[FollowingFilterVC class]] && ![[customnav.viewControllers objectAtIndex:0]isKindOfClass:[GenderFilterVC class]])
        {
            NSLog(@"from another status: diff");
            [self.feedVC pullToRefresh];
            
            //            self.countOfFeedViewApperance += 1;
            
            //            [customnav setViewControllers:[NSArray arrayWithObject:self.feedVC]];
            
            if ([self.previousViewAtIndexFirst isEqualToString:FEED_VC]) {
                self.previousViewAtIndexFirst = FEED_VC;
                self.countOfFeedViewApperance += 1;
                [customnav setViewControllers:[NSArray arrayWithObject:self.feedVC]];
            }
            else if ([self.previousViewAtIndexFirst isEqualToString:FOLLOWING_FILTER_VC]) {
                self.previousViewAtIndexFirst = FOLLOWING_FILTER_VC;
                [customnav setViewControllers:[NSArray arrayWithObject:self.followingFeed]];
            }
            else if ([self.previousViewAtIndexFirst isEqualToString:GENDER_FILTER_MALE_VC]) {
                self.previousViewAtIndexFirst = GENDER_FILTER_MALE_VC;
                [customnav setViewControllers:[NSArray arrayWithObject:self.genderMaleFeed]];
            }
            else if ([self.previousViewAtIndexFirst isEqualToString:GENDER_FILTER_FEMALE_VC]) {
                self.previousViewAtIndexFirst = GENDER_FILTER_FEMALE_VC;
                [customnav setViewControllers:[NSArray arrayWithObject:self.genderFeMaleFeed]];
            }
            
        }
        else {
            if ([[customnav.viewControllers objectAtIndex:0] isKindOfClass:[FeedVC class]] && self.tabindex != 0) {
                self.countOfFeedViewApperance += 1;
            }
            [self toCheckSameTabReTapActionOnTabBar:tabBarController];
        }
    }
    else{
        
        if ([self.revealController hasRightViewController]) {
            [self.revealController setRightViewController:nil];
        }
        
        [self toCheckSameTabReTapActionOnTabBar:tabBarController];
    }
    
    self.tabindex = (int)tabBarController.selectedIndex;
}

-(void) toCheckSameTabReTapActionOnTabBar:(UITabBarController *) tabBarController{
    
    if (self.tabindex == tabBarController.selectedIndex){
        NSLog(@"status: same");
        [self toFireScrollUpNotifications:self.tabindex];
        
    }
    else{
        NSLog(@"status: diff");
        if (tabBarController.selectedIndex == 3) {
            UITabBarItem * tabitem = [tabBarController.tabBar.items objectAtIndex:3];
            UINavigationController *nav = (UINavigationController *)[self.tabbarController.viewControllers objectAtIndex:3];
            BOOL view_loaded = [[nav.viewControllers objectAtIndex:0] isViewLoaded];
            NSLog(@"nav loaded : %d",view_loaded);
            if (tabitem.badgeValue != nil && view_loaded) {
                
                // loading data of notifications when there is new notif on clicking on the tab
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_MY_NOTIFICATIONS" object:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_FOLLOWING_NOTIFICATIONS" object:nil];
            }
        }
    }
    
}

-(void) toFireScrollUpNotifications:(NSInteger) tabIndex{
    NSString * notif_type;
    float y_offset = 0.0;
    
    switch (tabIndex) {
        case 0:
            notif_type = @"MOVESCROLLVIEWTOTOP_FEED_NOTIFICATION";
            y_offset = 0.0;
            break;
            
        case 1:
            notif_type = @"MOVESCROLLVIEWTOTOP_HASHTAG_NOTIFICATION";
            y_offset = 0.0;
            break;
            
        case 3:
            notif_type = @"MOVESCROLLVIEWTOTOP_NOTIF_NOTIFICATION";
            y_offset = 0.0;
            break;
        case 4:
            
            notif_type = @"MOVESCROLLVIEWTOTOP_PROFILE_NOTIFICATION";
            y_offset = -44.0;
            
            break;
            
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notif_type object:nil userInfo:@{@"offset" : [NSValue valueWithCGPoint:CGPointMake(0.0, y_offset)]}];
    if (tabIndex == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:notif_type object:nil userInfo:@{@"offset" : [NSValue valueWithCGPoint:CGPointMake(0.0, y_offset)]}];
    }
}

#pragma mark -pull latest post to feed top
-(void)pullLatestPostToFeedTop{
    if (![self.revealController hasRightViewController]) {
        [self.revealController setRightViewController:self.rightViewController];
    }
    //        }
    UINavigationController *customnav=(UINavigationController*)[self.tabbarController.viewControllers objectAtIndex:0];
    if (![[customnav.viewControllers objectAtIndex:0]isKindOfClass:[FeedVC class]])
    {
        
        [customnav setViewControllers:[NSArray arrayWithObject:self.feedVC]];
    }
    self.tabbarController.selectedViewController = [self.tabbarController.viewControllers objectAtIndex:0];
    self.tabbarController.selectedIndex = 0;
    self.tabindex = 0;
    
    [self.feedVC showRefreshAnimation];
    //    [self.feedVC pullToRefresh];
}

#pragma mark - PushNotifiactionDelegates Methods

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *formattedToken = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"formated Device Token:%@",formattedToken);
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"PUSH_NOTIFICATION_DEVICE_TOKEN"]==nil)
    {
        //start notification in API
    }
    [[NSUserDefaults standardUserDefaults] setValue:formattedToken forKey:@"PUSH_NOTIFICATION_DEVICE_TOKEN"];
    NSLog(@"formatted token:%@", formattedToken);
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"received %@",userInfo);
    NSLog(@"BAGDE:%@",[[userInfo objectForKey:@"aps"] valueForKey:@"badge"]);
    
    UIApplicationState  hhApp_state = application.applicationState;
    
    if (hhApp_state == UIApplicationStateInactive || hhApp_state == UIApplicationStateBackground) {
        
        if ([userInfo objectForKey:@"feed_id"] != [NSNull null] || [userInfo objectForKey:@"profile_id"] != [NSNull null] || [[userInfo objectForKey:@"push_name"] isEqualToString:@"M_HOTTIE_OF_DAY"]) {
            [self presentNotificationSegmentWithRespectivePage:NO withNotificationDict:userInfo];
        }
        
    }
    else {
        if (self.tabbarController.selectedIndex == 3)
        {
            //refresh notifications
            NSString * prefix = @"";
            if ([((NSString *)[userInfo objectForKey:@"push_name"]) characterAtIndex:0] == 'M') {
                prefix = @"M";
                
            }
            else {
                prefix = @"F";
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_NOTIFICATION_WHILE_IN_VIEW" object:nil userInfo:@{@"Notif_type": prefix}];
        }
        else
        {
            //display batch
            NSLog(@"BADGE:%@",[userInfo objectForKey:@"aps"]);
            if ([[userInfo objectForKey:@"aps"] valueForKey:@"badge"] == 0)
            {
                [[[[[self tabbarController] tabBar] items] objectAtIndex:3] setBadgeValue:nil];
            }
            else
            {
                [[[[[self tabbarController] tabBar] items] objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] valueForKey:@"badge"]]];
                
                [UIApplication sharedApplication].applicationIconBadgeNumber = [((NSString *)[[userInfo objectForKey:@"aps"] objectForKey:@"badge"]) integerValue];
            }
        }
    }
    /*
     
     if ([userInfo objectForKey:@"feed_id"] != [NSNull null] && self.tabbarController.selectedIndex != 3 && [[userInfo objectForKey:@"push_name"] isEqualToString:@"F_POSTED_HOTTIE"]){
     [self presentNotificationSegmentWithRespectivePage:NO withNotificationDict:userInfo];
     }
     else if (self.tabbarController.selectedIndex == 3)
     {
     //refresh notifications
     NSString * prefix = @"";
     if ([((NSString *)[userInfo objectForKey:@"push_name"]) characterAtIndex:0] == 'M') {
     prefix = @"M";
     
     }
     else {
     prefix = @"F";
     }
     [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_NOTIFICATION_WHILE_IN_VIEW" object:nil userInfo:@{@"Notif_type": prefix}];
     }
     else
     {
     //display batch
     NSLog(@"BADGE:%@",[userInfo objectForKey:@"aps"]);
     if ([[userInfo objectForKey:@"aps"] valueForKey:@"badge"] == 0)
     {
     [[[[[self tabbarController] tabBar] items] objectAtIndex:3] setBadgeValue:nil];
     }
     else
     {
     [[[[[self tabbarController] tabBar] items] objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] valueForKey:@"badge"]]];
     
     [UIApplication sharedApplication].applicationIconBadgeNumber = [((NSString *)[[userInfo objectForKey:@"aps"] objectForKey:@"badge"]) integerValue];
     }
     }
     
     */
}

#pragma mark ---RevealViewControllerAction

- (void) showLeftMenuViewManually {
    [self getRearView];
}

- (void)getRearView
{
    [self.revealController showViewController:self.revealController.leftViewController];
}

- (void)getRightView
{
    [self.revealController showViewController:self.revealController.rightViewController];
}

#pragma mark Centralized methods for aap
// VoteList downloading for each
- (void) voteListDownload{
    if ([Helper checkConnection]==YES)
    {
        [[HottieAPI sharedHottieHTTPClient] requestWithPath:VOTE_LIST_URL params:nil onCompletion:^(NSDictionary *json, NSString *errorMessage) {
            if (errorMessage == nil) {
                NSArray * new_voteDict = [json objectForKey:@"feed_vote_list"];
                if (![new_voteDict isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"VOTE_LIST"]]) {
                    NSLog(@"different");
                    [[NSUserDefaults standardUserDefaults] setObject:new_voteDict forKey:@"VOTE_LIST"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else{
                    NSLog(@"same");
                }
            }
            else{
                NSLog(@"Error --- %@",errorMessage);
            }
        }];
    }
    else{
        [APP_DEL showNoConnectionwithDisplayMessage:NO_INTERNET_CONNECTION_MESSAGE
         
         ];
    }
}
//Clearing NotificationBatchNumber
- (void) clearBadgeOnActuallyTappingAtThirdTab{
    if ([Helper checkConnection]==YES)
    {
        NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
        NSString *pushdeviceToken = [data objectForKey:@"PUSH_NOTIFICATION_DEVICE_TOKEN"];
        HHUserDetails *user = [Helper getUserProfileDetail];
        NSDictionary *postParams = @{@"device_token"        : [Helper GetUNIQUEID],
                                     @"push_device_token"   : pushdeviceToken,
                                     @"user_id"             : user.userid,
                                     @"type"                : DEVICE_TYPE
                                     };
        
        [[HottieAPI sharedHottieHTTPClient]requestWithPath:BADGE_CLEAR_URL params:postParams onCompletion:^(NSDictionary *jsonDic, NSString *errorMessage)
         {
             if (errorMessage==nil)
             {
                 // loading data of notifications when there is new notif on clicking on the tab
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_MY_NOTIFICATIONS" object:nil];
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_FOLLOWING_NOTIFICATIONS" object:nil];
             }
             else
             {
                 //Error
             }
         }];
    }
    else{
        [APP_DEL showNoConnectionwithDisplayMessage:NO_INTERNET_CONNECTION_MESSAGE
         
         ];
    }
}

-(void) presentNotificationSegmentWithRespectivePage:(BOOL) flag withNotificationDict:(NSDictionary *) dictionary{
    UINavigationController *nav = (UINavigationController *)[self.tabbarController.viewControllers objectAtIndex:3];
    
    //    self.notificationsegmentVC.isLunchedFromDropDownMenu = flag;
    self.notificationsegmentVC.postFeedId = [dictionary objectForKey:@"feed_id"] == [NSNull null] ? @"" : [dictionary objectForKey:@"feed_id"];
    self.notificationsegmentVC.profileId = [dictionary objectForKey:@"profile_id"] == [NSNull null] ? @"" : [dictionary objectForKey:@"profile_id"];
    self.notificationsegmentVC.notification_type = [dictionary objectForKey:@"push_name"];
    
    if (self.tabbarController.selectedIndex == 3 && !flag) {
        if (nav.viewControllers.count > 1) {
            [nav popToRootViewControllerAnimated:NO];
        }
        else {
            [self.notificationsegmentVC forwadingToRespectiveView];
        }
    }
    else {
        self.tabbarController.selectedViewController = nav;
        self.tabindex = 3;
        self.tabbarController.selectedIndex = 3;
        [nav popToRootViewControllerAnimated:NO];
    }
}

@end
