//
//  BasePaymentView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/5/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayUHeader.h"

//
#import "PaymentsSDK.h"
#import "PayTmConfig.h"

@interface BasePaymentView : BaseView<PGTransactionDelegate>

@property(strong,nonatomic) NSString *strTotalFare;

@property (weak,nonatomic) IBOutlet UIScrollView *svBar;
@property (weak,nonatomic) IBOutlet UIView *uvView1;
@property (weak,nonatomic) IBOutlet UIView *uvView2;
@property (weak,nonatomic) IBOutlet UIView *uvView3;
//
@property (strong, nonatomic) IBOutlet UILabel *lblTitlePaymentOption;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleTravelSummary;


@property (strong, nonatomic) IBOutlet UILabel *tripLocation;
@property (strong, nonatomic) IBOutlet UILabel *pickUpDate;
@property (strong, nonatomic) IBOutlet UILabel *vehicleCategory;
@property (strong, nonatomic) IBOutlet UILabel *totalFare;

@property(strong,nonatomic) NSDictionary *customerCredential;
//
@property (weak, nonatomic) IBOutlet UITableView *tableForPaymentOption;
//
@property (nonatomic,strong)  PayUModelPaymentParams *paymentParam;
@property (nonatomic, strong) PayUModelPaymentRelatedDetail *paymentRelatedDetail;

@property (nonatomic,strong)  NSArray *paymentArray;;
@end
