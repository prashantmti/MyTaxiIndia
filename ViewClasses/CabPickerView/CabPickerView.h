//
//  CabPickerView.h
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/31/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CabPickerView : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
    IBOutlet UIPickerView *picker;
    NSArray *dataArray;
    NSMutableArray  *availabilityArray;
    NSInteger index;
}
@end