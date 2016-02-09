//
//  PayUUIPaymentUIWebViewController.m
//  SeamlessTestApp
//
//  Created by Umang Arya on 07/10/15.
//  Copyright © 2015 PayU. All rights reserved.
//

#import "PayUUIPaymentUIWebViewController.h"
#import "WebViewJavascriptBridge.h"
#import "PayUHeader.h"

#import "BasePaymentView.h"
//#import "PayU_CB_SDK.h"

@interface PayUUIPaymentUIWebViewController ()
@property WebViewJavascriptBridge* PayU;
@property (nonatomic,strong) UIAlertView *alertView;

//@property (strong, nonatomic) CBConnection *CBC;

@end

@implementation PayUUIPaymentUIWebViewController
@synthesize selectedCabInfo,finalresponseDic;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.paymentWebView.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [_CBC logTxnTerminateEvent];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    
    _PayU = [WebViewJavascriptBridge bridgeForWebView:_paymentWebView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback){
        
    NSLog(@"ObjC received message from JS: %@", data);
    if (data)
    {
        finalresponseDic=[self stringToDictiory:data];
        if ([[finalresponseDic valueForKey:@"status"] isEqualToString:@"failure"]) {
            ErroView *EV = [self.storyboard instantiateViewControllerWithIdentifier:@"ErroView"];
            EV.errorMsgStr=[finalresponseDic valueForKey:@"error_Message"];
            [self.navigationController pushViewController:EV animated:true];
            
        }else
        {
            WebServiceClass *WSC = [[WebServiceClass alloc] init];
            NSString *auth=[self createAuth:merchantId string2:[self uniqueTstamp] string3:authPassword];
            NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
            [postDic setObject:merchantId forKey:@"merchantId"];
            [postDic setObject:[self uniqueTstamp] forKey:@"salt"];
            
            [postDic setObject:[[selectedCabInfo valueForKey:@"result"] valueForKey:@"id"] forKey:@"bookingId"];
        
            [postDic setObject:[finalresponseDic valueForKey:@"mode"] forKey:@"paymentMode"];
            [postDic setObject:[finalresponseDic valueForKey:@"amount"] forKey:@"amount"];
            [postDic setObject:[finalresponseDic valueForKey:@"productinfo"]  forKey:@"paymentDetails"];
            [postDic setObject:[finalresponseDic valueForKey:@"mihpayid"] forKey:@"referenceNumber"];
            
            [WSC getServerResponseForUrl:postDic serviceURL:IDconfirmBooking isPOST:YES isLoder:NO auth:auth view:self.view  withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
                if (success) {
                    
                    if ([[response valueForKey:@"status"] isEqualToString:@"error"])
                    {
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
    }];

    [self.paymentWebView loadRequest:self.paymentRequest];
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidesWhenStopped:YES];
}

#pragma UIWebView delegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self.activityIndicator startAnimating];
//    [_CBC payUwebView:webView shouldStartLoadWithRequest:request];
    return true;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.activityIndicator startAnimating];
    NSLog(@"webViewDidStartLoad URL----->%@",webView.request.URL);
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityIndicator stopAnimating];
//    [_CBC payUwebViewDidFinishLoad:webView];
    NSLog(@"webViewDidFinishLoad URL----->%@",webView.request.URL);
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    NSLog(@"webViewDidfailLoad URL----->%@",webView.request.URL);
     [self.activityIndicator stopAnimating];
//    [_CBC payUwebView:webView didFailLoadWithError:error];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Back Button Handling

-(BOOL) navigationShouldPopOnBackButton
{
    self.alertView = [[UIAlertView alloc]initWithTitle:@"Confirmation" message:@"Do you want to cancel this transaction?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] ;
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
        //[self.navigationController popToRootViewControllerAnimated:true];
    }
}

-(NSMutableDictionary*)stringToDictiory:(NSString*)string{
    NSArray *stringArray=[string componentsSeparatedByString:@","];
    NSMutableDictionary *finalDic=[[NSMutableDictionary alloc]init];
    
    for (int x=0; x<stringArray.count; x++) {
        NSArray *arrayVal=[[stringArray objectAtIndex:x] componentsSeparatedByString:@"="];
        [finalDic setObject:[arrayVal objectAtIndex:1] forKey:[arrayVal objectAtIndex:0]];
    }
    //NSLog(@"finalDic==>%@",finalDic);
    return finalDic;
}

-(IBAction)backBtnAlertAction
{
    [self navigationShouldPopOnBackButton];
}
@end
