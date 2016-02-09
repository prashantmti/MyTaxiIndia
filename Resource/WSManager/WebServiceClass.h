//
//  WebServiceClass.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/20/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IDWebService.h"
#import "IDLoader.h"
#import "TaxiLoader.h"
@interface WebServiceClass : NSObject<NSURLSessionDelegate>
{
     NSDictionary *resultDic;
}

typedef void (^ASCompletionBlock)(BOOL success, NSDictionary *response, NSError *error);

- (void)getServerResponseForUrl:(NSDictionary*)dataParams serviceURL:(NSString*)serviceURL isPOST:(BOOL)isPOST isLoder:(BOOL)isLoder auth:(NSString*)auth view:(UIView*)view withCallback:(ASCompletionBlock)callback;

@end
