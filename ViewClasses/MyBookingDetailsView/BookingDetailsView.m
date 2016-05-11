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
#import "OutStationView.h"

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

    if ([[_DyBookingDetails valueForKey:@"status"] isEqualToString:@"UNCONFIRMED"]){
        
        if ([_responseViewTag isEqual:@"1"]){
            [self setFlurry:@"Booking Confirm" params:nil];
            cellArray = @[@"cell0",@"cell1",@"cell2",@"cell3",@"cell6"];
        }else{
            [self setFlurry:@"Booking Details" params:nil];
            cellArray = @[@"cell1",@"cell2",@"cell3",@"cell6"];
        }
    }else if([[_DyBookingDetails valueForKey:@"status"] isEqualToString:@"BOOKED"]){
        //
        if ([_responseViewTag isEqual:@"1"]) {
            [self setFlurry:@"Booking Confirm" params:nil];
            cellArray = @[@"cell0",@"cell1",@"cell2",@"cell3",@"cell4",@"cell7"];
        }else{
            [self setFlurry:@"Booking Details" params:nil];
            cellArray = @[@"cell1",@"cell2",@"cell3",@"cell4"];
        }
    }else{
        [self setFlurry:@"Booking Details" params:nil];
        cellArray = @[@"cell1",@"cell2",@"cell3",@"cell4"];
    }
    //
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
        
        NSArray *taxiItems=[NSArray arrayWithArray:[self getItemsArrayOnlyTaxi:[_DyBookingDetails valueForKey:@"items"]]];
        return taxiItems.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //
    NSString *cellIdentifier = [cellArray objectAtIndex:indexPath.section];
    MyBookingDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    //
     NSArray *taxiItems=[NSArray arrayWithArray:[self getItemsArrayOnlyTaxi:[_DyBookingDetails valueForKey:@"items"]]];
    
    if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell1"]) {
        NSString *fromCityH,*toCityH;
        //
        fromCityH=[self getCity:[taxiItems[0] valueForKey:@"fromCity"]];
        toCityH=  [self getCity:[taxiItems[0] valueForKey:@"toCity"]];
        //
        cell.lblBookingID.text=[self validateNullValue:[_DyBookingDetails valueForKey:@"id"] isString:FALSE];
        cell.lblBookingStatus.text=[self validateNullValue:[_DyBookingDetails valueForKey:@"status"] isString:TRUE];
        cell.lblDepartureCity.text=[fromCityH capitalizedString];
        cell.lblArrivalCity.text=[toCityH capitalizedString];
        //
        NSString *tripType=[self validateNullValue:[_DyBookingDetails valueForKey:@"tripType"] isString:YES];
        
        if ([[tripType lowercaseString] isEqual:@"oneway"]) {
            cell.imgTripIcon.image=[UIImage imageNamed:@"trip_icon_local"];
        }else{
            cell.imgTripIcon.image=[UIImage imageNamed:@"trip_icon"];
        }
    }
    else if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell2"]) {
        cell.lblName.text=[[self validateNullValue:[_DyBookingDetails valueForKey:@"billingName"] isString:YES] capitalizedString];
        cell.lblAddress.text=[[self validateNullValue:[_DyBookingDetails valueForKey:@"billingAddressLine1"] isString:YES] capitalizedString];
        cell.lblMobileNo.text=[self validateNullValue:[_DyBookingDetails valueForKey:@"billingAddressPhone"] isString:FALSE];
        //
        NSString *userPickUpdateMs=[self validateNullValue:[taxiItems[0] valueForKey:@"fromDate"] isString:FALSE];
        cell.lblDate.text=[self msWithOrdinalStyle_ddMMyy:userPickUpdateMs];
        cell.lblBookingTime.text=[self msToTimeUTC:userPickUpdateMs];
        
        //
        [self setLabelUnderLine:cell.lblCell2Title];
    }
    else if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell3"]) {
        cell.lblBaseFare.text=[self setRs:[self valueRoundOff:[_DyBookingDetails valueForKey:@"netAmount"]]];
    
        NSString *couponCode=[self validateNullValue:[_DyBookingDetails valueForKey:@"couponCode"] isString:YES];
        
        if ([couponCode isEqualToString:@"MTIPROMO05"]) {
            cell.lblDiscount.text=[self setRs:@"0"];
        }else{
            cell.lblDiscount.text=[self setRs:[self valueRoundOff:[_DyBookingDetails valueForKey:@"couponDiscount"]]];
        }
        
        cell.lblServiceTax.text=[self setRs:[self valueRoundOff:[_DyBookingDetails valueForKey:@"serviceTax"]]];
        cell.lblTotalAmount.text=[self setRs:[self valueRoundOff:[_DyBookingDetails valueForKey:@"totalAmount"]]];
        
        //
        NSString *kmlimitStr;
        NSNumber *minKmPerDay,*totalKmCharged;
        minKmPerDay=    [[taxiItems[0] valueForKey:@"taxiFare"] valueForKey:@"minKmPerDay"];
        totalKmCharged= [[taxiItems[0] valueForKey:@"taxiFare"] valueForKey:@"totalKmCharged"];
        
        if ([minKmPerDay isEqual:[NSNull null]] && [totalKmCharged isEqual:[NSNull null]]) {
            kmlimitStr=@"0";
        }else if([minKmPerDay isEqual:[NSNull null]]    || minKmPerDay>totalKmCharged){
            kmlimitStr=[NSString stringWithFormat:@"%@",totalKmCharged];
        }else if([totalKmCharged isEqual:[NSNull null]] || minKmPerDay<totalKmCharged){
            kmlimitStr=[NSString stringWithFormat:@"%@",minKmPerDay];
        }else{
            kmlimitStr=[NSString stringWithFormat:@"%@",totalKmCharged];
        }
        cell.lblKMLimit.text=[NSString stringWithFormat:@"%@ KM",kmlimitStr];
        //
        
        if ([[_DyBookingDetails valueForKey:@"advanceAmount"] isEqual:[NSNull null]]) {
            cell.lblPayableAmount.text=[self setRs:@"0"];
        }else{
            cell.lblPayableAmount.text=[self setRs:[self valueRoundOff:[_DyBookingDetails valueForKey:@"advanceAmount"]]];
        }
        //
        [self setLabelUnderLine:cell.lblCell3Title];
    }
    else if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell4"]) {
        //
        NSString *strCellTitle=[NSString stringWithFormat:@"Taxi Summary #%ld",(long)indexPath.row+1];
        //
        NSString *strCarType=[self validateNullValue:[[taxiItems objectAtIndex:indexPath.row] valueForKey:@"category"] isString:YES];
        //
        NSString * taxiNo=[[self validateNullValue:[[taxiItems objectAtIndex:indexPath.row] valueForKey:@"taxiNo"] isString:YES] uppercaseString];
        //
        NSString * driveName=[[[taxiItems objectAtIndex:indexPath.row] valueForKey:@"driver"] valueForKey:@"name"];
        //
        cell.lblCell4Title.text=strCellTitle;
        [self setLabelUnderLine:cell.lblCell4Title];
        //
        cell.lblCarType.text=strCarType;
        //
        cell.lblTaxiNo.text=taxiNo;
        //
        if ([driveName isEqual:[NSNull null]]) {
            cell.lblDriverName.text=@"Awaited";
        }else{
            cell.lblDriverName.text=driveName;
        }
        //----------------------------------------------------------------------------
        
        if ([[[taxiItems objectAtIndex:indexPath.row] valueForKey:@"driver"] isEqual:[NSNull null]]){
            cell.view4.frame=CGRectMake(0, 4,cell.view4.frame.size.width,172-35);
            cell.viewCallDriver.hidden=TRUE;
        }else{
            if ([[_DyBookingDetails valueForKey:@"status"] isEqualToString:@"BOOKED"]||[[_DyBookingDetails valueForKey:@"status"] isEqualToString:@"TRIPSTART"]) {
                //
                cell.viewCallDriver.hidden=FALSE;
                cell.view4.frame=CGRectMake(0, 4,cell.view4.frame.size.width,172);
                //
                NSString *driverMb;
                driverMb=[[[taxiItems objectAtIndex:indexPath.row] valueForKey:@"driver"] valueForKey:@"mobile"];
                _driverMbStr=driverMb;
                [cell.btnCallDriver addTarget:self action:@selector(callDriverAction:) forControlEvents:UIControlEventTouchUpInside];
                //
                [cell.btnTrackDriver setTag:indexPath.row];
                [cell.btnTrackDriver addTarget:self action:@selector(trackDriverAction:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                cell.viewCallDriver.hidden=TRUE;
                cell.view4.frame=CGRectMake(0, 4,cell.view4.frame.size.width,172-35);
            }
        }

        //----------------------------------------------------------------------------
    }
//    else if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell5"]) {
//        //
//        cell.lblCell5Title.text=[NSString stringWithFormat:@"Taxi Summary #%ld",(long)indexPath.row+1];
//        [self setLabelUnderLine:cell.lblCell5Title];
//        //
//       
//        //
//        cell.lblCell5CarType.text=[self validateNullValue:[[taxiItems objectAtIndex:indexPath.row] valueForKey:@"category"] isString:YES];
//        //
//        NSString * driveName=[[[taxiItems objectAtIndex:indexPath.row] valueForKey:@"driver"] valueForKey:@"name"];
//        cell.lblCell5DriverName.text=[[self validateNullValue:driveName isString:YES] capitalizedString];
//        //
//        cell.lblCell5TaxiNo.text=[[self validateNullValue:[[taxiItems objectAtIndex:indexPath.row] valueForKey:@"taxiNo"] isString:YES] uppercaseString];
//    }
//    else if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell4"] || [[cellArray objectAtIndex:indexPath.section] isEqual:@"cell5"]) {
//        
//        NSString *strCellTitle=[NSString stringWithFormat:@"Taxi Summary #%ld",(long)indexPath.row+1];
//        //
//        NSString *strCarType=[self validateNullValue:[[taxiItems objectAtIndex:indexPath.row] valueForKey:@"category"] isString:YES];
//        //
//        NSString * taxiNo=[[self validateNullValue:[[taxiItems objectAtIndex:indexPath.row] valueForKey:@"taxiNo"] isString:YES] uppercaseString];
//        
//        if ([[[taxiItems objectAtIndex:indexPath.row] valueForKey:@"driver"] isEqual:[NSNull null]] && [[cellArray objectAtIndex:indexPath.section] isEqual:@"cell5"]){
//            //
//            cell.lblCell5Title.text=strCellTitle;
//            [self setLabelUnderLine:cell.lblCell5Title];
//            //
//            cell.lblCell5CarType.text=strCarType;
//            //
//            cell.lblCell5TaxiNo.text=taxiNo;
//            //
//            cell.lblCell5DriverName.text=@"N/A";
//        }else{
//            //
//            cell.lblCell4Title.text=strCellTitle;
//            [self setLabelUnderLine:cell.lblCell4Title];
//            //
//            cell.lblCarType.text=strCarType;
//            //
//            cell.lblTaxiNo.text=taxiNo;
//            //
//            NSString * driveName=[[[taxiItems objectAtIndex:indexPath.row] valueForKey:@"driver"] valueForKey:@"name"];
//            cell.lblDriverName.text=driveName;
//            //----------------------------------------------------------------------------
//            NSString *driverMb;
//            driverMb=[[[taxiItems objectAtIndex:indexPath.row] valueForKey:@"driver"] valueForKey:@"mobile"];
//            _driverMbStr=driverMb;
//            [cell.btnCallDriver addTarget:self action:@selector(callDriverAction:) forControlEvents:UIControlEventTouchUpInside];
//            //
//            [cell.btnTrackDriver setTag:indexPath.row];
//            [cell.btnTrackDriver addTarget:self action:@selector(trackDriverAction:) forControlEvents:UIControlEventTouchUpInside];
//            //----------------------------------------------------------------------------
//        }
//    }
    else if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell6"]) {
        [cell.btnCallCC1 addTarget:self action:@selector(callCCAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell7"]) {
        [cell.btnCallCC2 addTarget:self action:@selector(callCCAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    // Configure the cell...
    //cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor=[UIColor whiteColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell0"]) {
        return 50;
    }
    if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell1"]) {
        return 100;
    }
    if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell2"]) {
        return 200;
    }
    if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell3"]) {
        return 200;
    }
    if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell4"]) {
        //
        NSArray *taxiItems=[NSArray arrayWithArray:[self getItemsArrayOnlyTaxi:[_DyBookingDetails valueForKey:@"items"]]];
        if ([[[taxiItems objectAtIndex:indexPath.row] valueForKey:@"driver"] isEqual:[NSNull null]]){
            return 180-35;
        }else{
            if ([[_DyBookingDetails valueForKey:@"status"] isEqualToString:@"BOOKED"]||[[_DyBookingDetails valueForKey:@"status"] isEqualToString:@"TRIPSTART"]) {
                return 180;
            }else{
                return 180-35;
            }
        }
    }
    if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell6"]) {
        return 200;
    }
    if ([[cellArray objectAtIndex:indexPath.section] isEqual:@"cell7"]) {
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:+91-888-200-1133"]];
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
        //
        [UIView transitionWithView:self.navigationController.view
                          duration:0.75
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [self.navigationController popToRootViewControllerAnimated:NO];
                        } completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(NSArray*)getItemsArrayOnlyTaxi:(NSArray*)itemArray{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(itemType CONTAINS %@)",@"TAXI"];
    NSArray *sortedItemArray = [itemArray filteredArrayUsingPredicate:predicate];
    return sortedItemArray;
}
@end
