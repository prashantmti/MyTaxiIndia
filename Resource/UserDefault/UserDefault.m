//
//  UserDefault.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/23/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "UserDefault.h"

@implementation UserDefault


//  for user ID
+ (NSString *)userID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
}

+ (void)setUserID:(NSString *)userID
{
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)bookingID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"bookingID"];
}

+ (void)setBookingID:(NSString *)bookingID
{
    [[NSUserDefaults standardUserDefaults] setObject:bookingID forKey:@"bookingID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//  for user email
- (NSString *)userEmail
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"];
}

- (void)setUserEmail:(NSString *)userEmail
{
    [[NSUserDefaults standardUserDefaults] setObject:userEmail forKey:@"userEmail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//  for user mobile no
- (NSString *)userMobileNo
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userMobileNo"];
}

- (void)setUserMobileNo:(NSString *)userMobileNo
{
    [[NSUserDefaults standardUserDefaults] setObject:userMobileNo forKey:@"userMobileNo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//  for user addresss
- (NSString *)userAddress
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userAddress"];
}

- (void)setUserAddress:(NSString *)userAddress
{
    [[NSUserDefaults standardUserDefaults] setObject:userAddress forKey:@"userAddress"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
