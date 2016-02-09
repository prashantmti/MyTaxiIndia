//
//  ModalGlobal.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 12/18/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "ModalGlobal.h"

@implementation ModalGlobal


+ (id)sharedManager {
    static ModalGlobal *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.mbt=[ModalBaseTaxis new];
    }
    return self;
}

@end
