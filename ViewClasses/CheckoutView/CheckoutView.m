//
//  CheckoutView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/3/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "CheckoutView.h"

//
#import "PayUUIConstants.h"
#import "PayUSAGetHashes.h"
#import "iOSDefaultActivityIndicator.h"
#import "PayUSAGetTransactionID.h"
#import "PayUSAOneTapToken.h"
//
#import "BasePaymentView.h"
//
#import "BookingDetailsView.h"

@interface CheckoutView ()
//
@property (strong, nonatomic) PayUModelPaymentParams *paymentParam;
@property (strong, nonatomic) iOSDefaultActivityIndicator *defaultActivityIndicator;
@property (strong, nonatomic) NSMutableArray *listOfNilKeys;
@property (strong, nonatomic) NSArray * listofAllKeys;
@property (strong, nonatomic) PayUWebServiceResponse *webServiceResponse;
@property (strong, nonatomic) PayUSAGetHashes *getHashesFromServer;
@property (strong, nonatomic) PayUSAGetTransactionID *getTransactionID;
//@property (strong, nonatomic) UISwitch *switchForSalt;
//@property (strong, nonatomic) UISwitch *switchForOneTap;
//
@end

@implementation CheckoutView
@synthesize selectedCabInfo,baseFare,discount,serviceTax,totalAmount,advanceAmount,location,returnDate,bookingID;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mg=[ModalGlobal sharedManager];
    
    [self setDataOnView];
    [self setUI];
    
    
    //
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(textPressed:)];
    [couponText addGestureRecognizer:longPress];
    
    //
    _btnPayFull.backgroundColor=[self colorWithCode:@"666666"];
    
    _isApplyCoupon=NO;
    //
    _paymentActionTag=1;
    
    //
    [self setFlurry:@"Checkout" params:nil];
}

- (void) textPressed:(UILongPressGestureRecognizer *) gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized &&
        [gestureRecognizer.view isKindOfClass:[couponText class]]){
        couponText.text = [[UIPasteboard generalPasteboard] string];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self GATrackOnView:NSStringFromClass(self.class) kGAIScreenName:kGAIScreenName];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setUI{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if (screenHeight-64<666){
      _TPscrollBar.contentSize=CGSizeMake(_TPscrollBar.frame.size.width,666);
    }
    
    [self setBoxShadow:uvView1];
    [self setBoxShadow:uvView2];
    [self setBoxShadow:uvView3];
    [self setBoxShadow:uvView4];
    [self setBoxShadow:uvView5];
    [self setBoxShadow:uvView6];
    //
    [self setTextBoxLine:userName];
    [self setTextBoxLine:userEmail];
    [self setTextBoxLine:userPhone];
    [self setTextBoxLine:userAddress];
    [self setTextBoxLine:jetprivilegeNo];
    [self setTextBoxLine:couponText];
    
    
    //[self setButtonShadow:_btnApplyCoupon];
    //[self setButtonShadow:_btnMakePayment];
    
    //
    [self setLabelUnderLine:_lblTitleCollection];
    [self setLabelUnderLine:_lblTitleCoupon];
    [self setLabelUnderLine:_lblTitleCustomerDetails];
    
    //
    if([[UserDefault loginTag]intValue]!=0){
        userEmail.enabled=false;
    }else{
        userEmail.enabled=true;
    }
    
}


-(void)setDataOnView
{
    NSArray*itemsArray=[[selectedCabInfo valueForKey:@"result"] valueForKey:@"items"];
    //
    _departureDate.text=[self dateWithOrdinalStyle:self.mg.mbt.departureDate];
    //
    baseFareStr=[[selectedCabInfo valueForKey:@"result"] valueForKey:@"netAmount"];
    discountStr=[[selectedCabInfo valueForKey:@"result"] valueForKey:@"couponDiscount"];
    serviceTaxStr=[[selectedCabInfo valueForKey:@"result"] valueForKey:@"serviceTax"];
    totalAmountStr=[[selectedCabInfo valueForKey:@"result"] valueForKey:@"totalAmount"];
    advanceAmountStr=[[selectedCabInfo valueForKey:@"result"] valueForKey:@"advanceAmount"];
    //
    baseFare.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self valueRoundOff:baseFareStr]];
    serviceTax.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self valueRoundOff:serviceTaxStr]];
    discount.text=[NSString stringWithFormat:@"%@%@/-",rupee,@"0"];
    totalAmount.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self valueRoundOff:totalAmountStr]];
    
    if ([advanceAmountStr isEqual:[NSNull null]]) {
        advanceAmount.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self valueRoundOff:totalAmountStr]];
    }else{
        advanceAmount.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self valueRoundOff:advanceAmountStr]];
    }
    
    //
    NSNumber *minKmPerDay,*totalKmCharged;
    minKmPerDay=    [[itemsArray[0] valueForKey:@"taxiFare"] valueForKey:@"minKmPerDay"];
    totalKmCharged= [[itemsArray[0] valueForKey:@"taxiFare"] valueForKey:@"totalKmCharged"];
    
    if ([minKmPerDay isEqual:[NSNull null]] && [totalKmCharged isEqual:[NSNull null]]) {
        kmlimitStr=@"0";
    }else if([minKmPerDay isEqual:[NSNull null]]    || minKmPerDay>totalKmCharged){
        kmlimitStr=[NSString stringWithFormat:@"%@",totalKmCharged];
    }else if([totalKmCharged isEqual:[NSNull null]] || minKmPerDay<totalKmCharged){
        kmlimitStr=[NSString stringWithFormat:@"%@",minKmPerDay];
    }else{
        kmlimitStr=[NSString stringWithFormat:@"%@",totalKmCharged];
    }
    _kmLimit.text=[NSString stringWithFormat:@"%@ KM",kmlimitStr];
    //
    
    NSString *fromStr,*toStr;
    fromStr=[self getCity:[itemsArray[0] valueForKey:@"fromCity"]];
    toStr=[self getCity:[itemsArray[0] valueForKey:@"toCity"]];
    location.text=[[NSString stringWithFormat:@"%@-%@",fromStr,toStr] capitalizedString];
    //
    bookingID=[itemsArray[0] valueForKey:@"bookingId"];
    [self getCustomerDetails:[[selectedCabInfo valueForKey:@"result"] valueForKey:@"customerId"]];
}


- (IBAction)applyCoupon:(id)sender {
    if ([self trimValue:couponText.text].length==0) {
        [self alertWithText:nil message:@"Enter Promo Code"];
        return;
    }
    WebServiceClass *WSC = [[WebServiceClass alloc] init];
    NSString *auth=[self createAuth:merchantId string2:[self uniqueTstamp] string3:authPassword];
    NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
    [postDic setObject:merchantId forKey:@"merchantId"];
    [postDic setObject:[self uniqueTstamp] forKey:@"salt"];
    
    [postDic setObject:bookingID forKey:@"bookingId"];
    [postDic setObject:[self trimValue:couponText.text] forKey:@"couponCode"];

    [WSC getServerResponseForUrl:postDic serviceURL:IDApplyCoupon isPOST:YES isLoder:YES  auth:auth view:self.view withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        if (success) {
            if([[response valueForKey:@"status"] isEqualToString:@"error"]){
                [self alertWithText:nil message:[response valueForKey:@"error"]];
            }else
            {
                baseFareStr=[[response valueForKey:@"result"] valueForKey:@"netAmount"];
                discountStr=[[response valueForKey:@"result"] valueForKey:@"couponDiscount"];
                serviceTaxStr=[[response valueForKey:@"result"] valueForKey:@"serviceTax"];
                totalAmountStr=[[response valueForKey:@"result"] valueForKey:@"totalAmount"];
                advanceAmountStr=[[response valueForKey:@"result"] valueForKey:@"advanceAmount"];
                
                //
                baseFare.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self valueRoundOff:baseFareStr]];
                discount.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self valueRoundOff:discountStr]];
                serviceTax.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self valueRoundOff:serviceTaxStr]];
                totalAmount.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self valueRoundOff:totalAmountStr]];

                if ([advanceAmountStr isEqual:[NSNull null]]) {
                    advanceAmount.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self valueRoundOff:totalAmountStr]];
                }else{
                    advanceAmount.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self valueRoundOff:advanceAmountStr]];
                }
                _isApplyCoupon=YES;
                NSString *cMsg=[[response valueForKey:@"result"] valueForKey:@"couponMessage"];
                [self alertWithText:nil message:[NSString stringWithFormat:@"Coupon successfully applied. %@",cMsg]];
            }
        }else{
            NSLog(@"error===>%@",error.localizedDescription);
            [self alertWithText:nil message:error.localizedDescription];
            return;
        }
    }];
}

- (IBAction)actionPay:(id)sender {
    
        if ([self validateString:userName.text]==FALSE) {
            [self alertWithText:nil message:@"Please Enter Name"];
            return;
        }
        else if ([self validateEmail:userEmail.text]==FALSE) {
            [self alertWithText:nil message:@"Please Enter Valid Email ID"];
            return;
        }
        else if ([self validateMobile:userPhone.text]==FALSE) {
            [self alertWithText:nil message:@"Please Enter Valid Phone No."];
            return;
        }
        else if ([self validateString:userAddress.text]==FALSE) {
            [self alertWithText:nil message:@"Please Enter Address"];
            return;
        }
        else if ([self validateAddress:userAddress.text]==FALSE) {
            [self alertWithText:nil message:@"Address Max Limit 200"];
            return;
        }
        else if ([self validateJP:jetprivilegeNo.text]==FALSE) {
            [self alertWithText:nil message:@"Plese Enter Valid Jet Privilege No."];
            return;
        }
        else{
            [IDLoader setOnView:self.view withTitle:nil animated:YES];
            [self callActionService];
        }
}

- (IBAction)paymentAction:(UIButton *)sender {
    [self paymentActionByTag:sender.tag];
}

-(void)paymentActionByTag:(NSInteger)tag{
    
    if (tag==_paymentActionTag) {
        return;
    }else{
        switch (tag) {
            case 1:{
                //
                [self setUIonView:tag];
                //
                _paymentActionTag=tag;
                //
                _imgPayFull.image=[UIImage imageNamed:@"payFullCK"];
                _imgPayToDriver.image=[UIImage imageNamed:@"payToDriverUK"];
                _imgPayAdvance.image=[UIImage imageNamed:@"payToAdvanceUK"];
                //
                [self callPaymentService];
                break;
            }case 2:{
                //
                [self setUIonView:tag];
                //
                _paymentActionTag=tag;
                //
                _imgPayFull.image=[UIImage imageNamed:@"payFullUK"];
                _imgPayToDriver.image=[UIImage imageNamed:@"payToDriverCK"];
                _imgPayAdvance.image=[UIImage imageNamed:@"payToAdvanceUK"];
                //
                [self callPaymentService];
                break;
            }
            case 3:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:couponActionMsg
                                                               delegate:self
                                                      cancelButtonTitle:@"No"
                                                      otherButtonTitles:@"Yes", nil];
                [alert show];
                alert.tag=tag;
                break;
            }
            default:
                return;
                break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(buttonIndex) {
        case 0: //"No" pressed
            break;
        case 1:{    //"YES"
            //
            [self setUIonView:alertView.tag];
            //
            _paymentActionTag=alertView.tag;
            //
            _imgPayFull.image=[UIImage imageNamed:@"payFullUK"];
            _imgPayToDriver.image=[UIImage imageNamed:@"payToDriverUK"];
            _imgPayAdvance.image=[UIImage imageNamed:@"payToAdvanceCK"];
            //
            [self callPaymentService];
             break;
        }
    }
}


-(void)callPaymentService{
    //
    WebServiceClass *WSC = [[WebServiceClass alloc] init];
    NSString *auth=[self createAuth:merchantId string2:[self uniqueTstamp] string3:authPassword];
    //
    NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
    [postDic setObject:merchantId forKey:@"merchantId"];
    [postDic setObject:[self uniqueTstamp] forKey:@"salt"];
    [postDic setObject:bookingID forKey:@"bookingId"];
    
    switch (_paymentActionTag) {
        case 2:{
            [postDic setObject:@"false" forKey:@"advancePayment"];
            [postDic setObject:@"true" forKey:@"paymentNotRequired"];
            break;
        }
        case 3:{
            [postDic setObject:@"true" forKey:@"advancePayment"];
            [postDic setObject:@"false" forKey:@"paymentNotRequired"];
            break;
        }
        default:{
            [postDic setObject:@"false" forKey:@"advancePayment"];
            break;
        }
    }
    
    [WSC getServerResponseForUrl:postDic serviceURL:IDAdvancePayment isPOST:YES isLoder:YES  auth:auth view:self.view withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        if (success) {
            if([[response valueForKey:@"status"] isEqualToString:@"error"]){
                if (_paymentActionTag==2) {
                    //
                    UIAlertController * alert=  [UIAlertController
                                                 alertControllerWithTitle:nil
                                                 message:[response valueForKey:@"error"]
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             //
                                             [self paymentActionByTag:1];    //for full payment
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    [self alertWithText:nil message:[response valueForKey:@"error"]];
                }
                return;
            }else
            {
                baseFareStr=[[response valueForKey:@"result"] valueForKey:@"netAmount"];
                discountStr=[[response valueForKey:@"result"] valueForKey:@"couponDiscount"];
                serviceTaxStr=[[response valueForKey:@"result"] valueForKey:@"serviceTax"];
                totalAmountStr=[[response valueForKey:@"result"] valueForKey:@"totalAmount"];
                advanceAmountStr=[[response valueForKey:@"result"] valueForKey:@"advanceAmount"];
                
                baseFare.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self valueRoundOff:baseFareStr]];
                discount.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self valueRoundOff:discountStr]];
                serviceTax.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self valueRoundOff:serviceTaxStr]];
                totalAmount.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self valueRoundOff:totalAmountStr]];
                
                
                switch (_paymentActionTag) {
                    case 1:{
                        advanceAmount.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self valueRoundOff:totalAmountStr]];
                        break;
                    }
                    case 2:{
                        advanceAmount.text=@"0/-";
                        break;
                    }
                    case 3:{
                        advanceAmount.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self valueRoundOff:advanceAmountStr]];
                        break;
                    }
                }
            }
        }else{
            NSLog(@"error===>%@",error.localizedDescription);
            [self alertWithText:nil message:error.localizedDescription];
            return;
        }
    }];
}

-(void)callActionService{
    //
    UIDevice *device = [UIDevice currentDevice];
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    NSString *deviceToken=self.mg.mbt.deviceToken;
    if (deviceToken == (id)[NSNull null] || deviceToken.length == 0)
        deviceToken = @"0";
    WebServiceClass *WSC = [[WebServiceClass alloc] init];
    NSString *auth=[self createAuth:merchantId string2:[self uniqueTstamp] string3:authPassword];
    NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
    
    [postDic setObject:merchantId forKey:@"merchantId"];
    [postDic setObject:[self uniqueTstamp] forKey:@"salt"];
    
    [postDic setObject:bookingID forKey:@"bookingId"];
    [postDic setObject:[self trimValue:userName.text] forKey:@"customerName"];
    [postDic setObject:[self trimValue:userEmail.text] forKey:@"customerEmail"];
    [postDic setObject:[self trimValue:userPhone.text] forKey:@"customerPhone"];
    [postDic setObject:[self trimValue:userAddress.text] forKey:@"customerAddress"];
    
    if ([self trimValue:jetprivilegeNo.text].length!=0) {
        [postDic setObject:[self trimValue:jetprivilegeNo.text] forKey:@"jetMembershipNo"];
    }
    // iOS Device ID
    [postDic setObject:currentDeviceId forKey:@"customerDeviceId"];
    // iOS App ID
    [postDic setObject:deviceToken forKey:@"customerAppId"];//this is GCM sender ID
    [postDic setObject:[NSString stringWithFormat:@"%@:%@",merchantKey,userEmail.text] forKey:@"userCredentials"];

    //
    [WSC getServerResponseForUrl:postDic serviceURL:IDUpdateCustomerDetails isPOST:YES isLoder:NO auth:auth view:self.view withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        if (success) {
            //
            if([[response valueForKey:@"status"] isEqualToString:@"error"]){
                [IDLoader hideFromView:self.view animated:YES];
                [self alertWithText:nil message:[response valueForKey:@"error"]];
                return;
            }else
            {
                NSString * customerID;
                customerID=[self stringFormat:[[response valueForKey:@"result"] valueForKey:@"customerId"]];
                [UserDefault setUserID:customerID]; //add customer ID on local
                //
                if ([[UserDefault userID]intValue]!=0){
                    // update userDetails in UserDefault
                    NSMutableDictionary *userDetails=[[NSMutableDictionary alloc]init];
                    [userDetails setValue:[UserDefault userID] forKey:@"customerId"];
                    [userDetails setValue:[self trimValue:userName.text] forKey:@"name"];
                    [userDetails setValue:[self trimValue:userEmail.text] forKey:@"email"];
                    [userDetails setValue:[self trimValue:userPhone.text] forKey:@"phone"];
                    [userDetails setValue:[self trimValue:userAddress.text] forKey:@"address"];
                    //
                    NSLog(@"userDetails===>%@",userDetails);
                    [UserDefault setUserDetails:userDetails];
                    //
                }
                //  for pay to driver case
                if (_paymentActionTag==2) {
                    [self payToDriverAction];
                }else{
                    [self setDataParamsforPayment:response selectedCabInfo:selectedCabInfo];
                }
  
            }
        }else{
            [self alertWithText:nil message:error.localizedDescription];
            return;
        }
    }];
}

//  new payment code
-(void)setDataParamsforPayment:(NSDictionary*)customerCredential selectedCabInfo:(NSDictionary*)selectedCabInfo {
    //
    NSString *strTotalFare,*strAdvanceAmount,*strTotalAmount;
    //
    NSString *bkID=[[customerCredential valueForKey:@"result"] valueForKey:@"id"];
    NSString *identifier=[[customerCredential valueForKey:@"result"] valueForKey:@"identifier"];
    //
    strAdvanceAmount=[[customerCredential valueForKey:@"result"] valueForKey:@"advanceAmount"];
    strTotalAmount  =[[customerCredential valueForKey:@"result"] valueForKey:@"totalAmount"];
    //
    if ([strAdvanceAmount isEqual:[NSNull null]]) {
        strTotalFare=[self valueRoundOff:strTotalAmount];
    }else{
        strTotalFare=[self valueRoundOff:strAdvanceAmount];
    }
    //
    self.paymentParam = [PayUModelPaymentParams new];
    self.paymentParam.key = merchantKey;
    self.paymentParam.transactionID = [NSString stringWithFormat:@"%@_%@",bkID,identifier];
    self.paymentParam.amount =[NSString stringWithFormat:@"%@",strTotalFare];
    self.paymentParam.productInfo = productInfo;
    self.paymentParam.SURL = successUrl;
    self.paymentParam.FURL = failureUrl;
    self.paymentParam.firstName =[[customerCredential valueForKey:@"result"] valueForKey:@"billingName"];
    self.paymentParam.email =[[customerCredential valueForKey:@"result"] valueForKey:@"billingAddressEmail"];
    self.paymentParam.phoneNumber = [[customerCredential valueForKey:@"result"] valueForKey:@"billingAddressPhone"];
    self.paymentParam.environment =ENVIRONMENT_PRODUCTION;
    self.paymentParam.userCredentials =[NSString stringWithFormat:@"%@:%@",merchantKey,[[customerCredential valueForKey:@"result"] valueForKey:@"billingAddressEmail"]] ;
    // set hash
    [self callSDKWithHashes:[self getHashFromMTIServer:customerCredential] withError:nil customerCredential:customerCredential];
}

-(PayUModelHashes*)getHashFromMTIServer:(NSDictionary*)customerCredential{
    NSString * paymentHash;
    NSString * paymentRelatedDetailsHash;
    NSString * VASForMobileSDKHash;
    NSString * deleteUserCardHash;
    NSString * editUserCardHash;
    NSString * saveUserCardHash;
    NSString * getUserCardHash;
    
    paymentHash=[[[customerCredential valueForKey:@"result"] valueForKey:@"paymentHashKey"] valueForKey:@"payment_hash"];
    
    paymentRelatedDetailsHash=[[[customerCredential valueForKey:@"result"] valueForKey:@"paymentHashKey"] valueForKey:@"payment_related_details_for_mobile_sdk_hash"];
    
    VASForMobileSDKHash=[[[customerCredential valueForKey:@"result"] valueForKey:@"paymentHashKey"] valueForKey:@"vas_for_mobile_sdk_hash"];
    
    deleteUserCardHash=[[[customerCredential valueForKey:@"result"] valueForKey:@"paymentHashKey"] valueForKey:@"delete_user_card_hash"];
    
    editUserCardHash=[[[customerCredential valueForKey:@"result"] valueForKey:@"paymentHashKey"] valueForKey:@"edit_user_card_hash"];
    
    saveUserCardHash=[[[customerCredential valueForKey:@"result"] valueForKey:@"paymentHashKey"] valueForKey:@"save_user_card_hash"];
    
    getUserCardHash=[[[customerCredential valueForKey:@"result"] valueForKey:@"paymentHashKey"] valueForKey:@"get_user_cards_hash"];
    
    self.setPayUHashes = [PayUModelHashes new];
    self.setPayUHashes.paymentHash=paymentHash;
    self.setPayUHashes.paymentRelatedDetailsHash=paymentRelatedDetailsHash;
    self.setPayUHashes.VASForMobileSDKHash=VASForMobileSDKHash;
    self.setPayUHashes.deleteUserCardHash=deleteUserCardHash;
    self.setPayUHashes.editUserCardHash=editUserCardHash;
    self.setPayUHashes.saveUserCardHash=saveUserCardHash;
    self.setPayUHashes.getUserCardHash=getUserCardHash;
    return self.setPayUHashes;
}

//PayU Code
-(void)callSDKWithHashes:(PayUModelHashes *) allHashes withError:(NSString *) errorMessage customerCredential:(NSDictionary*)customerCredential{
    
    //
    _isUserLogin=YES;
    if (errorMessage == nil) {
        self.paymentParam.hashes = allHashes;
        if (_isUserLogin==YES){
            
            PayUSAOneTapToken *OneTapToken = [PayUSAOneTapToken new];
            [OneTapToken getOneTapTokenDictionaryFromServerWithPaymentParam:self.paymentParam CompletionBlock:^(NSDictionary *CardTokenAndMerchantHash, NSString *errorString) {
                if (errorString) {
                    [self.defaultActivityIndicator stopAnimatingActivityIndicator];
                    PAYUALERT(@"Error", errorMessage);
                }else{
                    [self callSDKWithOneTap:CardTokenAndMerchantHash customerCredential:customerCredential];
                }
            }];
            
        }
        else{
            [self callSDKWithOneTap:nil customerCredential:customerCredential];
        }
    }
    else{
        [self.defaultActivityIndicator stopAnimatingActivityIndicator];
        PAYUALERT(@"Error", errorMessage);
    }
}

-(void)callSDKWithOneTap:(NSDictionary *)oneTapDict customerCredential:(NSDictionary*)customerCredential{
    //
    if ([[UserDefault loginTag]intValue]!=0) {
        self.paymentParam.OneTapTokenDictionary = oneTapDict;
    }
    //
    PayUWebServiceResponse *respo = [PayUWebServiceResponse new];
    [respo callVASForMobileSDKWithPaymentParam:self.paymentParam];        //FORVAS1
    self.webServiceResponse = [PayUWebServiceResponse new];
    [self.webServiceResponse getPayUPaymentRelatedDetailForMobileSDK:self.paymentParam withCompletionBlock:^(PayUModelPaymentRelatedDetail *paymentRelatedDetails, NSString *errorMessage, id extraParam) {
        //
        [IDLoader hideFromView:self.view animated:YES];
        //
        if (errorMessage){
            PAYUALERT(@"Error", errorMessage);
        }
        else{
            BasePaymentView * BPV=[self.storyboard instantiateViewControllerWithIdentifier:@"BasePaymentView"];
            BPV.paymentParam=self.paymentParam;
            BPV.paymentRelatedDetail=paymentRelatedDetails;
            BPV.customerCredential=customerCredential;
            [self.navigationController pushViewController:BPV animated:YES];
        }
    }];
}
//
//
-(void)getCustomerDetails:(NSString*)customerID
{
    customerID=[self stringFormat:customerID];
    
    if([[UserDefault userID]intValue]==0){
        return;
    }else{
        if ([[UserDefault userID] intValue]==[customerID intValue]) {
            userName.text=[self validateNullValue:[[selectedCabInfo valueForKey:@"result"] valueForKey:@"billingName"] isString:TRUE];
            userEmail.text=[self validateNullValue:[[selectedCabInfo valueForKey:@"result"] valueForKey:@"billingAddressEmail"] isString:TRUE];
            userPhone.text=[self validateNullValue:[[selectedCabInfo valueForKey:@"result"] valueForKey:@"billingAddressPhone"] isString:TRUE];
            userAddress.text=[self validateNullValue:[[selectedCabInfo valueForKey:@"result"] valueForKey:@"billingAddressLine1"] isString:TRUE];
            jetprivilegeNo.text=[self validateNullValue:[[selectedCabInfo valueForKey:@"result"] valueForKey:@"jetMembershipNo"] isString:TRUE];
        }
    }
}
//
//
-(void)setUIonView:(NSInteger)sender{
    //
    CGFloat htCview=44.0+8.0;
    //
    if (sender==1){     //For Full Payment
        uvView4.hidden=false;
        uvView5.frame=CGRectMake(uvView5.frame.origin.x,uvView5.frame.origin.y+htCview,uvView5.frame.size.width,uvView5.frame.size.height);
        uvView6.frame=CGRectMake(uvView6.frame.origin.x, uvView6.frame.origin.y+htCview,uvView6.frame.size.width,uvView6.frame.size.height);
        _btnTCA.frame=CGRectMake(_btnTCA.frame.origin.x,_btnTCA.frame.origin.y+htCview, _btnTCA.frame.size.width,_btnTCA.frame.size.height);
        _btnMakePayment.frame=CGRectMake(_btnMakePayment.frame.origin.x,_btnMakePayment.frame.origin.y+htCview, _btnMakePayment.frame.size.width,_btnMakePayment.frame.size.height);
    }else{//For===>   Pay Advance   ||    Pay to Driver
        if (_paymentActionTag ==2 || _paymentActionTag==3) {
            return;
        }else{
            uvView4.hidden=true;
            uvView5.frame=CGRectMake(uvView5.frame.origin.x,uvView5.frame.origin.y-htCview,uvView5.frame.size.width,uvView5.frame.size.height);
            uvView6.frame=CGRectMake(uvView6.frame.origin.x,uvView6.frame.origin.y-htCview,uvView6.frame.size.width,uvView6.frame.size.height);
            _btnTCA.frame=CGRectMake(_btnTCA.frame.origin.x,_btnTCA.frame.origin.y-htCview, _btnTCA.frame.size.width,_btnTCA.frame.size.height);
            _btnMakePayment.frame=CGRectMake(_btnMakePayment.frame.origin.x,_btnMakePayment.frame.origin.y-htCview, _btnMakePayment.frame.size.width,_btnMakePayment.frame.size.height);
        }
    }
}


-(void)payToDriverAction{
    //
    NSString * amount;
    //
    if ([advanceAmountStr isEqual:[NSNull null]]) {
        amount=[self valueRoundOff:totalAmountStr];
    }else{
        amount=[self valueRoundOff:advanceAmountStr];
    }
    
    WebServiceClass *WSC = [[WebServiceClass alloc] init];
    NSString *auth=[self createAuth:merchantId string2:[self uniqueTstamp] string3:authPassword];
    
    NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
    //
    [postDic setObject:merchantId forKey:@"merchantId"];
    [postDic setObject:[self uniqueTstamp] forKey:@"salt"];
    //
    [postDic setObject:bookingID forKey:@"bookingId"];
    [postDic setObject:[NSNull null] forKey:@"paymentMode"];
    //[postDic setObject:amount forKey:@"amount"];
    [postDic setObject:@"payToDriver" forKey:@"paymentDetails"];
    //[postDic setObject:[NSNull null] forKey:@"referenceNumber"];
    
    [WSC getServerResponseForUrl:postDic serviceURL:IDconfirmBooking isPOST:YES isLoder:NO auth:auth view:self.view  withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        if (success) {
            //
            [IDLoader hideFromView:self.view animated:YES];
            if ([[response valueForKey:@"status"] isEqualToString:@"error"]){
                [self alertWithText:nil message:[response valueForKey:@"error"]];
                //
                return ;
            }else{
                NSLog(@"response===>%@",response);
                BookingDetailsView *BDV = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingDetailsView"];
                BDV.DyBookingDetails=[response valueForKey:@"result"];
                BDV.responseViewTag=@"1";
                [self.navigationController pushViewController:BDV animated:true];
            }
        }else{
            [self alertWithText:@"Error!" message:error.localizedDescription];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }];
}

- (IBAction)tacBtn:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.mytaxiindia.com/terms-and-conditions.php"]];
}

@end