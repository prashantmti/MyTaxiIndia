//
//  PayUUIPaymentUIWebViewController.m
//  SeamlessTestApp
//
//  Created by Umang Arya on 07/10/15.
//  Copyright © 2015 PayU. All rights reserved.
//

#import "PayUUIPaymentUIWebViewController.h"
#import "PayUHeader.h"
#import "PayUUIConstants.h"
#import "PayU_CB_SDK.h"

//
#import "PayUSAGetHashes.h"
#import "iOSDefaultActivityIndicator.h"
#import "PayUSAGetTransactionID.h"
#import "PayUSAOneTapToken.h"

//
#import "BookingDetailsView.h"
#import "CheckoutView.h"
#import "BasePaymentView.h"

@interface PayUUIPaymentUIWebViewController ()<PayUCBWebViewResponseDelegate>
@property(strong, nonatomic) PayUWebViewResponse *webViewResponse;
@property (strong, nonatomic) CBConnection *CBC;
@property (nonatomic,strong) UIAlertView *alertView;
@property BOOL showActivityIndicator;
@end


@implementation PayUUIPaymentUIWebViewController
@synthesize finalresponseDic;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showActivityIndicator = YES;
    [self.activityIndicator setHidesWhenStopped:YES];
    
    self.paymentWebView.delegate = self;
    //    [self configurePayUResponse];
    [self configurCB];
    if (!self.showActivityIndicator) {
        [self.activityIndicator setHidden:true];
    }
    [self.paymentWebView loadRequest:self.paymentRequest];
}

-(void)configurePayUResponse{
    self.webViewResponse = [PayUWebViewResponse new];
    self.webViewResponse.delegate = self;
}

-(void)configurCB{
    self.showActivityIndicator = NO;
    self.CBC = [[CBConnection alloc] init:self.view webView:self.paymentWebView];
    self.CBC.isWKWebView = NO;
    self.CBC.cbServerID = CB_ENVIRONMENT_SDKTEST;
    self.CBC.analyticsServerID = CB_ENVIRONMENT_SDKTEST;
    self.CBC.merchantKey = self.paymentParam.key;
    self.CBC.txnID = self.paymentParam.transactionID;
    self.CBC.isAutoOTPSelect = YES;
    self.CBC.cbWebViewResponseDelegate = self;
    [self.CBC payUActivityIndicator];
    [self.CBC initialSetup];
    
    if (self.CBC == nil) {
        [self configurePayUResponse];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    
}


#pragma UIWebView delegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self startActivityIndicator];
    NSLog(@"shouldStartLoadWithRequest %@",[[request URL] absoluteString]);
    [self.CBC payUwebView:webView shouldStartLoadWithRequest:request];
    [self.webViewResponse initialSetupForWebView:webView];
    return true;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self startActivityIndicator];
    NSLog(@"webViewDidStartLoad URL----->%@",webView.request.URL);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self stopActivityIndicator];
    NSLog(@"webViewDidFinishLoad URL----->%@",webView.request.URL);
    [self.CBC payUwebViewDidFinishLoad:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    NSLog(@"webViewDidfailLoad URL----->%@",webView.request.URL);
    NSLog(@"%@",error.localizedDescription);
    [self stopActivityIndicator];
    [self.CBC payUwebView:webView didFailLoadWithError:error];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    NSLog(@"Inside Dealloc of webview");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:true];
    NSLog(@"Inside viewWillDisappear");
}

-(void)PayUSuccessResponse:(id)response{
        if(response)
        {
            finalresponseDic=[self stringToDictiory:response];
            if ([[finalresponseDic valueForKey:@"status"] isEqualToString:@"failure"]) {
                ErroView *EV = [self.storyboard instantiateViewControllerWithIdentifier:@"ErroView"];
                EV.errorMsgStr=[finalresponseDic valueForKey:@"Error_Message"];
                [self.navigationController pushViewController:EV animated:true];
            }else
            {
                // save hash on sever
                    NSString *merchant_hash = [finalresponseDic valueForKey:@"merchant_hash"];
                    if ([[finalresponseDic objectForKey:@"card_token"] length] >1 && merchant_hash.length >1 && self.paymentParam) {
                        //
                        PayUSAOneTapToken *merchantHash = [PayUSAOneTapToken new];
                        [merchantHash saveOneTapTokenForMerchantKey:self.paymentParam.key withCardToken:[finalresponseDic objectForKey:@"card_token"] withUserCredential:self.paymentParam.userCredentials andMerchantHash:merchant_hash withCompletionBlock:^(NSString *message, NSString *errorString) {
                            //
                            if (errorString == nil) {
                                NSLog(@"Response From merchant Hash Server %@",message);
                            }
                            else{
                                NSLog(@"Error from merchant Hash Server %@", errorString);
                            }
                        }];
                    }
                //
                WebServiceClass *WSC = [[WebServiceClass alloc] init];
                NSString *auth=[self createAuth:merchantId string2:[self uniqueTstamp] string3:authPassword];
                NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
                [postDic setObject:merchantId forKey:@"merchantId"];
                [postDic setObject:[self uniqueTstamp] forKey:@"salt"];
                //
                [postDic setObject:[self splitString:self.paymentParam.transactionID pattern:@"_"][0] forKey:@"bookingId"];
                //
                [postDic setObject:[finalresponseDic valueForKey:@"mode"] forKey:@"paymentMode"];
                [postDic setObject:[finalresponseDic valueForKey:@"transaction_fee"] forKey:@"amount"];
                [postDic setObject:[finalresponseDic valueForKey:@"productinfo"]  forKey:@"paymentDetails"];
                [postDic setObject:[finalresponseDic valueForKey:@"id"] forKey:@"referenceNumber"];
    
                [WSC getServerResponseForUrl:postDic serviceURL:IDconfirmBooking isPOST:YES isLoder:NO auth:auth view:self.view  withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
                    if (success) {
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
        }
}
-(void)PayUFailureResponse:(id)response{
    NSLog(@"PayUFailureResponse===>%@",response);
    finalresponseDic=[self stringToDictiory:response];
    //
    if ([[finalresponseDic valueForKey:@"status"] isEqualToString:@"failure"]) {
        ErroView *EV = [self.storyboard instantiateViewControllerWithIdentifier:@"ErroView"];
        EV.errorMsgStr=[finalresponseDic valueForKey:@"field9"];
        [self.navigationController pushViewController:EV animated:true];
    }
}

-(void)PayUConnectionError:(id)notification{
    self.alertView = [[UIAlertView alloc]initWithTitle:@"Network Error!" message:@"Seems you are not connected to internet" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    self.alertView.tag = 501;
    [self.alertView show];
}

-(void)startActivityIndicator{
    if (self.showActivityIndicator) {
        [self.activityIndicator startAnimating];
    }
}

-(void)stopActivityIndicator{
    [self.activityIndicator stopAnimating];
}



-(NSDictionary*)stringToDictiory:(NSString*)string{
    //
    NSData *webData = [string dataUsingEncoding:NSUTF8StringEncoding];
    //
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&error];
    return jsonDict;
}

-(IBAction)backBtnAlertAction
{
    [self navigationShouldPopOnBackButton];
}

#pragma mark - Back Button Handling

-(BOOL) navigationShouldPopOnBackButton
{
    self.alertView = [[UIAlertView alloc]initWithTitle:@"Confirmation!" message:@"Do you want to cancel this transaction?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    self.alertView.tag = 502;
    [self.alertView show];
    return NO;
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            
            if ([controller isKindOfClass:[CheckoutView class]]) {
                
                [self.navigationController popToViewController:controller
                                                      animated:YES];
                break;
            }
        }
    }
}
@end
