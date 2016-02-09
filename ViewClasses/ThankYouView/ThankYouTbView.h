//
//  ThankYouTbView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 12/7/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThankYouCell.h"


//GA
#import "AppDelegate.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface ThankYouTbView : UITableViewController

@property(strong, nonatomic) NSDictionary *confirmResponse;

@property (strong, nonatomic) NSString *driverMbStr;

@property(nonatomic, weak) AppDelegate *delegate;
@end
