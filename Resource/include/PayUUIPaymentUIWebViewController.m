//
//  PayUUIPaymentUIWebViewController.m
//  SeamlessTestApp
//
//  Created by Umang Arya on 07/10/15.
//  Copyright © 2015 PayU. All rights reserved.
//

#import "PayUUIPaymentUIWebViewController.h"
#import "WebViewJavascriptBridge.h"

@interface PayUUIPaymentUIWebViewController ()
@property WebViewJavascriptBridge* PayU;

@end

@implementation PayUUIPaymentUIWebViewController
@synthesize selectedCabInfo,finalresponseDic;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.paymentWebView.delegate = self;
    
    
    NSLog(@"selectedCabInfo===>%@",selectedCabInfo);
}

- (void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:true];
    _PayU = [WebViewJavascriptBridge bridgeForWebView:_paymentWebView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback){
                 
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
            
            [WSC getServerResponseForUrl:postDic serviceURL:IDconfirmBooking isPOST:YES isLoder:YES auth:auth view:self.view  withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
                if (success) {
                    
                    if ([[response valueForKey:@"status"] isEqualToString:@"error"])
                    {
                        [self alertWithText:@"Error!" message:[response valueForKey:@"error"]];
                        return ;
                    }else{
                        NSLog(@"response===>%@",response);
                        
                        ThankYouView *TYV = [self.storyboard instantiateViewControllerWithIdentifier:@"ThankYouView"];
                        TYV.confirmResponse=response;
                        [self.navigationController pushViewController:TYV animated:true];
                    }
                }else{
                    NSLog(@"error===>%@",error.localizedDescription);
                    [self alertWithText:nil message:error.localizedDescription];
                    return;
                }
            }];
            
            NSLog(@"ObjC received message from JS: %@", data);
            NSLog(@"array==>%@",[data componentsSeparatedByString:@","]);
            if(data)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"passData" object:[NSMutableData dataWithData:data ]];
                responseCallback(@"Response for message from ObjC");
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
    return true;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.activityIndicator startAnimating];
    NSLog(@"webViewDidStartLoad URL----->%@",webView.request.URL);
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityIndicator stopAnimating];
    NSLog(@"webViewDidFinishLoad URL----->%@",webView.request.URL);
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    NSLog(@"webViewDidfailLoad URL----->%@",webView.request.URL);
    [self.activityIndicator stopAnimating];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
@end
