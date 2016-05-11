//
//  CCDCView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/5/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayUHeader.h"

@interface CCDCView : BaseView
{
    IBOutlet UIView * uvView1;
    IBOutlet UIView * uvView2;
    
}


//
@property (nonatomic, strong) IBOutlet UILabel *lblTitleCCDC;
@property (nonatomic, strong) IBOutlet UILabel *totalFare;
@property (nonatomic, strong) IBOutlet UILabel *txnID;
//


@property (strong,nonatomic) PayUModelPaymentParams *paymentParam;
//
@property (weak, nonatomic) IBOutlet UITextField *textFieldCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *textFieldExpiryMonth;
@property (weak, nonatomic) IBOutlet UITextField *textFieldExpiryYear;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCVV;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNameOnCard;

//
@property (nonatomic, strong) NSString *paymentType;
//

//
@property(assign,nonatomic) BOOL isStoreCard;
@property(assign,nonatomic) BOOL isOneTab;
//
@property(weak, nonatomic) IBOutlet UIButton *btnStoreCard;
@property(weak, nonatomic) IBOutlet UIButton *btnOneTab;
//
@property(weak, nonatomic) IBOutlet UILabel *lblStoreCard;
@property(weak, nonatomic) IBOutlet UILabel *lblOneTab;
//
@property (weak,nonatomic) IBOutlet TPKeyboardAvoidingScrollView *TPscrollBar;

- (IBAction)payByCCDC:(id)sender;

@end
