//
//  CouponListingView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 1/11/16.
//  Copyright © 2016 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponListingCell.h"


@interface CouponListingView : BaseView<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *errorLbl;
}

//
@property (weak,nonatomic) IBOutlet UIBarButtonItem *barButton;
//
@property (weak, nonatomic) IBOutlet UITableView *TBCouponList;
//
@property (strong, nonatomic) NSArray *aryCouponResult;
@end
