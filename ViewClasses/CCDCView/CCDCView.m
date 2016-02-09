//
//  CCDCView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/5/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "CCDCView.h"

@interface CCDCView ()

@end

@implementation CCDCView
@synthesize selectedCabInfo,customerCredential,btnStoreCard;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _totalFare.text=[NSString stringWithFormat:@"%@%@/-",rupee,self.paymentParam.amount];
    _txnID.text=self.paymentParam.transactionID;
    
    //
    [self setUI];
    
    //
    _isStoreCard=NO;
    [self setSCAction:0];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    self.textFieldCardNumber.text = @"5123456789012346";
    self.textFieldExpiryMonth.text = @"05";
    self.textFieldExpiryYear.text = @"2017";
    self.textFieldNameOnCard.text = @"Umang";
    self.textFieldCVV.text = @"123";
}

-(void)setUI{
    //
    [self setBoxShadow:uvView1];
    [self setBoxShadow:uvView2];
    //
    [self setLabelUnderLine:_lblTitleCCDC];
    //
    [self setTextBoxLine:_textFieldCardNumber];
    [self setTextBoxLine:_textFieldNameOnCard];
    [self setTextBoxLine:_textFieldExpiryMonth];
    [self setTextBoxLine:_textFieldExpiryYear];
    [self setTextBoxLine:_textFieldCVV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stroreCardAction:(UIButton*)sender{
    [self setSCAction:sender.tag];
}


-(void)setSCAction:(NSInteger)tagValue{
    //
    if (tagValue==0) {
        _isStoreCard=NO;
        btnStoreCard.tag=1;
        [btnStoreCard setImage:[UIImage imageNamed:@"checkBox"]
                      forState:UIControlStateNormal];
    }else{
        _isStoreCard=YES;
        btnStoreCard.tag=0;
        [btnStoreCard setImage:[UIImage imageNamed:@"unCheckBox"]
                      forState:UIControlStateNormal];
    }
    
    
    NSLog(@"sender tag===>%ld",tagValue);
    NSLog(@"_isStoreCard===>%d",_isStoreCard);
}

- (IBAction)payByCCDC:(id)sender {
    
    self.paymentParam.expiryYear = self.textFieldExpiryYear.text;
    self.paymentParam.expiryMonth = self.textFieldExpiryMonth.text;
    self.paymentParam.nameOnCard = self.textFieldNameOnCard.text;
    self.paymentParam.cardNumber = self.textFieldCardNumber.text;
    self.paymentParam.CVV = self.textFieldCVV.text;
    
    if (_isStoreCard==YES) {
            self.paymentParam.storeCardName = self.textFieldNameOnCard.text;
    }else{
            self.paymentParam.storeCardName = nil;
    }
    self.createRequest = [PayUCreateRequest new];

    [self.createRequest createRequestWithPaymentParam:self.paymentParam forPaymentType:PAYMENT_PG_CCDC withCompletionBlock:^(NSMutableURLRequest *request, NSString *postParam, NSString *error) {
        if (error == nil) {
            PayUUIPaymentUIWebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_CONTROLLER_IDENTIFIER_PAYMENT_UIWEBVIEW];
            webView.paymentRequest = request;
            webView.selectedCabInfo=selectedCabInfo;
            [self.navigationController pushViewController:webView animated:true];
        }
        else{
            [self alertWithText:@"ERROR" message:error];
            return;
        }
    }];
}

-(void)dealloc{
    NSLog(@"Inside Dealloc of CCDC");
}
@end
