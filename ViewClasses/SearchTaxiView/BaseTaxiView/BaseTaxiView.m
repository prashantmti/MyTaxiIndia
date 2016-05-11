//
//  BaseTaxiView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/9/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "BaseTaxiView.h"
#import "SWRevealViewController.h"

@interface BaseTaxiView ()

@end

@implementation BaseTaxiView
@synthesize LocalTaxiCView,OutStationTaxiCView,BtnLtv,BtnOtv;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    self.mg=[ModalGlobal sharedManager];
    // Do any additional setup after loading the view.
    self.mg=[ModalGlobal sharedManager];
    //
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //
    [self setBaseViewAction:1];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(IBAction)BaseViewAction:(UIButton*)sender
{
    [self setBaseViewAction:sender.tag];
}

-(void)setBaseViewAction:(NSInteger)tag
{
    CGRect btnOtvFrame = BtnOtv.frame;
    CGRect btnLtvFrame = BtnLtv.frame;
    
    switch (tag) {
        case 1:
        {
            //selected OutStationTaxiCView
            LocalTaxiCView.hidden = YES;
            OutStationTaxiCView.hidden = NO;
            
            btnOtvFrame.size = CGSizeMake(BtnOtv.frame.size.width,42);
            BtnOtv.frame = btnOtvFrame;
            
            btnLtvFrame.size = CGSizeMake(BtnLtv.frame.size.width,44);
            BtnLtv.frame = btnLtvFrame;
            
            BtnLtv.backgroundColor=[self colorWithCode:@"666666"];
            BtnOtv.backgroundColor=[self colorWithCode:@"404040"];
            [BtnLtv setTitleColor:[self colorWithCode:@"FFFFFF"] forState:UIControlStateNormal];
            [BtnOtv setTitleColor:[self colorWithCode:@"FFFFFF"] forState:UIControlStateNormal];
            break;
        }
        case 3:{
            //selected LocalTaxiCView
            LocalTaxiCView.hidden = NO;
            OutStationTaxiCView.hidden = YES;
            
            btnOtvFrame.size = CGSizeMake(BtnOtv.frame.size.width,44);
            BtnOtv.frame = btnOtvFrame;
            
            btnLtvFrame.size = CGSizeMake(BtnLtv.frame.size.width,42);
            BtnLtv.frame = btnLtvFrame;
            
            BtnLtv.backgroundColor=[self colorWithCode:@"404040"];
            BtnOtv.backgroundColor=[self colorWithCode:@"666666"];
            [BtnLtv setTitleColor:[self colorWithCode:@"FFFFFF"] forState:UIControlStateNormal];
            [BtnOtv setTitleColor:[self colorWithCode:@"FFFFFF"] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}
@end
