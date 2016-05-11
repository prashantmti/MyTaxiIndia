//
//  CCDCView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/5/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "CCDCView.h"
#import "PayUUIConstants.h"
#import "iOSDefaultActivityIndicator.h"
#import "PayUUIPaymentUIWebViewController.h"

@interface CCDCView ()

@property (nonatomic, strong) PayUCreateRequest *createRequest;
@property (nonatomic, strong) PayUValidations *validations;
@property (strong, nonatomic) PayUWebServiceResponse *webServiceResponse;
@property (strong, nonatomic) iOSDefaultActivityIndicator *defaultActivityIndicator;

@end

@implementation CCDCView

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
    [self setOTAction:0];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
//    self.textFieldCardNumber.text = @"5123456789012346";
//    self.textFieldExpiryMonth.text = @"05";
//    self.textFieldExpiryYear.text = @"2017";
//    self.textFieldNameOnCard.text = @"Umang";
//    self.textFieldCVV.text = @"123";
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

- (IBAction)saveCardAction:(UIButton*)sender{
    [self setSCAction:sender.tag];
}

-(IBAction)oneTabAction:(UIButton*)sender{
    [self setOTAction:sender.tag];
}

-(void)setSCAction:(NSInteger)tagValue{
    //
    if ([self.paymentType isEqual:PAYMENT_PG_CASHCARD]) {
        _btnStoreCard.hidden = true;
        _lblStoreCard.hidden = true;
        _btnOneTab.hidden = true;
        _lblOneTab.hidden = true;
    }else{
        if (tagValue==0){
            _isStoreCard=NO;
            _btnStoreCard.tag=1;
            [_btnStoreCard setImage:[UIImage imageNamed:@"checkFalse"]
                           forState:UIControlStateNormal];
            _btnOneTab.hidden=true;
            _lblOneTab.hidden=true;
        }else{
            _isStoreCard=YES;
            _btnStoreCard.tag=0;
            [_btnStoreCard setImage:[UIImage imageNamed:@"checkTrue"]
                           forState:UIControlStateNormal];
            //
            _btnOneTab.hidden=false;
            _lblOneTab.hidden=false;
        }
    }
    //
    NSLog(@"setSCAction tag===>%ld",(long)tagValue);
    NSLog(@"_isStoreCard===>%d",_isStoreCard);
}

-(void)setOTAction:(NSInteger)tagValue{
    //
    if (tagValue==0) {
        _isOneTab=NO;
        _btnOneTab.tag=1;
        [_btnOneTab setImage:[UIImage imageNamed:@"checkFalse"]
                      forState:UIControlStateNormal];
    }else{
        _isOneTab=YES;
        _btnOneTab.tag=0;
        [_btnOneTab setImage:[UIImage imageNamed:@"checkTrue"]
                      forState:UIControlStateNormal];
    }
    //
    NSLog(@"setOTAction tag===>%ld",(long)tagValue);
    NSLog(@"_isOneTab===>%d",_isOneTab);
}

- (IBAction)payByCCDC:(id)sender {
    
    self.paymentParam.expiryYear = self.textFieldExpiryYear.text;
    self.paymentParam.expiryMonth = self.textFieldExpiryMonth.text;
    self.paymentParam.nameOnCard = self.textFieldNameOnCard.text;
    self.paymentParam.cardNumber = self.textFieldCardNumber.text;
    self.paymentParam.CVV = self.textFieldCVV.text;
    
    self.createRequest = [PayUCreateRequest new];
    
    if ([self.paymentType isEqual:PAYMENT_PG_CASHCARD]) {
        [self sendPaymentRequestWithPaymentType:PAYMENT_PG_CASHCARD];
    }
    else{
        if (_isStoreCard==YES) {
        self.paymentParam.storeCardName = self.textFieldNameOnCard.text;
        if (_isOneTab==YES) {
                self.paymentParam.isOneTap = 1;
            }
        }else{
            self.paymentParam.storeCardName = nil;
        }
        [self sendPaymentRequestWithPaymentType:PAYMENT_PG_CCDC];
    }
}

-(void)sendPaymentRequestWithPaymentType:(NSString *)paymentType
{
    [self.createRequest createRequestWithPaymentParam:self.paymentParam forPaymentType:paymentType withCompletionBlock:^(NSMutableURLRequest *request, NSString *postParam, NSString *error) {
        if (error == nil) {
            PayUUIPaymentUIWebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_CONTROLLER_IDENTIFIER_PAYMENT_UIWEBVIEW];
            webView.paymentRequest = (NSURLRequest *)request;
            webView.paymentParam = self.paymentParam;
            [self.navigationController pushViewController:webView animated:true];
        }
        else{
            NSLog(@"URL request from createRequestWithPostParam: %@",request);
            NSLog(@"PostParam from createRequestWithPostParam:%@",postParam);
            NSLog(@"Error from createRequestWithPostParam:%@",error);
            [[[UIAlertView alloc] initWithTitle:@"ERROR" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }];
}

- (IBAction)saveStoreCard:(id)sender {
    if ([self.paymentType isEqual:PAYMENT_PG_CASHCARD]) {
        self.btnOneTab.hidden = true;
        self.lblOneTab.hidden = true;
        self.btnStoreCard.hidden = true;
        self.lblStoreCard.hidden = true;
    }
    else{
//        [self.switchForOneTap setOn:false];
//        if (self.switchSaveStoreCard.on) {
//            self.textFieldstoreCardName.hidden = false;
//            if (self.paymentParam.OneTapTokenDictionary == nil) {
//                self.switchForOneTap.hidden = true;
//            }
//            else{
//                self.switchForOneTap.hidden = false;
//            }
//        }
//        else{
//            self.textFieldstoreCardName.hidden = true;
//            self.switchForOneTap.hidden = true;
//        }
    }
}

-(void)dealloc{
    NSLog(@"Inside Dealloc of CCDC");
}
@end
