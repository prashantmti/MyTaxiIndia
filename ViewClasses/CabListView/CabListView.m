//
//  CabListView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/27/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "CabListView.h"

@interface CabListView ()

@end

@implementation CabListView
@synthesize cabList,TBcabList;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mg=[ModalGlobal sharedManager];
    pickUPdate.text=[self dateWithOrdinal_EEddMMMyy:self.mg.mbt.departureDate];
    //
    [self setNavigationStyle];
    
    [self setFlurry:@"Cab List" params:nil];
}




-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToSingle:) name:@"pushToSingle" object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self GATrackOnView:NSStringFromClass(self.class) kGAIScreenName:kGAIScreenName];
}


-(void)setNavigationStyle{
    NSString *tripLocation;
    if([self.mg.mbt.tripType isEqual:@"2"]){        //for Local trip
       tripLocation=self.mg.mbt.departureCity;
    }else{
        if ([self splitString:self.mg.mbt.locationIds pattern:@","].count==2){
            tripLocation=[NSString stringWithFormat:@"%@-%@",self.mg.mbt.departureCity,self.mg.mbt.arrivalCity];
        }else if ([self splitString:self.mg.mbt.locationIds pattern:@","].count==3){
            tripLocation=[NSString stringWithFormat:@"%@-%@-%@",self.mg.mbt.departureCity,self.mg.mbt.arrivalCity,self.mg.mbt.arrivalMoreCity];
        }else{
            tripLocation=self.mg.mbt.departureCity;
        }
    }
    self.navigationItem.title=tripLocation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"TB count==>%lu",(unsigned long)cabList.count);
    return cabList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CabListViewCell";
    
    CabListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[CabListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSString *cabName,*seatingCapacity,*availability,*baseAmount,*totalAmount,*totalHrs;
    
    cabName=[[cabList objectAtIndex:indexPath.row] valueForKey:@"category"];
    
    seatingCapacity=[NSString stringWithFormat:@"%@",[[cabList objectAtIndex:indexPath.row] valueForKey:@"seatingCapacity"]];
    
    availability=[NSString stringWithFormat:@"%@",[[cabList objectAtIndex:indexPath.row] valueForKey:@"availability"]];
    
    totalHrs=[NSString stringWithFormat:@"%@",[[[cabList objectAtIndex:indexPath.row] valueForKey:@"tariff"] valueForKey:@"baseFare"]];
    
    baseAmount=[NSString stringWithFormat:@"%@",[[[cabList objectAtIndex:indexPath.row] valueForKey:@"tariff"] valueForKey:@"baseFare"]];
    
    totalAmount=[self validateNullValue:[[[cabList objectAtIndex:indexPath.row] valueForKey:@"tariff"] valueForKey:@"totalAmount"] isString:NO];

    if ([cabName isKindOfClass:[NSNull class]])
    {
        cabName=@"";
    }
    else if ([seatingCapacity isKindOfClass:[NSNull class]] || [seatingCapacity isEqual:@"<null>"])
    {
        seatingCapacity=@"0";
    }
    else if ([availability isKindOfClass:[NSNull class]] || [availability isEqual:@"<null>"])
    {
        availability=@"0";
    }
    else if ([totalHrs isKindOfClass:[NSNull class]] || [totalHrs isEqual:@"<null>"])
    {
        totalHrs=@"0";
    }
    else if ([baseAmount isKindOfClass:[NSNull class]] || [baseAmount isEqual:@"<null>"])
    {
        baseAmount=@"0";
    }
    else if ([totalAmount isKindOfClass:[NSNull class]] || [totalAmount isEqual:@"<null>"])
    {
        totalAmount=@"0";
    }
    
    if (cabName == nil || cabName == (id)[NSNull null]) {
        cell.cabIMG.image=[UIImage imageNamed:@"DEMO_SEATER"];
    } else {
        cell.cabIMG.image=[UIImage imageNamed:cabName];
    }
    //
    cell.cabName.text=[cabName stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    cell.seatingCapacity.text=[NSString stringWithFormat:@"%@ Seats",seatingCapacity];

    if ([availability isEqualToString:@"0"]) {
        cell.cabAvailability.backgroundColor=[self colorWithCode:@"242424"];
        cell.cabAvailability.text=@"Not Available";
        //
        cell.totalAmount.hidden=true;
        cell.totalAmountTitle.hidden=true;
    }
    else{
        cell.cabAvailability.backgroundColor=[self colorWithCode:@"0195c3"];
        cell.cabAvailability.text=[NSString stringWithFormat:@"Available %@",availability];
        //
        cell.totalAmount.hidden=false;
        cell.totalAmountTitle.hidden=false;
        //
        cell.totalAmount.text=[NSString stringWithFormat:@"%@%@/-",rupee,totalAmount];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *availability;
    availability=[self validateNullValue:[[cabList objectAtIndex:indexPath.row] valueForKey:@"availability"] isString:NO];
    
    if ([availability isEqualToString:@"0"]) {
        return;
    }else{
        dispatch_async (dispatch_get_main_queue(), ^{
            [self showPopPicker:indexPath.row];
        });
    }
}


-(void)showPopPicker:(NSInteger)sender
{
    PopPickerView *ppv = [self.storyboard  instantiateViewControllerWithIdentifier:@"PopPickerView"];
    ppv.DicSelectedCab=[cabList objectAtIndex:sender];
    ppv.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:ppv animated:YES completion:nil];
}

-(void)displayNewVC1
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PopPickerView *PPV = [storyboard instantiateViewControllerWithIdentifier:@"PopPickerView"];
    
    PPV.view.frame=CGRectMake(PPV.view.frame.origin.x,PPV.view.frame.origin.y, PPV.view.frame.size.width, PPV.view.frame.size.height);
    
    PPV.view.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [self.view addSubview:PPV.view];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        PPV.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // do something once the animation finishes, put it here
    }];
}

-(void)displayNewVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PopPickerView *newVC = [storyboard instantiateViewControllerWithIdentifier:@"PopPickerView"];
    
    //PopPickerView *newVC = [[PopPickerView alloc] init];
    
    CGFloat originY = -450;//set originY as you want to display newViewController from the Top to bottom with animation
    //initially set originY out of the Frame of CurrentViewcontroller
    newVC.view.frame = CGRectMake(0, originY, newVC.view.frame.size.width, newVC.view.frame.size.height);
    
    /*Display View With Animation*/
    originY = 300;
    [UIView animateWithDuration:.3 animations:^{
        //set new originY as you want.
        newVC.view.frame = CGRectMake(0, originY, newVC.view.frame.size.width,  newVC.view.frame.size.height);
    } completion:NULL];
    [self.view addSubview:newVC.view];
}


-(void)pushToSingle:(NSNotification *)notis{
    NSDictionary *dict = notis.userInfo;
    //int post_id = [[dict objectForKey:@"post_id"] intValue];
    
    WebServiceClass *WSC = [[WebServiceClass alloc] init];
    NSString *auth=[self createAuth:merchantId string2:[self uniqueTstamp] string3:authPassword];
    NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
    [postDic setObject:merchantId forKey:@"merchantId"];
    [postDic setObject:[self uniqueTstamp] forKey:@"salt"];
    
    [postDic setObject:sourceType forKey:@"sourceType"];
    [postDic setObject:self.mg.mbt.locationIds forKey:@"cityIds"];
    
    if([self.mg.mbt.tripType isEqualToString:@"2"])
    {
        [postDic setObject:self.mg.mbt.tripSelectDays forKey:@"hours"];
    }
    [postDic setObject:self.mg.mbt.tripType forKey:@"tripType"];
    [postDic setObject:[dict valueForKey:@"noOfCars"] forKey:@"noOfCars"];
    [postDic setObject:[[dict valueForKey:@"DicSelectedCab"] valueForKey:@"category"] forKey:@"vehicleCategory"];
    
    //pickTime
    NSString *selectedDate=[NSString stringWithFormat:@"%@ %@",[self splitString:self.mg.mbt.departureDate pattern:@" "][0],[dict valueForKey:@"pickTime"]];
    self.mg.mbt.departureDate=selectedDate;
    //
    [postDic setObject:selectedDate forKey:@"pickupDate"];
    
    if([self.mg.mbt.tripType isEqualToString:@"2"]){
        // no returnDate for==>2(local trip)
    }else{
        if ([self.mg.mbt.tripType isEqualToString:@"1"]) {
            [postDic setObject:self.mg.mbt.returnDate forKey:@"dropDate"];
        }
    }
    
    if([[UserDefault userID]intValue]!=0){
        [postDic setObject:[UserDefault userID] forKey:@"customerId"];
    }
    
    [WSC getServerResponseForUrl:postDic serviceURL:IDCabReview isPOST:YES isLoder:YES auth:auth view:self.view withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        if (success) {
            if ([[response valueForKey:@"status"] isEqualToString:@"error"])
            {
                if ([[response valueForKey:@"error"] isEqual:[NSNull null]])
                {
                    [self alertWithText:@"Error!" message:@"Null Error!"];
                    return ;
                }else{
                    [self alertWithText:nil message:[response valueForKey:@"error"]];
                    return ;
                }
            }else{
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            CheckoutView *CV = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckoutView"];
            CV.selectedCabInfo=response;
           [self.navigationController pushViewController:CV animated:YES];
            }
        }else{
            
            //NSLog(@"error===>%@",error.description);
            [self alertWithText:@"Error!" message:error.localizedDescription];
            return ;
        }
    }];
}
@end
