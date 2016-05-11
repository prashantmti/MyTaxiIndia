//
//  PayUUIStoredCardViewController.h
//  SeamlessTestApp
//
//  Created by Umang Arya on 08/10/15.
//  Copyright © 2015 PayU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayUHeader.h"

#import "PayUUIConstants.h"
#import "PayUUIPaymentUIWebViewController.h"



@interface PayUUIStoredCardViewController : BaseView <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIView * uvView1;
    UILabel *errorLbl;
}

@property (strong, nonatomic) PayUModelPaymentParams *paymentParam;
@property (strong, nonatomic) PayUModelPaymentRelatedDetail *paymentRelatedDetail;
@property (nonatomic, strong) NSString *paymentType;

@property (weak, nonatomic) IBOutlet UIView *viewInside1;
@property (weak, nonatomic) IBOutlet UITableView *tableViewStoredCard;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCVV;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPaymentTypeForSC;

@property (nonatomic, strong) PayUCreateRequest *createRequest;
@property (nonatomic, strong) PayUWebServiceResponse *webServiceResponse;
- (IBAction)PayBySC:(id)sender;

//- (IBAction)checkVAS:(id)sender;
-(void)configurePaymentParamWithIndex:(NSInteger) index;
-(PayUModelPaymentParams *) getPaymentParam;
//
@property (weak,nonatomic) IBOutlet TPKeyboardAvoidingScrollView *TPscrollBar;
@property (nonatomic, strong) IBOutlet UILabel *lblTotalFare;
@property (nonatomic, strong) IBOutlet UILabel *lblTxnID;


//
@property(assign,nonatomic) BOOL isOneTab;
@property(weak, nonatomic) IBOutlet UIButton *btnOneTab;
@property(weak, nonatomic) IBOutlet UILabel *lblOneTab;
//
@property (strong, nonatomic) NSMutableArray *storedArray;
@end
