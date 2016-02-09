//
//  WebServiceClass.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/20/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IDWebService.h"

@interface WebServiceClass : NSObject<NSURLSessionDelegate>
{
     NSDictionary *resultDic;
}



typedef void (^ASCompletionBlock)(BOOL success, NSDictionary *response, NSError *error);

- (void)getServerResponseForUrl:(NSDictionary*)dataParams serviceURL:(NSString*)serviceURL isPOST:(BOOL)isPOST withCallback:(ASCompletionBlock)callback;



//-(void)setServiceClass:(NSString*)baseUrl serviceUrl:(NSString*)serviceUrl dataDic:(NSDictionary*)dataDic isPOST:(BOOL)isPOST;

//-(NSDictionary*)setServiceClass:(NSString*)baseUrl serviceUrl:(NSString*)serviceUrl dataDic:(NSDictionary*)dataDic isPOST:(BOOL)isPOST;

@end
