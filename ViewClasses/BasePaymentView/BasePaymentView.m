//
//  BasePaymentView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/5/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "BasePaymentView.h"
#import "BasePaymentCell.h"
//
#import "CCDCView.h"
#import "NetBankingView.h"
#import "PayUUIStoredCardViewController.h"
#import "PayUUIEMIViewController.h"
#import "PayUUIPaymentUIWebViewController.h"
//
#import "PayUUIConstants.h"
//
#import "BookingDetailsView.h"
@interface BasePaymentView ()

@end

@implementation BasePaymentView
@synthesize customerCredential,strTotalFare;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mg=[ModalGlobal sharedManager];
    
    NSString*vehicleCategory,*strTotalAmount,*strAdvanceAmount;

    NSArray*itemsArray=[[customerCredential valueForKey:@"result"] valueForKey:@"items"];
    //
    NSString *fromStr,*toStr;
    fromStr=[self getCity:[itemsArray[0] valueForKey:@"fromCity"]];
    toStr=[self getCity:[itemsArray[0] valueForKey:@"toCity"]];
    //
    _tripLocation.text=[[NSString stringWithFormat:@"%@-%@",fromStr,toStr] capitalizedString];
    //
    strAdvanceAmount=[[customerCredential valueForKey:@"result"] valueForKey:@"advanceAmount"];
    strTotalAmount  =[[customerCredential valueForKey:@"result"] valueForKey:@"totalAmount"];
    if ([strAdvanceAmount isEqual:[NSNull null]]) {
        strTotalFare=[self valueRoundOff:strTotalAmount];
    }else{
        strTotalFare=[self valueRoundOff:strAdvanceAmount];
    }
    //
    vehicleCategory=[itemsArray[0] valueForKey:@"category"];
    //
    _pickUpDate.text=[self dateWithOrdinalStyle:self.mg.mbt.departureDate];
    _totalFare.text=[NSString stringWithFormat:@"%@%@/-",rupee,strTotalFare];
    _vehicleCategory.text=[vehicleCategory stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    
    //
    _paymentArray=[self changePaymentArrayOrder:self.paymentRelatedDetail.availablePaymentOptionsArray];
    
    [self setFlurry:@"Payment Options" params:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUI];
}

-(void)setUI{
    //    
    [self setBoxShadow:_uvView1];
    [self setBoxShadow:_uvView2];
    [self setBoxShadow:_uvView3];
    //
    [self setLabelUnderLine:_lblTitlePaymentOption];
    [self setLabelUnderLine:_lblTitleTravelSummary];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//New Code
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return 1;
    }else{
        return _paymentArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BasePaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_PAYMENT_OPTION];
    if (cell == nil) {
        cell = [[BasePaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_PAYMENT_OPTION];
    }
    
    if (indexPath.section==0) {
       cell.lblPaymentTitle.text=@"Paytm Wallet";
       [cell.imgPaymentIcon setImage:[UIImage imageNamed:@"paytm"]];
    }else{
        cell.lblPaymentTitle.text=[_paymentArray objectAtIndex:indexPath.row];
        
        NSString *PaymentImgName;
        PaymentImgName=[NSString stringWithFormat:@"PayU_%@",[_paymentArray objectAtIndex:indexPath.row]];
        PaymentImgName=[PaymentImgName stringByReplacingOccurrencesOfString:@" " withString:@""];
        PaymentImgName=[PaymentImgName stringByReplacingOccurrencesOfString:@"/" withString:@""];
        //
        [cell.imgPaymentIcon setImage:[UIImage imageNamed:PaymentImgName]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        [self payTmPayment];
    }
    else{
    if ([[_paymentArray objectAtIndex:indexPath.row]  isEqual: PAYMENT_PG_ONE_TAP_STOREDCARD]) {
        [self payByOneTapStoredCard];
    }
    if ([[_paymentArray objectAtIndex:indexPath.row]  isEqual: PAYMENT_PG_STOREDCARD]) {
        [self payByStoredCard];
    }
    if ([[_paymentArray objectAtIndex:indexPath.row]  isEqual: PAYMENT_PG_CCDC]) {
        [self payByCCDC];
    }
    if ([[_paymentArray objectAtIndex:indexPath.row]  isEqual: PAYMENT_PG_NET_BANKING]) {
        [self payByNetBanking];
    }
    if ([[_paymentArray objectAtIndex:indexPath.row]  isEqual: PAYMENT_PG_CASHCARD]) {
        [self payByCashCard];
    }
    if ([[_paymentArray objectAtIndex:indexPath.row]  isEqual: PAYMENT_PG_EMI]) {
        [self payByEMI];
    }
    if ([[_paymentArray objectAtIndex:indexPath.row]  isEqual: PAYMENT_PG_PAYU_MONEY]) {
        [self payByPayUMoney];
    }
    }
}

-(void)payByOneTapStoredCard{
    PayUUIStoredCardViewController *SCVC = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_CONTROLLER_IDENTIFIER_PAYMENT_STORED_CARD];
    SCVC.paymentType = PAYMENT_PG_ONE_TAP_STOREDCARD;
    SCVC.paymentParam = [self.paymentParam copy];
    SCVC.paymentRelatedDetail = self.paymentRelatedDetail;
    [self.navigationController pushViewController:SCVC animated:true];
}

- (void)payByCCDC{
    //
    CCDCView *CCDCVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CCDCView"];
    CCDCVC.paymentParam = [self.paymentParam copy];
    [self.navigationController pushViewController:CCDCVC animated:true];
    //
}
 
- (void)payByNetBanking{
    NetBankingView *NBVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NetBankingView"];
    NBVC.paymentParam = [self.paymentParam copy];
    NBVC.paymentRelatedDetail = self.paymentRelatedDetail;
    [self.navigationController pushViewController:NBVC animated:true];
}

- (void)payByStoredCard{
    PayUUIStoredCardViewController *SCVC = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_CONTROLLER_IDENTIFIER_PAYMENT_STORED_CARD];
    SCVC.paymentParam = [self.paymentParam copy];
    SCVC.paymentRelatedDetail = self.paymentRelatedDetail;
    [self.navigationController pushViewController:SCVC animated:true];
}

- (void)payByPayUMoney{
    PayUCreateRequest *createRequest = [PayUCreateRequest new];
    [createRequest createRequestWithPaymentParam:self.paymentParam forPaymentType:PAYMENT_PG_PAYU_MONEY withCompletionBlock:^(NSMutableURLRequest *request, NSString *postParam, NSString *error) {
        PayUUIPaymentUIWebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_CONTROLLER_IDENTIFIER_PAYMENT_UIWEBVIEW];
        webView.paymentRequest = request;
        [self.navigationController pushViewController:webView animated:true];
    }];
}

- (void)payByEMI{
    PayUUIEMIViewController *EMIVC = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_CONTROLLER_IDENTIFIER_PAYMENT_EMI];
    EMIVC.paymentParam = [self.paymentParam copy];
    EMIVC.paymentRelatedDetail = self.paymentRelatedDetail;
    [self.navigationController pushViewController:EMIVC animated:true];
}

- (void)payByCashCard{
    //
    NetBankingView *NBV = [self.storyboard instantiateViewControllerWithIdentifier:@"NetBankingView"];
    NBV.paymentParam = [self.paymentParam copy];
    NBV.paymentRelatedDetail=self.paymentRelatedDetail;
    NBV.paymentType=PAYMENT_PG_CASHCARD;
    [self.navigationController pushViewController:NBV animated:true];
}

-(void)dealloc{
    NSLog(@"Inside Dealloc of PaymentOption");
}
//New Code



//PayTM Code
+(NSString*)generateOrderIDWithPrefix:(NSString *)prefix
{
    srand ( (unsigned)time(NULL) );
    int randomNo = rand(); //just randomizing the number
    NSString *orderID = [NSString stringWithFormat:@"%@%d", prefix, randomNo];
    return orderID;
}

-(void)showController:(PGTransactionViewController *)controller
{
    if (self.navigationController != nil)
        [self.navigationController pushViewController:controller animated:YES];
    else
        [self presentViewController:controller animated:YES
                         completion:^{
                             
                         }];
}

-(void)removeController:(PGTransactionViewController *)controller
{
    if (self.navigationController != nil)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [controller dismissViewControllerAnimated:YES
                                       completion:^{
                                       }];
}


-(void)payTmPayment{
    
    PGMerchantConfiguration *mc = [PGMerchantConfiguration defaultConfiguration];
    //
    mc.checksumGenerationURL = PayTm_checksumGenerationURL;
    mc.checksumValidationURL = PayTm_checksumValidationURL;
    //
    NSMutableDictionary *orderDict = [NSMutableDictionary new];
    //Merchant configuration in the order object
    orderDict[@"MID"] = PayTm_MID;
    orderDict[@"CHANNEL_ID"] = PayTm_CHANNEL_ID;
    orderDict[@"INDUSTRY_TYPE_ID"] = PayTm_INDUSTRY_TYPE_ID;
    orderDict[@"WEBSITE"] = PayTm_WEBSITE;
    //Order configuration in the order
    //
    orderDict[@"TXN_AMOUNT"]=strTotalFare;  //strTotalFare/1
    //
    int randomNo = rand();
    NSString*bookindID=[[customerCredential valueForKey:@"result"] valueForKey:@"id"];
    orderDict[@"ORDER_ID"] =[NSString stringWithFormat:@"%d_%@",randomNo,bookindID];
    orderDict[@"CUST_ID"] = [[customerCredential valueForKey:@"result"] valueForKey:@"customerId"];
    PGOrder *order = [PGOrder orderWithParams:orderDict];
    
        PGTransactionViewController *txnController = [[PGTransactionViewController alloc] initTransactionForOrder:order];
    
        //show title var
        UIView *mNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,64)];
        mNavBar.backgroundColor =  self.navigationController.navigationBar.barTintColor;
        txnController.topBar = mNavBar;
    
        //Cancel button
        UIButton *mCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(8,self.navigationController.navigationBar.frame.origin.y,70,self.navigationController.navigationBar.frame.size.height)];
        [mCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        mCancelButton.titleLabel.textColor = [UIColor whiteColor];
        txnController.cancelButton = mCancelButton;
    
        //add title
        CGFloat x=self.view.frame.size.width/2-150/2;
        UILabel *mTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x,self.navigationController.navigationBar.frame.origin.y,150,self.navigationController.navigationBar.frame.size.height)];
        [mTitleLabel setText:@"PAYTM WALLET"];
        [mTitleLabel setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]];
        [mTitleLabel setTextAlignment:NSTextAlignmentCenter];
        mTitleLabel.textColor = [UIColor whiteColor];
        [mNavBar addSubview:mTitleLabel];
        //
    
        txnController.serverType = PayTm_serverUrl;
        txnController.merchant = mc;
        txnController.delegate = self;
        [txnController.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self showController:txnController];
}


#pragma mark PGTransactionViewController delegate

- (void)didSucceedTransaction:(PGTransactionViewController *)controller
                     response:(NSDictionary *)response{
    //DEBUGLOG(@"ViewController::didSucceedTransactionresponse= %@", response);
    NSString *title = [NSString stringWithFormat:@"Your Paytm Transaction has been successfully processed."];
    [[[UIAlertView alloc] initWithTitle:nil message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    //
    //[self removeController:controller];
    [self payToPayTMAction:response];
}

- (void)didFailTransaction:(PGTransactionViewController *)controller error:(NSError *)error response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didFailTransaction error = %@ response= %@", error, response);
    if (response)
    {
        [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:[response description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else if (error)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    [self removeController:controller];
}

- (void)didCancelTransaction:(PGTransactionViewController *)controller error:(NSError*)error response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didCancelTransaction error = %@ response= %@", error, response);
    //
//    NSString *msg = nil;
//    if (!error) msg = [NSString stringWithFormat:@"Successful"];
//    else msg = [NSString stringWithFormat:@"UnSuccessful"];
//    
//    [[[UIAlertView alloc] initWithTitle:@"Transaction Cancel" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    //
    [self removeController:controller];
}

- (void)didFinishCASTransaction:(PGTransactionViewController *)controller response:(NSDictionary *)response{
    DEBUGLOG(@"ViewController::didFinishCASTransaction:response = %@", response);
}


-(void)payToPayTMAction:(NSDictionary*)response{
    //
    WebServiceClass *WSC = [[WebServiceClass alloc] init];
    NSString *auth=[self createAuth:merchantId string2:[self uniqueTstamp] string3:authPassword];
    
    NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
    //
    [postDic setObject:merchantId forKey:@"merchantId"];
    [postDic setObject:[self uniqueTstamp] forKey:@"salt"];
    //
    [postDic setObject:[self splitString:[response valueForKey:@"ORDERID"] pattern:@"_"][1] forKey:@"bookingId"];
    [postDic setObject:[response valueForKey:@"PAYMENTMODE"] forKey:@"paymentMode"];
    [postDic setObject:[response valueForKey:@"TXNAMOUNT"] forKey:@"amount"];
    [postDic setObject:@"PAYTM" forKey:@"paymentDetails"];
    [postDic setObject:[response valueForKey:@"TXNID"] forKey:@"referenceNumber"];
    
    [WSC getServerResponseForUrl:postDic serviceURL:IDconfirmBooking isPOST:YES isLoder:YES auth:auth view:self.view  withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        if (success) {
            //
            if ([[response valueForKey:@"status"] isEqualToString:@"error"]){
                [self alertWithText:nil message:[response valueForKey:@"error"]];
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

-(NSArray*)changePaymentArrayOrder:(NSArray*)paymentArray{
    //
    NSMutableArray *newArray=[[NSMutableArray alloc]init];
    
    if ([paymentArray containsObject: @"Credit Card/Debit Card"]){
        [newArray addObject:@"Credit Card/Debit Card"];
    }
    if ([paymentArray containsObject: @"NetBanking"]){
        [newArray addObject:@"NetBanking"];
    }
    if ([paymentArray containsObject: @"PayU Money"]){
        [newArray addObject:@"PayU Money"];
    }
    if ([paymentArray containsObject: @"Stored Card"]){
        [newArray addObject:@"Stored Card"];
    }
    if ([paymentArray containsObject: @"EMI"]){
        [newArray addObject:@"EMI"];
    }
    if ([paymentArray containsObject: @"Cash Card"]){
        [newArray addObject:@"Cash Card"];
    }
    if ([paymentArray containsObject: @"One Tap Stored Card"]){
        [newArray addObject:@"One Tap Stored Card"];
    }
    return [NSArray arrayWithArray:newArray];
}
@end
