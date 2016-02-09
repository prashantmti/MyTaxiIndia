//
//  MyBookingCell.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/19/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBookingCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblBookingID;
@property (strong, nonatomic) IBOutlet UILabel *lblTripFrom;
@property (strong, nonatomic) IBOutlet UILabel *lblTripTo;
@property (strong, nonatomic) IBOutlet UILabel *lblTripDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTripStatus;

@property (weak, nonatomic) IBOutlet UIButton *btnCallDriver;
@property (weak, nonatomic) IBOutlet UIButton *btnTrackDriver;
@end
