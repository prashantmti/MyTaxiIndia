//
//  CallSupportView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/16/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "CallSupportView.h"

@interface CallSupportView ()

@end

@implementation CallSupportView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    [self setTextBoxLine:_TFName];
    [self setTextBoxLine:_TFPhoneNo];
    [self setTextBoxLine:_TFEmailID];
    [self setViewLine:uvEnquiry];
    [self setBoxShadow:vwMain];
    
    [self setGesturesOnUvCallSupport];
    
    //
    
    //
    if (![[UserDefault userDetails] isEqual:nil]) {
        _TFName.text=[self validateNullValue:[[UserDefault userDetails] valueForKey:@"name"] isString:YES];
        _TFEmailID.text=[self validateNullValue:[[UserDefault userDetails] valueForKey:@"email"] isString:YES];
        _TFPhoneNo.text=[self validateNullValue:[[UserDefault userDetails] valueForKey:@"phone"] isString:YES];
    }
    
    [self setFlurry:@"Call Support" params:nil];
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


-(IBAction)SendEnquiry:(id)sender
{
    if ([self validateString:_TFName.text]==FALSE) {
        [self alertWithText:nil message:@"Please Enter Name"];
        return;
    }
    else if ([self validateMobile:_TFPhoneNo.text]==FALSE) {
        [self alertWithText:nil message:@"Please Enter Valid Phone No."];
        return;
    }
    else if ([self validateEmail:_TFEmailID.text]==FALSE) {
        [self alertWithText:nil message:@"Please Enter Valid Email ID"];
        return;
    }
    else if ([self validateString:_TVEnquiry.text]==FALSE) {
        [self alertWithText:nil message:@"Please Enter Enquiry"];
        return;
    }
    else{
        [self callService];
    }
}

-(void)callService{

    WebServiceClass *WSC = [[WebServiceClass alloc] init];
    NSString *auth=[self createAuth:merchantId string2:[self uniqueTstamp] string3:authPassword];
    NSMutableDictionary *postDic=[[NSMutableDictionary alloc]init];
    [postDic setObject:merchantId forKey:@"merchantId"];
    [postDic setObject:[self uniqueTstamp] forKey:@"salt"];

    [postDic setObject:_TFName.text forKey:@"name"];
    [postDic setObject:_TFEmailID.text forKey:@"email"];
    [postDic setObject:_TFPhoneNo.text forKey:@"phone"];
    [postDic setObject:_TVEnquiry.text forKey:@"inquiryText"];
    [postDic setObject:sourceType forKey:@"inquirySource"];
    
    [WSC getServerResponseForUrl:postDic serviceURL:IDSaveInquiry isPOST:YES isLoder:YES auth:auth view:self.view  withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        if (success) {
            if ([[response valueForKey:@"status"] isEqualToString:@"error"])
            {
                [self alertWithText:@"Error!" message:[response valueForKey:@"error"]];
                return ;
            }
            else{
                NSLog(@"respponse===>%@",response);
                [self alertWithText:nil message:@"Thank You!"];
                return ;
            }
        }else{
            [self alertWithText:@"Error!" message:error.localizedDescription];
            return ;
        }
    }];
}


-(IBAction)callPhone:(id)sender {
    //8882001133
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:+91-888-200-1133"]];
}

//set gesture on call support
- (void)setGesturesOnUvCallSupport
{
    UITapGestureRecognizer* uvCallsupportGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionGesturesOnUvCallSupport:)];
    [uvCallSuport addGestureRecognizer:uvCallsupportGesture];
}

- (void)actionGesturesOnUvCallSupport: (UITapGestureRecognizer *)recognizer
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:+91-888-200-1133"]];
}
@end
