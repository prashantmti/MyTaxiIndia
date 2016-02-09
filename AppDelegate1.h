//
//  AppDelegate.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/12/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/CloudMessaging.h>

//GA
#import "GAI.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,GGLInstanceIDDelegate,GCMReceiverDelegate>

@property (strong, nonatomic) UIWindow *window;


//GA
@property (strong, nonatomic) id<GAITracker> tracker;


//GCM
@property(nonatomic, readonly, strong) NSString *registrationKey;
@property(nonatomic, readonly, strong) NSString *messageKey;
@property(nonatomic, readonly, strong) NSString *gcmSenderID;
@property(nonatomic, readonly, strong) NSDictionary *registrationOptions;
@end

