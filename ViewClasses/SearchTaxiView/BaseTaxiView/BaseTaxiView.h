//
//  BaseTaxiView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 11/9/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LocalStationView.h"
#import "OutStationView.h"

@interface BaseTaxiView : BaseView<UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet UIView *LocalTaxiCView;
@property (weak, nonatomic) IBOutlet UIView *OutStationTaxiCView;

@property (weak, nonatomic) IBOutlet UIButton *BtnLtv;
@property (weak, nonatomic) IBOutlet UIButton *BtnOtv;


@property (weak,nonatomic) IBOutlet UIBarButtonItem *barButton;

@property (weak,nonatomic) IBOutlet TPKeyboardAvoidingScrollView *TPscrollBar;

@property (strong, nonatomic) ModalGlobal *mg;
@end
