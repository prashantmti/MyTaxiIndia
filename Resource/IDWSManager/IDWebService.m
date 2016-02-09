//
//  IDWebService.m
//  IDVersion:1.0
//  Copyright (c) 2014 ID Developer Team
//  By Prashant
//

#import "IDWebService.h"

@implementation IDWebService

//http://192.168.1.9/ws//v1/booking/review?cities=Delhi,Agra&tripType=0&noOfCars=1&startDate=15-12-2015%2017:00&vehicleCategory=ghjk

//http://192.168.1.11/ws/v1/meta/regionsStartsWith?term=ag


//Set Base URL
//NSString *const IDBaseURL = @"http://192.168.1.17/ws/v1/";
NSString *const IDBaseURL = @"http://192.168.1.5/";


//
//set Service URL
NSString *const IDServiceURl = @"citiesJSON";

NSString *const IDSearchTaxi = @"/ws/v1/search/searchTaxiWithParams";
//Set Base URL";
@end
