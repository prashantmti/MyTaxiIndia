//
//  BookingDetailsView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 1/11/16.
//  Copyright © 2016 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyBookingDetailsCell.h"
#import "OutStationView.h"

@interface BookingDetailsView : BaseView<UITableViewDataSource,UITableViewDelegate>
{

}

//
@property (strong, nonatomic) NSDictionary *DyBookingDetails;

@property (strong, nonatomic) NSString *driverMbStr;

@property (strong, nonatomic) NSString *ccMbStr;

@property (strong, nonatomic) IBOutlet UITableView *tbBookingDetails;

@property (strong, nonatomic) NSString *responseViewTag;

@end
