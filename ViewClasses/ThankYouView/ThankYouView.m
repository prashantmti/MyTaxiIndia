//
//  ThankYouView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/9/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "ThankYouView.h"

@interface ThankYouView ()

@end

@implementation ThankYouView
@synthesize confirmResponse;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"confirmResponse====>%@",confirmResponse);

    
    NSString *bookingID,*name,*mobile,*address,*date,*tripLocation,*baseFare,*discount,*serviceTax,*totalAmount;
    
    bookingID=[[confirmResponse valueForKey:@"result"] valueForKey:@"id"];
    name=[[confirmResponse valueForKey:@"result"] valueForKey:@"billingName"];
    mobile=[[confirmResponse valueForKey:@"result"] valueForKey:@"billingAddressPhone"];
    address=[[confirmResponse valueForKey:@"result"] valueForKey:@"billingAddressLine1"];
    date=@"";
    tripLocation=[NSString stringWithFormat:@"%@-%@",[[confirmResponse valueForKey:@"result"] valueForKey:@"from"],[[confirmResponse valueForKey:@"result"] valueForKey:@"to"]];
    
    baseFare=[[confirmResponse valueForKey:@"result"] valueForKey:@"netAmount"];
    discount=[[confirmResponse valueForKey:@"result"] valueForKey:@"couponDiscount"];
    serviceTax=[[confirmResponse valueForKey:@"result"] valueForKey:@"serviceTax"];
    totalAmount=[[confirmResponse valueForKey:@"result"] valueForKey:@"totalAmount"];
    
    if ([name isKindOfClass:[NSNull class]] || [name isEqual:@"<null>"])
    {
        name=@"";
    }
    else if ([mobile isKindOfClass:[NSNull class]] || [mobile isEqual:@"<null>"])
    {
        mobile=@"";
    }
    else if ([address isKindOfClass:[NSNull class]] || [address isEqual:@"<null>"])
    {
        address=@"";
    }
    else if ([date isKindOfClass:[NSNull class]] || [date isEqual:@"<null>"])
    {
        date=@"";
    }
    else if ([tripLocation isKindOfClass:[NSNull class]] || [tripLocation isEqual:@"<null>"])
    {
        tripLocation=@"";
    }
    else if ([baseFare isKindOfClass:[NSNull class]] || [baseFare isEqual:@"<null>"])
    {
        baseFare=@"0";
    }
    else if ([discount isKindOfClass:[NSNull class]] || [discount isEqual:@"<null>"])
    {
        discount=@"0";
    }
    else if ([serviceTax isKindOfClass:[NSNull class]] || [serviceTax isEqual:@"<null>"])
    {
        serviceTax=@"0";
    } else if ([totalAmount isKindOfClass:[NSNull class]] || [totalAmount isEqual:@"<null>"])
    {
        totalAmount=@"0";
    }
    
    self.bookingID.text=[NSString stringWithFormat:@"%@",bookingID];
    self.name.text=name;
    self.mobile.text=mobile;
    self.address.text=address;
    self.tripDate.text=date;
    self.tripLocation.text=tripLocation;
    
    self.baseFare.text=[NSString stringWithFormat:@"%@",baseFare];
    self.discount.text=[NSString stringWithFormat:@"%@",discount];
    self.serviceTax.text=[NSString stringWithFormat:@"%@",serviceTax];
    self.totalAmount.text=[NSString stringWithFormat:@"%@",totalAmount];
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


-(IBAction)backBtnAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
