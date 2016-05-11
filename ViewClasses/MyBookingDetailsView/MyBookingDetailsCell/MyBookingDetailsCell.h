//
//  MyBookingDetailsCell.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/21/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBookingDetailsCell : UITableViewCell
{
    
}

//for cell1
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIImageView *imgTripIcon;
@property (strong, nonatomic) IBOutlet UILabel *lblBookingID;
@property (strong, nonatomic) IBOutlet UILabel *lblBookingStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblDepartureCity;
@property (strong, nonatomic) IBOutlet UILabel *lblArrivalCity;

//for cell2
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UILabel *lblCell2Title;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblMobileNo;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblBookingTime;

//for cell3
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UILabel *lblCell3Title;
@property (strong, nonatomic) IBOutlet UILabel *lblBaseFare;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscount;
@property (strong, nonatomic) IBOutlet UILabel *lblServiceTax;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblKMLimit;
@property (strong, nonatomic) IBOutlet UILabel *lblPayableAmount;

//for cell4
@property (strong, nonatomic) IBOutlet UIView *view4;
@property (strong, nonatomic) IBOutlet UILabel *lblCell4Title;
@property (strong, nonatomic) IBOutlet UILabel *lblCarType;
@property (strong, nonatomic) IBOutlet UILabel *lblDriverName;
@property (strong, nonatomic) IBOutlet UILabel *lblTaxiNo;
@property (weak, nonatomic)   IBOutlet UIView *viewCallDriver;
@property (weak, nonatomic) IBOutlet UIButton *btnCallDriver;
@property (weak, nonatomic) IBOutlet UIButton *btnTrackDriver;

//for cell4
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (strong, nonatomic) IBOutlet UILabel *lblCell5Title;
@property (strong, nonatomic) IBOutlet UILabel *lblCell5CarType;
@property (strong, nonatomic) IBOutlet UILabel *lblCell5DriverName;
@property (strong, nonatomic) IBOutlet UILabel *lblCell5TaxiNo;

//for cell6
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UIButton *btnCallCC1;
@property (strong, nonatomic) IBOutlet UIImageView *imgThankU;


//for cell7
@property (weak, nonatomic) IBOutlet UIView *view7;
@property (weak, nonatomic) IBOutlet UIButton *btnCallCC2;
@end
