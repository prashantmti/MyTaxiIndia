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

@interface MyBookingView : BaseView<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UILabel *errorLbl;
}
@property (weak, nonatomic) IBOutlet UIView   *uvBtn;
@property (weak, nonatomic) IBOutlet UIButton *BtnPT;
@property (weak, nonatomic) IBOutlet UIButton *BtnUT;

//
@property (weak,nonatomic) IBOutlet UIBarButtonItem *barButton;

@property (strong, nonatomic) NSArray *AyBookingResult;
@property (strong, nonatomic) NSArray *AyAllBookingResult;
@property (strong, nonatomic) NSArray *sortAyAllBookingResult;


@property (strong, nonatomic) NSMutableArray *arrayPastTrip;
@property (strong, nonatomic) NSMutableArray *arrayUpcommingTrip;

@property (weak, nonatomic) IBOutlet UITableView *TBMyBooking;

@property (strong, nonatomic) NSDictionary *DyBookingDetails;

@property (strong, nonatomic) NSString *driverMbStr;

@property (assign, nonatomic) NSInteger tripActionTag;
@end


//9540109510

