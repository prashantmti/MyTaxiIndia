//
//  UserCPView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 4/1/16.
//  Copyright © 2016 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCPView : BaseView
{
    IBOutlet TPKeyboardAvoidingScrollView * tpSignInView;
}
//
@property (weak,nonatomic) IBOutlet UIBarButtonItem *barButton;
//
@property (weak, nonatomic) IBOutlet UIView *viewSec1;

@property (strong, nonatomic) IBOutlet UITextField *tfNewPassword;
@property (strong, nonatomic) IBOutlet UITextField *tfConfirmPassword;

@property (weak, nonatomic) IBOutlet UIButton *btnChangePassword;
@end
