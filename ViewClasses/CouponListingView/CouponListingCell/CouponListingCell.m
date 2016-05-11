//
//  CouponListingCell.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 1/11/16.
//  Copyright © 2016 mytaxiit. All rights reserved.
//

#import "CouponListingCell.h"

@implementation CouponListingCell

- (void)awakeFromNib {
    // Initialization code
    [self setBoxShadow:vwCell];
    [self setBorder];
}

-(void)setBoxShadow:(UIView*)view{
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = CGSizeMake(-0.1,0.2);
    view.layer.shadowOpacity = 0.2;
}

-(void)setBorder{
    vLine.backgroundColor=[UIColor clearColor];
    CAShapeLayer * dotborder = [CAShapeLayer layer];
    dotborder.strokeColor = [UIColor grayColor].CGColor;//your own color
    dotborder.fillColor = nil;
    dotborder.lineWidth =0.6;
    dotborder.lineDashPattern = @[@3,@3];//your own patten
    dotborder.masksToBounds = NO;
    [vLine.layer addSublayer:dotborder];
    dotborder.path = [UIBezierPath bezierPathWithRect:vLine.bounds].CGPath;
    dotborder.frame = vLine.bounds;
}
@end
