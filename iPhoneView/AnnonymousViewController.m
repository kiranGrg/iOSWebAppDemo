//
//  AnnonymousViewController.m
//  HottieHunterDemo
//
//  Created by Kiran's Mac Mini on 10/10/14.
//  Copyright (c) 2014 Design Offshore Nepal. All rights reserved.
//

#import "AnnonymousViewController.h"
#import "Helper.h"
#import <CoreText/CoreText.h>
#import "Constants.h"
@interface AnnonymousViewController ()
- (IBAction)goBack:(id)sender;

@end

@implementation AnnonymousViewController
@synthesize firstlbl,secondLbl,thirdLbl,pointslbl,titleLabel;
@synthesize scrollview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if ([Helper isiPhone5orGreater]) {
        CGRect scrollframe = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.scrollview.frame=scrollframe;
    }
    else{
         CGRect scrollframe = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT);
         self.scrollview.frame=scrollframe;
        self.scrollview.contentSize = CGSizeMake(320,550);
    }
    self.titleLabel.font = FONT_ROBOTO_REGULAR(17.0f);
    self.titleLabel.textColor=HH_NAVIGATION_TITLE_BLACK_COLOR;
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"Your name and profile picture will not\nshow with the post.\n\nThe post will not be connected with your Facebook account.\n\nYou will be able to see the post on your profile page, but it will not be visible to others."];

    [attString addAttribute:(NSString*)kCTUnderlineStyleAttributeName
                      value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                      range:(NSRange){35,3}];
    [attString addAttribute:(NSString*)kCTUnderlineStyleAttributeName
                      value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                      range:(NSRange){74,3}];
    
    [attString addAttribute:(NSString*)kCTUnderlineStyleAttributeName
                      value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                      range:(NSRange){187,3}];
  
    self.pointslbl.attributedText = attString;

    self.firstlbl.font=FONT_ROBOTO_MEDIUM(19);
    self.thirdLbl.font=FONT_ROBOTO_MEDIUM(17);
    
    self.secondLbl.font=FONT_ROBOTO_LIGHT(17);
    self.pointslbl.font=FONT_ROBOTO_LIGHT(17);
    
    self.firstlbl.textColor=HH_BLACK_COLOR
    ;
    self.thirdLbl.textColor=HH_BLACK_COLOR;
    
    self.secondLbl.textColor=HH_BLACK_COLOR;
    self.pointslbl.textColor=[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
