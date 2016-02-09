//
//  ThankYouCell.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 12/7/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThankYouCell : UITableViewCell


//for cell1
@property (strong, nonatomic) IBOutlet UILabel *lblBookingID;
@property (strong, nonatomic) IBOutlet UILabel *lblBookingStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblLocationVal;


//for cell2
@property (strong, nonatomic) IBOutlet UILabel *lblname;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblMobileNo;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;


//for cell3
@property (strong, nonatomic) IBOutlet UILabel *lblBaseFare;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscount;
@property (strong, nonatomic) IBOutlet UILabel *lblServiceTax;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmount;


//for cell4
@property (strong, nonatomic) IBOutlet UILabel *lblTip;
@property (strong, nonatomic) IBOutlet UILabel *lblDrive;
@property (strong, nonatomic) IBOutlet UILabel *lblCarType;
@property (strong, nonatomic) IBOutlet UILabel *lblCarNo;
@property (weak, nonatomic) IBOutlet UIButton *btnCallDriver;

@end
