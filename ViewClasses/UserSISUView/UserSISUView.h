//
//  UserSISUView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 3/11/16.
//  Copyright © 2016 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileView.h"

//
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
//
#import <Google/SignIn.h>

@interface UserSISUView : BaseView<GIDSignInDelegate,GIDSignInUIDelegate>
{
    AppDelegate *appDelegate;
}

//
@property (weak,nonatomic) IBOutlet UIBarButtonItem *barButton;

//
@property (weak,nonatomic) IBOutlet TPKeyboardAvoidingScrollView *TPscrollBar;
//
@property (weak, nonatomic) IBOutlet UIView *viewSignIn;
@property (weak, nonatomic) IBOutlet UIView *viewSignUp;

@property (weak, nonatomic) IBOutlet UIButton *btnSignInTab;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUpTab;


// user SignIn

@property (strong, nonatomic) IBOutlet UITextField *tfUserSignInEmail;
@property (strong, nonatomic) IBOutlet UITextField *tfUserSignInPassword;

// user SignUP
@property (strong, nonatomic) IBOutlet UITextField *tfUserSignUpName;
@property (strong, nonatomic) IBOutlet UITextField *tfUserSignUpEmail;


// GPlusSignIn
//@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;

@end
