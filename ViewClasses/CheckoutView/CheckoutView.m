//
//  CheckoutView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/3/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "CheckoutView.h"

@interface CheckoutView ()

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
    _isFullPayment=YES;

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
    [self GATrackOnView:NSStringFromClass(self.class) kGAIScreenName:kGAIScreenName];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setUI{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if (screenHeight<600){
      _TPscrollBar.contentSize=CGSizeMake(_TPscrollBar.frame.size.width,600);
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
    [self setTextBoxLine:couponText];
    
    
    //[self setButtonShadow:_btnApplyCoupon];
    //[self setButtonShadow:_btnMakePayment];
    
    //
    [self setLabelUnderLine:_lblTitleCollection];
    [self setLabelUnderLine:_lblTitleCoupon];
    [self setLabelUnderLine:_lblTitleCustomerDetails];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)setDataOnView
{
    //
    _departureDate.text=[self dateWithOrdinalStyle:self.mg.mbt.departureDate];
    
    //
    baseFareStr=[[selectedCabInfo valueForKey:@"result"] valueForKey:@"netAmount"];
    discountStr=[[selectedCabInfo valueForKey:@"result"] valueForKey:@"discount"];
    serviceTaxStr=[[selectedCabInfo valueForKey:@"result"] valueForKey:@"serviceTax"];
    totalAmountStr=[[selectedCabInfo valueForKey:@"result"] valueForKey:@"totalAmount"];
    advanceAmountStr=[[selectedCabInfo valueForKey:@"result"] valueForKey:@"advanceAmount"];
    
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
    NSString *fromStr,*toStr;
    fromStr=[[selectedCabInfo valueForKey:@"result"] valueForKey:@"from"];
    toStr=[[selectedCabInfo valueForKey:@"result"] valueForKey:@"to"];
    location.text=[[NSString stringWithFormat:@"%@-%@",fromStr,toStr] capitalizedString];
    
    //
    bookingID=[self validateNullValue:[[[selectedCabInfo valueForKey:@"result"] valueForKey:@"items"][0] valueForKey:@"bookingId"] isString:NO];
    
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
                [self alertWithText:@"" message:[NSString stringWithFormat:@"Coupon successfully applied. %@",cMsg]];
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
        else{
            [self callActionService];
        }
}

- (IBAction)paymentAction:(UIButton *)sender {

    
    if (sender.tag==1 && _isFullPayment==NO) {        // for Full payment
        //
        NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
        //
        [postDic setObject:merchantId forKey:@"merchantId"];
        [postDic setObject:[self uniqueTstamp] forKey:@"salt"];
        //
        _isFullPayment=YES;
        //
        [self setUIonView:1];
        //
        [postDic setObject:bookingID forKey:@"bookingId"];
        [postDic setObject:@"false" forKey:@"advancePayment"];
        //
        _btnPayAdvance.backgroundColor=[self colorWithCode:@"0195c3"];
        _btnPayFull.backgroundColor=[self colorWithCode:@"666666"];
        //
        [self callPaymentService:postDic];
        //
    }else if (sender.tag==2 && _isFullPayment==YES){   //for pay advance
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:couponActionMsg
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
        [alert show];
    }else{
        return;
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0: //"No" pressed
            break;
        case 1:{    //"YES"
            //
            [self setUIonView:2];
            //
            _isFullPayment=NO;
            //
            _btnPayAdvance.backgroundColor=[self colorWithCode:@"666666"];
            _btnPayFull.backgroundColor=[self colorWithCode:@"0195c3"];
            //
            NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
            //
            [postDic setObject:merchantId forKey:@"merchantId"];
            [postDic setObject:[self uniqueTstamp] forKey:@"salt"];
            //
            [postDic setObject:bookingID forKey:@"bookingId"];
            [postDic setObject:@"true" forKey:@"advancePayment"];
            //
            [self callPaymentService:postDic];
             break;
        }
           
    }
}


-(void)callPaymentService:(NSDictionary*)postDic{
    //
    WebServiceClass *WSC = [[WebServiceClass alloc] init];
    NSString *auth=[self createAuth:merchantId string2:[self uniqueTstamp] string3:authPassword];

    //
    [WSC getServerResponseForUrl:postDic serviceURL:IDAdvancePayment isPOST:YES isLoder:YES  auth:auth view:self.view withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        if (success) {
            if([[response valueForKey:@"status"] isEqualToString:@"error"]){
                [self alertWithText:nil message:[response valueForKey:@"error"]];
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
                
                if ([advanceAmountStr isEqual:[NSNull null]]) {
                    advanceAmount.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self valueRoundOff:totalAmountStr]];
                }else{
                    advanceAmount.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self valueRoundOff:advanceAmountStr]];
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
    
    // iOS Device ID
    [postDic setObject:currentDeviceId forKey:@"customerDeviceId"];
    // iOS App ID
    
    [postDic setObject:deviceToken forKey:@"customerAppId"];//this is GCM sender ID
    
    [postDic setObject:[NSString stringWithFormat:@"%@:%@",merchantKey,userEmail.text] forKey:@"userCredentials"];

    [WSC getServerResponseForUrl:postDic serviceURL:IDupdateCustomerDetails isPOST:YES isLoder:YES auth:auth view:self.view withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        if (success) {
            if([[response valueForKey:@"status"] isEqualToString:@"error"]){
                [self alertWithText:nil message:[response valueForKey:@"error"]];
                return;
            }else
            {
                NSString * customerID;
                customerID=[self stringFormat:[[response valueForKey:@"result"] valueForKey:@"customerId"]];
                [UserDefault setUserID:customerID];
                //bookingId=[self stringFormat:[[response valueForKey:@"result"] valueForKey:@"bookingId"]];
                
                [UserDefault setUserID:customerID]; //add customer ID on local
                //[UserDefault setBookingID:bookingId];
                
                BasePaymentView * BPV=[self.storyboard instantiateViewControllerWithIdentifier:@"BasePaymentView"];
                BPV.customerCredential=response;
                BPV.selectedCabInfo=selectedCabInfo;
                [self.navigationController pushViewController:BPV animated:YES];
            }
        }else{
            [self alertWithText:nil message:error.localizedDescription];
            return;
        }
    }];
}

-(void)getCustomerDetails:(NSString*)customerID
{
    customerID=[self stringFormat:customerID];
    
    if ([customerID isEqual:[NSNull null]]){
        return;
    }else{
        if ([[UserDefault userID] isEqualToString:customerID]) {
            userName.text=[self validateNullValue:[[selectedCabInfo valueForKey:@"result"] valueForKey:@"billingName"] isString:TRUE];
            userEmail.text=[self validateNullValue:[[selectedCabInfo valueForKey:@"result"] valueForKey:@"billingAddressEmail"] isString:TRUE];
            userPhone.text=[self validateNullValue:[[selectedCabInfo valueForKey:@"result"] valueForKey:@"billingAddressPhone"] isString:TRUE];
            userAddress.text=[self validateNullValue:[[selectedCabInfo valueForKey:@"result"] valueForKey:@"billingAddressLine1"] isString:TRUE];
        }
    }
}

-(void)setUIonView:(NSInteger)sender{
    //
        CGFloat htCview=80.0;
    //
    if (sender==1){     //For Full Payment
        uvView4.hidden=false;
        uvView5.frame=CGRectMake(uvView5.frame.origin.x,uvView5.frame.origin.y+htCview,uvView5.frame.size.width,uvView5.frame.size.height);
        uvView6.frame=CGRectMake(uvView6.frame.origin.x, uvView6.frame.origin.y+htCview,uvView6.frame.size.width,uvView6.frame.size.height);
        _btnMakePayment.frame=CGRectMake(_btnMakePayment.frame.origin.x,_btnMakePayment.frame.origin.y+htCview, _btnMakePayment.frame.size.width,_btnMakePayment.frame.size.height);
    }else{      //For Advance Payment
        uvView4.hidden=true;
        uvView5.frame=CGRectMake(uvView5.frame.origin.x,uvView5.frame.origin.y-htCview,uvView5.frame.size.width,uvView5.frame.size.height);
        uvView6.frame=CGRectMake(uvView6.frame.origin.x,uvView6.frame.origin.y-htCview,uvView6.frame.size.width,uvView6.frame.size.height);
        _btnMakePayment.frame=CGRectMake(_btnMakePayment.frame.origin.x,_btnMakePayment.frame.origin.y-htCview, _btnMakePayment.frame.size.width,_btnMakePayment.frame.size.height);
    }
}
@end