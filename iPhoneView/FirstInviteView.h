//
//  FirstInviteView.h
//  HottieHunterDemo
//
//  Created by Prakash Maharjan on 4/07/2014.
//  Copyright (c) 2014 Design Offshore Nepal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailListCell.h"
//#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "TwitterUserListVC.h"

@class customTextView,MBProgressHUD, InviteEmailCell;

@interface FirstInviteView : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, InviteCountDelegate>
{
    NSArray *_allContacts;
}
@property (weak, nonatomic) IBOutlet UIImageView *navTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UILabel *lblNotice;

@property (nonatomic) BOOL syncedAnyAccount;

@property (nonatomic, strong) NSMutableArray *mailListArray;
@property (nonatomic, strong) NSMutableArray *iconsArray;

//@property (nonatomic, retain) FBFriendPickerViewController *friendPickerController;
@property (nonatomic, strong) MailListCell *mailListCell;
@property (nonatomic, strong) MailListCell *tempmailListCell;
@property (nonatomic,strong) InviteEmailCell *inviteEmailCell;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet customTextView *customTextView;

- (void)getTwitterAccount;
- (void)fetchPhoneContacts;
- (void)getFacebookFriends;
- (void)signInToGoogle;

- (IBAction)doNext:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *navTitlLbl;
@property(nonatomic,strong) NSString *userFirstName;
- (IBAction)whyActionView:(id)sender;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UIView *textVCcontainer;
@property (weak, nonatomic) IBOutlet UIButton *infobtn;

@end
