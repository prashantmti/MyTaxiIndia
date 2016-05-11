//
//  MessageClass.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/29/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "MessageClass.h"

@implementation MessageClass

//sysbol
//at=>alertText

NSString *const lightOrange=@"#cc3300";
NSString *const lightGreen=@"#086e00";


NSString *const error=@"Error";

//  message for SearchTaxiView

//OurStation View
NSString *const invalidDate=@"Invalid Pick/Drop Date.";

NSString *const atDCity=@"Select Departure City";
NSString *const atACity=@"Select Arrival City";
NSString *const atValidateCity=@"Departure/Arrival city couldn't be same.";

//  text for CheckoutView
NSString *const rupee=@"\u20B9";
NSString *const merchantId=@"3";
NSString *const authPassword=@"IOS";
NSString *const sourceType=@"IOS";
NSString *const couponActionMsg=@"Coupons can be only used for \"Full Payment\" and not applicable for \"Pay Advance\". Would you like to change to \"Pay Advance\"?";

// for Live:        Mvc4Wg
// for Testing:     gtKFFx/0MQaQP

NSString *const merchantKey=@"Mvc4Wg";
//also change self.paymentParam.environment on base payment

NSString *const productInfo=@"taxipayment";

//product
NSString *const successUrl=@"http://tms.mytaxiindia.com/payment/iossuccess";
NSString *const failureUrl=@"http://tms.mytaxiindia.com/payment/iosfailure";
//test
//NSString *const successUrl=@"https://payu.herokuapp.com/ios_success";
//NSString *const failureUrl=@"https://payu.herokuapp.com/ios_failure";
@end
