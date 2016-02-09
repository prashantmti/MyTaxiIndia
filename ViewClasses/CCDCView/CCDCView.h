//
//  CCDCView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/5/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "PayUUIPaymentOptionViewController.h"
#import "PayUUIConstants.h"
#import "PayUSAGetHashes.h"
#import "iOSDefaultActivityIndicator.h"
#import "PayUSAGetTransactionID.h"

#import "PayUUIPaymentUIWebViewController.h"

@interface CCDCView : BaseView
{
    IBOutlet UIView * uvView1;
    IBOutlet UIView * uvView2;
    
}


//
@property (nonatomic, strong) IBOutlet UILabel *lblTitleCCDC;


@property (nonatomic, strong) IBOutlet UILabel *totalFare;
@property (nonatomic, strong) IBOutlet UILabel *txnID;



@property (strong,nonatomic) PayUModelPaymentParams *paymentParam;
- (IBAction)payByCCDC:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *textFieldExpiryMonth;
@property (weak, nonatomic) IBOutlet UITextField *textFieldExpiryYear;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCVV;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNameOnCard;


@property(assign,nonatomic) BOOL isStoreCard;

@property(weak, nonatomic) IBOutlet UIButton *btnStoreCard;

@property (nonatomic, strong) PayUCreateRequest *createRequest;
@property (nonatomic, strong) PayUValidations *validations;
@property (strong, nonatomic) PayUWebServiceResponse *webServiceResponse;
@property (strong, nonatomic) iOSDefaultActivityIndicator *defaultActivityIndicator;


@property(strong, nonatomic) NSDictionary *customerCredential;
@property(strong, nonatomic) NSDictionary *selectedCabInfo;


@property (weak,nonatomic) IBOutlet TPKeyboardAvoidingScrollView *TPscrollBar;
@end
