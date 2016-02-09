//
//  IDLoader.h
//  serviceDemo
//
//  Created by prashant sahu on 02/11/15.
//  Copyright © 2015 prashant kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

#import "GMDCircleLoader.h"

@interface IDLoader : UIView
{
   // GMDCircleLoader *GCL;
    
}

@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) UIColor *lineTintColor;

+ (IDLoader *)setOnView:(UIView *)view withTitle:(NSString *)title animated:(BOOL)animated;

+ (BOOL)hideFromView:(UIView *)view animated:(BOOL)animated;

@end
