//
//  MyBookingView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/16/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBookingCell.h"


#import "BookingDetailsView.h"

@interface MyBookingView : BaseView<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *errorLbl;
}
@property (weak,nonatomic) IBOutlet UIBarButtonItem *barButton;

@property (strong, nonatomic) NSArray *AyBookingResult;

@property (weak, nonatomic) IBOutlet UITableView *TBMyBooking;

@property (strong, nonatomic) NSDictionary *DyBookingDetails;

@property (strong, nonatomic) NSString *driverMbStr;
@end


//9540109510

