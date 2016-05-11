//
//  UserProfileView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 3/17/16.
//  Copyright © 2016 mytaxiit. All rights reserved.
//

#import "UserProfileView.h"
//
#import "NavigationView.h"

@interface UserProfileView ()

@end

@implementation UserProfileView

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //
    self.automaticallyAdjustsScrollViewInsets = NO;
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    //
    [self setUI];
    //
    [self setFlurry:@"Profile View" params:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUI{
    //
    [self setTextBoxLine:_tfUserName];
    [self setTextBoxLine:_tfUserEmail];
    [self setTextBoxLine:_tfUserMobile];
    [self setTextBoxLine:_tfUserAddress];
    //
    [self setBoxShadow:uvSec1];
    
    //
    [self setButtonShadow:_btnUP];
    [self setButtonShadow:_btnCP];
    [self setButtonShadow:_btnLT];
    //
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if (screenHeight<504){
        _TPscrollBar.contentSize=CGSizeMake(_TPscrollBar.frame.size.width,504);
    }
    if (![[UserDefault userDetails] isEqual:nil]) {
        _tfUserName.text=[self validateNullValue:[[UserDefault userDetails] valueForKey:@"name"] isString:YES];
         _tfUserEmail.text=[self validateNullValue:[[UserDefault userDetails] valueForKey:@"email"] isString:YES];
         _tfUserMobile.text=[self validateNullValue:[[UserDefault userDetails] valueForKey:@"phone"] isString:YES];
         _tfUserAddress.text=[self validateNullValue:[[UserDefault userDetails] valueForKey:@"address"] isString:YES];
    }
}

-(IBAction)userLogout:(id)sender{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout"
                                                    message:@"Are you sure you want to logout?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Logout", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0: //"No" pressed
            break;
        case 1:{ //"Yes" pressed
            
            int loginTag=[[UserDefault loginTag] intValue];
            //
            switch (loginTag) {
            case 1:{
                [self setBaseViewAfterLogout];
                break;
            }
            case 2:{
                FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
                [login logOut];
                [self setBaseViewAfterLogout];
                break;
            }
            case 3:{
                    [[GIDSignIn sharedInstance] signOut];
                    [self setBaseViewAfterLogout];
                    break;
            }
            default:
                break;
            }
        break;
        }
    }
}

// set BaseView after logout
-(void)setBaseViewAfterLogout{
    
    UIAlertController * alert=[UIAlertController
                               alertControllerWithTitle:nil
                               message:@"You have successfully logout with MyTaxiIndia."
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action){
                             //
                             [UserDefault setLoginTag:@"0"];
                             [UserDefault setUserID:@"0"];
                             [UserDefault setUserDetails:nil];
                             //
                             UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                             OutStationView *OSV = [mainStoryboard instantiateViewControllerWithIdentifier:@"OutStationView"];
                             //
                             UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:OSV];
                             NavigationView *rearViewController=[[NavigationView alloc] init];
                             rearViewController = (NavigationView*)[mainStoryboard instantiateViewControllerWithIdentifier:@"NavigationView"];
                             //
                             SWRevealViewController *mainRevealController = [[SWRevealViewController alloc]  init];
                             mainRevealController.rearViewController = rearViewController;
                             mainRevealController.frontViewController= frontNavigationController;
                             appDelegate.window.rootViewController=mainRevealController;
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


-(IBAction)btnUPAction:(id)sender{      //update profile
    if ([self validateString:_tfUserName.text]==FALSE) {
        [self alertWithText:nil message:@"Please Enter Name"];
        return;
    }
    else if ([self validateMobile:_tfUserMobile.text]==FALSE) {
        [self alertWithText:nil message:@"Please Enter Valid Phone No."];
        return;
    }
    else if ([self validateAddress:_tfUserAddress.text]==FALSE) {
        [self alertWithText:nil message:@"Address Max Limit 200"];
        return;
    }
    else{
        [self callActionService];
    }
}

-(void)callActionService{
    NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
    [postDic setObject:[UserDefault userID] forKey:@"customerId"];
    [postDic setObject:[self trimValue:_tfUserName.text] forKey:@"name"];
    [postDic setObject:[self trimValue:_tfUserEmail.text] forKey:@"email"];
    [postDic setObject:[self trimValue:_tfUserMobile.text] forKey:@"phone"];
    [postDic setObject:[self trimValue:_tfUserAddress.text] forKey:@"address"];
    //
    WebServiceClass *WSC = [[WebServiceClass alloc] init];
    [WSC getServerResponseForUrl:postDic serviceURL:IDUpdateCustomerProfile isPOST:YES isLoder:YES auth:nil view:self.view withCallback:^(BOOL success, NSDictionary *response, NSError *error){
        if (success){
            if ([[response valueForKey:@"status"] boolValue]==YES){
                [UserDefault setUserDetails:[response valueForKey:@"result"]];
                [self alertWithText:nil message:@"Thank You, Your profile has been successfully updated."];
                return;
            }else{
                [self alertWithText:nil message:[response valueForKey:@"error"]];
                return;
            }
        }else{
            [self alertWithText:nil message:error.localizedDescription];
            return;
        }
    }];
}
@end
