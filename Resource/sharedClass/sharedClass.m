//
//  sharedClass.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/17/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "sharedClass.h"

@implementation sharedClass

static sharedClass *sharedInstance=nil;


+(sharedClass *)getInstance
{
    @synchronized(self)
    {
        if(sharedInstance==nil)
        {
            sharedInstance= [sharedClass new];
        }
    }
    return sharedInstance;
}
@end
