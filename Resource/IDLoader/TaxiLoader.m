//
//  TaxiLoader.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 1/12/16.
//  Copyright © 2016 mytaxiit. All rights reserved.
//

#import "TaxiLoader.h"

@implementation TaxiLoader


-(void)setOnView:(UIView *)view withTitle:(NSString *)title animated:(BOOL)animated {
    
    [self hideFromView:view animated:YES];
    
    view.userInteractionEnabled=FALSE;
    float height = [[UIScreen mainScreen] bounds].size.height;
    float width = [[UIScreen mainScreen] bounds].size.width;
    CGPoint center = CGPointMake(width/2, height/2);
    
    IDLoader *idLoader = [[IDLoader alloc] init];
    idLoader.frame=CGRectMake(0, 0, 120, 90);
    idLoader.center = center;
    idLoader.backgroundColor=[self colorWithCode:@"dbdbdb"];
    //idLoader.alpha=0.7;
    idLoader.layer.cornerRadius = 5.0f;
    [view addSubview:idLoader];
    
    //add label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0-5,idLoader.frame.size.height-27.0f, 120.0f, 30.0f)];
    label.font = [UIFont boldSystemFontOfSize:12.0f];
    label.textColor = GMD_SPINNER_COLOR;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    //[hud addSubview:label];
    
    NSArray * imageArray  = [[NSArray alloc] initWithObjects:
                             [UIImage imageNamed:@"1.png"],
                             [UIImage imageNamed:@"2.png"],
                             [UIImage imageNamed:@"3.png"],
                             [UIImage imageNamed:@"4.png"],
                             [UIImage imageNamed:@"5.png"],
                             nil];
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:
                             CGRectMake(0, 0, 120, 90)];
    imgView.animationImages = imageArray;
    imgView.animationDuration = 1;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [idLoader addSubview:imgView];
    [imgView startAnimating];
}

//------------------------------------
// Hide the leader in view
//------------------------------------
-(BOOL)hideFromView:(UIView *)view animated:(BOOL)animated {
   // IDLoader *idLoader = [IDLoader HUDForView:view];
    //    if (idLoader) {
    //        idLoader.transform = CGAffineTransformIdentity;
    //        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    //            idLoader.transform = CGAffineTransformMakeScale(0.01, 0.01);
    //        } completion:^(BOOL finished){
    //            idLoader.hidden = YES;
    //            [idLoader removeFromSuperview];
    //
    //        }];
    //        return YES;
    //    }
    return NO;
}

//------------------------------------
// Perform search for loader and hide it
//------------------------------------
+ (IDLoader *)HUDForView: (UIView *)view {
    view.userInteractionEnabled=TRUE;
    IDLoader *hud = nil;
    NSArray *subViewsArray = view.subviews;
    Class hudClass = [IDLoader class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (IDLoader *)aView;
        }
    }
    return hud;
}


-(UIColor*)colorWithCode:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end
