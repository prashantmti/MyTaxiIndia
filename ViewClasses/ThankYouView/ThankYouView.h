//
//  ThankYouView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/9/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ThankYouView : BaseView


@property(strong,nonatomic) IBOutlet UILabel * bookingID;
@property(strong,nonatomic) IBOutlet UILabel * tripLocation;

@property(strong,nonatomic) IBOutlet UILabel * name;
@property(strong,nonatomic) IBOutlet UILabel * address;
@property(strong,nonatomic) IBOutlet UILabel * mobile;
@property(strong,nonatomic) IBOutlet UILabel * tripDate;

@property(strong,nonatomic) IBOutlet UILabel * baseFare;
@property(strong,nonatomic) IBOutlet UILabel * discount;
@property(strong,nonatomic) IBOutlet UILabel * serviceTax;
@property(strong,nonatomic) IBOutlet UILabel * totalAmount;

@property(strong, nonatomic) NSDictionary *confirmResponse;
@end
