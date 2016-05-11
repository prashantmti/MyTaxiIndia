//
//  MyBookingCell.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/19/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "MyBookingCell.h"

@implementation MyBookingCell

- (void)awakeFromNib {
    // Initialization code
    [self setBoxShadow:_view1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setBoxShadow:(UIView*)view{
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = CGSizeMake(-0.3,0.2);
    view.layer.shadowOpacity = 0.3;
}
@end
