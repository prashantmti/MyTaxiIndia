//
//  PayUUIEMIViewController.h
//  SeamlessTestApp
//
//  Created by Umang Arya on 28/10/15.
//  Copyright © 2015 PayU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayUUIConstants.h"
#import "PayUHeader.h"

@interface PayUUIEMIViewController : BaseView <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIView * uvView1;
    IBOutlet UIView * uvView2;
}
@property (nonatomic, strong) IBOutlet UILabel *lblTotalFare;
@property (nonatomic, strong) IBOutlet UILabel *lblTxnID;

@property (weak, nonatomic) IBOutlet UITableView *tableViewBankName;
@property (weak, nonatomic) IBOutlet UITableView *tableViewEMIDuration;

@property (strong, nonatomic) PayUModelPaymentParams *paymentParam;
@property (nonatomic, strong) PayUModelPaymentRelatedDetail *paymentRelatedDetail;

@property (weak, nonatomic) IBOutlet UITextField *textFieldCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *textFieldExpiryMonth;
@property (weak, nonatomic) IBOutlet UITextField *textFieldExpiryYear;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCVV;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNameOnCard;

- (IBAction)payByEMI:(id)sender;
- (IBAction)checkVAS:(id)sender;


@property (weak,nonatomic) IBOutlet TPKeyboardAvoidingScrollView *TPscrollBar;
@property (nonatomic, strong) NSString *paymentType;
//
@property (nonatomic, strong) IBOutlet UILabel *lblTitleEMI;
@property (nonatomic, strong) IBOutlet UILabel *lblTitleCardDetail;

//
@end
