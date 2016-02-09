//
//  ModalGlobal.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 12/18/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModalBaseTaxis.h"


@interface ModalGlobal : NSObject

+ (id)sharedManager;


//set classes
@property (strong, nonatomic) ModalBaseTaxis * mbt;
@end
