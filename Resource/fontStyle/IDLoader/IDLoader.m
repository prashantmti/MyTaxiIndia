//
//  IDLoader.m
//  serviceDemo
//
//  Created by prashant sahu on 02/11/15.
//  Copyright © 2015 prashant kumar. All rights reserved.
//

#import "IDLoader.h"

#pragma mark - Interface
@interface IDLoader ()
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, assign) BOOL isSpinning;
@end

@implementation IDLoader

+ (UIView*)setOnView:(UIView *)view withTitle:(NSString *)title animated:(BOOL)animated {
    
    [self hideFromView:view animated:YES];
    
    view.userInteractionEnabled=FALSE;
    float height = [[UIScreen mainScreen] bounds].size.height;
    float width = [[UIScreen mainScreen] bounds].size.width;
    CGPoint center = CGPointMake(width/2, height/2);
    
    IDLoader *idLoader = [[IDLoader alloc] init];
    idLoader.frame=CGRectMake(0, 0, 130.0, 90);
    idLoader.center = center;
    idLoader.backgroundColor=[UIColor blackColor];
    idLoader.alpha=0.7;
    idLoader.layer.cornerRadius = 5.0f;
    [view addSubview:idLoader];
    
    //add label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0-5,idLoader.frame.size.height-27.0f, 150.0f, 30.0f)];
    label.font = [UIFont boldSystemFontOfSize:12.0f];
    label.textColor = GMD_SPINNER_COLOR;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    //[hud addSubview:label];
    
    
    //[self attachPopUpAnimation:idLoader];
    idLoader.transform = CGAffineTransformMakeScale(0.01, 0.04);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        idLoader.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        GMDCircleLoader *GMD;
        GMD=[[GMDCircleLoader alloc]init];
        [idLoader addSubview:[GMD initPopView:idLoader]];
        [idLoader addSubview:label];
        
        // do something once the animation finishes, put it here
    }];
    
    return idLoader;
}

//------------------------------------
// Hide the leader in view
//------------------------------------
+ (BOOL)hideFromView:(UIView *)view animated:(BOOL)animated {
    IDLoader *idLoader = [IDLoader HUDForView:view];
    if (idLoader) {
        idLoader.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            idLoader.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished){
            idLoader.hidden = YES;
            [idLoader removeFromSuperview];
        }];
        return YES;
    }
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
@end
