//
//  PayUUIPaymentUIWebViewController.h
//  SeamlessTestApp
//
//  Created by Umang Arya on 07/10/15.
//  Copyright © 2015 PayU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingDetailsView.h"


//
#import "CheckoutView.h"

@interface PayUUIPaymentUIWebViewController : BaseView<UIWebViewDelegate>

@property(nonatomic,strong) NSMutableURLRequest *paymentRequest;
@property (weak, nonatomic) IBOutlet UIWebView *paymentWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (strong, nonatomic) NSString *merchantKey;
@property (strong, nonatomic) NSString *txnID;


@property(strong, nonatomic) NSDictionary *selectedCabInfo;
@property(strong, nonatomic) NSDictionary *finalresponseDic;
@end
