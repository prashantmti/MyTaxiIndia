//
//  BookingDetailsView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 1/11/16.
//  Copyright © 2016 mytaxiit. All rights reserved.
//

#import "BookingDetailsView.h"
//
#import "DriverTrackingView.h"

@implementation BookingDetailsView
{
    NSArray *cellArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mg=[ModalGlobal sharedManager];
    
    //
    NSLog(@"DyBookingDetails===>%@",_DyBookingDetails);
    
    //_responseViewTag: 1=>Thank you     2=>Booking Detail
    
    if ([_responseViewTag isEqual:@"1"]) {
        if ([[_DyBookingDetails valueForKey:@"status"] isEqualToString:@"UNCONFIRMED"]){
            cellArray = @[@"cell1",@"cell2",@"cell3",@"cell5"];
        }else{
            cellArray = @[@"cell1",@"cell2",@"cell3",@"cell4",@"cell6"];
        }
    }else{
        if ([[_DyBookingDetails valueForKey:@"status"] isEqualToString:@"UNCONFIRMED"]){
            cellArray = @[@"cell1",@"cell2",@"cell3",@"cell5"];
        }else{
            cellArray = @[@"cell1",@"cell2",@"cell3",@"cell4"];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return cellArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    if ([[cellArray objectAtIndex:section] isEqual:@"cell4"]) {
        NSArray *taxiItems=[_DyBookingDetails valueForKey:@"items"];
        return taxiItems.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [cellArray objectAtIndex:indexPath.section];
    MyBookingDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell1"]) {
        NSString *fromCityH,*toCityH;
        fromCityH=[self validateNullValue:[_DyBookingDetails valueForKey:@"from"] isString:YES];
        toCityH=[self validateNullValue:[_DyBookingDetails valueForKey:@"to"] isString:YES];
        //
        cell.lblBookingID.text=[self validateNullValue:[_DyBookingDetails valueForKey:@"id"] isString:FALSE];
        cell.lblBookingStatus.text=[self validateNullValue:[_DyBookingDetails valueForKey:@"status"] isString:TRUE];
        cell.lblDepartureCity.text=[fromCityH capitalizedString];
        cell.lblArrivalCity.text=[toCityH capitalizedString];
    }
    if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell2"]) {
        cell.lblName.text=[[self validateNullValue:[_DyBookingDetails valueForKey:@"billingName"] isString:YES] capitalizedString];
        cell.lblAddress.text=[[self validateNullValue:[_DyBookingDetails valueForKey:@"billingAddressLine1"] isString:YES] capitalizedString];
        cell.lblMobileNo.text=[self validateNullValue:[_DyBookingDetails valueForKey:@"billingAddressPhone"] isString:FALSE];
        //
        NSString *userPickUpdateMs=[self validateNullValue:[_DyBookingDetails  valueForKey:@"fromDate"] isString:FALSE];
        cell.lblDate.text=[self msWithOrdinalStyle_ddMMyy:userPickUpdateMs];
        cell.lblBookingTime.text=[self msToTimeUTC:userPickUpdateMs];
        
        //
        [self setLabelUnderLine:cell.lblCell2Title];
    }
    if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell3"]) {
        cell.lblBaseFare.text=[self setRs:[self valueRoundOff:[_DyBookingDetails valueForKey:@"netAmount"]]];
        cell.lblDiscount.text=[self setRs:[self valueRoundOff:[_DyBookingDetails valueForKey:@"couponDiscount"]]];
        cell.lblServiceTax.text=[self setRs:[self valueRoundOff:[_DyBookingDetails valueForKey:@"serviceTax"]]];
        cell.lblTotalAmount.text=[self setRs:[self valueRoundOff:[_DyBookingDetails valueForKey:@"totalAmount"]]];
        
        if ([[_DyBookingDetails valueForKey:@"advanceAmount"] isEqual:[NSNull null]]) {
            cell.lblPayableAmount.text=[self setRs:[self valueRoundOff:[_DyBookingDetails valueForKey:@"totalAmount"]]];
        }else{
            cell.lblPayableAmount.text=[self setRs:[self valueRoundOff:[_DyBookingDetails valueForKey:@"advanceAmount"]]];
        }
        //
        [self setLabelUnderLine:cell.lblCell3Title];
    }
    if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell4"]) {
        //
        cell.lblCell4Title.text=[NSString stringWithFormat:@"Taxi Summary #%ld",(long)indexPath.row+1];
        [self setLabelUnderLine:cell.lblCell4Title];
        //
        NSArray *taxiItems=[_DyBookingDetails valueForKey:@"items"];
        //
        cell.lblCarType.text=[self validateNullValue:[[taxiItems objectAtIndex:indexPath.row] valueForKey:@"category"] isString:YES];
        //
        NSString * driveName=[[[taxiItems objectAtIndex:indexPath.row]valueForKey:@"driver"] valueForKey:@"name"];
        cell.lblDriverName.text=[[self validateNullValue:driveName isString:YES] capitalizedString];
        //
        cell.lblTaxiNo.text=[[self validateNullValue:[[taxiItems objectAtIndex:indexPath.row] valueForKey:@"taxiNo"] isString:YES] uppercaseString];
        //----------------------------------------------------------------------------
        if ([[_DyBookingDetails valueForKey:@"status"] isEqualToString:@"BOOKED"]||[[_DyBookingDetails valueForKey:@"status"] isEqualToString:@"TRIPSTART"]) {
            //
                cell.btnCallDriver.hidden=false;
                cell.btnTrackDriver.hidden=false;
            //
            NSString *driverMb;
            driverMb=[[[taxiItems objectAtIndex:indexPath.row] valueForKey:@"driver"] valueForKey:@"mobile"];
            _driverMbStr=driverMb;
            [cell.btnCallDriver addTarget:self action:@selector(callDriverAction:) forControlEvents:UIControlEventTouchUpInside];
            //
            [cell.btnTrackDriver setTag:indexPath.row];
            [cell.btnTrackDriver addTarget:self action:@selector(trackDriverAction:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            cell.btnCallDriver.hidden=true;
            cell.btnTrackDriver.hidden=true;
            cell.summaryDriverView.frame=CGRectMake(cell.summaryDriverView.frame.origin.x,4,cell.summaryDriverView.frame.size.width,cell.summaryDriverView.frame.size.height-100);
        }
       //----------------------------------------------------------------------------
    }
    if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell5"]) {
        [cell.btnCallCC1 addTarget:self action:@selector(callCCAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell6"]) {
        [cell.btnCallCC2 addTarget:self action:@selector(callCCAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    // Configure the cell...
    //cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor=[UIColor whiteColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell1"]) {
        return 100;
    }
    if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell2"]) {
        return 200;
    }
    if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell3"]) {
        return 178;
    }
    if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell4"]) {
        if ([[_DyBookingDetails valueForKey:@"status"] isEqualToString:@"BOOKED"] ||[[_DyBookingDetails valueForKey:@"status"] isEqualToString:@"TRIPSTART"]){
            return 180;
        }else{
            return 180-30;
        }
    }
    if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell5"]) {
        return 200;
    }
    if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell6"]) {
        return 120;
    }
    else{
        return 0;
    }
}

-(void)callDriverAction:(UIButton*)button{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_driverMbStr]]];
}

-(void)trackDriverAction:(UIButton*)button{
    DriverTrackingView *DTV = [self.storyboard instantiateViewControllerWithIdentifier:@"DriverTrackingView"];
    DTV.strDriverDetailsObj=[NSString stringWithFormat:@"%ld",(long)button.tag];
    DTV.dicBookingDetails =_DyBookingDetails;
    [self.navigationController pushViewController:DTV animated:true];
}

-(void)callCCAction:(UIButton*)button{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:8882001133"]];
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

-(NSString*)setRs:(NSString*)value{
    NSString *rupees;
    [self validateNullValue:value isString:NO];
    if ([value isEqual:[NSNull null]]) {
        rupees=@"0";
    }else{
        rupees=value;
    }
    rupees=[NSString stringWithFormat:@"%@%@/-",rupee,rupees];
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

-(IBAction)backBtnActionFinal{
    if([_responseViewTag isEqualToString:@"1"]){
        self.mg.mbt.tripActionComplete=@"YES";
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
