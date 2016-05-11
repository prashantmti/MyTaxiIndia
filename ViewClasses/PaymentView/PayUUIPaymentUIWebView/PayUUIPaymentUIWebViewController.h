//
//  PayUUIPaymentUIWebViewController.h
//  SeamlessTestApp
//
//  Created by Umang Arya on 07/10/15.
//  Copyright © 2015 PayU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayUHeader.h"

@interface PayUUIPaymentUIWebViewController : BaseView<UIWebViewDelegate,PayUSDKWebViewResponseDelegate>

@property(nonatomic,strong) NSURLRequest *paymentRequest;
@property (strong,nonatomic) PayUModelPaymentParams *paymentParam;
@property (weak, nonatomic) IBOutlet UIWebView *paymentWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (strong, nonatomic) NSString *merchantKey;
@property (strong, nonatomic) NSString *txnID;
@property(strong, nonatomic) NSDictionary *finalresponseDic;
@end
