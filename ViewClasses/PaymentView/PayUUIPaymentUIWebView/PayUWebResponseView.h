//
//  PayUWebResponseView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 2/24/16.
//  Copyright © 2016 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayUHeader.h"

@interface PayUWebResponseView : UIViewController<UIWebViewDelegate,PayUSDKWebViewResponseDelegate>
@property(nonatomic,strong) NSURLRequest *paymentRequest;
@property (strong,nonatomic) PayUModelPaymentParams *paymentParam;

@property (unsafe_unretained, nonatomic) IBOutlet UIWebView *paymentWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
