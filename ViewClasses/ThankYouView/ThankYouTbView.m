//
//  ThankYouTbView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 12/7/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "ThankYouTbView.h"

@interface ThankYouTbView ()
{
    NSArray *cellArray;
}
@end

@implementation ThankYouTbView

@synthesize confirmResponse;

- (void)viewDidLoad {
    [super viewDidLoad];
    
     NSLog(@"confirmResponse====>%@",confirmResponse);
    
    if ([[confirmResponse valueForKey:@"status"] isEqualToString:@"unconfirmed"]) {
        cellArray = @[@"cell1", @"cell2", @"cell3", @"cell5"];
    }else
    {
        cellArray = @[@"cell1", @"cell2", @"cell3", @"cell4"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self GATrackOnView:NSStringFromClass(self.class) kGAIScreenName:kGAIScreenName];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    
    return cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [cellArray objectAtIndex:indexPath.row];
    ThankYouCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.row==0) {
        NSString *cBookingID,*cBookingStatus,*cLocationVal;
        
        cBookingID =[self validateNullValue:[[confirmResponse valueForKey:@"result"] valueForKey:@"id"] isString:FALSE];
        cBookingStatus=[self validateNullValue:[[confirmResponse valueForKey:@"result"] valueForKey:@"status"] isString:FALSE];
        cLocationVal=[NSString stringWithFormat:@"%@-%@",[[confirmResponse valueForKey:@"result"] valueForKey:@"from"],[[confirmResponse valueForKey:@"result"] valueForKey:@"to"]];
        
        cell.lblBookingID.text=[NSString stringWithFormat:@"Booking ID: %@",cBookingID];
        cell.lblBookingStatus.text=cBookingStatus;
        cell.lblLocationVal.text=cLocationVal;
    }
    if (indexPath.row==1) {
        
        NSString *cName,*cMobile,*cAddress,*cDate;
        cName=[[confirmResponse valueForKey:@"result"] valueForKey:@"billingName"];
        cMobile=[[confirmResponse valueForKey:@"result"] valueForKey:@"billingAddressPhone"];
        
        cAddress=[self validateNullValue: [[confirmResponse valueForKey:@"result"] valueForKey:@"billingAddressLine1"] isString:YES];
        cDate=[self msTodate:[self validateNullValue:[[confirmResponse valueForKey:@"result"] valueForKey:@"fromDate"] isString:NO]];
        
        cell.lblname.text=cName;
        cell.lblMobileNo.text=cMobile;
        cell.lblAddress.text=cAddress;
        cell.lblDate.text=cDate;
    }
    if (indexPath.row==2) {
        
        NSString *cBaseFare,*cDiscount,*cServiceTax,*cTotalAmount;
        cBaseFare=[[confirmResponse valueForKey:@"result"] valueForKey:@"netAmount"];
        cDiscount=[[confirmResponse valueForKey:@"result"] valueForKey:@"couponDiscount"];
        cServiceTax=[[confirmResponse valueForKey:@"result"] valueForKey:@"serviceTax"];
        cTotalAmount=[[confirmResponse valueForKey:@"result"] valueForKey:@"totalAmount"];
        
        
        cell.lblBaseFare.text=[self setRs:[self valueRoundOff:cBaseFare]];
        cell.lblDiscount.text=[self setRs:[self valueRoundOff:cDiscount]];
        cell.lblServiceTax.text=[self setRs:[self valueRoundOff:cServiceTax]];
        cell.lblTotalAmount.text=[self setRs:[self valueRoundOff:cTotalAmount]];
        
//        cell.lblBaseFare.text=[self setRs:cBaseFare];
//        cell.lblDiscount.text=[self setRs:cDiscount];
//        cell.lblServiceTax.text=[self setRs:cServiceTax];
//        cell.lblTotalAmount.text=[self setRs:cTotalAmount];
    }
    if (indexPath.row==3) {
        
        if ([[confirmResponse valueForKey:@"status"] isEqualToString:@"unconfirmed"]) {
            NSString *cTrip,*cCarType,*cDriver,*cDriverMb,*cTaxiNo;
            
            cTrip=[NSString stringWithFormat:@"%@-%@",[[confirmResponse valueForKey:@"result"] valueForKey:@"from"],[[confirmResponse valueForKey:@"result"] valueForKey:@"to"]];
            
            cCarType=[[[confirmResponse valueForKey:@"result"] valueForKey:@"items"][0] valueForKey:@"category"];
            
            cDriver=[[[[confirmResponse valueForKey:@"result"] valueForKey:@"items"][0] valueForKey:@"driver"] valueForKey:@"name"];
            
            cDriverMb=[[[[confirmResponse valueForKey:@"result"] valueForKey:@"items"][0] valueForKey:@"driver"] valueForKey:@"mobile"];
            
            cTaxiNo=[[[confirmResponse valueForKey:@"result"] valueForKey:@"items"][0] valueForKey:@"taxiNo"];
            
            cell.lblTip.text=cTrip;
            cell.lblCarType.text=cCarType;
            cell.lblDrive.text=cDriver;
            cell.lblCarNo.text=cTaxiNo;
            
            NSString *driverMb;
            driverMb=[[[confirmResponse valueForKey:@"items"][0] valueForKey:@"driver"] valueForKey:@"mobile"];
            _driverMbStr=driverMb;
            [cell.btnCallDriver addTarget:self action:@selector(callDriverAction:) forControlEvents:UIControlEventTouchUpInside];
        }else{
        
        }
    }
//
    // Configure the cell...
//    cell.backgroundColor=[UIColor clearColor];
//    cell.textLabel.textColor=[UIColor whiteColor];
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row==0) {
        return 100;
    }
    else if (indexPath.row==1) {
        return 200;
    }
    else if (indexPath.row==2) {
        return 135;
    }
    else if (indexPath.row==3) {
        if ([[confirmResponse valueForKey:@"status"] isEqualToString:@"unconfirmed"]) {
            return 180;
        }else{
            return 260;
        }
    }
    else{
        return 0;
    }
}


-(void)callDriverAction:(UIButton*)button{
    NSLog(@"_driverMbStr==>%@",_driverMbStr);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_driverMbStr]];
}

-(NSString*)validateNullValue:(id)value isString:(BOOL)isString
{
    NSString *string;
    
    if (isString && [value isEqual:[NSNull null]]) {
        string=@"N/A";
    }else if (!isString) {
        if ([value isEqual:[NSNull null]]) {
            string=@"0";
        }else{
            string=[NSString stringWithFormat:@"%@",value];
        }
    }else{
        string=value;
    }
    return string;
}

-(NSString*)msTodate:(NSString*)msStr
{
    //NSString *msStr=[NSString stringWithFormat:@"%@",ms];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([msStr doubleValue] / 1000)];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateStr=[timeFormatter stringFromDate:date];
    return dateStr;
}

-(NSString*)setRs:(NSString*)value
{
    NSString *rupees;
    
    [self validateNullValue:value isString:NO];
    if ([value isEqual:[NSNull null]]) {
        rupees=@"0";
    }else{
        rupees=value;
    }
    rupees=[NSString stringWithFormat:@"%@%@",rupee,rupees];
    return rupees;
}

-(NSString*)valueRoundOff:(NSString*)string{
    NSString *finalString;
    if ([string isEqual:[NSNull null]]) {
        string=@"0";
        finalString=string;
    }else{
        double strDouble = [string doubleValue];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
        [formatter setMaximumFractionDigits:2];
        NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithDouble:strDouble]];
        NSLog(@"numberString===>%@",numberString);
        finalString=numberString;
    }
    return finalString;
}

-(IBAction)backBtnAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


//GA
-(void)GATrackOnView:(NSString*)className kGAIScreenName:(NSString*)kGAIScreenName
{
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:className];
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [[GAI sharedInstance] dispatch];
}

@end
