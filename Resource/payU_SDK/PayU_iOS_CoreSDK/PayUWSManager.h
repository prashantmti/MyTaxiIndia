//
//  WSManager.h
//  PayU_iOS_SDK_TestApp
//
//  Created by Sharad Goyal on 15/10/15.
//  Copyright (c) 2015 PayU, India. All rights reserved.
//

/*
 This class is used to handle WebServices
 */

#import <Foundation/Foundation.h>

#define ATTRIBUTE_ALLOC __attribute__((unavailable("alloc not available, call sharedSingletonInstance instead")))
#define ATTRIBUTE_INTI __attribute__((unavailable("init not available, call sharedSingletonInstance instead")))
#define ATTRIBUTE_NEW __attribute__((unavailable("new not available, call sharedSingletonInstance instead")))
#define ATTRIBUTE_COPY __attribute__((unavailable("copy not available, call sharedSingletonInstance instead")))

@interface PayUWSManager : NSObject

+(instancetype)getSingletonInstance;

@property (copy) void (^myBlockVar) (BOOL success, NSDictionary *response, NSError *error);

+(instancetype) alloc ATTRIBUTE_ALLOC;
-(instancetype) init  ATTRIBUTE_INTI;
+(instancetype) new   ATTRIBUTE_NEW;
+(instancetype) copy  ATTRIBUTE_INTI;

- (void) postOperation:(NSString *)pURL parameter:(NSString *)bodyPost andCompletion:(void (^)(BOOL success, NSDictionary *response, NSError *error))block;

@end
