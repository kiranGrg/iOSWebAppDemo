//
//  FirstInviteView.m
//  HottieHunterDemo
//
//  Created by Prakash Maharjan on 4/07/2014.
//  Copyright (c) 2014 Design Offshore Nepal. All rights reserved.
//

#import "FirstInviteView.h"

#import <AddressBook/AddressBook.h>
#import "AppDelegate.h"

#import "TwitterUserListVC.h"
#import "Constants.h"
#import "ServerURL+Constants.h"
#import "ImageConstants.h"
#import "Helper.h"
#import "MailListCell.h"
#import "MBProgressHUD.h"

#import "FetchContactController.h"

#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "CNPPopupController.h"
#import "WhyViewController.h"
#import "customTextView.h"

#import "InviteBannerCell.h"

#import <CoreText/CoreText.h>
#import "GiFHUD.h"
#import "HottieAPI.h"
#import "MBProgressHUD.h"
#import "InviteEmailCell.h"

#define TEXT_TO_FORMAT @"Hottie Hunter is way better with friends,\nas it allows you to share hotties with\neach other :) %@"
#define TEXT @"Tell me more"

@interface FirstInviteView ()<CNPPopupControllerDelegate, CustomTextViewDelegate,FBSDKAppInviteDialogDelegate>
@property (nonatomic, strong) CNPPopupController *popupController;
@property (nonatomic, strong) InviteBannerCell * inviteCell;
@end

@implementation FirstInviteView
@synthesize navTitlLbl,userFirstName,hud;

#pragma mark - UIViewController Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [GiFHUD setGifWithImageName:GIF_HUD_ANIMATION_IMAGE];
    self.navigationController.navigationBarHidden=YES;
    self.mailListArray = [[NSMutableArray alloc]initWithObjects:@"Phone Contacts",@"Gmail", @"Twitter",@"Facebook", @"My Email",nil];
    self.iconsArray = [[NSMutableArray alloc]initWithObjects:INVITE_PHONE_CONTACT_ICON,INVITE_GMAIL_ICON, INVITE_TWITTER_ICON,INVITE_FACEBOOK_ICON,INVITE_MY_EMAIL_ICON,nil];
    self.activity.hidden=YES;
    [self.activity stopAnimating];
    
    [self.btnNext setTitleColor:HH_DEFAULT_BLUE_COLOR_NORMAL forState:UIControlStateNormal];
    [self.btnNext setTitleColor:HH_DEFAULT_BLUE_COLOR_HIGHLIGHTED forState:UIControlStateHighlighted];
    self.btnNext.titleLabel.font=FONT_ROBOTO_MEDIUM(15.0f);
    [self showPopupWithStyle:CNPPopupStyleCentered];
    [self.customTextView setAttributedText:[self getAttributedTexT]];
    self.customTextView.textAlignment = NSTextAlignmentCenter;
    self.customTextView.customDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.activity.hidden=YES;
    [self.activity stopAnimating];
    self.navTitlLbl.font = FONT_ROBOTO_REGULAR(17.0f);
    self.navTitlLbl.textColor=HH_NAVIGATION_TITLE_BLACK_COLOR;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//for welcome pop up
- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle
{
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    //[UIFont fontWithName:@"Roboto-Regular" size:14]
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Welcome %@!",userFirstName] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Roboto-Medium" size:27], NSParagraphStyleAttributeName : paragraphStyle,NSForegroundColorAttributeName : HH_BLACK_COLOR}];
    NSMutableAttributedString *lineOne = [[NSMutableAttributedString alloc] initWithString:@"We hope you, and\n your friends have\na great time." attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Roboto-Light" size:24], NSParagraphStyleAttributeName : paragraphStyle}];
    
    NSMutableAttributedString *line2 = [[NSMutableAttributedString alloc] initWithString:@"There's a Hottie Hunter within us all." attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Roboto-Light" size:24], NSParagraphStyleAttributeName : paragraphStyle}];
    
    NSMutableAttributedString *line3 = [[NSMutableAttributedString alloc] initWithString:@"Happy Hunting :)\n" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Roboto-Light" size:24], NSParagraphStyleAttributeName : paragraphStyle}];
    
    
    NSNumber* underlineNumber = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    [lineOne addAttribute:NSUnderlineStyleAttributeName value:underlineNumber range:NSMakeRange(8,3)];//Underline color
    [lineOne addAttribute:NSUnderlineColorAttributeName value:UNDERLINE_COLOR range:NSMakeRange(8,3)];
    
    [lineOne addAttribute:NSUnderlineStyleAttributeName value:underlineNumber range:NSMakeRange(18,12)];//Underline color
    [lineOne addAttribute:NSUnderlineColorAttributeName value:UNDERLINE_COLOR range:NSMakeRange(18,12)];
    
    
    NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:@"Go for it!" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Roboto-Medium" size:20.0f], NSForegroundColorAttributeName : HH_BLACK_COLOR, NSParagraphStyleAttributeName : paragraphStyle}];
    
    CNPPopupButton *buttonItem = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
    [buttonItem setAttributedTitle:buttonTitle forState:UIControlStateNormal];
    buttonItem.backgroundColor = HH_DEFAULT_YELLOW_COLOR;
    buttonItem.layer.cornerRadius=5.0f;
    
    
    buttonItem.selectionHandler = ^(CNPPopupButton *button){
        [self.popupController dismissPopupControllerAnimated:YES];
        //NSLog(@"Block for button: %@", button.titleLabel.text);
    };
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = title;
    
    UILabel *lineOneLabel = [[UILabel alloc] init];
    lineOneLabel.numberOfLines = 0;
    lineOneLabel.attributedText = lineOne;
    
    UILabel *linetwoLabel = [[UILabel alloc] init];
    linetwoLabel.numberOfLines = 0;
    linetwoLabel.attributedText = line2;
    
    UILabel *linethreeLabel = [[UILabel alloc] init];
    linethreeLabel.numberOfLines = 0;
    linethreeLabel.attributedText = line3;
    
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel,lineOneLabel,linetwoLabel,linethreeLabel,buttonItem]];
    
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    self.popupController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromBottom;
    [self.popupController presentPopupControllerAnimated:NO];
}

-(NSAttributedString *) getAttributedTexT{
    NSString * to_format_str = TEXT;
    to_format_str =  [to_format_str stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    to_format_str =  [to_format_str stringByReplacingOccurrencesOfString:to_format_str withString:[NSString stringWithFormat:@"*%@*",to_format_str]];
    NSDictionary * attributes = @{
                                  @"*"  :   @{
                                          NSForegroundColorAttributeName   :   GUIDE_GREY_COLOR,
                                          NSUnderlineStyleAttributeName    :   [NSNumber numberWithInt:NSUnderlinePatternDot | NSUnderlineStyleSingle],
                                          NSFontAttributeName              :   FONT_ROBOTO_MEDIUM(16),
                                          @"wordValue"                     :   TEXT
                                          },
                                  @"Normal"                      :   @{
                                          NSForegroundColorAttributeName   :   HH_BLACK_COLOR,
                                          @"wordValue"                     :   @"Normal",
                                          NSFontAttributeName              :   FONT_ROBOTO_MEDIUM(17)
                                          }
                                  };
    NSAttributedString * attr_str = [self.customTextView getattributedTextFromText:[NSString stringWithFormat:TEXT_TO_FORMAT,to_format_str] withAttributedDictonary:attributes];
    return attr_str;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        return 70;
    }
    
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mailListArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MailListCell";
    static NSString *inviteEmailCellIdentifier = @"InviteEmailCell";
    
    [self.mailListCell setSelectionStyle:UITableViewCellSelectionStyleNone]; //for selection style none
    [self.inviteEmailCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.mailListCell = (MailListCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    self.inviteEmailCell = (InviteEmailCell *)[self.tableView dequeueReusableCellWithIdentifier:inviteEmailCellIdentifier];
    
    
    if (indexPath.row == 5)
    {
        if (self.inviteEmailCell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InviteEmailCell" owner:self options:nil];
            self.inviteEmailCell = [nib objectAtIndex:0];
            
        }
        self.inviteEmailCell.txtlbl.font = FONT_ROBOTO_LIGHT(13);
        self.inviteEmailCell.txtlbl.textColor = [UIColor colorWithRed:166.0f/255.0f green:166.0f/255.0f blue:166.0f/255.0f alpha:1.0f];
        
        self.inviteEmailCell.dotlbl.font = FONT_ROBOTO_LIGHT(17);
        self.inviteEmailCell.dotlbl.textColor = [UIColor colorWithRed:166.0f/255.0f green:166.0f/255.0f blue:166.0f/255.0f alpha:1.0f];
        self.inviteEmailCell.dotlbl.hidden = YES;
        return self.inviteEmailCell;
    }
    else{
        if (self.mailListCell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MailListCell" owner:self options:nil];
            self.mailListCell = [nib objectAtIndex:0];
            
            [self.mailListCell.searchContactsButton addTarget: self
                                                       action: @selector(searchContactButtonPressed:)
                                             forControlEvents: UIControlEventTouchUpInside];
            self.mailListCell.searchContactsButton.tag=indexPath.row;
            
        }
        self.mailListCell.domainLabel.font=FONT_ROBOTO_LIGHT(15);
        self.mailListCell.domainLabel.textColor=HH_BLACK_COLOR;
        self.mailListCell.domainLabel.text = [self.mailListArray objectAtIndex:indexPath.row];
        self.mailListCell.logoIMg.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.iconsArray objectAtIndex:indexPath.row]]];
        
        return self.mailListCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)searchContactButtonPressed:(id) sender
{
    UIButton *selectedBtn = (UIButton *)sender;
    
    self.tempmailListCell = (MailListCell *)[self getParentCell:selectedBtn];
    switch (selectedBtn.tag)
    {
        case 0:
            
            [GiFHUD showWithOverlay];
            //            [self fetchPhoneContacts];
            [self performSelectorInBackground:@selector(fetchPhoneContacts) withObject:nil];
            break;
            
        case 1:
            [self signInToGoogle];
            
            break;
            
        case 2:
            //self.activity.hidden = NO;
            //[self.activity startAnimating];
            [self getTwitterAccount];
            break;
            
        case 3:
            [self getFacebookFriends];
            break;
            
        case 4:
            [GiFHUD showWithOverlay];
            //            [self fetchPhoneContacts];
            [self performSelectorInBackground:@selector(fetchPhoneContactsEmailOnly) withObject:nil];
            break;
            
        default:
            
            break;
            
    }
}

- (UITableViewCell*)getParentCell:(UIView*)subview
{
    UITableViewCell * tableCell = nil;
    while (subview.superview != Nil) {
        if ([subview.superview isKindOfClass:[UITableViewCell class]])
        {
            tableCell = (UITableViewCell*)subview.superview;
            break;
        }
        else
        {
            subview = subview.superview;
        }
    }
    return tableCell;
}

- (void)fetchPhoneContacts
{
    
    FetchContactController * fetchController = [FetchContactController sharedFetchContactController];
    
    NSArray * sorted_phoneContactList = [fetchController fetchContactListFromDeviceWithEmailFlag:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (sorted_phoneContactList.count != 0) {
            TwitterUserListVC *twitterListVC = [[TwitterUserListVC alloc]initWithNibName:@"TwitterUserListVC" bundle:nil];
            twitterListVC.twitterUserList = [NSMutableArray arrayWithArray:sorted_phoneContactList];
            twitterListVC.isPhone = YES;
            twitterListVC.isInvite = YES;
            twitterListVC.normalInviteDelegate = self;
            twitterListVC.navTitle = @"Invite Friends";
            twitterListVC.sms_text_message = INVITE_VIA_SMS_TEXT;
            [self presentViewController:twitterListVC animated:YES completion:nil];
            
            [GiFHUD dismiss];
        }
        else{
            [GiFHUD dismiss];
            //[self notifyErrorWithMessage:@"No contacts on device."];
        }
    });
    
}

- (void)fetchPhoneContactsEmailOnly
{
    //    [GiFHUD showWithOverlay];
    FetchContactController * fetchController = [FetchContactController sharedFetchContactController];
    
    
    NSArray * sorted_phoneContactList = [fetchController filterContactWithEmailOnly:[fetchController fetchContactListFromDeviceWithEmailFlag:YES]];
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (sorted_phoneContactList.count != 0) {
            [GiFHUD dismiss];
            TwitterUserListVC *twitterListVC = [[TwitterUserListVC alloc]initWithNibName:@"TwitterUserListVC" bundle:nil];
            twitterListVC.twitterUserList = [NSMutableArray arrayWithArray:sorted_phoneContactList];
            twitterListVC.isPhone = YES;
            twitterListVC.isInvite = YES;
            twitterListVC.navTitle = @"Invite Friends";
            twitterListVC.normalInviteDelegate = self;
            twitterListVC.sms_text_message = INVITE_VIA_SMS_TEXT;
            [self presentViewController:twitterListVC animated:YES completion:nil];
            
            
        }
        else{
            [GiFHUD dismiss];
            [self notifyErrorWithMessage:@"No contacts on device."];
        }
    });
    
}

- (void)getTwitterAccount
{
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             self.activity.hidden=YES;
             [self.activity stopAnimating];
             NSArray *accounts = [accountStore accountsWithAccountType:accountType];
             // Check if the users has setup at least one Twitter account
             if (accounts.count > 0)
             {
                 
                 ACAccount *twitterAccount = [accounts objectAtIndex:0];
                 TwitterUserListVC *twitterListVC = [[TwitterUserListVC alloc]initWithNibName:@"TwitterUserListVCOther" bundle:nil];
                 twitterListVC.isTwitter = YES;
                 twitterListVC.navTitle = @"Invite Friends";
                 twitterListVC.twitterAccount = twitterAccount;
                 twitterListVC.normalInviteDelegate = self;
                 twitterListVC.isInvite = YES;
                 self.activity.hidden = YES;
                 [self.activity stopAnimating];
                 [self presentViewController:twitterListVC animated:YES completion:nil];
                 
                 //                for(ACAccount *t in accounts)
                 //                {
                 //                    if([t.username isEqualToString:username])
                 //                    {
                 //                        twitterAccount = t;
                 //                        break;
                 //                    }
                 //                }
             }
             else
             {
                 self.activity.hidden=YES;
                 [self.activity stopAnimating];
                 UIAlertView *accountSetupAlert = [[UIAlertView alloc]initWithTitle:@"No Twitter Accounts" message:@"There are no Twitter accounts configured. You can add or create a Twitter account in Setting" delegate:self cancelButtonTitle:@"Settings" otherButtonTitles:@"Cancel", nil];
                 accountSetupAlert.tag=10;
                 [accountSetupAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
             }
         }
         else
         {
             self.activity.hidden = YES;
             [self.activity stopAnimating];
             UIAlertView *accountSetupAlert = [[UIAlertView alloc]initWithTitle:@"No Permission!" message:@"To give permission, go to Setting then Twitter and turn on for Hottie Hunter " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [accountSetupAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
         }
     }];
    
}
-(void)getFacebookFriends
{
 /*
    if ([Helper checkConnection]==YES) {
        
        [Helper facebookSessionCheck];
        AppDelegate *delegate=  (AppDelegate*)[[UIApplication sharedApplication]delegate];
        NSLog(@"appdel session:%@",delegate.session);
        
        [FBWebDialogs
         presentRequestsDialogModallyWithSession:delegate.session
         message:@"I just started using HottieHunter."
         title:@"Hottie Hunter"
         parameters:nil
         handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
             if (error) {
                 // Error launching the dialog or sending the request.
                 NSLog(@"Error sending request.");
             } else {
                 if (result == FBWebDialogResultDialogNotCompleted) {
                     // User clicked the "x" icon
                     NSLog(@"User canceled request.");
                 } else {
                     // Handle the send request callback
                     NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                     
                     if (urlParams == nil || ![urlParams objectForKey:@"request"]) {
                         // User clicked the Cancel button
                         NSLog(@"No invitation selected.");
                     } else {
                         // User clicked the Send button
                         [self.tempmailListCell.searchContactsButton setImage:[UIImage imageNamed:@"ic_shown_btn.png"] forState:UIControlStateNormal];
                         NSArray * invitation_id = [((NSDictionary *)[urlParams objectForKey:@"invites_id"]) allValues];
                         NSLog(@"invitation ids : %@",[invitation_id componentsJoinedByString:@","]);
                         [self sendInviteCountwithCategory:@"facebook" withPeople:[invitation_id componentsJoinedByString:@","]];
                         
                         //other action to register on server for count goes below here
                     }
                 }
             }
         }];
    }
    
    else{
        [APP_DEL showNoConnectionwithDisplayMessage:NO_INTERNET_CONNECTION_MESSAGE
         
         ];
    }
  */
    
    
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    //content.appLinkURL = [NSURL URLWithString:@"https://www.mydomain.com/myapplink"];
    
    content.appLinkURL = [NSURL URLWithString:FACEBOOK_INVITE_URL];
    //    //optionally set previewImageURL
    // content.appInvitePreviewImageURL = [NSURL URLWithString:@"https://www.mydomain.com/my_invite_image.jpg"];
    
    content.appInvitePreviewImageURL = [NSURL URLWithString:DEFAULT_HH_LOGO_SHARE_URL];
    
    // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate`
    //[FBSDKAppInviteDialog showWithContent:content
    //delegate:self];
    
    
    [FBSDKAppInviteDialog showFromViewController:self withContent:content delegate:self];
}

/*!
 @abstract Sent to the delegate when the app invite completes without error.
 @param appInviteDialog The FBSDKAppInviteDialog that completed.
 @param results The results from the dialog.  This may be nil or empty.
 */
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results{
    NSLog(@"result ----- :%@",results);
}

/*!
 @abstract Sent to the delegate when the app invite encounters an error.
 @param appInviteDialog The FBSDKAppInviteDialog that completed.
 @param error The error.
 */
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error{
    NSLog(@"Error: %@",error.localizedDescription);
}

- (void)sendInviteCountwithCategory:(NSString*)category withPeople:(NSString*)people
{
    if ([Helper checkConnection]==YES)
    {
        HHUserDetails *user = [Helper getUserProfileDetail];
        NSDictionary *postParams = @{@"receiptent"              :people,
                                     @"device_token"    : [Helper GetUNIQUEID],
                                     @"user_id"         : user.userid,
                                     @"category"        : category
                                     };
        
        [[HottieAPI sharedHottieHTTPClient]requestWithPath:INVITE_VIA_EMAIL_URL params:postParams onCompletion:^(NSDictionary *jsonDic, NSString *errorMessage)
         {
             if (errorMessage==nil)
             {
                 
                 [self inviteCountDelegate:[[jsonDic objectForKey:@"count"]intValue] withinviteInfo:[jsonDic objectForKey:@"reward_view"]];
                 
             }
             else
             {
                 //[self notifyErrorWithMessage:errorMessage];
             }
         }];
    }
    else{
        [APP_DEL showNoConnectionwithDisplayMessage:NO_INTERNET_CONNECTION_MESSAGE
         
         ];
    }
}

#pragma mark GoogleAuth Methods

- (GTMOAuth2Authentication * )authForGoogle
{
    //This URL is defined by the individual 3rd party APIs, be sure to read their documentation
    
    NSURL * tokenURL = [NSURL URLWithString:GoogleTokenURL];
    // We'll make up an arbitrary redirectURI.  The controller will watch for
    // the server to redirect the web view to this URI, but this URI will not be
    // loaded, so it need not be for any actual web page. This needs to match the URI set as the
    // redirect URI when configuring the app with Instagram.
    NSString * redirectURI = @"urn:ietf:wg:oauth:2.0:oob";
    GTMOAuth2Authentication * auth;
    
    auth = [GTMOAuth2Authentication authenticationWithServiceProvider:@"lifebeat" tokenURL:tokenURL redirectURI:redirectURI clientID:GoogleClientID clientSecret:GoogleClientSecret];
    auth.scope = @"https://www.google.com/m8/feeds/";
    return auth;
}

- (void)signInToGoogle
{
    GTMOAuth2Authentication * auth = [self authForGoogle];
    
    // Display the authentication view
    GTMOAuth2ViewControllerTouch *viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:auth authorizationURL:[NSURL URLWithString:GoogleAuthURL]                       keychainItemName:@"GoogleKeychainName" delegate:self finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    viewController.hidesBottomBarWhenPushed=YES;
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - IBAction Methods

- (IBAction)doNext:(id)sender
{
    
    if ([Helper getNextTappedInfo])
    {
        AppDelegate * del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [del createTabBar ];
        
    }
    
    else{
        [Helper savenexttappedInfo];
        if (self.syncedAnyAccount)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Find Your Friends" message:@"Did you know you can use multiple accounts to find all your friends?" delegate:self cancelButtonTitle:@"Great!" otherButtonTitles:@"Later", nil];
            alert.tag=1;
            [alert show];
            
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Find Your Friends" message:@"Your Friends might already use Hottie Hunter, find and connect with them." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Later", nil];
            alert.tag=0;
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((buttonIndex == 1) && (alertView.tag == 0))
    {
        AppDelegate * del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [del createTabBar ];
    }
    
    if ((buttonIndex == 1) && (alertView.tag == 1))
    {
        AppDelegate * del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [del createTabBar ];
    }
    
    if ((buttonIndex == 0) && (alertView.tag == 10))
    {
        if ([Helper isVersionEqualorGreaterThan8]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
        
    }
    
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController finishedWithAuth:(GTMOAuth2Authentication * )auth error:(NSError * )error
{
    NSLog(@"auth access token: %@", auth);
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    __block NSMutableArray *gmailList = [[NSMutableArray alloc]init];
    NSURL *url = [NSURL URLWithString:@"https://www.google.com/m8/feeds/contacts/default/full?alt=json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [auth authorizeRequest:request completionHandler:^(NSError *error) {
        if (error)
        {
            NSLog(@"GTMOAuth2Authentication:%@",[error description]);
        }
        else
        {
            NSURLResponse *response = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            if (data)
            {
                FetchContactController * fetchcontroller = [FetchContactController sharedFetchContactController];
                
                gmailList = [fetchcontroller parseGmailList:data];
                
                TwitterUserListVC *twitterListVC = [[TwitterUserListVC alloc]initWithNibName:@"TwitterUserListVC" bundle:nil];
                twitterListVC.normalInviteDelegate = self;
                twitterListVC.twitterUserList = gmailList;
                twitterListVC.isGmail = YES;
                twitterListVC.isInvite = YES;
                twitterListVC.navTitle = @"Invite Friends";
                [self presentViewController:twitterListVC animated:YES completion:nil];
            }
            else
            {
                // fetch failed
                NSLog(@"GTMOAuth2Authentication Fetch Failed:%@",[error description]);
            }
        }
    }];
}

- (void)makeRequestForUserData
{
    /*
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (!error)
         {
             // Success! Include your code to handle the results here
             NSLog(@"user info: %@", result);
         }
         else
         {
             // An error occurred, we need to handle the error
             // See: https://developers.facebook.com/docs/ios/errors
         }
     }];
     */
}

- (NSDictionary*)parseURLParams:(NSString *)query
{
    NSLog(@"query is : %@",query);
    
    if (!query) {
        return nil;
    }
    else{
        NSArray *pairs = [query componentsSeparatedByString:@"&"];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *toParams = [[NSMutableDictionary alloc] init];
        for (NSString *pair in pairs) {
            
            NSArray *kv = [pair componentsSeparatedByString:@"="];
            NSString *val = [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            if (![[kv[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] isEqualToString:@"request"]) {
                toParams[[kv[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] = val;
            }
            else{
                params[[kv[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] = val;
            }
        }
        params[@"invites_id"] = toParams;
        
        NSLog(@"Invite Request Parameter%@",params);
        
        return params;
    }
}


- (IBAction)whyActionView:(id)sender {
    [self pushToWhyViewController];
}

-(void) pushToWhyViewController{
    WhyViewController * whyView = [[WhyViewController alloc] initWithNibName:@"WhyViewController" bundle:nil];
    whyView.isFromFirstIviteView = YES;
    whyView.buttonTxt=@"Tap to go back";
    [self.navigationController pushViewController:whyView animated:YES];
}

#pragma mark CustomTextviewDelegate
-(void) clickedFreeTag:(NSString *)tagName{
    if ([tagName isEqualToString:TEXT]) {
        [self pushToWhyViewController];
    }
}

#pragma mark InviteCountDelegate methods
-(void) inviteCountDelegate:(int)inviteCount withinviteInfo:(NSString *)info{
    
    NSLog(@"First Invite Count is : %d",inviteCount);
    self.syncedAnyAccount = YES;
    [self.tempmailListCell.searchContactsButton setImage:[UIImage imageNamed:@"ic_shown_btn.png"] forState:UIControlStateNormal];
    
    [self notifyErrorWithMessage:@"Invitation Sent"];
    
}


- (void)secondViewControllerDismissed
{
    [self.activity stopAnimating];
    self.activity.hidden = YES;
}
- (void)notifyErrorWithMessage:(NSString*)errorMessage
{
    NSLog(@"error ---- %@",errorMessage);
    [self showhud];
    self.hud.labelText = errorMessage;
    [self hidehud];
}
#pragma mark MBProgressHUD Methods

- (void)showhud
{
    self.hud = [Helper getHudforview:self.view];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
}

- (void)hidehud
{
    [self.hud hide:YES afterDelay:2];
}

@end
