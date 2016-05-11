//
//  MyBookingView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/16/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "MyBookingView.h"

@interface MyBookingView ()

@end

@implementation MyBookingView
@synthesize AyBookingResult,TBMyBooking;
@synthesize arrayPastTrip,arrayUpcommingTrip;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    if([[UserDefault userID]intValue]==0){
        TBMyBooking.hidden=true;
        _uvBtn.hidden=true;
        _BtnPT.hidden=true;
        _BtnUT.hidden=true;
        [self addErrorLabel];
    }else
    {
        TBMyBooking.hidden=false;
        _uvBtn.hidden=false;
        _BtnPT.hidden=false;
        _BtnUT.hidden=false;
        //
        [errorLbl removeFromSuperview];
        //
        _BtnPT.backgroundColor=[self colorWithCode:@"666666"];
        _BtnUT.backgroundColor=[self colorWithCode:@"404040"];
        [self callService:2];
    }
    //
    [self setFlurry:@"My Trips" params:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self GATrackOnView:NSStringFromClass(self.class) kGAIScreenName:kGAIScreenName];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (AyBookingResult == nil || [AyBookingResult count] == 0){
        return 0;
    }else{
        return AyBookingResult.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdf = @"MyBookingCell";
    
    MyBookingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdf];
    if (cell == nil) {
        cell = [[MyBookingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdf];
    }
    
    NSDictionary *dicBookingResult=[AyBookingResult objectAtIndex:indexPath.row];
    //
    NSArray *taxiItemArray=[NSArray arrayWithArray:[self getItemsArrayOnlyTaxi:[dicBookingResult valueForKey:@"items"]]];
    //
    cell.lblBookingID.text=[self stringFormat:[dicBookingResult valueForKey:@"id"]];
    //
    NSString *fromCity,*toCity;
    fromCity=[[taxiItemArray[0] valueForKey:@"fromCity"] capitalizedString];
    toCity=  [[taxiItemArray[0] valueForKey:@"toCity"] capitalizedString];
    //
    cell.lblTripFrom.text=[self getCity:fromCity];
    cell.lblTripTo.text=  [self getCity:toCity];
    cell.lblTripStatus.text=[dicBookingResult valueForKey:@"status"];
    //
    NSString *fromDate;
    fromDate=[taxiItemArray[0] valueForKey:@"fromDate"];
    cell.lblTripDate.text=[self msWithOrdinalStyle_ddMMyy:fromDate];
    //
    NSString *tripType=[self validateNullValue:[dicBookingResult valueForKey:@"tripType"] isString:YES];
    //
    if ([[tripType lowercaseString] isEqual:@"oneway"]) {
        cell.imgTripIcon.image=[UIImage imageNamed:@"trip_icon_local"];
    }else{
        cell.imgTripIcon.image=[UIImage imageNamed:@"trip_icon"];
    }
    
    //-------------------------------------------------------------------------------------
    if ([[taxiItemArray[0] valueForKey:@"driver"] isEqual:[NSNull null]]){
        cell.btnCallDriver.hidden=TRUE;
    }else{
        if ([[dicBookingResult valueForKey:@"status"] isEqualToString:@"BOOKED"]||[[dicBookingResult valueForKey:@"status"] isEqualToString:@"TRIPSTART"]) {
            //
            NSString *driverMb;
            driverMb=[[taxiItemArray[0] valueForKey:@"driver"] valueForKey:@"mobile"];
            _driverMbStr=driverMb;
            //
            [cell.btnCallDriver addTarget:self action:@selector(callDriverAction:) forControlEvents:UIControlEventTouchUpInside];
            //
            cell.btnCallDriver.hidden=FALSE;
        }else{
            cell.btnCallDriver.hidden=TRUE;
        }
    }
    //-------------------------------------------------------------------------------------
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookingDetailsView *bdv = [storyboard  instantiateViewControllerWithIdentifier:@"BookingDetailsView"];
    bdv.DyBookingDetails=[AyBookingResult objectAtIndex:indexPath.row];
    bdv.responseViewTag=@"2";
    [self.navigationController pushViewController:bdv animated:YES];
}


-(void)callDriverAction:(UIButton*)button{
    NSLog(@"_driverMbStr==>%@",_driverMbStr);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_driverMbStr]]];
}


-(void)callService:(NSInteger)tripActionTag{
    dispatch_async (dispatch_get_main_queue(), ^{
        WebServiceClass *WSC = [[WebServiceClass alloc] init];
        NSString *auth=[self createAuth:merchantId string2:[self uniqueTstamp] string3:authPassword];
        NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
        [postDic setObject:merchantId forKey:@"merchantId"];
        [postDic setObject:[self uniqueTstamp] forKey:@"salt"];
        //
        [postDic setObject:[UserDefault userID] forKey:@"customerId"];
    
    [WSC getServerResponseForUrl:postDic serviceURL:IDGetBooking isPOST:YES isLoder:YES auth:auth view:self.view  withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        if (success) {
            if ([[response valueForKey:@"status"] isEqualToString:@"error"])
            {
                [self alertWithText:@"Error!" message:[response valueForKey:@"error"]];
                [self addErrorLabel];
                return ;
            }else{
                [self sortArray:[response objectForKey:@"result"] tripActionTag:tripActionTag];
            }
        }else{
            [self alertWithText:@"Error!" message:error.localizedDescription];
            return;
        }
    }];
    });
}


-(void)sortArray:(NSArray*)result tripActionTag:(NSInteger)tripActionTag{
    
    //
    NSLog(@"booking result===>%lu",(unsigned long)result.count);
    //
    if (result == nil || [result count] == 0){
        [self addErrorLabel];
    }else{
        //  1
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(queryType CONTAINS %@ ) OR (queryType CONTAINS %@)",@"TAXI_HOTEL",@"TAXI"];
        NSArray *sortArray = [result filteredArrayUsingPredicate:predicate];
        //
        //  2
        arrayUpcommingTrip=[[NSMutableArray alloc] init];
        arrayPastTrip=     [[NSMutableArray alloc] init];
        //
        for (NSDictionary* obj in sortArray) {
            //
            NSDictionary *itemDic=[self getItemsArrayOnlyTaxi:[obj valueForKey:@"items"]][0];
            //
            NSString*fromMs=[itemDic valueForKey:@"fromDate"];
            //
            
            NSLog(@"crr==>%@",[self currentDate]);
            NSLog(@"ms ==>%@",[self msToDate:fromMs]);
            
            switch ([[self currentDate] compare:[self msToDate:fromMs]]) {
                    //
                case NSOrderedAscending:
                    // system date earlier then date
                    [arrayUpcommingTrip addObject:obj];
                    break;
                case NSOrderedSame:
                    //  Same
                    [arrayUpcommingTrip addObject:obj];
                    break;
                case NSOrderedDescending:
                    // system date later then date
                    [arrayPastTrip addObject:obj];
                    break;
            }
        }
        //  3
        [self tripActionUI:tripActionTag];
    }
}

-(IBAction)tripAction:(UIButton*)sender{
    //
    switch (sender.tag) {
        case 1:{
            
            if (sender.tag==_tripActionTag) {
                break;
            }else{
                _BtnPT.backgroundColor=[self colorWithCode:@"404040"];
                _BtnUT.backgroundColor=[self colorWithCode:@"666666"];
                _tripActionTag=sender.tag;
                [self tripActionUI:sender.tag];
                break;
            }
        }
        case 2:{
            if (sender.tag==_tripActionTag) {
                break;
            }else{
                _BtnPT.backgroundColor=[self colorWithCode:@"666666"];
                _BtnUT.backgroundColor=[self colorWithCode:@"404040"];
                _tripActionTag=sender.tag;
                [self tripActionUI:sender.tag];
                break;
            }
        }
        default:
            break;
    }
}

-(void)tripActionUI:(NSInteger)tripActionTag{
    //
    NSLog(@"arrayPastTrip===>%lu",(unsigned long)arrayPastTrip.count);
    NSLog(@"arrayUpcommingTrip===>%lu",(unsigned long)arrayUpcommingTrip.count);
    //
    if (tripActionTag==1){
        AyBookingResult=[NSArray arrayWithArray:arrayPastTrip];
    }else{
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"fromDate" ascending: YES];
        NSArray *sortedArray = [arrayUpcommingTrip sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        AyBookingResult=[NSArray arrayWithArray:sortedArray];
    }
    
    if (AyBookingResult.count==0 || [AyBookingResult isEqual:nil]){
        TBMyBooking.hidden=true;
        [self addErrorLabel];
    }else{
        [errorLbl removeFromSuperview];
        TBMyBooking.hidden=false;
        TBMyBooking.delegate=self;
        TBMyBooking.dataSource=self;
        [TBMyBooking reloadData];
        //
        [TBMyBooking setContentOffset:CGPointZero animated:YES];
    }
}

-(void)addErrorLabel{
    TBMyBooking.hidden=true;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    errorLbl=[[UILabel alloc]init];
    
    CGFloat srW=screenRect.size.width;
    CGFloat srH=screenRect.size.height;
    
    CGFloat lblW=srW-20;
    CGFloat lblH=40;
    
    errorLbl.frame=CGRectMake(srW/2-lblW/2,srH/2-lblH/2,lblW,lblH);
    errorLbl.text=@"No Booking Found";
    errorLbl.textAlignment=NSTextAlignmentCenter;
    errorLbl.textColor=[UIColor lightGrayColor];
    errorLbl.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:errorLbl];
}

-(NSArray*)getItemsArrayOnlyTaxi:(NSArray*)itemArray{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(itemType CONTAINS %@)",@"TAXI"];
    NSArray *sortedItemArray = [itemArray filteredArrayUsingPredicate:predicate];
    return sortedItemArray;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)activeScrollView
{
    _BtnPT.enabled = NO;
    _BtnUT.enabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _BtnPT.enabled = YES;
    _BtnUT.enabled = YES;
}
@end
