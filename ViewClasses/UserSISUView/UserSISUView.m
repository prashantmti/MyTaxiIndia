//
//  UserSISUView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 3/11/16.
//  Copyright © 2016 mytaxiit. All rights reserved.
//

#import "UserSISUView.h"
//
#import "NavigationView.h"

@interface UserSISUView ()

@end

@implementation UserSISUView

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //
    self.automaticallyAdjustsScrollViewInsets = NO;
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);

    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    //
    [self setUI];
}


-(void)setUI{
    //
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if (screenHeight<504){
        _TPscrollBar.contentSize=CGSizeMake(_TPscrollBar.frame.size.width,504);
    }
    //
    [self setTextBoxLine:_tfUserSignInEmail];
    [self setTextBoxLine:_tfUserSignInPassword];
    [self setTextBoxLine:_tfUserSignUpName];
    [self setTextBoxLine:_tfUserSignUpEmail];
    //
    [self setBoxShadow:_viewSignIn];
    [self setBoxShadow:_viewSignUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//----------------------------------------User SignIn/SignUp Action---------------------------------//

-(IBAction)userSignInBtnAction:(UIButton*)sender{
    
    switch (sender.tag) {
        case 1:{
            if ([self trimValue:_tfUserSignInEmail.text].length==0 || [self trimValue:_tfUserSignInPassword.text].length==0) {
                [self alertWithText:nil message:@"Please, Enter valid Email or Password"];
                return;
            }else{
                [self mtiSignIn:_tfUserSignInEmail.text password:_tfUserSignInPassword.text signInTag:YES];
            }
            break;
        }
        case 2:{
            [self FBLoginWithSDK];
            break;
        }
        case 3:{
            //GS
            [[GIDSignIn sharedInstance] signIn];
            break;
        }
        default:{
            break;
        }
    }
}

// Login with MTI
-(void)mtiSignIn:(NSString*)email password:(NSString*)password signInTag:(BOOL)signInTag{
        //
        WebServiceClass *WSC = [[WebServiceClass alloc] init];
        //
        NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
        [postDic setObject:email forKey:@"email"];
        [postDic setObject:password forKey:@"password"];
        
        [WSC getServerResponseForUrl:postDic serviceURL:IDUserSignIn isPOST:YES isLoder:signInTag auth:nil view:self.view withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
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
                    //
                    NSString *customerId=[[response valueForKey:@"result"] valueForKey:@"customerId"];
                    NSDictionary * userDetails=[response valueForKey:@"result"];
                    //
                    if (signInTag){
                        [self setBaseViewAfterLogin:customerId userDetails:userDetails loginTag:@"1"];
                    }else{
                        [self setBaseViewAfterLogin:customerId userDetails:userDetails loginTag:@"3"];
                    }
                }
            }else{
                [self alertWithText:@"Error!" message:error.localizedDescription];
                return ;
            }
        }];
}

//-------------------------------------Facebook Login-------------------------------//
-(void)FBLoginWithSDK{
    //
    NSArray *permissionsArray = @[@"email"];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: permissionsArray
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"FB Process error");
         } else if (result.isCancelled) {
             NSLog(@"FB Cancelled");
         } else {
             NSLog(@"result===>%@",result);
             NSLog(@"Logged in");
             if(result.token){
                 [IDLoader setOnView:self.view withTitle:nil animated:YES];
                 [self getFBProfile];
             }
         }
     }];
}

-(void)getFBProfile{
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}];
    //
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            [self FBMtiRegister:userData];
        }
    }];
    [connection start];
}

// New FB user register with MTI
-(void)FBMtiRegister:(NSDictionary*)FBUserInfo{
    WebServiceClass *WSC = [[WebServiceClass alloc] init];
    //
    NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
    [postDic setObject:[FBUserInfo valueForKey:@"id"] forKey:@"facebookId"];
    [postDic setObject:[FBUserInfo valueForKey:@"name"] forKey:@"name"];
    [postDic setObject:[FBUserInfo valueForKey:@"email"] forKey:@"email"];
    
    [WSC getServerResponseForUrl:postDic serviceURL:IDFBMtiRegister isPOST:YES isLoder:NO auth:nil view:self.view withCallback:^(BOOL success, NSDictionary *response, NSError *error){
        //
        if (success){
            NSLog(@"response===>%@",response);
            if ([[response valueForKey:@"status"] intValue]==0){
                if ([[response valueForKey:@"error"] isEqual:[NSNull null]]){
                    [IDLoader hideFromView:self.view animated:YES];
                    [self alertWithText:nil message:@"Null Response!"];
                    return;
                }else{
                    // existing FB user update in MTI
                    [self FBMtiUpdate:postDic customerId:[[response valueForKey:@"result"] valueForKey:@"customerId"]];
                    return;
                }
            }else{
                //--------------------------------------------------------//
                NSLog(@"user mtiFBMtiSignIn");
                [self FBMtiSignIn:[[response valueForKey:@"result"] valueForKey:@"facebookId"]];
            }
        }else{
            [self alertWithText:@"Error!" message:error.localizedDescription];
            return;
        }
    }];
}

// existing FB user update with MTI
-(void)FBMtiUpdate:(NSDictionary*)FBResponse customerId:(NSString*)customerId{
    
    NSLog(@"FBResponse===>%@",FBResponse);
    NSLog(@"customerId===>%@",customerId);
    //
    WebServiceClass *WSC = [[WebServiceClass alloc] init];
    //
    NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
    [postDic setObject:customerId forKey:@"customerId"];
    [postDic setObject:[FBResponse valueForKey:@"facebookId"] forKey:@"facebookId"];
    [postDic setObject:[FBResponse valueForKey:@"name"] forKey:@"name"];
    [postDic setObject:[FBResponse valueForKey:@"email"] forKey:@"email"];
    //
    [WSC getServerResponseForUrl:postDic serviceURL:IDUpdateCustomerProfile isPOST:YES isLoder:NO auth:nil view:self.view withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        //
        if (success){
            //
             NSLog(@"response===>%@",response);
            if ([[response valueForKey:@"status"] intValue]==0){
                if ([[response valueForKey:@"error"] isEqual:[NSNull null]]){
                    [self alertWithText:nil message:@"Null Response!"];
                    return;
                }else{
                    [self alertWithText:nil message:[response valueForKey:@"error"]];
                    return;
                }
            }else{
                NSLog(@"user mtiFBMtiSignIn");
                [self FBMtiSignIn:[[response valueForKey:@"result"] valueForKey:@"facebookId"]];
            }
        }else{
            [self alertWithText:@"Error!" message:error.localizedDescription];
            return;
        }
    }];
}

 //existing FB user login
-(void)FBMtiSignIn:(NSString*)FBId{
    
    WebServiceClass *WSC = [[WebServiceClass alloc] init];
    //
    NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
    [postDic setObject:FBId forKey:@"facebookId"];
    //
    [WSC getServerResponseForUrl:postDic serviceURL:IDFBMtiLogin isPOST:YES isLoder:NO auth:nil view:self.view withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        //
        [IDLoader hideFromView:self.view animated:YES];
        //
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
                NSLog(@"Login sucess with FBMtiSignIn");
                NSString *customerId=[[response valueForKey:@"result"] valueForKey:@"customerId"];
                NSDictionary * userDetails=[response valueForKey:@"result"];
                //
                [self setBaseViewAfterLogin:customerId userDetails:userDetails loginTag:@"2"];
            }
        }else{
            [self alertWithText:@"Error!" message:error.localizedDescription];
            return;
        }
    }];
}

//----------------------------------------------Facebook Login--------------------------------------------------//

//----------------------------------------------Google Login--------------------------------------------------//
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error) {
        [IDLoader hideFromView:self.view animated:YES];
        NSLog(@"%@",[NSString stringWithFormat:@"Status: Authentication error: %@", error]);
        return;
    }else{
        [self googleMtiRegister:user.profile.name email:user.profile.email];
    }
}

-(void)googleMtiRegister:(NSString*)name email:(NSString*)email{
    WebServiceClass *WSC = [[WebServiceClass alloc] init];
    //
    NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
    [postDic setObject:name forKey:@"name"];
    [postDic setObject:email forKey:@"email"];
    
    [WSC getServerResponseForUrl:postDic serviceURL:IDFBMtiRegister isPOST:YES isLoder:NO auth:nil view:self.view withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        NSLog(@"response===>%@",response);
        //
        if (success){
            if ([[response valueForKey:@"status"] intValue]==0){
                if ([[response valueForKey:@"error"] isEqual:[NSNull null]]){
                    [self alertWithText:nil message:@"Null Response!"];
                    return;
                }else{
                    NSDictionary *result=[response valueForKey:@"result"];
                    [postDic setObject:[result valueForKey:@"passphrase"] forKey:@"passphrase"];
                    //
                    [self googleMtiUpdate:postDic customerId:[result valueForKey:@"customerId"]];
                    return;
                }
            }else{
                NSDictionary *result=[response valueForKey:@"result"];
                [self mtiSignIn:[result valueForKey:@"email"] password:[result valueForKey:@"passphrase"] signInTag:NO];
            }
        }else{
            [self alertWithText:@"Error!" message:error.localizedDescription];
            return;
        }
    }];
}

// existing FB user update with MTI
-(void)googleMtiUpdate:(NSDictionary*)googleResponse customerId:(NSString*)customerId{
    //
    WebServiceClass *WSC = [[WebServiceClass alloc] init];
    //
    NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
    [postDic setObject:customerId forKey:@"customerId"];
    [postDic setObject:[googleResponse valueForKey:@"name"] forKey:@"name"];
    [postDic setObject:[googleResponse valueForKey:@"email"] forKey:@"email"];
    //
    [WSC getServerResponseForUrl:postDic serviceURL:IDUpdateCustomerProfile isPOST:YES isLoder:NO auth:nil view:self.view withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
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
                [self mtiSignIn:[googleResponse valueForKey:@"email"] password:[googleResponse valueForKey:@"passphrase"] signInTag:NO];
            }
        }else{
            [self alertWithText:@"Error!" message:error.localizedDescription];
            return;
        }
    }];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [IDLoader setOnView:self.view withTitle:nil animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//----------------------------------------------Google Login--------------------------------------------------//




// set BaseView after login
-(void)setBaseViewAfterLogin:(NSString*)customerID userDetails:(NSDictionary*)userInfo loginTag:(NSString*)loginTag{
    
    switch ([loginTag integerValue]) {
        case 1:{
            //
            NSDictionary *flurryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"User Login", @"Title",
                                    @"MTI", @"LoginType",
                                    nil];
            [self setFlurry:@"Login View" params:flurryParams];
            //
            break;
        }
        case 2:{
            //
            NSDictionary *flurryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"User Login", @"Title",
                                          @"Facebook", @"LoginType",
                                          nil];
            [self setFlurry:@"Login View" params:flurryParams];
            break;
        }
        case 3:{
            //
            NSDictionary *flurryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"User Login", @"Title",
                                          @"Google+", @"LoginType",
                                          nil];
            [self setFlurry:@"Login View" params:flurryParams];
            break;
        }
        default:{
            break;
        }
    }
    //
    [UserDefault setLoginTag:loginTag];
    [UserDefault setUserID:customerID];
    [UserDefault setUserDetails:userInfo];
    
    //[UserDefault setUserInfo:userInfo];
    //
    UIAlertController * alert=[UIAlertController
                               alertControllerWithTitle:nil
                               message:@"You have successfully logged in with MyTaxiIndia."
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action){
                             UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                             
                             UserProfileView *UPV = [mainStoryboard instantiateViewControllerWithIdentifier:@"UserProfileView"];
                             //
                             UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:UPV];
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

-(IBAction)userSignUpBtnAction{
    if ([self trimValue:_tfUserSignUpName.text].length==0 || [self trimValue:_tfUserSignUpEmail.text].length==0) {
        [self alertWithText:nil message:@"Please, enter name or valid email"];
        return;
    }else{
        //
        WebServiceClass *WSC = [[WebServiceClass alloc] init];
        //
        NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
        [postDic setObject:[self trimValue:_tfUserSignUpName.text] forKey:@"name"];
        [postDic setObject:[self trimValue:_tfUserSignUpEmail.text] forKey:@"email"];
        
                [WSC getServerResponseForUrl:postDic serviceURL:IDFBMtiRegister isPOST:YES isLoder:YES auth:nil view:self.view withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        
                    if (success){
                        if ([[response valueForKey:@"status"] intValue]==0)
                        {
                            if ([[response valueForKey:@"error"] isEqual:[NSNull null]]){
                                [self alertWithText:nil message:@"Null Response!"];
                                return;
                            }else{
                                [self alertWithText:nil message:[response valueForKey:@"error"]];
                                return;
                            }
                        }else{
                            //
                            [self alertWithText:nil message:@"You have successfully registered with Mytaxiindia and Login Credential has been send your registered email."];
                        }
                    }else{
                        [self alertWithText:@"Error!" message:error.localizedDescription];
                        return ;
                    }
                }];
    }
}

-(IBAction)resetPassword:(UIButton*)sender{
    //
    if ([self trimValue:_tfUserSignInEmail.text].length==0) {
        [self alertWithText:nil message:@"Please, enter valid email."];
        return;
    }else{
        WebServiceClass *WSC = [[WebServiceClass alloc] init];
        //
        NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
        [postDic setObject:[self trimValue:_tfUserSignInEmail.text] forKey:@"email"];
        
        [WSC getServerResponseForUrl:postDic serviceURL:IDMtiResetPassword isPOST:YES isLoder:YES auth:nil view:self.view withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        
                    if (success){
                        if ([[response valueForKey:@"status"] intValue]==0)
                        {
                            if ([[response valueForKey:@"error"] isEqual:[NSNull null]]){
                                [self alertWithText:nil message:@"Null Response!"];
                                return;
                            }else{
                                [self alertWithText:nil message:[response valueForKey:@"error"]];
                                return;
                            }
                        }else{
                            //
                            [self alertWithText:nil message:@"Your Password has been reset successfully, Please check your email."];
                            return;
                        }
                    }else{
                        [self alertWithText:@"Error!" message:error.localizedDescription];
                        return ;
                    }
            }];
    }
}
@end
