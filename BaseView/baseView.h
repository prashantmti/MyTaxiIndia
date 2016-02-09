//
//  baseView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/16/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface baseView : UIViewController
{
    UIToolbar *toolBar;
}

-(NSArray*)getLocationArray;


-(void)showPickerView;

-(void)addDatePickerWithToolBar;


@property(strong,nonatomic) UIDatePicker *datePicker;
@end
