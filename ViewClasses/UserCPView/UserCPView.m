//
//  UserCPView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 4/1/16.
//  Copyright © 2016 mytaxiit. All rights reserved.
//

#import "UserCPView.h"

@interface UserCPView ()

@end

@implementation UserCPView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    //
    self.automaticallyAdjustsScrollViewInsets = NO;
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    //
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setUI{
    //
    [self setTextBoxLine:_tfNewPassword];
    [self setTextBoxLine:_tfConfirmPassword];
    //
    [self setBoxShadow:_viewSec1];
    //
    [self setButtonShadow:_btnChangePassword];
    
}


-(IBAction)btnChangePasswordAction:(UIButton*)sender{
    
    //
    if ([self validateString:_tfNewPassword.text]==FALSE) {
        [self alertWithText:nil message:@"Please Enter New Password"];
        return;
    }
    else if ([self validateString:_tfConfirmPassword.text]==FALSE) {
        [self alertWithText:nil message:@"Please Enter Confirm Password"];
        return;
    }
    else if (![[self trimValue:_tfNewPassword.text] isEqual:[self trimValue:_tfConfirmPassword.text]]) {
        //
        [self alertWithText:nil message:@"Password don't match, please try again."];
        return;
    }else{
        WebServiceClass *WSC = [[WebServiceClass alloc] init];
        //
        NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
        [postDic setObject:[UserDefault userID]  forKey:@"userId"];
        [postDic setObject:[[UserDefault userDetails] valueForKey:@"email"] forKey:@"email"];
        [postDic setObject:_tfConfirmPassword.text forKey:@"password"];
        //
        [WSC getServerResponseForUrl:postDic serviceURL:IDUserCP isPOST:YES isLoder:YES auth:nil view:self.view withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
            if (success){
                if ([[response valueForKey:@"status"] intValue]==0){
                    if ([[response valueForKey:@"error"] isEqual:[NSNull null]]){
                        [self alertWithText:nil message:@"Null Response!"];
                        return;
                    }else{
                        [self alertWithText:nil message:[response valueForKey:@"error"]];
                        return;
                    }
                }else{
                    [self alertWithText:nil message:@"Your password has been changed successfully."];
                }
            }else{
                [self alertWithText:@"Error!" message:error.localizedDescription];
                return ;
            }
        }];
    }
}
@end
