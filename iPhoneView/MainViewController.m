 //
//  MainViewController.m
//  HottieHunterDemo
//
//  Created by Kiran's Mac Mini on 10/9/14.
//  Copyright (c) 2014 Design Offshore Nepal. All rights reserved.
//

#import "MainViewController.h"

#import "APPChildViewController.h"
#import "MBProgressHUD.h"

#import <QuartzCore/QuartzCore.h>
//#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "AppDelegate.h"
#import "HottieAPI.h"
#import "PKRevealController.h"
#import "RearViewController.h"
#import "RightViewController.h"
#import "FeedVC.h"
#import "HHUserDetails.h"
#import "Constants.h"
#import "ImageConstants.h"
#import "ServerURL+Constants.h"
#import "Helper.h"
#import "FirstInviteView.h"
#import "UIImageView+WebCache.h"

#import "DataManager.h"

@interface MainViewController ()<UIPageViewControllerDataSource>

@property (nonatomic, assign) BOOL isFirstLogin;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated
{
    NOTIFICATION_ADD_OBSERVER(@selector(updateNavTitle:), @"UPDATENAVTITLE");
    NOTIFICATION_ADD_OBSERVER(@selector(rotateChildViewController:), @"CHILDVIEW_ROTATION");
    self.navigationController.navigationBarHidden=YES;
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.btnFBLogin setImage:[UIImage imageNamed:ENTER_PAGE_FB_LOGIN_BUTTON] forState:UIControlStateNormal];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageViewController.dataSource = self;
    [[self.pageViewController view] setFrame:self.view.bounds];
    
    APPChildViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [[self view] addSubview:[self.pageViewController view]];
    [self.pageViewController didMoveToParentViewController:self];
    
    
    self.pageControlUI.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControlUI.pageIndicatorTintColor = [UIColor grayColor];
    
    [self.view bringSubviewToFront:self.pageControlUI];
    [self.view bringSubviewToFront:self.btnFBLogin];
    
    
    
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FacebookNotification" object:nil];
    
    
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    NOTIFICATION_REMOVE_OBSERVER(@"UPDATENAVTITLE");
    NOTIFICATION_REMOVE_OBSERVER(@"CHILDVIEW_ROTATION");
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UIpageviewcontroller datasource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSInteger index = [(APPChildViewController *)viewController pageIndex];
    
    
    if (index == 0) {
        //        return nil;
        index = 5;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSInteger index = [(APPChildViewController *)viewController pageIndex];
    
    index++;
    if (index == 5) {
        //        return nil;
        index = 0;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (APPChildViewController *)viewControllerAtIndex:(NSInteger)index {
    
    if (index < 0 || index > 4) {
        return nil;
    }
    APPChildViewController *childViewController = [[APPChildViewController alloc] initWithNibName:@"APPChildViewController" bundle:nil];
    childViewController.pageIndex = index;
    return childViewController;
}

#pragma mark Notification Actions

- (void) updateNavTitle:(NSNotification *) notif{
    NSDictionary * dict = notif.userInfo;
    NSInteger index = [[dict objectForKey:@"index"] integerValue];
    self.pageControlUI.currentPage = index;
    if(index == 0){
        self.pageControlUI.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    else{
        self.pageControlUI.currentPageIndicatorTintColor = HH_BLACK_COLOR;
    }
}

- (void) rotateChildViewController:(NSNotification *) notif{
    NSDictionary * dict = notif.userInfo;
    NSInteger nextPageIndex = [[dict objectForKey:@"nextPageIndex"] intValue];
    [self changePage:nextPageIndex];
}

#pragma mark Shifting ViewController Through timer notif

- (void)changePage:(NSInteger) nextPageIndex {
    
    APPChildViewController *viewController = [self viewControllerAtIndex:nextPageIndex];
    
    if (viewController == nil) {
        return;
    }
    
    [self.pageViewController setViewControllers:@[viewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
}

#pragma mark IBActions

- (IBAction)fbLogInStart:(id)sender {
    [self facebookLogin];
}


#pragma mark - Facebook Methods

- (void)facebookLogin
{
    /*
    if (!APP_DEL.session.isOpen)
    {
        // create a fresh session object
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"email",@"user_friends",@"basic_info",@"read_friendlists",@"user_location",@"user_birthday",nil];
        //NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile",nil];
        
        
        APP_DEL.session = [[FBSession alloc] initWithPermissions:permissions];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        NSLog(@"FBSession state:%u", APP_DEL.session.state);
        if (APP_DEL.session.state == FBSessionStateCreatedTokenLoaded || APP_DEL.session.state==FBSessionStateCreated) {
            // even though we had a cached token, we need to login to make the session usable
            [APP_DEL.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
                // we recurse here, in order to update buttons and labels
                switch (session.state)
                {
                    case FBSessionStateOpen:
                    {
                        if(error)
                        {
                            NSLog(@"Error occurred");
                            [self facebookLogin];
                        }
                        else
                        {
                            [self getUserFacebookDetails];
                        }
                        
                    }
                        // here you get the token
                        // NSLog(@"%@", session.accessToken);
                        break;
                    case FBSessionStateClosed:
                    case FBSessionStateClosedLoginFailed:
                        [APP_DEL.session closeAndClearTokenInformation];
                        break;
                    default:
                        break;
                }
            }];
        }
  
    }
     
     */
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // TODO:Token is already available.
        NSLog(@"token:%@",[FBSDKAccessToken currentAccessToken].tokenString);
        [self getUserFacebookDetails];
        
    }
    else{
        self.facebooklogin = [[FBSDKLoginManager alloc] init];
        APP_DEL.facebooklogin=self.facebooklogin;
        APP_DEL.facebooklogin.loginBehavior = FBSDKLoginBehaviorNative;
        [self.facebooklogin
         logInWithReadPermissions: @[@"public_profile",@"email",@"user_friends",@"user_location",@"user_birthday"]fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 NSLog(@"Process error:%@",error.localizedDescription);
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 NSLog(@"Logged in");
                 NSLog(@"token:%@",[FBSDKAccessToken currentAccessToken].tokenString);
                 NSLog(@"result data:%@",result.description);
                 NSDictionary *dict = (NSDictionary*) result;
                 NSLog(@"facebook login detail from facebook:%@",dict);
                 
                 [self getUserFacebookDetails];
             }
         }];
   
    }
}

- (void)getUserFacebookDetails
{
   // [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location , friends ,hometown , friendlists"}]
     
        FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"/v2.3/me" parameters:@{@"fields": @"birthday,email,first_name,gender,id, last_name,link,middle_name,name,location,hometown"}];
    
   // FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"/v2.3/me" parameters:nil];
        
        FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
        
        [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            
            if(result)
            {
                NSLog(@"RESULT:%@",result);
                if ([result objectForKey:@"email"]) {
                    
                    NSLog(@"Email: %@",[result objectForKey:@"email"]);
                    
                }
                if ([result objectForKey:@"first_name"]) {
                    
                    NSLog(@"First Name : %@",[result objectForKey:@"first_name"]);
                    
                }
                if ([result objectForKey:@"id"]) {
                    
                    NSLog(@"User id : %@",[result objectForKey:@"id"]);
                    
                }
                
            }
            
            NSDictionary *userData = (NSDictionary *)result;
            NSLog(@"userData:%@",userData);
            [Helper saveLoggedInFBToken:[FBSDKAccessToken currentAccessToken].tokenString];
            [self registerAndCheckUserLoginwithdetails:userData];
            
        }];
        
        [connection start];

           //[activityIndicator startAnimating];
    /*
    FBSession *facebook_session = APP_DEL.session;
    
    [[[FBRequest alloc] initWithSession:facebook_session graphPath:@"me"] startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
         if (!error) {
             // get the data from user object
             
             NSDictionary *dict = (NSDictionary*) user;
             NSLog(@"facebook login detail from facebook:%@",dict);
             
             
             // NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:[dict valueForKey:@"locale"]];
             
             // NSString *country = [usLocale displayNameForKey: NSLocaleCountryCode value: countryCode];
             
             //register or check user in HH server
             
             // [self sendFBRequestToServer:APP_DEL.session.accessTokenData.accessToken email:[dict objectForKey:@"email"]];
             
             //             NSLog(@"ACCESS TOKEN=%@ and id=%d", APP_DEL.session.accessTokenData.accessToken, (int)[dict objectForKey:@"id"]);
             
             [[NSUserDefaults standardUserDefaults] setObject:APP_DEL.session.accessTokenData.accessToken forKey:@"FB_ACCESS_TOKEN"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             [self registerAndCheckUserLoginwithdetails:dict];
             //show feed revealview controller when user sucessfully signed in
             //[self dismissModalViewControllerAnimated:NO];
         }
         else
         {
             NSLog(@"Error: %@",error);
         }
     }];
     
     */
}

- (void)loginFailed
{
    NSLog(@"Facebook Login Failed");
}

- (void)registerAndCheckUserLoginwithdetails:(NSDictionary*)userdict
{
    //for country from locale
    //    NSLocale *locale = [NSLocale currentLocale];
    //    NSLog(@"lcoale:%@",locale);
    //    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    //    NSLog(@"countryCode:%@",countryCode);
    //    NSString *countryName = [locale displayNameForKey: NSLocaleCountryCode
    //                                                value: countryCode];
    //    NSLog(@"country:::%@",countryName);
    
    
    
    //get timezone
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSString *tzName = [timeZone name];
    
    NSString *pushdeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"PUSH_NOTIFICATION_DEVICE_TOKEN"];
    NSString * ID = @"";
    NSString * location = @"";
    NSString * name = @"";
    NSString * firstName = @"";
    NSString * middleName = @"";
    NSString * lastName = @"";
    NSString * email = @"";
    NSString * gender = @"";
    NSString * birthday = @"";
    
    
    if ([userdict objectForKey:@"id"])
    {
        ID = [userdict objectForKey:@"id"];
    }
    else
    {
        ID = @"";
    }
    
    
    if ([userdict objectForKey:@"location"])
    {
        location = [[userdict objectForKey:@"location"] objectForKey:@"name"];
    }
    else
    {
        location = @"";
    }
    
    if ([userdict objectForKey:@"name"])
    {
        name = [userdict objectForKey:@"name"];
    }
    else
    {
        name = @"";
    }
    
    if ([userdict objectForKey:@"first_name"])
    {
        firstName = [userdict objectForKey:@"first_name"];
    }
    else
    {
        firstName = @"";
    }
    if ([userdict objectForKey:@"middle_name"])
    {
        middleName = [userdict objectForKey:@"middle_name"];
    }
    else
    {
        middleName = @"";
    }
    
    if ([userdict objectForKey:@"last_name"])
    {
        lastName = [userdict objectForKey:@"last_name"];
    }
    else
    {
        lastName = @"";
    }
    
    
    if ([userdict objectForKey:@"email"])
    {
        email = [userdict objectForKey:@"email"];
    }
    else
    {
        email = @"";
    }
    
    if ([userdict objectForKey:@"gender"])
    {
        gender = [userdict objectForKey:@"gender"];
    }
    else
    {
        gender = @"";
    }
    
    if ([userdict objectForKey:@"birthday"])
    {
        birthday = [userdict objectForKey:@"birthday"];
    }
    else
    {
        birthday = @"";
    }
    
    NSLog(@"ID:%@",ID);
    NSLog(@"device_token :%@",[Helper GetUNIQUEID]);
   // NSLog(@"facebook_access_token : %@",APP_DEL.session.accessTokenData.accessToken);
    NSLog(@"fbtoken:%@",[FBSDKAccessToken currentAccessToken].tokenString);
    NSLog(@"user_id :%@",[userdict objectForKey:@"id"]);
    NSLog(@"user_name :%@",[userdict objectForKey:@"name"]);
    
    NSLog(@"name :%@",[[userdict objectForKey:@"location"]valueForKey:@"name"]);
    NSLog(@"push_device_token : %@", pushdeviceToken);
    NSLog(@"timezone :%@",tzName);
    
    NSDictionary *postParams = @{@"user_id"           : ID,
                                 @"facebook_access_token": [FBSDKAccessToken currentAccessToken].tokenString,
                                 @"device_token"      : [Helper GetUNIQUEID],
                                 @"push_device_token" : pushdeviceToken,
                                 @"type"              : DEVICE_TYPE,
                                 @"timezone":tzName,
                                 @"name":name,
                                 @"email":email,
                                 @"gender":gender,
                                 @"first_name":firstName,
                                 @"middle_name":middleName,
                                 @"last_name":lastName,
                                 @"birthday":birthday,
                                 @"location":location
                                 
                                 };
    
    [[HottieAPI sharedHottieHTTPClient]requestWithPath:HOTTIE_HUNTER_LOGIN_URL params:postParams onCompletion:^(NSDictionary *jsonDic, NSString *errorMessage)
     {
         
         
         if (errorMessage==nil)
         {
             
             NSArray *result = [jsonDic objectForKey:@"data"];
             NSLog(@"1 -- From server userProfile Data: --------------\n%@",result);
             NSDictionary * dict = [result objectAtIndex:0];
             NSString *usrID = [dict valueForKey:@"user_id"];
             NSString *isfirstLogin = [dict valueForKey:@"wb_ios_status"];
             NSLog(@"firstLogin:%@",isfirstLogin);
             
             //             [[NSUserDefaults standardUserDefaults] setObject:isfirstLogin forKey:@"firstloginOrNot"];
             //             [[NSUserDefaults standardUserDefaults] synchronize];
             
             self.isFirstLogin = ([isfirstLogin compare:@"enable" options:NSCaseInsensitiveSearch] == NSOrderedSame) ? true : false;
            
             NSLog(@"first login value is : %@", (self.isFirstLogin) ? @"true" : @"false");
             
             [self getUserProfileDetailsWithId:usrID withfirstName:[userdict objectForKey:@"first_name"]];
             
             [self dismissViewControllerAnimated:NO completion:nil];
         }
         
         else
         {
             //Error
             [self notifyErrorWithMessage:errorMessage];
             //[APP_DEL.session closeAndClearTokenInformation];
             return;
             
         }
     }];
    
}

- (void)getUserProfileDetailsWithId:(NSString*)userid withfirstName:(NSString*)firstName
{
    
    NSDictionary *postParams = @{@"user_id"         : userid,
                                 @"profile_view_id" : userid,
                                 @"device_token"    : [Helper GetUNIQUEID]
                                 };
    [[HottieAPI sharedHottieHTTPClient]requestWithPath:USER_PROFILE_INFO_URL params:postParams onCompletion:^(NSDictionary *jsonDic, NSString *errorMessage)
     {
         if (errorMessage==nil)
         {
             NSDictionary *userdict = [[jsonDic objectForKey:@"data"] objectForKey:@"profile"];
             NSLog(@"Profile Data After User Being Registered: ******************** \%@",userdict);
             
             //save to userdefaults
             [Helper LoginUser];
             [Helper setUserProfileDetail:[[DataManager sharedDataManger] getUserDetails:userdict]];
             
             //             NSString* firstLoginStatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"firstloginOrNot"];
             //
             //             NSLog(@"first Login status:%@",firstLoginStatus);
             if (self.isFirstLogin)
             {
                 FirstInviteView *firstInvitView = [[FirstInviteView alloc]initWithNibName:@"FirstInviteView" bundle:nil];
                 firstInvitView.userFirstName = firstName;
                 [self.navigationController pushViewController:firstInvitView animated:NO];
             }
             else
             {
                 [APP_DEL createTabBar];
             }
             
         }
         else
         {
             [self notifyErrorWithMessage:errorMessage];
            // [APP_DEL.session closeAndClearTokenInformation];
         }
     }];
}

- (void)notifyErrorWithMessage:(NSString*)errorMessage
{
    //    NSLog(@"error ---- %@",errorMessage);
    [self showhud];
    self.hud.labelText = errorMessage;
    [self hidehud];
}


- (NSString*)getFormattedDate:(NSString*)birthday
{
    NSArray * dobArray = [birthday componentsSeparatedByString:@"/"];
    return [NSString stringWithFormat:@"%@-%@-%@",dobArray[2],dobArray[0],dobArray[1]];
}


#pragma mark hudactions

-(void)showhud{
    
    self.hud=[Helper getHudforview:self.view];
    [self.view addSubview:self.hud];
    self.hud.labelFont = [UIFont boldSystemFontOfSize:12.0f];
    [self.hud show:YES];
}

-(void)hidehud{
    [self.hud hide:YES afterDelay:1];
}


@end
