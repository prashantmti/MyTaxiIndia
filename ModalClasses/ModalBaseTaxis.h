//
//  ModalBaseTaxis.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 12/18/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModalBaseTaxis : NSObject

@property (strong, nonatomic) NSString * departureCity;
@property (strong, nonatomic) NSString * departureLocation;

@property (strong, nonatomic) NSString * arrivalCity;
@property (strong, nonatomic) NSString * arrivalLocation;

@property (strong, nonatomic) NSString * arrivalMoreCity;
@property (strong, nonatomic) NSString * arrivalMoreLocation;

@property (strong, nonatomic) NSString * departureDate;
@property (strong, nonatomic) NSString * returnDate;


//
//  oneWay  :   0;
//  round   :   1;
//  local   :   2;
@property (strong, nonatomic) NSString * tripType;
@property (strong, nonatomic) NSString * tripSelectDays;


//
@property (strong, nonatomic) NSString * locationIds;


@property (strong, nonatomic) NSString *tripActionComplete;

//
@property (strong, nonatomic) NSString * deviceToken;
@end
