//
//  CouponListingView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 1/11/16.
//  Copyright © 2016 mytaxiit. All rights reserved.
//

#import "CouponListingView.h"

@implementation CouponListingView
@synthesize aryCouponResult;
@synthesize TBCouponList;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    //
    [self setFlurry:@"MTI OfferZone" params:nil];
    //
    [self callService];
    
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aryCouponResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdf = @"CouponListingCell";
    
    CouponListingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdf];
    if (cell == nil) {
        cell = [[CouponListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdf];
    }
    NSDictionary *couponDic=[aryCouponResult objectAtIndex:indexPath.row];
    //
    cell.lblCouponCode.text=[self validateNullValue:[couponDic valueForKey:@"couponCode"] isString:YES];
    //
    cell.lblCouponType.text=[self validateNullValue:[couponDic valueForKey:@"couponType"] isString:YES];
    //
    if ([self validateNullValue:[couponDic valueForKey:@"tripType"] isString:YES].length==0) {
        cell.lblTripType.text=@"ALL";
    }else{
        cell.lblTripType.text=[self validateNullValue:[couponDic valueForKey:@"tripType"] isString:YES];
    }
    //
    if ([[couponDic valueForKey:@"percentDiscount"] isEqual:[NSNull null]]) {
        cell.lblDiscount.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self validateNullValue:[couponDic valueForKey:@"absoluteDiscount"] isString:NO]];
    }else{
        cell.lblDiscount.text=[NSString stringWithFormat:@"%@%%",[self validateNullValue:[couponDic valueForKey:@"percentDiscount"] isString:NO]];
    }
    NSString *couponValidity=[self msWithOrdinalStyle_ddMMyy:[couponDic valueForKey:@"validUpto"]];
    cell.lblCouponValidity.text=couponValidity;
    //
    cell.lblCouponMaxDicount.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self validateNullValue:[couponDic valueForKey:@"maxDiscount"] isString:NO]];
    //
    cell.lblCouponMinValue.text=[NSString stringWithFormat:@"%@%@/-",rupee,[self validateNullValue:[couponDic valueForKey:@"minBookingVal"] isString:NO]];
    //
    cell.couponCopy.tag=indexPath.row;
    [cell.couponCopy addTarget:self action:@selector(couponCopyAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)couponCopyAction:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TBCouponList];
    NSIndexPath *indexPath = [self.TBCouponList indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil){
        NSDictionary *couponDic=[aryCouponResult objectAtIndex:indexPath.row];
        [[UIPasteboard generalPasteboard] setString:[couponDic valueForKey:@"couponCode"]];
        [self alertWithText:nil message:@"Coupon Copied."];
    }
}


-(void)callService{
    dispatch_async (dispatch_get_main_queue(), ^{
        WebServiceClass *WSC = [[WebServiceClass alloc] init];
        
        [WSC getServerResponseForUrl:nil serviceURL:IDPromos isPOST:YES isLoder:YES auth:nil view:self.view  withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
            if (success) {
                if ([response valueForKey:@"status"]==0)
                {
                    [self alertWithText:@"Error!" message:[response valueForKey:@"error"]];
                    return ;
                }else{
                    aryCouponResult=[response valueForKey:@"result"];
                    if(aryCouponResult.count==0){
                        TBCouponList.hidden=true;
                        CGRect screenRect = [[UIScreen mainScreen] bounds];
                        errorLbl=[[UILabel alloc]init];
                        
                        CGFloat srW=screenRect.size.width;
                        CGFloat srH=screenRect.size.height;
                        
                        CGFloat lblW=srW-20;
                        CGFloat lblH=40;
                        
                        errorLbl.frame=CGRectMake(srW/2-lblW/2,srH/2-lblH/2,lblW,lblH);
                        errorLbl.text=@"No offers available yet";
                        errorLbl.textAlignment=NSTextAlignmentCenter;
                        errorLbl.textColor=[UIColor lightGrayColor];
                        errorLbl.font = [UIFont systemFontOfSize:17];
                        [self.view addSubview:errorLbl];
                    }else{
                        [errorLbl removeFromSuperview];
                        TBCouponList.hidden=false;
                        [TBCouponList reloadData];
                    }
                }
            }else{
                [self alertWithText:@"Error!" message:error.localizedDescription];
                return;
            }
        }];
    });
}
@end
