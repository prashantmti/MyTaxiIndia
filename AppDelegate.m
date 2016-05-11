//
//  AppDelegate.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/12/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "AppDelegate.h"
//
#import "SWRevealViewController.h"

//
#import "CouponListingView.h"

//
#import "ModalGlobal.h"

//
#import "NavigationView.h"

//
#import <FBSDKCoreKit/FBSDKCoreKit.h>

//
#import "UserDefault.h"

//GS
#import <Google/SignIn.h>

//Flurry
#import <Flurry.h>

@import GoogleMaps;

@interface AppDelegate ()
{
    ModalGlobal *mg;
}
//GCM
@property(nonatomic, strong) void (^registrationHandler)(NSString *registrationToken, NSError *error);
@property(nonatomic, assign) BOOL connectedToGCM;
@property(nonatomic, strong) NSString* registrationToken;
@property(nonatomic, assign) BOOL subscribedToTopic;
//GCM

@end

//
NSString *const SubscriptionTopic = @"/topics/global";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    //
    mg=[ModalGlobal sharedManager];
    //-- Set Notification
    
//    if(IS_OS_8_OR_LATER)
//    {
//        UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
//        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
//    }
//    
    //-- Set Notification
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    //GCM
    [self initGCM:application];
    
    //FB
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

    //GMS
    [GMSServices provideAPIKey:@"AIzaSyBylG_bu-wkTE7E4fZZRg5hKDIWmQ7vdQQ"];
    
    //For GA
    [GIDSignIn sharedInstance].clientID = @"176773253945-icvpnuncobd6lk5vjg6jg56ooi5epmig.apps.googleusercontent.com";
    
    //for Flurry
    [Flurry startSession:@"7STMT29MHTBSDPYXTX6R"];
    
    //
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //GCM
    //[[GCMService sharedInstance] disconnect];
    // [START_EXCLUDE]
    //_connectedToGCM = NO;
    // [END_EXCLUDE]
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {    
    //GCM
    // Connect to the GCM server to receive non-APNS notifications
    [[GCMService sharedInstance] connectWithHandler:^(NSError *error) {
        if (error) {
            NSLog(@"Could not connect to GCM: %@", error.localizedDescription);
        } else {
            _connectedToGCM = true;
            NSLog(@"Connected to GCM");
            // [START_EXCLUDE]
            [self subscribeToTopic];
            // [END_EXCLUDE]
        }
    }];
    
    //FB
    [FBSDKAppEvents activateApp];
}

//GCM
-(void)initGCM:(UIApplication *)application
{
    //GCM
    //
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    // [START_EXCLUDE]
    _registrationKey = @"onRegistrationCompleted";
    _messageKey = @"onMessageReceived";
    // Configure the Google context: parses the GoogleService-Info.plist, and initializes
    // the services that have entries in the file
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    _gcmSenderID = [[[GGLContext sharedInstance] configuration] gcmSenderID];
    NSLog(@"_gcmSenderID===>%@",_gcmSenderID);
    

    // [END register_for_remote_notifications]
    
    //
    // [START start_gcm_service]
    GCMConfig *gcmConfig = [GCMConfig defaultConfig];
    gcmConfig.receiverDelegate = self;
    [[GCMService sharedInstance] startWithConfig:gcmConfig];
    // [END start_gcm_service]
    
    __weak typeof(self) weakSelf = self;
    // Handler for registration token request
    _registrationHandler = ^(NSString *registrationToken, NSError *error){
        if (registrationToken != nil) {
            weakSelf.registrationToken = registrationToken;
            NSLog(@"Registration Token: %@", registrationToken);
            //
            mg.mbt.deviceToken=registrationToken;
            NSLog(@"deviceToken==%@",mg.mbt.deviceToken);
            
            [weakSelf subscribeToTopic];
        } else {
            NSLog(@"Registration to GCM failed with error: %@", error.localizedDescription);
        }
    };
}

- (void)subscribeToTopic {
    // If the app has a registration token and is connected to GCM, proceed to subscribe to the
    // topic
    if (_registrationToken && _connectedToGCM) {
        [[GCMPubSub sharedInstance] subscribeWithToken:_registrationToken
                                                 topic:SubscriptionTopic
                                               options:nil
                                               handler:^(NSError *error) {
                                                   if (error) {
                                                       // Treat the "already subscribed" error more gently
                                                       if (error.code == 3001) {
                                                           NSLog(@"Already subscribed to %@",
                                                                 SubscriptionTopic);
                                                       } else {
                                                           NSLog(@"Subscription failed: %@",
                                                                 error.localizedDescription);
                                                       }
                                                   } else {
                                                       self.subscribedToTopic = true;
                                                       NSLog(@"Subscribed to %@", SubscriptionTopic);
                                                   }
                                               }];
    }
}


- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:(UIUserNotificationSettings *)settings
{
    NSLog(@"Registering device for push notifications..."); // iOS 8
    [application registerForRemoteNotifications];
}


// [START receive_apns_token]
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // [END receive_apns_token]
    // [START get_gcm_reg_token]
    // Create a config and set a delegate that implements the GGLInstaceIDDelegate protocol.
    GGLInstanceIDConfig *instanceIDConfig = [GGLInstanceIDConfig defaultConfig];
    instanceIDConfig.delegate = self;
    
    //
    instanceIDConfig.logLevel = kGCMLogLevelError;
    //
    // Start the GGLInstanceID shared instance with the that config and request a registration
    // token to enable reception of notifications
    [[GGLInstanceID sharedInstance] startWithConfig:instanceIDConfig];
    _registrationOptions = @{kGGLInstanceIDRegisterAPNSOption:deviceToken,
                             kGGLInstanceIDAPNSServerTypeSandboxOption:@YES};
    [[GGLInstanceID sharedInstance] tokenWithAuthorizedEntity:_gcmSenderID
                                                        scope:kGGLInstanceIDScopeGCM
                                                      options:_registrationOptions
                                                      handler:_registrationHandler];
    // [END get_gcm_reg_token]
}

// [START receive_apns_token_error]
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Registration for remote notification failed with error: %@", error.localizedDescription);
    // [END receive_apns_token_error]
}

// [START ack_message_reception]
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler {
    NSLog(@"background one Notification received: %@", userInfo);
    //
    // This works only if the app started the GCM service
    [[GCMService sharedInstance] appDidReceiveMessage:userInfo];
    // Handle the received message
    handler(UIBackgroundFetchResultNoData);
    // [END_EXCLUDE]
    
    if([application applicationState] == UIApplicationStateActive){
        //
        [self playLocalNotification:application userInfo:userInfo];
    }else if ([application applicationState] == UIApplicationStateBackground){
        //
        return;
    }else if ([application applicationState] == UIApplicationStateInactive){
        //
        [self setAction];
    }else{
        //
        return;
    }
    
}
// [START on_token_refresh]
- (void)onTokenRefresh {

    //
    // A rotation of the registration tokens is happening, so the app needs to request a new token.
    NSLog(@"The GCM registration token needs to be changed.");
    [[GGLInstanceID sharedInstance] tokenWithAuthorizedEntity:_gcmSenderID
                                                        scope:kGGLInstanceIDScopeGCM
                                                      options:_registrationOptions
                                                      handler:_registrationHandler];
}
// [END on_token_refresh]

// [START upstream_callbacks]
- (void)willSendDataMessageWithID:(NSString *)messageID error:(NSError *)error {
    if (error) {
        // Failed to send the message.
    } else {
        // Will send message, you can save the messageID to track the message
    }
}

- (void)didSendDataMessageWithID:(NSString *)messageID {
    // Did successfully send message identified by messageID
}
// [END upstream_callbacks]

- (void)didDeleteMessagesOnServer {
    // Some messages sent to this device were deleted on the GCM server before reception, likely
    // because the TTL expired. The client should notify the app server of this, so that the app
    // server can resend those messages.
}

-(void)setAction
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CouponListingView *clv = [mainStoryboard instantiateViewControllerWithIdentifier:@"CouponListingView"];
    //
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:clv];
    NavigationView *rearViewController = (NavigationView*)[mainStoryboard instantiateViewControllerWithIdentifier: @"NavigationView"];
    //
    SWRevealViewController *mainRevealController = [[SWRevealViewController alloc]  init];
    mainRevealController.rearViewController = rearViewController;
    mainRevealController.frontViewController= frontNavigationController;
    self.window.rootViewController = mainRevealController;
}

-(void)playLocalNotification:(UIApplication*)application userInfo:(NSDictionary*)userInfo{
    NSString *alert=[[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"body"];
    //
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"MyTaxiIndia" message:alert delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Show", nil] ;
    [alertView show];

}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1) {
        [self setAction];
    }
}

//FB
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //
    //return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
    if ([[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation]) {
        return YES;
    }else if([[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation]){
        return YES;
    }else{
        return NO;
    }
}

//GS
//- (BOOL)application:(UIApplication *)app
//            openURL:(NSURL *)url
//            options:(NSDictionary *)options {
//    return [[GIDSignIn sharedInstance] handleURL:url
//                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
//}
//
//- (void)signIn:(GIDSignIn *)signIn
//didSignInForUser:(GIDGoogleUser *)user
//     withError:(NSError *)error {
//    
//    
//     NSLog(@"sign call in app delegate==============>");
//    // Perform any operations on signed in user here.
//    NSString *userId = user.userID;                  // For client-side use only!
//    NSString *idToken = user.authentication.idToken; // Safe to send to the server
//    NSString *fullName = user.profile.name;
//    NSString *givenName = user.profile.givenName;
//    NSString *familyName = user.profile.familyName;
//    NSString *email = user.profile.email;
//    
//    //
//    NSLog(@"userId===>%@",userId);
//    NSLog(@"idToken===>%@",idToken);
//    NSLog(@"fullName===>%@",fullName);
//    NSLog(@"givenName===>%@",givenName);
//    NSLog(@"familyName===>%@",familyName);
//    NSLog(@"email===>%@",email);
//    // ...
//    // ...
//}
@end