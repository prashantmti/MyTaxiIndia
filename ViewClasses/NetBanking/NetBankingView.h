//
//  NetBankingView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/5/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PayU_iOS_CoreSDK.h"
#import "PayUUIConstants.h"
#import "PayUUIPaymentUIWebViewController.h"

@interface NetBankingView : BaseView<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIView * uvView1;
}


//


@property (nonatomic, strong) PayUModelPaymentRelatedDetail *paymentRelatedDetail;
@property (strong,nonatomic) PayUModelPaymentParams *paymentParam;

@property (strong, nonatomic) IBOutlet UILabel * lblTitlePaymentOption;


@property (nonatomic, strong) IBOutlet UILabel *lblTotalFare;
@property (nonatomic, strong) IBOutlet UILabel *lblTxnID;

@property (weak, nonatomic) IBOutlet UITableView *tbNetBanking;


- (IBAction)PayByNetBanking:(id)sender;


@property (nonatomic, strong) NSString *paymentType;

@property (nonatomic, strong) NSString *bankCode;

@property (nonatomic, strong) PayUCreateRequest *createRequest;

@property(strong, nonatomic) NSDictionary *customerCredential;
@property(strong, nonatomic) NSDictionary *selectedCabInfo;
@end