//
//  LocalStationView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/9/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CabListView.h"
#import "AutoCityView.h"

@interface LocalStationView : BaseView<UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UIView * uvView1;
    IBOutlet UIView * uvView2;
    IBOutlet UIView * DPView1;
    
    UIPickerView *dataPickerView;
}

@property (strong, nonatomic) IBOutlet UITextField *tfPickUpCity;
@property (strong, nonatomic) IBOutlet UITextField *tfDays;

@property(strong, nonatomic) NSMutableDictionary *selectedTripCites;

@property(strong,nonatomic) UIDatePicker *datePicker;
@property(strong,nonatomic) NSString *pickupDate;
@property(assign,nonatomic) BOOL isShowPicker;

@property(strong,nonatomic) IBOutlet UILabel *lbDpView1dd;
@property(strong,nonatomic) IBOutlet UILabel *lbDpView1mmyy;
@property(strong,nonatomic) IBOutlet UILabel *lbDpView1Day;

@property (strong, nonatomic) BaseView *baseView;

@property (strong, nonatomic) NSArray *cabList;

@property (weak, nonatomic) IBOutlet UIButton *btnSearchTaxi;

@property (strong, nonatomic) ModalGlobal *mg;

@end
