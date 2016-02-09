//
//  BasePaymentView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/5/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayUHeader.h"


#import "NetBankingView.h"
#import "CCDCView.h"

@interface BasePaymentView : BaseView
{
    NSString *strTotalFare;
    
    //
    IBOutlet UIView * uvSaveCard;
}


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

//
@property (strong, nonatomic) PayUModelHashes *setPayUHashes;

@property (nonatomic, strong) PayUModelPaymentRelatedDetail *paymentRelatedDetail;

@property (strong, nonatomic) PayUModelPaymentParams *paymentParam;
@property (strong, nonatomic) iOSDefaultActivityIndicator *defaultActivityIndicator;
@property (strong, nonatomic) NSMutableArray *listOfNilKeys;
@property (strong, nonatomic) NSArray * listofAllKeys;
@property (strong, nonatomic) PayUWebServiceResponse *webServiceResponse;
@property (strong, nonatomic) PayUSAGetHashes *getHashesFromServer;
@property (strong, nonatomic) PayUSAGetTransactionID *getTransactionID;


@property(strong,nonatomic) NSDictionary *customerCredential;
@property(strong,nonatomic) NSDictionary *selectedCabInfo;

@property (strong, nonatomic) ModalGlobal *mg;


@end
