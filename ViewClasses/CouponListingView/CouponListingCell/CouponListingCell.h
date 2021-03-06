//
//  CouponListingCell.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 1/11/16.
//  Copyright © 2016 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponListingCell : UITableViewCell
{
    IBOutlet UIView *vwCell;
    IBOutlet UILabel *vLine;
}

@property (strong, nonatomic) IBOutlet UILabel *lblDiscount;
@property (strong, nonatomic) IBOutlet UILabel *lblCouponCode;
@property (strong, nonatomic) IBOutlet UILabel *lblCouponType;
@property (strong, nonatomic) IBOutlet UILabel *lblCouponValidity;
//
@property (strong, nonatomic) IBOutlet UILabel *lblCouponMaxDicount;
@property (strong, nonatomic) IBOutlet UILabel *lblCouponMinValue;

@property (strong, nonatomic) IBOutlet UILabel *lblTripType;

//
@property (weak, nonatomic) IBOutlet UIButton *couponCopy;
@end
