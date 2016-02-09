//
//  PayUUIPaymentOptionViewController.h
//  SeamlessTestApp
//
//  Created by Umang Arya on 07/10/15.
//  Copyright © 2015 PayU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayUHeader.h"

@interface PayUUIPaymentOptionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) PayUModelPaymentParams *paymentParam;
@property (nonatomic, strong) PayUModelPaymentRelatedDetail *paymentRelatedDetail;


@property (weak, nonatomic) IBOutlet UITableView *tableForPaymentOption;


@end
