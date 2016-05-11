//
//  UserDefault.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/23/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefault : NSObject

+ (NSString *)userID;
+ (void)setUserID:(NSString *)userID;

+ (NSDictionary *)userDetails;
+ (void)setUserDetails:(NSDictionary *)userDetails;


// login tag:   0=false|1=true
+ (NSString*)loginTag;
+ (void)setLoginTag:(NSString*)loginTag;
@end
