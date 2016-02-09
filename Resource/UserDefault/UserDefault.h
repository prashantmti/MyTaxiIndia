//
//  UserDefault.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/23/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefault : NSObject


@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userMobileNo;
@property (nonatomic, strong) NSString *userAddress;


+ (NSString *)userID;
+ (void)setUserID:(NSString *)userID;

+ (NSString *)bookingID;
+ (void)setBookingID:(NSString *)bookingID;
@end
