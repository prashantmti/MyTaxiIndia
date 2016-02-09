//
//  CabListViewCell.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/27/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "CabListViewCell.h"

@implementation CabListViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setBoxShadow:vwCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setBoxShadow:(UIView*)view
{
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = CGSizeMake(-0.3,0.2);
    view.layer.shadowOpacity = 0.3;
}
@end
