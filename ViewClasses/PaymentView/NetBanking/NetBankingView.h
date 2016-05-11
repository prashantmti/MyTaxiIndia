//
//  NetBankingView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/5/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayUHeader.h"
#import "PayUUIConstants.h"
#import "PayUUIPaymentUIWebViewController.h"
#import "CCDCView.h"


@interface NetBankingView : BaseView<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIView * uvView1;
}
//
@property (nonatomic, strong) PayUModelPaymentRelatedDetail *paymentRelatedDetail;
@property (strong,nonatomic) PayUModelPaymentParams *paymentParam;

//
@property (weak, nonatomic) IBOutlet UITableView *tbNetBanking;

@property (strong, nonatomic) IBOutlet UILabel *lblTitlePaymentOption;
@property (nonatomic, strong) IBOutlet UILabel *lblTotalFare;
@property (nonatomic, strong) IBOutlet UILabel *lblTxnID;

@property (nonatomic, strong) NSString *paymentType;
@property (nonatomic, strong) NSString *bankCode;

@property (nonatomic, strong) PayUCreateRequest *createRequest;

- (IBAction)PayByNetBanking:(id)sender;
@end