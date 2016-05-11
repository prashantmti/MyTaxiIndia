//
//  IDWebService.h
//  IDVersion:1.0
//  Copyright (c) 2014 ID Developer Team
//  By Prashant
//

#import <Foundation/Foundation.h>

@interface IDWebService : NSObject

//Set Base URL
extern NSString *const IDBaseURL;

//set Service URL
extern NSString *const IDServiceURl;

extern NSString *const IDSearchTaxi;

extern NSString *const IDRegionsStart;

extern NSString *const IDCityStartsWith;

extern NSString *const IDAllCities;

extern NSString *const IDCabReview;

extern NSString *const IDApplyCoupon;

extern NSString *const IDUpdateCustomerDetails;

extern NSString *const IDconfirmBooking;

extern NSString *const IDSaveInquiry;

extern NSString *const IDGetBooking;

extern NSString *const IDAdvancePayment;

extern NSString *const IDPromos;

extern NSString *const IDGetDriverLocation;

extern NSString *const IDUserSignIn;

extern NSString *const IDFBMtiRegister;

extern NSString *const IDUpdateCustomerProfile;

extern NSString *const IDFBMtiLogin;

extern NSString *const IDUserCP;    //change password

extern NSString *const IDMtiResetPassword;
@end
