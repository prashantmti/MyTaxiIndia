//
//  UserDefault.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/23/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "UserDefault.h"

@implementation UserDefault

+ (void)load{
    NSLog(@"UserDefault");
}


//  for user ID
+ (NSString *)userID{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
}
+ (void)setUserID:(NSString *)userID{
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//  for login tag
+ (NSString*)loginTag{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"loginTag"];
}
+ (void)setLoginTag:(NSString *)loginTag{
    [[NSUserDefaults standardUserDefaults] setObject:loginTag forKey:@"loginTag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//  for user info
+ (NSDictionary *)userDetails{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"];
    NSDictionary *retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return retrievedDictionary;
}
//  for user info
+ (void)setUserDetails:(NSDictionary *)userDetails{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:userDetails] forKey:@"userDetails"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
