//
//  NavigationView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/23/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "NavigationView.h"
#import "SWRevealViewController.h"

@interface NavigationView ()

@end

@implementation NavigationView
{
    NSArray *menus,*viewIdentifier;
    //
    NSInteger _previouslySelectedRow;
}

- (void)viewDidLoad {
    //
    [super viewDidLoad];
    //
    mg=[ModalGlobal sharedManager];
    self.navigationController.navigationBar.barTintColor = [self colorWithCode:@"2b80bc"];
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.tableView.backgroundColor=[self colorWithCode:@"494949"];
    //
    [self setMenu];
    
}

-(void)viewWillAppear:(BOOL)animated{
    //
    [self setMenu];
    //
    [self.tableView reloadData];
}

-(void)setMenu{
    //
    menus = @[@"Login", @"Search_Taxi", @"My_Trips", @"Offers", @"Call_Support", @"About_Us", @"Rate_Us", @"Share"];
    //
    if ([[UserDefault loginTag]intValue]==0) {
        viewIdentifier = @[@"UserSIView", @"OutStationView", @"MyBookingView", @"CouponListingView", @"CallSupportView",@"AboutUSView"];
    }else{
        viewIdentifier = @[@"UserProfileView", @"OutStationView", @"MyBookingView", @"CouponListingView", @"CallSupportView",@"AboutUSView"];
    }
    //
}

-(id)init{
    self=[super init];
    if (self) {
        // Custom initialization
        [self.tableView reloadData];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self.tableView reloadData];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    _previouslySelectedRow = -1;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menus count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    //
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor=[UIColor whiteColor];
    //
    cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"nv%@",[menus objectAtIndex:indexPath.row]]];
    
    if(indexPath.row==0 && [[UserDefault loginTag]intValue]!=0){
        cell.textLabel.text=[[UserDefault userDetails] valueForKey:@"name"];
    }else{
        NSString *menuTitle=[[menus objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        cell.textLabel.text=menuTitle;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 6:{
            static NSString *const rateURL = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1064864700&type=Purple+Software&pageNumber=0&sortOrdering=2&mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:rateURL]];
            break;
        } case 7:{
            [self socialShare];
            break;
        }  default:{
            SWRevealViewController *revealController = self.revealViewController;
            NSInteger row = indexPath.row;
            if (row == _previouslySelectedRow){
                [revealController revealToggleAnimated:YES];
                return;
            }
            _previouslySelectedRow = row;
            //
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            //
            UIViewController *frontController = nil;
            frontController =[mainStoryboard instantiateViewControllerWithIdentifier:[viewIdentifier objectAtIndex:indexPath.row]];
            [navController setViewControllers:@[frontController] animated: NO];
            [revealController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            break;
        }
    }
}

-(UIColor*)colorWithCode:(NSString*)hex{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; // your own style
}

- (BOOL)prefersStatusBarHidden {
    return NO; // your own visibility code
}


-(void)socialShare{
    
                NSString*shareText=@"Outstation Taxi Booking";
                NSURL *website = [NSURL URLWithString:@"http://www.mytaxiindia.com/offer/mobile-app-offer.php"];
                //
                UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[shareText,website] applicationActivities:nil];
                //
                activityViewController.excludedActivityTypes = @[
                                                            UIActivityTypePostToFacebook,
                                                            UIActivityTypePostToTwitter,
                                                            UIActivityTypePostToWeibo,
                                                            UIActivityTypeMessage,
                                                            UIActivityTypeMail,
                                                            UIActivityTypeAssignToContact,
                                                            UIActivityTypePostToFlickr,
                                                            UIActivityTypePostToVimeo,
                                                            UIActivityTypePostToTencentWeibo,
                                                            UIActivityTypeAirDrop
                                                            ];
    
                // check if new API supported
                if ([activityViewController respondsToSelector:@selector(completionWithItemsHandler)]) {
                    activityViewController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
                        // When completed flag is YES, user performed specific activity
                        NSLog(@"completed dialog - activity: %@ - finished flag: %d", activityType, completed);
                    };
                } else {
                    activityViewController.completionHandler = ^(NSString *activityType, BOOL completed) {
                        // When completed flag is YES, user performed specific activity
                        NSLog(@"completed dialog - activity: %@ - finished flag: %d", activityType, completed);
                    };
                }
                [self presentViewController:activityViewController animated:YES completion:nil];
    
    
//    NSString *shareText = @"Outstation Taxi Booking:";
//    NSURL *shareUrl=[NSURL URLWithString:@"http://www.mytaxiindia.com/offer/mobile-app-offer.php"];
//    NSArray *activityItems = @[shareUrl,shareText];
//    UIActivityViewController *activityController =[[UIActivityViewController alloc]
//                                                   initWithActivityItems:activityItems applicationActivities:nil];
//    [self presentViewController:activityController
//                       animated:YES completion:nil];
}
@end
