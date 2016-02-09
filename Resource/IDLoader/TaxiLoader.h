//
//  TaxiLoader.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 1/12/16.
//  Copyright © 2016 mytaxiit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaxiLoader : NSObject


- (void)setOnView:(UIView *)view withTitle:(NSString *)title animated:(BOOL)animated;

- (BOOL)hideFromView:(UIView *)view animated:(BOOL)animated;


@end
