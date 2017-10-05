//
//  MainViewController.h
//  HottieHunterDemo
//
//  Created by Kiran's Mac Mini on 10/9/14.
//  Copyright (c) 2014 Design Offshore Nepal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD,FBSDKLoginManager;

@interface MainViewController : UIViewController

@property (nonatomic, strong) NSString *userNameString, *emailAdd, *birthday, *userId, *gender, *profilePicId;

@property (nonatomic, strong) UIPageViewController * pageViewController;
@property (weak, nonatomic) IBOutlet UIButton *btnFBLogin;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControlUI;

@property(nonatomic, strong) MBProgressHUD *hud;

- (IBAction)fbLogInStart:(id)sender;
- (void)loginFailed;
- (void)facebookLogin;
@property (nonatomic,strong) FBSDKLoginManager *facebooklogin;

@end
