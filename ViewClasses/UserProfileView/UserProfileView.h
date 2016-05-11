//
//  UserProfileView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 3/17/16.
//  Copyright © 2016 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OutStationView.h"
//
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
//
#import <Google/SignIn.h>
@interface UserProfileView : BaseView
{
    AppDelegate *appDelegate;
    IBOutlet UIView *uvSec1;
}
//
@property (weak,nonatomic) IBOutlet UIBarButtonItem *barButton;
//
@property(weak,nonatomic) IBOutlet UIButton *btnUP;     //update profile
@property(weak,nonatomic) IBOutlet UIButton *btnCP;     //change password
@property(weak,nonatomic) IBOutlet UIButton *btnLT;     //logout

//
@property (weak,nonatomic) IBOutlet TPKeyboardAvoidingScrollView *TPscrollBar;
//
@property(weak,nonatomic) IBOutlet UITextField *tfUserName;
@property(weak,nonatomic) IBOutlet UITextField *tfUserEmail;
@property(weak,nonatomic) IBOutlet UITextField *tfUserMobile;
@property(weak,nonatomic) IBOutlet UITextField *tfUserAddress;
@end
