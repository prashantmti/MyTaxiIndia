//
//  CheckoutView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/3/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePaymentView.h"

@interface CheckoutView : BaseView
{
    IBOutlet UIView * uvView1;
    IBOutlet UIView * uvView2;
    IBOutlet UIView * uvView3;
    IBOutlet UIView * uvView4;
    IBOutlet UIView * uvView5;
    IBOutlet UIView * uvView6;
    
    

    
    //
    IBOutlet UITextField * couponText;
    
    
    IBOutlet UITextField * userName;
    IBOutlet UITextField * userEmail;
    IBOutlet UITextField * userPhone;
    IBOutlet UITextField * userAddress;
    
    //NSNumber* baseFareStr,*discountStr,*serviceTaxStr,*totalAmountStr;
    NSString* baseFareStr,*discountStr,*serviceTaxStr,*totalAmountStr,*advanceAmountStr;
}

@property (strong, nonatomic) ModalGlobal *mg;

@property (strong, nonatomic) NSString *bookingID;

@property (strong, nonatomic) NSDictionary *selectedCabInfo;



@property (strong, nonatomic) IBOutlet UILabel *lblTitleCollection;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleCoupon;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleCustomerDetails;

@property (strong, nonatomic) IBOutlet UILabel *location;
//
@property (strong, nonatomic) IBOutlet UILabel *departureDate;
@property (strong, nonatomic) IBOutlet UILabel *returnDate;

@property (strong, nonatomic) IBOutlet UILabel *baseFare;
@property (strong, nonatomic) IBOutlet UILabel *discount;
@property (strong, nonatomic) IBOutlet UILabel *serviceTax;
@property (strong, nonatomic) IBOutlet UILabel *totalAmount;
@property (strong, nonatomic) IBOutlet UILabel *advanceAmount;

@property (weak,nonatomic) IBOutlet TPKeyboardAvoidingScrollView *TPscrollBar;

@property (weak,nonatomic) IBOutlet UIButton *btnApplyCoupon;
//
@property (weak,nonatomic) IBOutlet UIButton *btnMakePayment;
//
@property (weak,nonatomic) IBOutlet UIButton *btnPayAdvance;
@property (weak,nonatomic) IBOutlet UIButton *btnPayFull;


@property(nonatomic, assign) BOOL isApplyCoupon;
@property(nonatomic, assign) BOOL isFullPayment;
@end
