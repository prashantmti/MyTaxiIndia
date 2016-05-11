//
//  OutStationView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/9/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"
#import "AutoCityView.h"
#import "CabListView.h"


#import "PopPickerView.h"
#import "SearchTaxiModal.h"
#import "LocalStationView.h"
#import "CouponListingView.h"

@interface OutStationView : BaseView
{
    IBOutlet UIView * uvTripAction;
    IBOutlet UIView * uvFrom;
    IBOutlet UIView * uvTo;
    IBOutlet UIView * uvMoreCity;
    IBOutlet UIView * uvDpPicker;
    IBOutlet UIView * uvTripView;

    IBOutlet UIView * DPView1;
    IBOutlet UIView * DPView2;
    
    UIView *popSuperView;
    UIView *popWindowView;
}

//
@property (weak,nonatomic) IBOutlet UIBarButtonItem *barButton;
//
@property (strong, nonatomic) BaseView *baseView;
//
@property(assign, nonatomic) BOOL *isShowUvMoreCity;
@property(assign, nonatomic) BOOL isShowPicker;

@property (weak,nonatomic) IBOutlet TPKeyboardAvoidingScrollView *tpScrollBar;




@property (strong, nonatomic) IBOutlet UITextField *tfDepartureCity;
@property (strong, nonatomic) IBOutlet UITextField *tfArrivalCity;
@property (strong, nonatomic) IBOutlet UITextField *tfAddMoreCity;




//@property (strong, nonatomic) PayUModelHashes *setPayUHashes;





@property (strong, nonatomic) UIViewController * currentViewController;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentTab;
@property (weak, nonatomic) IBOutlet UIButton *owBtn;
@property (weak, nonatomic) IBOutlet UIButton *rtBtn;


@property (strong, nonatomic) IBOutlet UIImageView *IVaddMoreCity;

@property (strong, nonatomic) NSString * departureLocID;
@property (strong, nonatomic) NSString * arrivalLocID;


@property (nonatomic, assign) BOOL isAddMoreCtiy;   //isAddMoreCtiy

@property (weak, nonatomic) IBOutlet UIButton *btnAddMoreCity;
@property (weak, nonatomic) IBOutlet UIButton *btnSearchTaxi;

@property (strong, nonatomic) NSString *selectedLocation;

@property(strong,nonatomic) NSString *selectedDateFromDP;

@property(strong,nonatomic) UIDatePicker *datePicker;

@property(strong,nonatomic) NSString *pickupDate,*dropDate;

@property(strong,nonatomic) IBOutlet UILabel *lbDpView1dd;
@property(strong,nonatomic) IBOutlet UILabel *lbDpView1mmyy;
@property(strong,nonatomic) IBOutlet UILabel *lbDpView1Day;

@property(strong,nonatomic) IBOutlet UILabel *lbDpView2dd;
@property(strong,nonatomic) IBOutlet UILabel *lbDpView2mmyy;
@property(strong,nonatomic) IBOutlet UILabel *lbDpView2Day;

@property (strong, nonatomic) NSArray *cabList;

@property(strong, nonatomic) NSString *tripType;
@property(strong, nonatomic) NSString *tripWaytag;

@property(strong, nonatomic) NSMutableDictionary *selectedTripCites;
@end
