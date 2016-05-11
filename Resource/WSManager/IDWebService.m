//
//  IDWebService.m
//  IDVersion:1.0
//  Copyright (c) 2014 ID Developer Team
//  By Prashant
//

#import "IDWebService.h"

@implementation IDWebService


//Set Base URL
NSString *const IDBaseURL = @"http://api.mytaxiindia.com/";
//NSString *const IDBaseURL = @"http://52.33.249.28/";

//set Service URL
NSString *const IDCityStartsWith= @"meta/cityStartsWith";
//NSString *const IDAllCities= @"meta/allCities";
NSString *const IDAllCities= @"meta/cityStartsWith";

NSString *const IDServiceURl = @"v1/citiesJSON";

NSString *const IDSearchTaxi = @"v1/search/searchTaxiWithParams";

//NSString *const IDRegionsStart= @"meta/regionsStartsWith";

//NSString *const IDRegionsStart= @"meta/cityStartsWith";

NSString *const IDCabReview = @"v1/booking/review";

NSString *const IDApplyCoupon= @"v1/booking/applyCoupon";

NSString *const IDUpdateCustomerDetails= @"v1/booking/updateCustomerDetails";

NSString *const IDconfirmBooking= @"v1/booking/confirmBooking";

NSString *const IDSaveInquiry= @"v1/user/saveInquiry";

NSString *const IDGetBooking= @"v1/user/getBookings";

NSString *const IDAdvancePayment=@"v1/booking/advancePayment";

NSString *const IDPromos=@"v1/user/promos";

NSString *const IDGetDriverLocation=@"meta/getDriverLocation";

NSString *const IDUserSignIn=@"v1/user/login";

NSString *const IDFBMtiRegister=@"v1/user/register";

NSString *const IDUpdateCustomerProfile= @"v1/user/updateCustomer";

NSString *const IDFBMtiLogin=@"v1/user/loginWithFacebook";

NSString *const IDUserCP=@"v1/user/changePassword";

NSString *const IDMtiResetPassword=@"v1/user/triggerResetPassword";

@end
