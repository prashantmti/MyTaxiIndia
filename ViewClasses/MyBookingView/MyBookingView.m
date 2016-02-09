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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    
    if([[UserDefault userID] isEqual:nil] || [[UserDefault userID] isEqual:[NSNull null]] || [UserDefault userID].length==0){
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
    }else
    {
        TBMyBooking.hidden=false;
        [errorLbl removeFromSuperview];
        [self callService];
    }

    [self setNavigationStyle];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self GATrackOnView:NSStringFromClass(self.class) kGAIScreenName:kGAIScreenName];
}


-(void)setNavigationStyle{
    self.navigationItem.title=@"My Trips";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return AyBookingResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdf = @"MyBookingCell";
    
    MyBookingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdf];
    if (cell == nil) {
        cell = [[MyBookingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdf];
    }
    NSDictionary *resultDiC=[AyBookingResult objectAtIndex:indexPath.row];
    //
    cell.lblBookingID.text=[self stringFormat:[resultDiC valueForKey:@"id"]];
    //
    NSString *fromCity,*toCity;
    fromCity=[self validateNullValue:[[resultDiC valueForKey:@"items"][0] valueForKey:@"toCity"] isString:YES];
    toCity=[self validateNullValue:[[resultDiC valueForKey:@"items"][0] valueForKey:@"toCity"] isString:YES];
    //cell.lblLocationVal.text=[NSString stringWithFormat:@"%@-%@",fromCity,toCity];
    cell.lblTripFrom.text=[self validateNullValue:[[resultDiC valueForKey:@"items"][0] valueForKey:@"fromCity"] isString:YES];
    cell.lblTripTo.text=[self validateNullValue:[[resultDiC valueForKey:@"items"][0] valueForKey:@"toCity"] isString:YES];
    cell.lblTripStatus.text=[resultDiC valueForKey:@"status"];
    //
    NSString *fromDate;
    fromDate=[self validateNullValue:[[resultDiC valueForKey:@"items"][0] valueForKey:@"fromDate"] isString:NO];
    cell.lblTripDate.text=[self msWithOrdinalStyle_ddMMyy:fromDate];
    
    NSString *driverMb;
    driverMb=[[[resultDiC valueForKey:@"items"][0] valueForKey:@"driver"] valueForKey:@"mobile"];
    _driverMbStr=driverMb;
    //
    [cell.btnCallDriver addTarget:self action:@selector(callDriverAction:) forControlEvents:UIControlEventTouchUpInside];

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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_driverMbStr]];
}

-(void)callService{
    dispatch_async (dispatch_get_main_queue(), ^{
        WebServiceClass *WSC = [[WebServiceClass alloc] init];
        NSString *auth=[self createAuth:merchantId string2:[self uniqueTstamp] string3:authPassword];
        NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
        [postDic setObject:merchantId forKey:@"merchantId"];
        [postDic setObject:[self uniqueTstamp] forKey:@"salt"];
        
        //48
        [postDic setObject:[UserDefault userID] forKey:@"customerId"];
        //[postDic setObject:@"5" forKey:@"customerId"];
    
    [WSC getServerResponseForUrl:postDic serviceURL:IDGetBooking isPOST:YES isLoder:YES auth:auth view:self.view  withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        if (success) {
            if ([[response valueForKey:@"status"] isEqualToString:@"error"])
            {
                [self alertWithText:@"Error!" message:[response valueForKey:@"error"]];
                [self addErrorLabel];
                return ;
            }else{
                AyBookingResult=[response valueForKey:@"result"];
                if(AyBookingResult.count==0)
                {
                    [self addErrorLabel];
                }else{
                    [errorLbl removeFromSuperview];
                    TBMyBooking.hidden=false;
                    [TBMyBooking reloadData];
                }
            }
        }else{
            [self alertWithText:@"Error!" message:error.localizedDescription];
            return;
        }
    }];
    });
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
@end
