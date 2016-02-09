//
//  BasePaymentView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/5/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "BasePaymentView.h"

#import "PayUUIStoredCardViewController.h"
#import "PayUUIPaymentOptionViewController.h"


#import "PayUUIConstants.h"
#import "PayUSAGetHashes.h"
#import "iOSDefaultActivityIndicator.h"
#import "PayUSAGetTransactionID.h"
#import "PayUUIEMIViewController.h"

@interface BasePaymentView ()

@end

@implementation BasePaymentView
@synthesize customerCredential,selectedCabInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mg=[ModalGlobal sharedManager];
    
    NSString*from,*to,*vehicleCategory,*strTotalAmount,*strAdvanceAmount;
    from=[self validateNullValue:[[customerCredential valueForKey:@"result"] valueForKey:@"from"] isString:YES];
    to=[self validateNullValue:[[customerCredential valueForKey:@"result"] valueForKey:@"to"] isString:YES];
    //
    strAdvanceAmount=[[customerCredential valueForKey:@"result"] valueForKey:@"advanceAmount"];
    strTotalAmount  =[[customerCredential valueForKey:@"result"] valueForKey:@"totalAmount"];
    
    if ([strAdvanceAmount isEqual:[NSNull null]]) {
        strTotalFare=[self valueRoundOff:strTotalAmount];
    }else{
        strTotalFare=[self valueRoundOff:strAdvanceAmount];
    }
    
    vehicleCategory=[[[customerCredential valueForKey:@"result"] valueForKey:@"items"][0]valueForKey:@"category"];
    
    _pickUpDate.text=[self dateWithOrdinalStyle:self.mg.mbt.departureDate];
    _tripLocation.text=[[NSString stringWithFormat:@"%@-%@",from,to] capitalizedString];
    _totalFare.text=[NSString stringWithFormat:@"%@%@/-",rupee,strTotalFare];
    _vehicleCategory.text=[vehicleCategory stringByReplacingOccurrencesOfString:@"_" withString:@" "];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUI];
}


-(void)setUI{
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat screenHeight = screenRect.size.height;
//    if (screenHeight==480){
//        _svBar.contentSize=CGSizeMake(_svBar.frame.size.width,504);
//    }
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


-(PayUModelHashes*)getHashFromMTIServer{ 
    
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



-(void)dataReceived:(NSNotification *)noti
{
    NSLog(@"dataReceived from surl/furl:%@", noti.object);
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSString *message = [NSString stringWithFormat:@"%@",noti.object];
    
    [self alertWithText:nil message:message];
    //PAYUALERT(@"Status", message);
}


//-(IBAction)bankingAction:(id)sender
//{
//    [self action];
//}
//
//
//-(IBAction)netbankingAction:(id)sender
//{
//    [self netBanking];
//}



- (IBAction)bankingAction:(id)sender {
    
    dispatch_async (dispatch_get_main_queue(), ^{
        [IDLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    });
    
    UIButton *instanceButton = (UIButton*)sender;
    
    NSString *bookingID=[[customerCredential valueForKey:@"result"] valueForKey:@"id"];
    NSString *identifier=[[customerCredential valueForKey:@"result"] valueForKey:@"identifier"];
    

    self.paymentParam = [PayUModelPaymentParams new];
    self.paymentParam.key = merchantKey;
    self.paymentParam.transactionID = [NSString stringWithFormat:@"%@_%@",bookingID,identifier];
    //self.paymentParam.amount =[NSString stringWithFormat:@"%@",strTotalFare];
    self.paymentParam.amount =[NSString stringWithFormat:@"%@",strTotalFare];
    self.paymentParam.productInfo = productInfo;
    self.paymentParam.SURL = successUrl;
    self.paymentParam.FURL = failureUrl;
    self.paymentParam.firstName =[[customerCredential valueForKey:@"result"] valueForKey:@"billingName"];
    self.paymentParam.email =[[customerCredential valueForKey:@"result"] valueForKey:@"billingAddressEmail"];
    self.paymentParam.phoneNumber = [[customerCredential valueForKey:@"result"] valueForKey:@"billingAddressPhone"];
    self.paymentParam.environment =ENVIRONMENT_MOBILETEST;
    self.paymentParam.userCredentials =[NSString stringWithFormat:@"%@:%@",merchantKey,[[customerCredential valueForKey:@"result"] valueForKey:@"billingAddressEmail"]] ;
    //[self.defaultActivityIndicator startAnimatingActivityIndicatorWithSelfView:self.view];
    
   // self.view.userInteractionEnabled = NO;
    self.paymentParam.hashes =[self getHashFromMTIServer];
    
    PayUWebServiceResponse *respo = [PayUWebServiceResponse new];
    [respo callVASForMobileSDKWithPaymentParam:self.paymentParam];
    
    //FORVAS1
    self.webServiceResponse = [PayUWebServiceResponse new];
    [self.webServiceResponse getPayUPaymentRelatedDetailForMobileSDK:self.paymentParam withCompletionBlock:^(PayUModelPaymentRelatedDetail *paymentRelatedDetails, NSString *errorMessage, id extraParam) {
        
        //[self.defaultActivityIndicator stopAnimatingActivityIndicator];
        [IDLoader hideFromView:self.view animated:YES];
        
        if (errorMessage) {
            PAYUALERT(@"Error", errorMessage);
        }
        else{
            switch (instanceButton.tag) {
                case 1:{
                    //
                    CCDCView *CCDCVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CCDCView"];
                    CCDCVC.paymentParam = self.paymentParam;
                    CCDCVC.selectedCabInfo=selectedCabInfo;
                    [self.navigationController pushViewController:CCDCVC animated:true];
                    break;
                }case 2:{
                    //
                    NetBankingView *NBV = [self.storyboard instantiateViewControllerWithIdentifier:@"NetBankingView"];
                    NBV.paymentParam = self.paymentParam;
                    NBV.selectedCabInfo=selectedCabInfo;
                    NBV.paymentRelatedDetail=paymentRelatedDetails;
                    NBV.paymentType=PAYMENT_PG_NET_BANKING;
                    [self.navigationController pushViewController:NBV animated:true];
                    break;
                }case 3:{
                    //
                    PayUCreateRequest *createRequest = [PayUCreateRequest new];
                    [createRequest createRequestWithPaymentParam:self.paymentParam forPaymentType:PAYMENT_PG_PAYU_MONEY withCompletionBlock:^(NSMutableURLRequest *request, NSString *postParam, NSString *error) {
                        PayUUIPaymentUIWebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_CONTROLLER_IDENTIFIER_PAYMENT_UIWEBVIEW];
                        webView.paymentRequest = request;
                        [self.navigationController pushViewController:webView animated:true];
                    }];
                    break;
                }case 4:{
                    PayUUIEMIViewController *EMIVC = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_CONTROLLER_IDENTIFIER_PAYMENT_EMI];
                    EMIVC.paymentParam = self.paymentParam;
                    EMIVC.paymentRelatedDetail = paymentRelatedDetails;
                    EMIVC.paymentType=PAYMENT_PG_EMI;
                    [self.navigationController pushViewController:EMIVC animated:true];
                    break;
                }case 5:{
                    //
                    NetBankingView *NBV = [self.storyboard instantiateViewControllerWithIdentifier:@"NetBankingView"];
                    NBV.paymentParam = self.paymentParam;
                    NBV.selectedCabInfo=selectedCabInfo;
                    NBV.paymentRelatedDetail=paymentRelatedDetails;
                    NBV.paymentType=PAYMENT_PG_CASHCARD;
                    [self.navigationController pushViewController:NBV animated:true];
                    break;
                }case 6:{
                    
//                    PayUUIStoredCardViewController *SCVC = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_CONTROLLER_IDENTIFIER_PAYMENT_STORED_CARD];
//                    SCVC.paymentParam = self.paymentParam;
//                    SCVC.paymentRelatedDetail =paymentRelatedDetails;
//                    [self.navigationController pushViewController:SCVC animated:true];
                    
                    
                    if ([paymentRelatedDetails.availablePaymentOptionsArray containsObject:@"Stored Card"]) // YES
                    {
                        PayUUIStoredCardViewController *SCVC = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_CONTROLLER_IDENTIFIER_PAYMENT_STORED_CARD];
                        SCVC.paymentParam = self.paymentParam;
                        SCVC.selectedCabInfo=selectedCabInfo;
                        SCVC.paymentRelatedDetail =paymentRelatedDetails;
                        [self.navigationController pushViewController:SCVC animated:true];
                    }else{
                        [self alertWithText:nil message:@"No Saved Card"];
                    }
                    break;
                }
                default:
                    break;
            }
        }
    }];    
}
@end
